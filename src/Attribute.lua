--[[

	TopbarPlus was developed by ForeverHD and is possible thanks to HD Admin.

	By using TopbarPlus in your experience or application, you agree to either:
		1. Keep Attribute unchanged, or
		2. If an experience, to credit TopbarPlus in your description, or in a
		   devforum post linked from your experience's description.

	v3 has involved over 380 hours of work to develop, so please consider supporting
	its development by donating here:
	https://www.roblox.com/games/start?placeId=106966695720565

	You can suggest features or report bugs with the tag 'TopbarPlus' here:
	https://forum.hdadmin.com/

	Many thanks! ~Ben, October 19th 2026

]]


task.defer(function()
	local RunService = game:GetService("RunService")
	local VERSION = require(script.Parent.VERSION)
	local appVersion = VERSION.getAppVersion()
	local latestVersion = VERSION.getLatestVersion()
	local isOutdated = not VERSION.isUpToDate()
	if not RunService:IsStudio() then
		print(`🍍 Running TopbarPlus {appVersion} by @ForeverHD & HD Admin`)
	end
	if isOutdated and latestVersion then
		warn(`A new version of TopbarPlus ({appVersion} -> {latestVersion}) is available: https://devforum.roblox.com/t/topbarplus/1017485`)
	end
end)

task.defer(function()
	-- Only the developer playtesting in Studio sees this, and only if not donated. Nothing ever appears in-game
	local RunService = game:GetService("RunService")
	local localPlayer = game:GetService("Players").LocalPlayer
	if not RunService:IsStudio() or not localPlayer or localPlayer.UserId <= 0 then
		return
	end
	local BadgeService = game:GetService("BadgeService")
	local success, isSupporter = pcall(BadgeService.UserHasBadgeAsync, BadgeService, localPlayer.UserId, 3117667999886969)
	if success and not isSupporter then
		print("[TopbarPlus]: Please consider a one-time donation (from 5 Robux) at https://www.roblox.com/games/start?placeId=106966695720565 to support this project (this message only ever appears to non-donators in-studio)")
	end
end)

return {}