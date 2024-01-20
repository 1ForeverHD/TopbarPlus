-- LOCAL
local Utility = {}
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer



-- FUNCTIONS
function Utility.copyTable(t)
	-- Credit to Stephen Leitnick (September 13, 2017) for this function from TableUtil
	assert(type(t) == "table", "First argument must be a table")
	local tCopy = table.create(#t)
	for k,v in pairs(t) do
		if (type(v) == "table") then
			tCopy[k] = Utility.copyTable(v)
		else
			tCopy[k] = v
		end
	end
	return tCopy
end

function Utility.formatStateName(incomingStateName)
	return string.upper(string.sub(incomingStateName, 1, 1))..string.lower(string.sub(incomingStateName, 2))
end

function Utility.localPlayerRespawned(callback)
	-- The client localscript may be located under a ScreenGui with ResetOnSpawn set to true
	-- In these scenarios, traditional methods like CharacterAdded won't be called by the
	-- time the localscript has been destroyed, therefore we listen for died instead
	task.spawn(function()
		local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		local humanoid
		for i = 1, 5 do
			humanoid = character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				break
			end
			task.wait(1)
		end
		if humanoid then
			humanoid.Died:Once(function()
				task.delay(Players.RespawnTime-0.1, function()
					callback()
				end)

			end)
		end
	end)
end



return Utility
