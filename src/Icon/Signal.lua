--[=[
	@class ScriptSignal
]=]
local ScriptSignal = {}
ScriptSignal.__index = ScriptSignal

--[=[
	@class ScriptConnection
]=]
local ScriptConnection = {}
ScriptConnection.__index = ScriptConnection

--[=[
	@prop Connected boolean
	@readonly
	@within ScriptConnection
	@ignore

	A boolean which determines if a ScriptConnection is active or not
]=]

local FreeThread: thread? = nil

local function RunHandlerInFreeThread(
	handle: (...any) -> (),
	...
)
	local thread = FreeThread :: thread
	FreeThread = nil

	handle(...)

	FreeThread = thread
end

local function CreateFreeThread()
	FreeThread = coroutine.running()

	while true do
		RunHandlerInFreeThread( coroutine.yield() )
	end
end

--[=[
	Creates a ScriptSignal object

	@return ScriptSignal
	@ignore
]=]
function ScriptSignal.new()
	return setmetatable({
		_active = true,
		_head = nil
	}, ScriptSignal)
end

--[=[
	Returns a boolean determining if the object is a ScriptSignal

	```lua
	local janitor = Janitor.new()
	local signal = ScriptSignal.new()

	ScriptSignal.Is(signal) -> true
	ScriptSignal.Is(janitor) -> false
	```

	@param object any
	@return boolean
	@ignore
]=]
function ScriptSignal.Is(object): boolean
	return typeof(object) == 'table'
		and getmetatable(object) == ScriptSignal
end

--[=[
	Returns a boolean determing if a ScriptSignal object is active

	```lua
	ScriptSignal:IsActive() -> true
	ScriptSignal:Destroy()
	ScriptSignal:IsActive() -> false
	```

	@return boolean
	@ignore
]=]
function ScriptSignal:IsActive(): boolean
	return self._active == true
end

--[=[
	Connects a function to the ScriptSignal

	```lua
	ScriptSignal:Connect(function(text)
		print(text)
	end)

	ScriptSignal:Fire("Something")
	ScriptSignal:Fire("Something else")

	-- "Something" and then "Something else" are printed
	```

	@param handle (...: any) -> ()
	@return ScriptConnection
	@ignore
]=]
function ScriptSignal:Connect(
	handle: (...any) -> ()
)
	assert(
		typeof(handle) == 'function',
		"Must be function"
	)

	if self._active == false then
		return setmetatable({
			Connected = false
		}, ScriptConnection)
	end

	local _head = self._head

	local node = {
		_signal = self,
		_connection = nil,
		_handle = handle,

		_next = _head,
		_prev = nil
	}

	if _head then
		_head._prev = node
	end
	self._head = node

	local connection = setmetatable({
		Connected = true,
		_node = node
	}, ScriptConnection)

	node._connection = connection

	return connection
end

--[=[
	Connects a function to a ScriptSignal object, but only allows that
	connection to run once. any later fire calls won't trigger anything

	```lua
	ScriptSignal:ConnectOnce(function()
		print("Connection fired")
	end)

	ScriptSignal:Fire()
	ScriptSignal:Fire()

	-- "Connection fired" is only fired once
	```

	@param handle (...: any) -> ()
	@ignore
]=]
function ScriptSignal:ConnectOnce(
	handle: (...any) -> ()
)
	assert(
		typeof(handle) == 'function',
		"Must be function"
	)

	local connection
	connection = self:Connect(function(...)
		if connection == nil then
			return
		end

		connection:Disconnect()
		connection = nil

		handle(...)
	end)
end

--[=[
	Yields the thread until a fire call happens, returns what the signal was fired with

	```lua
	task.spawn(function()
		print(
			ScriptSignal:Wait()
		)
	end)

	ScriptSignal:Fire("Arg", nil, 1, 2, 3, nil)
	-- "Arg", nil, 1, 2, 3, nil are printed
	```

	@yields
	@return ...any
	@ignore
]=]
function ScriptSignal:Wait(): (...any)
	local thread do
		thread = coroutine.running()

		local connection
		connection = self:Connect(function(...)
			if connection == nil then
				return
			end

			connection:Disconnect()
			connection = nil

			task.spawn(thread, ...)
		end)
	end

	return coroutine.yield()
end

--[=[
	Fires a ScriptSignal object with the arguments passed through it

	```lua
	ScriptSignal:Connect(function(text)
		print(text)
	end)

	ScriptSignal:Fire("Some Text...")

	-- "Some Text..." is printed twice
	```

	@param ... any
	@ignore
]=]
function ScriptSignal:Fire(...)
	local node = self._head
	while node ~= nil do
		if node._connection ~= nil then
			if FreeThread == nil then
				task.spawn(CreateFreeThread)
			end

			task.spawn(
				FreeThread :: thread,
				node._handle, ...
			)
		end

		node = node._next
	end
end

--[=[
	Disconnects all connections from a ScriptSignal object
	without destroying it and without making it unusable

	```lua
	local connection = ScriptSignal:Connect(function() end)

	connection.Connected -> true

	ScriptSignal:DisconnectAll()

	connection.Connected -> false
	```

	@ignore
]=]
function ScriptSignal:DisconnectAll()
	local node = self._head
	while node ~= nil do
		local _connection = self._connection
		if _connection ~= nil then
			_connection:Disconnect()
		end

		node = node._next
	end
end

--[=[
	Destroys a ScriptSignal object, disconnecting all connections
	and making it unusable.

	```lua
	ScriptSignal:Destroy()

	local connection = ScriptSignal:Connect(function() end)
	connection.Connected -> false
	```

	@ignore
]=]
function ScriptSignal:Destroy()
	if self._active == false then
		return
	end

	self:DisconnectAll()
	self._active = false
end

--[=[
	Disconnects a connection, any :Fire calls from now on would not
	invoke this connection's function

	```lua
	local connection = ScriptSignal:Connect(function() end)

	connection.Connected -> true

	connection:Disconnect()

	connection.Connected -> false
	```

	@ignore
]=]
function ScriptConnection:Disconnect()
	if self.Connected == false then
		return
	end

	self.Connected = false

	local _node = self._node
	local _prev = self._prev
	local _next = self._next

	if _next then
		_next._prev = _prev
	end

	if _prev then
		_prev._next = _next
	else
		-- _node == _signal._head

		_node._signal._head = _next
	end

	_node._connection = nil
	self._node = nil
end

-- Compatibility methods for TopbarPlus
ScriptConnection.destroy = ScriptConnection.Disconnect
ScriptConnection.Destroy = ScriptConnection.Disconnect
ScriptConnection.disconnect = ScriptConnection.Disconnect
ScriptSignal.destroy = ScriptSignal.Destroy
ScriptSignal.Disconnect = ScriptSignal.Destroy
ScriptSignal.disconnect = ScriptSignal.Destroy

ScriptSignal.connect = ScriptSignal.Connect
ScriptSignal.wait = ScriptSignal.Wait
ScriptSignal.fire = ScriptSignal.Fire

export type Class = typeof(
	ScriptSignal.new()
)

export type ScriptConnection = typeof(
	ScriptSignal.new():Connect(function() end)
)

return ScriptSignal