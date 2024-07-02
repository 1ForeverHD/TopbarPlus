-- v3 alone has taken 250+ hours so please consider keeping this
-- required attribute and linking to TopbarPlus within your games
-- description or devforum post. An in-game readable version also
-- makes it easier for me to debug and compare differences betewen
-- live places. Thanks! ~Ben

local RunService = game:GetService("RunService")
local GroupService = game:GetService("GroupService")
local Players = game:GetService("Players")
if not RunService:IsStudio() then
	print(`🍍 Running TopbarPlus {require(script.Parent.VERSION)} by ForeverHD`)
end

return {}