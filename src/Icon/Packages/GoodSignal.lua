--[[
-------------------------------------
This package was modified by ForeverHD.

PACKAGE MODIFICATIONS:
	1. Added alias ``Signal:Destroy/destroy`` for ``Signal:DisconnectAll``
	2. Removed some warnings/errors
	3. Possibly some additional changes which weren't tracked
	4. Added :ConnectOnce
	5. Added a tracebackString and callFunction which now wraps errors with this traceback message
-------------------------------------
--]]



-- Credit to Stravant for this package:
-- https://devforum.roblox.com/t/lua-signal-class-comparison-optimal-goodsignal-class/1387063

--------------------------------------------------------------------------------
--               Batched Yield-Safe Signal Implementation                     --
-- This is a Signal class which has effectively identical behavior to a       --
-- normal RBXScriptSignal, with the only difference being a couple extra      --
-- stack frames at the bottom of the stack trace when an error is thrown.     --
-- This implementation caches runner coroutines, so the ability to yield in   --
-- the signal handlers comes at minimal extra cost over a naive signal        --
-- implementation that either always or never spawns a thread.                --
--                                                                            --
-- API:                                                                       --
--   local Signal = require(THIS MODULE)                                      --
--   local sig = Signal.new()                                                 --
--   local connection = sig:Connect(function(arg1, arg2, ...) ... end)        --
--   sig:Fire(arg1, arg2, ...)                                                --
--   connection:Disconnect()                                                  --
--   sig:DisconnectAll()                                                      --
--   local arg1, arg2, ... = sig:Wait()                                       --
--                                                                            --
-- Licence:                                                                   --
--   Licenced under the MIT licence.                                          --
--                                                                            --
-- Authors:                                                                   --
--   stravant - July 31st, 2021 - Created the file.                           --
--------------------------------------------------------------------------------

-- The currently idle thread to run the next handler on
local freeRunnerThread = nil
local function callFunction(fn, tracebackString, ...)
	fn(...)
	--[[
	local _, modifiedErrorMessage = xpcall(fn, function(errorMessage)
		local path = errorMessage:split(":")
		local path1 = path and path[1]
		local otherMessage
		if #path == 1 then
			local len = string.find(path1, '"')
			if len then
				otherMessage = string.sub(path1, 1, len-2)
			end
		end
		local moduleName = (path1 and path1:match("[^%.]+$")) or "Unknown"
		if #moduleName > 10 then
			moduleName = tracebackString
		end
		local lineNumber = (path and path[2]) or "?"
		local message = (path and path[3] and path[3]:sub(2)) or otherMessage or "NA" 
		if message == "NA" then
			message = errorMessage
		end
		local newErrorMessage = ("Signal connection threw an error: [%s:%s]: %s"):format(moduleName, lineNumber, message)
		return newErrorMessage
	end, ...)
	if modifiedErrorMessage then
		main.warn(modifiedErrorMessage, tracebackString) -- This needs to include original and after
	end
	--]]
end

-- Function which acquires the currently idle handler runner thread, runs the
-- function fn on it, and then releases the thread, returning it to being the
-- currently idle one.
-- If there was a currently idle runner thread already, that's okay, that old
-- one will just get thrown and eventually GCed.
local function acquireRunnerThreadAndCallEventHandler(fn, tracebackString, ...)
	local acquiredRunnerThread = freeRunnerThread
	freeRunnerThread = nil
	callFunction(fn, tracebackString, ...)
	-- The handler finished running, this runner thread is free again.
	freeRunnerThread = acquiredRunnerThread
end

-- Coroutine runner that we create coroutines of. The coroutine can be 
-- repeatedly resumed with functions to run followed by the argument to run
-- them with.
local function runEventHandlerInFreeThread(...)
	acquireRunnerThreadAndCallEventHandler(...)
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

-- Connection class
local Connection = {}
Connection.__index = Connection

function Connection.new(signal, fn)
	return setmetatable({
		_connected = true,
		_signal = signal,
		_fn = fn,
		_next = false,
	}, Connection)
end

function Connection:Disconnect()
	if not self._connected then
		return
	end
	self._connected = false

	-- Unhook the node, but DON'T clear it. That way any fire calls that are
	-- currently sitting on this node will be able to iterate forwards off of
	-- it, but any subsequent fire calls will not hit it, and it will be GCed
	-- when no more fire calls are sitting on it.
	if self._signal._handlerListHead == self then
		self._signal._handlerListHead = self._next
	else
		local prev = self._signal._handlerListHead
		while prev and prev._next ~= self do
			prev = prev._next
		end
		if prev then
			prev._next = self._next
		end
	end
end
Connection.Destroy = Connection.Disconnect

-- Make Connection strict
setmetatable(Connection, {
	__index = function(tb, key)
		error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(key)), 2)
	end,
	__newindex = function(tb, key, value)
		error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(key)), 2)
	end
})

-- Signal class
local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({
		_handlerListHead = false,	
	}, Signal)
end

function Signal:Connect(fn)
	local connection = Connection.new(self, fn)
	if self._handlerListHead then
		connection._next = self._handlerListHead
		self._handlerListHead = connection
	else
		self._handlerListHead = connection
	end
	return connection
end

function Signal:ConnectOnce(fn)
	local connection
	local newFn = function(...)
		connection:Disconnect()
		fn(...)
	end
	connection = self:Connect(newFn)
	return connection
end
Signal.Once = Signal.ConnectOnce

-- Disconnect all handlers. Since we use a linked list it suffices to clear the
-- reference to the head handler.
function Signal:DisconnectAll()
	self._handlerListHead = false
end
Signal.Destroy = Signal.DisconnectAll
Signal.destroy = Signal.DisconnectAll

-- Signal:Fire(...) implemented by running the handler functions on the
-- coRunnerThread, and any time the resulting thread yielded without returning
-- to us, that means that it yielded to the Roblox scheduler and has been taken
-- over by Roblox scheduling, meaning we have to make a new coroutine runner.
function Signal:_FireBehaviour(isSpecial, ...)
	local tracebackString = table.concat({debug.info(3, "sl")}, " ")
	local item = self._handlerListHead
	local completedSignal = isSpecial and Signal.new()
	local totalItems = 0
	local completedItems = 0
	if isSpecial then
		local itemToCheck = item
		while itemToCheck do
			if itemToCheck._connected then
				totalItems += 1
			end
			itemToCheck = itemToCheck._next
		end
	end
	while item do
		if item._connected then
			if not freeRunnerThread then
				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
			end
			local modifiedFunction = function(...)
				callFunction(item._fn, tracebackString, ...)
				if isSpecial then
					completedItems += 1
					if completedItems == totalItems then
						completedSignal:Fire()
						completedSignal:Destroy()
						completedSignal = false
					end
				end
			end
			task.spawn(freeRunnerThread, modifiedFunction, tracebackString, ...)
		end
		item = item._next
	end
	if isSpecial then
		return completedSignal
	end
end

function Signal:Fire(...)
	self:_FireBehaviour(false, ...)
end

function Signal:SpecialFire(...)
	-- 'Special Fires' creates and returns an additional Signal which is called when all the original signals events have
	-- finished calling
	return self:_FireBehaviour(true, ...)
end


-- Implement Signal:Wait() in terms of a temporary connection using
-- a Signal:Connect() which disconnects itself.
function Signal:Wait()
	local waitingCoroutine = coroutine.running()
	local cn;
	cn = self:Connect(function(...)
		cn:Disconnect()
		task.spawn(waitingCoroutine, ...)
	end)
	return coroutine.yield()
end

return Signal