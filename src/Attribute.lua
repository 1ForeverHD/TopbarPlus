-- v3 alone has taken 300+ hours so please consider keeping this
-- required attribute and linking to TopbarPlus within your games
-- description or devforum post. An in-game readable version also
-- makes it easier for me to debug and compare differences betewen
-- live places. Thanks! ~Ben

task.defer(function()
	local RunService = game:GetService("RunService")
	local VERSION = require(script.Parent.VERSION)
	local appVersion = VERSION.getAppVersion()
	local latestVersion = VERSION.getLatestVersion()
	local isOutdated = not VERSION.isUpToDate()
	if not RunService:IsStudio() then
		print(`🍍 Running TopbarPlus {appVersion} by ForeverHD`)
	end
	if isOutdated then
		warn(`A new version of TopbarPlus ({latestVersion}) is available: https://devforum.roblox.com/t/topbarplus/1017485`)
	end
end)

return {}