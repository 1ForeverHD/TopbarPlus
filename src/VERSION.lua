--!strict
-- LOCAL
local VERSION = {}



-- SHARED
VERSION.appVersion = "v3.3.1"
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
			return game:GetService("MarketplaceService"):GetProductInfo(DEVELOPMENT_PLACE_ID)
		end)
		if success and hdDevelopmentDetails then
			placeName = hdDevelopmentDetails.Name
			break
		end
		task.wait(1)
	end
	latestVersion = string.match(placeName, "^TopbarPlus (.*)$")
	if latestVersion then
		latestVersion = latestVersion:gsub("%s+", "") -- Remove all whitespace (spaces, tabs, newlines)
	end
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