--!strict
-- LOCAL
local VERSION = {}
local hasFetchedLatestVersion = false



-- SHARED
VERSION.appVersion = "v3.5.0"
VERSION.latestVersion = nil :: string?



-- FUNCTIONS
local function isNewerVersion(latest: string, current: string): boolean
	local latestParts = string.split(string.match(latest, "(%d+%.%d+%.%d+)") or "", ".")
	local currentParts = string.split(string.match(current, "(%d+%.%d+%.%d+)") or "", ".")
	for index = 1, 3 do
		local latestPart, currentPart = tonumber(latestParts[index]) or 0, tonumber(currentParts[index]) or 0
		if latestPart ~= currentPart then
			return latestPart > currentPart
		end
	end
	return false
end

function VERSION.getLatestVersion(): string?
	if hasFetchedLatestVersion then
		return VERSION.latestVersion
	end
	hasFetchedLatestVersion = true
	local success, result = pcall(function()
		return game:GetService("MarketplaceService"):GetProductInfoAsync(92368439343389)
	end)
	if success and result then
		local versionNumbers = string.match(result.Name, "v(%d+%.%d+%.%d+)")
		VERSION.latestVersion = if versionNumbers then "v"..versionNumbers else nil
	end
	return VERSION.latestVersion
end

function VERSION.getAppVersion()
	return VERSION.appVersion
end

function VERSION.isUpToDate()
	local latestVersion = VERSION.getLatestVersion()
	return latestVersion == nil or not isNewerVersion(latestVersion, VERSION.getAppVersion())
end



return VERSION
