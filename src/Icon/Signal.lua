local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local heartbeat = RunService.Heartbeat
local Signal = {}
Signal.__index = Signal
Signal.ClassName = "Signal"
Signal.totalConnections = 0



-- CONSTRUCTOR
function Signal.new(createConnectionsChangedSignal)
	local self = setmetatable({}, Signal)
	
	if createConnectionsChangedSignal then
		self.connectionsChanged = Signal.new()
	end

	self.connections = {}
	self.totalConnections = 0
	self.waiting = {}
	self.totalWaiting = 0

	return self
end



-- METHODS
function Signal:Fire(...)
	for _, connection in pairs(self.connections) do
		connection.Handler(...)
	end
	if self.totalWaiting > 0 then
		local packedArgs = table.pack(...)
		for waitingId, _ in pairs(self.waiting) do
			self.waiting[waitingId] = packedArgs
		end
	end
end
Signal.fire = Signal.Fire

function Signal:Connect(handler)
	if not (type(handler) == "function") then
		error(("connect(%s)"):format(typeof(handler)), 2)
	end
	
	local signal = self
	local connectionId = HttpService:GenerateGUID(false)
	local connection = {}
	connection.Connected = true
	connection.ConnectionId = connectionId
	connection.Handler = handler
	self.connections[connectionId] = connection

	function connection:Disconnect()
		signal.connections[connectionId] = nil
		connection.Connected = false
		signal.totalConnections -= 1
		if signal.connectionsChanged then
			signal.connectionsChanged:Fire(-1)
		end
	end
	connection.Destroy = connection.Disconnect
	connection.destroy = connection.Disconnect
	connection.disconnect = connection.Disconnect
	self.totalConnections += 1
	if self.connectionsChanged then
		self.connectionsChanged:Fire(1)
	end

	return connection
end
Signal.connect = Signal.Connect

function Signal:Wait()
	local waitingId = HttpService:GenerateGUID(false)
	self.waiting[waitingId] = true
	self.totalWaiting += 1
	repeat heartbeat:Wait() until self.waiting[waitingId] ~= true
	self.totalWaiting -= 1
	local args = self.waiting[waitingId]
	self.waiting[waitingId] = nil
	return unpack(args)
end
Signal.wait = Signal.Wait

function Signal:Destroy()
	if self.bindableEvent then
		self.bindableEvent:Destroy()
		self.bindableEvent = nil
	end
	if self.connectionsChanged then
		self.connectionsChanged:Fire(-self.totalConnections)
		self.connectionsChanged:Destroy()
		self.connectionsChanged = nil
	end
	self.totalConnections = 0
	for connectionId, connection in pairs(self.connections) do
		self.connections[connectionId] = nil
	end
end
Signal.destroy = Signal.Destroy
Signal.Disconnect = Signal.Destroy
Signal.disconnect = Signal.Destroy



return Signal