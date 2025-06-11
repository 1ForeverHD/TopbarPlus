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

task.defer(function()
	local RunService = game:GetService("RunService")
	local VERSION = require(script.Parent.VERSION)
	local appVersion = VERSION.getAppVersion()
	local latestVersion = VERSION.getLatestVersion()
	local isOutdated = not VERSION.isUpToDate()
	if not RunService:IsStudio() then
		print(`🍍 Running TopbarPlus {appVersion} by @ForeverHD & HD Admin`)
	end
	if isOutdated then
		warn(`A new version of TopbarPlus ({latestVersion}) is available: https://devforum.roblox.com/t/topbarplus/1017485`)
	end
end)

return {}