-- This module enables you to place Icon wherever you like within the data model while
-- still enabling third-party applications (such as HDAdmin/Nanoblox) to locate it
-- This is necessary to prevent two TopbarPlus applications initiating at runtime which would
-- cause icons to overlap with each other

local replicatedStorage = game:GetService("ReplicatedStorage")
local TopbarPlusReference = {
    container = script.Parent
}

function TopbarPlusReference.addToReplicatedStorage()
    local existingItem = replicatedStorage:FindFirstChild(script.Name)
    if existingItem then
        return false
    end
    script:Clone().Parent = replicatedStorage
    return true
end

return TopbarPlusReference