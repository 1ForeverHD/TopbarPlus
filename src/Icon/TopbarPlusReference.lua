-- This module enables you to place Icon wherever you like within the data model while
-- still enabling third-party applications (such as HDAdmin/Nanoblox) to locate it
-- This is necessary to prevent two TopbarPlus applications initiating at runtime which would
-- cause icons to overlap with each other

local replicatedStorage = game:GetService("ReplicatedStorage")
local TopbarPlusReference = {}

function TopbarPlusReference.addToReplicatedStorage()
    local existingItem = replicatedStorage:FindFirstChild(script.Name)
    if existingItem then
        return false
    end
    local objectValue = Instance.new("ObjectValue")
    objectValue.Name = script.Name
    objectValue.Value = script.Parent
    objectValue.Parent = replicatedStorage
    return objectValue
end

function TopbarPlusReference.getObject()
    local objectValue = replicatedStorage:FindFirstChild(script.Name)
    if objectValue then
        return objectValue
    end
    return false
end

return TopbarPlusReference