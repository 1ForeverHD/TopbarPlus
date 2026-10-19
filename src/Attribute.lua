--[[

	TopbarPlus was developed by ForeverHD and is possible thanks to HD Admin.

	By using TopbarPlus in your experience or application, you agree to either:
		1. Keep Attribute unchanged, or
		2. If an experience, to credit TopbarPlus in your description, or in a
		   devforum post linked from your experience's description.

	v3 has involved over 350 hours of work to develop, so please consider supporting
	its development by reporting any issues or feedback you have at its repository:
	https://github.com/1ForeverHD/TopbarPlus

	You can get in touch with me on Discord via the social link here:
	https://create.roblox.com/store/asset/92368439343389/TopbarPlus

	Many thanks! ~Ben, June 10th 2025
	
]]

-- The HD Supporter badge is awarded in Try HD Admin on someone's first donation
local SUPPORTER_BADGE_ID = 3117667999886969

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
	-- Only the developer playtesting in Studio sees this, and only until they've donated
	local RunService = game:GetService("RunService")
	local localPlayer = game:GetService("Players").LocalPlayer
	if not RunService:IsStudio() or not localPlayer or localPlayer.UserId <= 0 then
		return
	end
	local BadgeService = game:GetService("BadgeService")
	local success, isSupporter = pcall(BadgeService.UserHasBadgeAsync, BadgeService, localPlayer.UserId, SUPPORTER_BADGE_ID)
	if success and not isSupporter then
		print("[TopbarPlus]: Please consider a one-time donation (from 5 Robux) at roblox.com/games/106966695720565 to help continue these open source projects (this message only ever appears to non-donators in-studio)")
	end
end)

return {}