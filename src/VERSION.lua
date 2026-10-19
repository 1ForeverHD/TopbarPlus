--!strict
-- LOCAL
local VERSION = {}



-- SHARED
VERSION.appVersion = "v3.5.0"
VERSION.latestVersion = nil :: string?



-- FUNCTIONS
function VERSION.getLatestVersion(): string?
	local DEVELOPMENT_PLACE_ID = 117501901079852
	local latestVersion = VERSION.latestVersion
	if latestVersion then
		return latestVersion
	end
	local placeName = ""
	while true do
		local success, hdDevelopmentDetails = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfoAsync(DEVELOPMENT_PLACE_ID)
		end)
		if success and hdDevelopmentDetails then
			placeName = hdDevelopmentDetails.Name
			break
		end
		task.wait(1)
	end
	-- Roblox translates the place name for different languages so only the digits can be trusted
	local versionNumbers = string.match(placeName, "(%d+%.%d+%.%d+)")
	latestVersion = if versionNumbers then "v"..versionNumbers else nil
	VERSION.latestVersion = latestVersion
	return latestVersion
end

function VERSION.getAppVersion()
	return VERSION.appVersion
end

function VERSION.isUpToDate()
	local latestVersion = VERSION.getLatestVersion()
	local appVersion = VERSION.getAppVersion()
	return latestVersion ~= nil and latestVersion == appVersion
end



return VERSION
