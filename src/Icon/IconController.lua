--[[ icon_controller:header
## Functions

#### setGameTheme
```lua
IconController.setGameTheme(theme)
```
Sets the default theme which is applied to all existing and future icons.

----
#### setDisplayOrder
```lua
IconController.setDisplayOrder(number)
```
Changes the DisplayOrder of the TopbarPlus ScreenGui to the given value.

----
#### setTopbarEnabled
```lua
IconController.setTopbarEnabled(bool)
```
When set to ``false``, hides all icons created with TopbarPlus. This can also be achieved by calling ``starterGui:SetCore("TopbarEnabled", false)``.

----
#### setGap
```lua
IconController.setGap(integer, alignment)
```
Defines the offset width (i.e. gap) between each icon for the given alignment, ``left``, ``mid``, ``right``, or all alignments if not specified. 

----
#### setLeftOffset
```lua
IconController.setLeftOffset(integer)
```
Defines the offset from the left side of the screen to the nearest left-set icon. 

----
#### setRightOffset
```lua
IconController.setRightOffset(integer)
```
Defines the offset from the right side of the screen to the nearest right-set icon. 

----
#### updateTopbar
```lua
IconController.updateTopbar()
```
Determines how icons should be positioned on the topbar and moves them accordingly.  

----
#### clearIconOnSpawn
```lua
IconController.clearIconOnSpawn(icon)
```
Calls destroy on the given icon when the player respawns. This is useful for scenarious where you wish to cleanup icons that are constructed within a Gui with ``ResetOnSpawn`` set to ``true``. For example:

```lua
-- Place at the bottom of your icon creator localscript
local icons = IconController.getIcons()
for _, icon in pairs(icons) do
	IconController.clearIconOnSpawn(icon)
end
```

----
#### getIcons
```lua
local arrayOfIcons = IconController.getIcons()
```
Returns all icons as an array.

----
#### getIcon
```lua
local icon = IconController.getIcon(name)
```
Returns the icon with the given name (or ``false`` if not found). If multiple icons have the same name, then one will be returned randomly.

----



## Properties
#### mimicCoreGui
```lua
local bool = IconController.mimicCoreGui --[default: 'true']
```
Set to ``false`` to have the topbar persist even when ``game:GetService("StarterGui"):SetCore("TopbarEnabled", false)`` is called.

----
#### controllerModeEnabled
{read-only}
```lua
local bool = IconController.controllerModeEnabled
```

----
#### leftGap
{read-only}
```lua
local gapNumber = IconController.leftGap --[default: '12']
```

----
#### midGap
{read-only}
```lua
local gapNumber = IconController.midGap --[default: '12']
```

----
#### rightGap
{read-only}
```lua
local gapNumber = IconController.rightGap --[default: '12']
```

----
#### leftOffset
{read-only}
```lua
local offset = IconController.leftGap --[default: '0']
```

----
#### rightOffset
{read-only}
```lua
local offset = IconController.rightGap --[default: '0']
```
--]]



-- LOCAL
local starterGui = game:GetService("StarterGui")
local guiService = game:GetService("GuiService")
local hapticService = game:GetService("HapticService")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local players = game:GetService("Players")
local IconController = {}
local replicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(script.Parent.Signal)
local TopbarPlusGui = require(script.Parent.TopbarPlusGui)
local topbarIcons = {}
local fakeChatName = "_FakeChat"
local forceTopbarDisabled = false
local menuOpen
local topbarUpdating = false
local STUPID_CONTROLLER_OFFSET = 32



-- LOCAL FUNCTIONS
local function checkTopbarEnabled()
	local success, bool = xpcall(function()
		return starterGui:GetCore("TopbarEnabled")
	end,function(err)
		--has not been registered yet, but default is that is enabled
		return true	
	end)
	return (success and bool)
end

local function checkTopbarEnabledAccountingForMimic()
	local topbarEnabledAccountingForMimic = (checkTopbarEnabled() or not IconController.mimicCoreGui)
	return topbarEnabledAccountingForMimic
end



-- OFFSET HANDLERS
local alignmentDetails = {}
alignmentDetails["left"] = {
	startScale = 0,
	getOffset = function()
		local offset = 48 + IconController.leftOffset
		if checkTopbarEnabled() and starterGui:GetCoreGuiEnabled("Chat") then
			offset += 12 + 32
		end
		return offset
	end,
	getStartOffset = function()
		local alignmentGap = IconController["leftGap"]
		local startOffset = alignmentDetails.left.getOffset() + alignmentGap
		return startOffset
	end,
	records = {}
}
alignmentDetails["mid"] = {
	startScale = 0.5,
	getOffset = function()
		return 0
	end,
	getStartOffset = function(totalIconX) 
		local alignmentGap = IconController["midGap"]
		return -totalIconX/2 + (alignmentGap/2)
	end,
	records = {}
}
alignmentDetails["right"] = {
	startScale = 1,
	getOffset = function()
		local offset = IconController.rightOffset
		if checkTopbarEnabled() and (starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) or starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) or starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu)) then
			offset += 48
		end
		return offset
	end,
	getStartOffset = function(totalIconX)
		local startOffset = -totalIconX - alignmentDetails.right.getOffset()
		return startOffset
	end,
	records = {}
	--reverseSort = true
}



-- PROPERTIES
IconController.topbarEnabled = true
IconController.controllerModeEnabled = false
IconController.previousTopbarEnabled = checkTopbarEnabled()
IconController.leftGap = 12
IconController.midGap = 12
IconController.rightGap = 12
IconController.leftOffset = 0
IconController.rightOffset = 0
IconController.mimicCoreGui = true



-- EVENTS
IconController.iconAdded = Signal.new()
IconController.iconRemoved = Signal.new()
IconController.controllerModeStarted = Signal.new()
IconController.controllerModeEnded = Signal.new()



-- CONNECTIONS
local iconCreationCount = 0
IconController.iconAdded:Connect(function(icon)
	topbarIcons[icon] = true
	if IconController.gameTheme then
		icon:setTheme(IconController.gameTheme)
	end
	icon.updated:Connect(function()
		IconController.updateTopbar()
	end)
	-- When this icon is selected, deselect other icons if necessary
	icon.selected:Connect(function()
		local allIcons = IconController.getIcons()
		for _, otherIcon in pairs(allIcons) do
			if icon.deselectWhenOtherIconSelected and otherIcon ~= icon and otherIcon.deselectWhenOtherIconSelected and otherIcon:getToggleState() == "selected" then
				otherIcon:deselect(icon)
			end
		end
	end)
	-- Order by creation if no order specified
	iconCreationCount = iconCreationCount + 1
	icon:setOrder(iconCreationCount)
	-- Apply controller view if enabled
	if IconController.controllerModeEnabled then
		IconController._enableControllerModeForIcon(icon, true)
	end
	IconController:_updateSelectionGroup()
	IconController.updateTopbar()
end)

IconController.iconRemoved:Connect(function(icon)
	topbarIcons[icon] = nil
	icon:setEnabled(false)
	icon:deselect()
	icon.updated:Fire()
	IconController:_updateSelectionGroup()
end)



-- METHODS
function IconController.setGameTheme(theme)
	IconController.gameTheme = theme
	local icons = IconController.getIcons()
	for _, icon in pairs(icons) do
		icon:setTheme(theme)
	end
end

function IconController.setDisplayOrder(value)
	value = tonumber(value) or TopbarPlusGui.DisplayOrder
	TopbarPlusGui.DisplayOrder = value
end
IconController.setDisplayOrder(10)

function IconController.getIcons()
	local allIcons = {}
	for otherIcon, _ in pairs(topbarIcons) do
		table.insert(allIcons, otherIcon)
	end
	return allIcons
end

function IconController.getIcon(name)
	for otherIcon, _ in pairs(topbarIcons) do
		if otherIcon.name == name then
			return otherIcon
		end
	end
	return false
end

function IconController.canShowIconOnTopbar(icon)
	if (icon.enabled == true or icon.accountForWhenDisabled) and icon.presentOnTopbar then
		return true
	end
	return false
end

function IconController.getMenuOffset(icon)
	local alignment = icon:get("alignment")
	local alignmentGap = IconController[alignment.."Gap"]
	local iconSize = icon:get("iconSize") or UDim2.new(0, 32, 0, 32)
	local sizeX = iconSize.X.Offset
	local iconWidthAndGap = (sizeX + alignmentGap)
	local extendLeft = 0
	local extendRight = 0
	local additionalRight = 0
	if icon.menuOpen then
		local menuSize = icon:get("menuSize")
		local menuSizeXOffset = menuSize.X.Offset
		local direction = icon:_getMenuDirection()
		if direction == "right" then
			extendRight += menuSizeXOffset + alignmentGap/6--2
		elseif direction == "left" then
			extendLeft = menuSizeXOffset + 4
			extendRight += alignmentGap/3--4
			additionalRight = menuSizeXOffset
		end
	end
	return extendLeft, extendRight, additionalRight
end

-- This is responsible for positioning the topbar icons
local requestedTopbarUpdate = false
function IconController.updateTopbar()
	local function getIncrement(otherIcon, alignment)
		--local container = otherIcon.instances.iconContainer
		--local sizeX = container.Size.X.Offset
		local iconSize = otherIcon:get("iconSize", otherIcon:getIconState()) or UDim2.new(0, 32, 0, 32)
		local sizeX = iconSize.X.Offset
		local alignmentGap = IconController[alignment.."Gap"]
		local iconWidthAndGap = (sizeX + alignmentGap)
		local increment = iconWidthAndGap
		local preOffset = 0
		if otherIcon._parentIcon == nil then
			local extendLeft, extendRight, additionalRight = IconController.getMenuOffset(otherIcon)
			preOffset += extendLeft
			increment += extendRight + additionalRight
		end
		return increment, preOffset
	end
	if topbarUpdating then -- This prevents the topbar updating and shifting icons more than it needs to
		requestedTopbarUpdate = true
		return false
	end
	coroutine.wrap(function()
		topbarUpdating = true
		runService.Heartbeat:Wait()
		topbarUpdating = false
		
		for alignment, alignmentInfo in pairs(alignmentDetails) do
			alignmentInfo.records = {}
		end

		for otherIcon, _ in pairs(topbarIcons) do
			if IconController.canShowIconOnTopbar(otherIcon) then
				local alignment = otherIcon:get("alignment")
				table.insert(alignmentDetails[alignment].records, otherIcon)
			end
		end
		local viewportSize = workspace.CurrentCamera.ViewportSize
		for alignment, alignmentInfo in pairs(alignmentDetails) do
			local records = alignmentInfo.records
			if #records > 1 then
				if alignmentInfo.reverseSort then
					table.sort(records, function(a,b) return a:get("order") > b:get("order") end)
				else
					table.sort(records, function(a,b) return a:get("order") < b:get("order") end)
				end
			end
			local totalIconX = 0
			for i, otherIcon in pairs(records) do
				local increment = getIncrement(otherIcon, alignment)
				totalIconX = totalIconX + increment
			end
			local offsetX = alignmentInfo.getStartOffset(totalIconX, alignment)
			local preOffsetX = offsetX
			local containerX = TopbarPlusGui.TopbarContainer.AbsoluteSize.X
			for i, otherIcon in pairs(records) do
				local increment, preOffset = getIncrement(otherIcon, alignment)
				local newAbsoluteX = alignmentInfo.startScale*containerX + preOffsetX+preOffset
				preOffsetX = preOffsetX + increment
			end
			for i, otherIcon in pairs(records) do
				local container = otherIcon.instances.iconContainer
				local increment, preOffset = getIncrement(otherIcon, alignment)
				local topPadding = otherIcon.topPadding
				local newPositon = UDim2.new(alignmentInfo.startScale, offsetX+preOffset, topPadding.Scale, topPadding.Offset)
				local isAnOverflowIcon = string.match(otherIcon.name, "_overflowIcon-")
				local repositionInfo = otherIcon:get("repositionInfo")
				if repositionInfo then
					tweenService:Create(container, repositionInfo, {Position = newPositon}):Play()
				else
					container.Position = newPositon
				end
				offsetX = offsetX + increment
				otherIcon.targetPosition = UDim2.new(0, (newPositon.X.Scale*viewportSize.X) + newPositon.X.Offset, 0, (newPositon.Y.Scale*viewportSize.Y) + newPositon.Y.Offset)
			end
		end

		-- OVERFLOW HANDLER
		--------
		local START_LEEWAY = 10 -- The additional offset where the end icon will be converted to ... without an apparant change in position
		local function getBoundaryX(iconToCheck, side, gap)
			local additionalGap = gap or 0
			local currentSize = iconToCheck:get("iconSize", iconToCheck:getIconState())
			local sizeX = currentSize.X.Offset
			local extendLeft, extendRight = IconController.getMenuOffset(iconToCheck)
			local boundaryXOffset = (side == "left" and (-additionalGap-extendLeft)) or (side == "right" and sizeX+additionalGap+extendRight)
			local boundaryX = iconToCheck.targetPosition.X.Offset + boundaryXOffset
			return boundaryX
		end
		local function getSizeX(iconToCheck, usePrevious)
			local currentSize, previousSize = iconToCheck:get("iconSize", iconToCheck:getIconState(), "beforeDropdown")
			local newSize = (usePrevious and previousSize) or currentSize
			local extendLeft, extendRight = IconController.getMenuOffset(iconToCheck)
			local sizeX = newSize.X.Offset + extendLeft + extendRight
			return sizeX
		end

		for alignment, alignmentInfo in pairs(alignmentDetails) do
			local overflowIcon = alignmentInfo.overflowIcon
			if overflowIcon then
				local alignmentGap = IconController[alignment.."Gap"]
				local oppositeAlignment = (alignment == "left" and "right") or "left"
				local oppositeAlignmentInfo = alignmentDetails[oppositeAlignment]
				local oppositeOverflowIcon = IconController.getIcon("_overflowIcon-"..oppositeAlignment)
				
				-- This determines whether any icons (from opposite or mid alignment) are overlapping with this alignment
				local overflowBoundaryX = getBoundaryX(overflowIcon, alignment)
				if overflowIcon.enabled then
					overflowBoundaryX = getBoundaryX(overflowIcon, oppositeAlignment, alignmentGap)
				end
				local function doesExceed(givenBoundaryX)
					local exceeds = (alignment == "left" and givenBoundaryX < overflowBoundaryX) or (alignment == "right" and givenBoundaryX > overflowBoundaryX)
					return exceeds
				end
				local alignmentOffset = oppositeAlignmentInfo.getOffset()
				if not overflowIcon.enabled then
					alignmentOffset += START_LEEWAY
				end
				local alignmentBorderX = (alignment == "left" and viewportSize.X - alignmentOffset) or (alignment == "right" and alignmentOffset)
				local closestBoundaryX = alignmentBorderX
				local exceededCriticalBoundary = doesExceed(closestBoundaryX)
				local function checkBoundaryExceeded(recordToCheck)
					local totalIcons = #recordToCheck
					for i = 1, totalIcons do
						local endIcon = recordToCheck[totalIcons+1 - i]
						if IconController.canShowIconOnTopbar(endIcon) then
							local isAnOverflowIcon = string.match(endIcon.name, "_overflowIcon-")
							if isAnOverflowIcon and totalIcons ~= 1 then --!!!
								break
							elseif isAnOverflowIcon and not endIcon.enabled then
								continue
							end
							local additionalMyX = 0
							if not overflowIcon.enabled then
								additionalMyX = START_LEEWAY
							end
							local myBoundaryX = getBoundaryX(endIcon, alignment, additionalMyX)
							local isNowClosest = (alignment == "left" and myBoundaryX < closestBoundaryX) or (alignment == "right" and myBoundaryX > closestBoundaryX)
							if isNowClosest then
								closestBoundaryX = myBoundaryX
								if doesExceed(myBoundaryX) then
									exceededCriticalBoundary = true
								end
							end
						end
					end
				end
				checkBoundaryExceeded(alignmentDetails[oppositeAlignment].records)
				checkBoundaryExceeded(alignmentDetails.mid.records)

				-- This determines which icons to give to the overflow if an overlap is present
				if exceededCriticalBoundary then
					local recordToCheck = alignmentInfo.records
					local totalIcons = #recordToCheck
					for i = 1, totalIcons do
						local endIcon = (alignment == "left" and recordToCheck[totalIcons+1 - i]) or (alignment == "right" and recordToCheck[i])
						if endIcon ~= overflowIcon and IconController.canShowIconOnTopbar(endIcon) then
							local additionalGap = alignmentGap
							local overflowIconSizeX = overflowIcon:get("iconSize", overflowIcon:getIconState()).X.Offset
							if overflowIcon.enabled then
								additionalGap += alignmentGap + overflowIconSizeX
							end
							local myBoundaryXPlusGap = getBoundaryX(endIcon, oppositeAlignment, additionalGap)
							local exceeds = (alignment == "left" and myBoundaryXPlusGap >= closestBoundaryX) or (alignment == "right" and myBoundaryXPlusGap <= closestBoundaryX)
							if exceeds then
								if not overflowIcon.enabled then
									local overflowContainer = overflowIcon.instances.iconContainer
									local yPos = overflowContainer.Position.Y
									local appearXAdditional = (alignment == "left" and -overflowContainer.Size.X.Offset) or 0
									local appearX = getBoundaryX(endIcon, oppositeAlignment, appearXAdditional)
									overflowContainer.Position = UDim2.new(0, appearX, yPos.Scale, yPos.Offset)
									overflowIcon:setEnabled(true)
								end
								if #endIcon.dropdownIcons > 0 then
									endIcon._overflowConvertedToMenu = true
									local wasSelected = endIcon.isSelected
									endIcon:deselect()
									local iconsToConvert = {}
									for _, dIcon in pairs(endIcon.dropdownIcons) do
										table.insert(iconsToConvert, dIcon)
									end
									for _, dIcon in pairs(endIcon.dropdownIcons) do
										dIcon:leave()
									end
									endIcon:setMenu(iconsToConvert)
									if wasSelected and overflowIcon.isSelected then
										endIcon:select()
									end
								end
								endIcon:join(overflowIcon, "dropdown")
								if #endIcon.menuIcons > 0 and endIcon.menuOpen then
									endIcon:deselect()
									endIcon:select()
									overflowIcon:select()
								end
							end
							break
						end
					end
				
				else
					
					-- This checks to see if the lowest/highest (depending on left/right) ordered overlapping icon is no longer overlapping, removes from the dropdown, and repeats if valid
					local winningOrder, winningOverlappedIcon
					local totalOverlappingIcons = #overflowIcon.dropdownIcons
					if not (oppositeOverflowIcon and oppositeOverflowIcon.enabled and #alignmentInfo.records == 1 and #oppositeAlignmentInfo.records ~= 1) then
						for _, overlappedIcon in pairs(overflowIcon.dropdownIcons) do
							local iconOrder = overlappedIcon:get("order")
							if winningOverlappedIcon == nil or (alignment == "left" and iconOrder < winningOrder) or (alignment == "right" and iconOrder > winningOrder) then
								winningOrder = iconOrder
								winningOverlappedIcon = overlappedIcon
							end
						end
					end
					if winningOverlappedIcon then
						local sizeX = getSizeX(winningOverlappedIcon, true)
						local myForesightBoundaryX = getBoundaryX(overflowIcon, oppositeAlignment)
						if totalOverlappingIcons == 1 then
							myForesightBoundaryX = getBoundaryX(overflowIcon, alignment, alignmentGap-START_LEEWAY)
						end
						local availableGap = math.abs(closestBoundaryX - myForesightBoundaryX) - (alignmentGap*2)
						local noLongerExeeds = (sizeX < availableGap)
						if noLongerExeeds then
							if #overflowIcon.dropdownIcons == 1 then
								overflowIcon:setEnabled(false)
							end
							local overflowContainer = overflowIcon.instances.iconContainer
							local yPos = overflowContainer.Position.Y
							overflowContainer.Position = UDim2.new(0, myForesightBoundaryX, yPos.Scale, yPos.Offset)
							winningOverlappedIcon:leave()
							--
							if winningOverlappedIcon._overflowConvertedToMenu then
								winningOverlappedIcon._overflowConvertedToMenu = nil
								local iconsToConvert = {}
								for _, dIcon in pairs(winningOverlappedIcon.menuIcons) do
									table.insert(iconsToConvert, dIcon)
								end
								for _, dIcon in pairs(winningOverlappedIcon.menuIcons) do
									dIcon:leave()
								end
								winningOverlappedIcon:setDropdown(iconsToConvert)
							end
							--
						end
					end

				end
			end
		end
		--------
		if requestedTopbarUpdate then
			requestedTopbarUpdate = false
			IconController.updateTopbar()
		end
		return true
	end)()
end

function IconController.setTopbarEnabled(bool, forceBool)
	if forceBool == nil then
		forceBool = true
	end
	local indicator = TopbarPlusGui.Indicator
	if forceBool and not bool then
		forceTopbarDisabled = true
	elseif forceBool and bool then
		forceTopbarDisabled = false
	end
	local topbarEnabledAccountingForMimic = checkTopbarEnabledAccountingForMimic()
	if IconController.controllerModeEnabled then
		if bool then
			if TopbarPlusGui.TopbarContainer.Visible or forceTopbarDisabled or menuOpen or not topbarEnabledAccountingForMimic then return end
			if forceBool then
				indicator.Visible = topbarEnabledAccountingForMimic
			else
				if hapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) and hapticService:IsMotorSupported(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small) then
					hapticService:SetMotor(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small,1)
					delay(0.2,function()
						pcall(function()
							hapticService:SetMotor(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small,0)
						end)
					end)
				end
				TopbarPlusGui.TopbarContainer.Visible = true
				TopbarPlusGui.TopbarContainer:TweenPosition(
					UDim2.new(0,0,0,5 + STUPID_CONTROLLER_OFFSET),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					0.1,
					true
				)
				
				
				local selectIcon
				local targetOffset = 0
				IconController:_updateSelectionGroup()
				runService.Heartbeat:Wait()
				local indicatorSizeTrip = 50 --indicator.AbsoluteSize.Y * 2
				for otherIcon, _ in pairs(topbarIcons) do
					if IconController.canShowIconOnTopbar(otherIcon) and (selectIcon == nil or otherIcon:get("order") > selectIcon:get("order")) then
						selectIcon = otherIcon
					end
					local container = otherIcon.instances.iconContainer
					local newTargetOffset = -27 + container.AbsoluteSize.Y + indicatorSizeTrip
					if newTargetOffset > targetOffset then
						targetOffset = newTargetOffset
					end
				end
				if guiService:GetEmotesMenuOpen() then
					guiService:SetEmotesMenuOpen(false)
				end
				if guiService:GetInspectMenuEnabled() then
					guiService:CloseInspectMenu()
				end
				local newSelectedObject = IconController._previousSelectedObject or selectIcon.instances.iconButton
				IconController._setControllerSelectedObject(newSelectedObject)
				indicator.Image = "rbxassetid://5278151071"
				indicator:TweenPosition(
					UDim2.new(0.5,0,0,targetOffset + STUPID_CONTROLLER_OFFSET),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					0.1,
					true
				)
			end
		else
			if forceBool then
				indicator.Visible = false
			else
				indicator.Visible = topbarEnabledAccountingForMimic
			end
			if not TopbarPlusGui.TopbarContainer.Visible then return end
			guiService.AutoSelectGuiEnabled = true
			IconController:_updateSelectionGroup(true)
			TopbarPlusGui.TopbarContainer:TweenPosition(
				UDim2.new(0,0,0,-TopbarPlusGui.TopbarContainer.Size.Y.Offset + STUPID_CONTROLLER_OFFSET),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true,
				function()
					TopbarPlusGui.TopbarContainer.Visible = false
				end
			)
			indicator.Image = "rbxassetid://5278151556"
			indicator:TweenPosition(
				UDim2.new(0.5,0,0,5),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true
			)
		end
	else
		local topbarContainer = TopbarPlusGui.TopbarContainer
		if topbarEnabledAccountingForMimic then
			topbarContainer.Visible = bool
		else
			topbarContainer.Visible = false
		end
	end
end

function IconController.setGap(value, alignment)
	local newValue = tonumber(value) or 12
	local newAlignment = tostring(alignment):lower()
	if newAlignment == "left" or newAlignment == "mid" or newAlignment == "right" then
		IconController[newAlignment.."Gap"] = newValue
		IconController.updateTopbar()
		return
	end
	IconController.leftGap = newValue
	IconController.midGap = newValue
	IconController.rightGap = newValue
	IconController.updateTopbar()
end

function IconController.setLeftOffset(value)
	IconController.leftOffset = tonumber(value) or 0
	IconController.updateTopbar()
end

function IconController.setRightOffset(value)
	IconController.rightOffset = tonumber(value) or 0
	IconController.updateTopbar()
end

local localPlayer = players.LocalPlayer
local iconsToClearOnSpawn = {}
localPlayer.CharacterAdded:Connect(function()
	for _, icon in pairs(iconsToClearOnSpawn) do
		icon:destroy()
	end
	iconsToClearOnSpawn = {}
end)
function IconController.clearIconOnSpawn(icon)
	coroutine.wrap(function()
		local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
		table.insert(iconsToClearOnSpawn, icon)
	end)()
end



-- PRIVATE METHODS
function IconController:_updateSelectionGroup(clearAll)
	if IconController._navigationEnabled then
		guiService:RemoveSelectionGroup("TopbarPlusIcons")
	end
	if clearAll then
		guiService.CoreGuiNavigationEnabled = IconController._originalCoreGuiNavigationEnabled
		guiService.GuiNavigationEnabled = IconController._originalGuiNavigationEnabled
		IconController._navigationEnabled = nil
	elseif IconController.controllerModeEnabled then
		local icons = IconController.getIcons()
		local iconContainers = {}
		for i, otherIcon in pairs(icons) do
			local featureName = otherIcon.joinedFeatureName
			if not featureName or otherIcon._parentIcon[otherIcon.joinedFeatureName.."Open"] == true then
				table.insert(iconContainers, otherIcon.instances.iconButton)
			end
		end
		guiService:AddSelectionTuple("TopbarPlusIcons", table.unpack(iconContainers))
		if not IconController._navigationEnabled then
			IconController._originalCoreGuiNavigationEnabled = guiService.CoreGuiNavigationEnabled
			IconController._originalGuiNavigationEnabled = guiService.GuiNavigationEnabled
			guiService.CoreGuiNavigationEnabled = false
			guiService.GuiNavigationEnabled = true
			IconController._navigationEnabled = true
		end
	end
end

local function getScaleMultiplier()
	if guiService:IsTenFootInterface() then
		return 3
	else
		return 1.3
	end
end

function IconController._setControllerSelectedObject(object)
	local startId = (IconController._controllerSetCount and IconController._controllerSetCount + 1) or 0
	IconController._controllerSetCount = startId
	guiService.SelectedObject = object
	delay(0.1, function() -- blame the roblox guiservice its a piece of doo doo
		local finalId = IconController._controllerSetCount
		if startId == finalId then
			guiService.SelectedObject = object
		end
	end)
end

function IconController._enableControllerMode(bool)
	local indicator = TopbarPlusGui.Indicator
	local controllerOptionIcon = IconController.getIcon("_TopbarControllerOption")
	if IconController.controllerModeEnabled == bool then
		return
	end
	IconController.controllerModeEnabled = bool
	if bool then
		TopbarPlusGui.TopbarContainer.Position = UDim2.new(0,0,0,5)
		TopbarPlusGui.TopbarContainer.Visible = false
		local scaleMultiplier = getScaleMultiplier()
		indicator.Position = UDim2.new(0.5,0,0,5)
		indicator.Size = UDim2.new(0, 18*scaleMultiplier, 0, 18*scaleMultiplier)
		indicator.Image = "rbxassetid://5278151556"
		indicator.Visible = checkTopbarEnabledAccountingForMimic()
		indicator.Position = UDim2.new(0.5,0,0,5)
	else
		TopbarPlusGui.TopbarContainer.Position = UDim2.new(0,0,0,0)
		TopbarPlusGui.TopbarContainer.Visible = checkTopbarEnabledAccountingForMimic()
		indicator.Visible = false
		IconController._setControllerSelectedObject(nil)
	end
	for icon, _ in pairs(topbarIcons) do
		IconController._enableControllerModeForIcon(icon, bool)
	end
end

function IconController._enableControllerModeForIcon(icon, bool)
	local parentIcon = icon._parentIcon
	local featureName = icon.joinedFeatureName
	if parentIcon then
		icon:leave()
	end
	if bool then
		local scaleMultiplier = getScaleMultiplier()
		local currentSizeDeselected = icon:get("iconSize", "deselected")
		local currentSizeSelected = icon:get("iconSize", "selected")
		local currentSizeHovering = icon:getHovering("iconSize")
		icon:set("iconSize", UDim2.new(0, currentSizeDeselected.X.Offset*scaleMultiplier, 0, currentSizeDeselected.Y.Offset*scaleMultiplier), "deselected", "controllerMode")
		icon:set("iconSize", UDim2.new(0, currentSizeSelected.X.Offset*scaleMultiplier, 0, currentSizeSelected.Y.Offset*scaleMultiplier), "selected", "controllerMode")
		if currentSizeHovering then
			icon:set("iconSize", UDim2.new(0, currentSizeSelected.X.Offset*scaleMultiplier, 0, currentSizeSelected.Y.Offset*scaleMultiplier), "hovering", "controllerMode")
		end
		icon:set("alignment", "mid", "deselected", "controllerMode")
		icon:set("alignment", "mid", "selected", "controllerMode")
	else
		local states = {"deselected", "selected", "hovering"}
		for _, iconState in pairs(states) do
			local _, previousAlignment = icon:get("alignment", iconState, "controllerMode")
			if previousAlignment then
				icon:set("alignment", previousAlignment, iconState)
			end
			local currentSize, previousSize = icon:get("iconSize", iconState, "controllerMode")
			if previousSize then
				icon:set("iconSize", previousSize, iconState)
			end
		end
	end
	if parentIcon then
		icon:join(parentIcon, featureName)
	end
end



-- BEHAVIOUR
--Controller support
coroutine.wrap(function()
	
	-- Create PC 'Enter Controller Mode' Icon
	runService.Heartbeat:Wait() -- This is required to prevent an infinite recursion
	local Icon = require(script.Parent)
	local controllerOptionIcon = Icon.new()
		:setName("_TopbarControllerOption")
		:setOrder(100)
		:setImage("rbxassetid://5278150942")
		:setRight()
		:setEnabled(false)
		:setTip("Controller mode")
	controllerOptionIcon.deselectWhenOtherIconSelected = false

	-- This decides what controller widgets and displays to show based upon their connected inputs
	-- For example, if on PC with a controller, give the player the option to enable controller mode with a toggle
	-- While if using a console (no mouse, but controller) then bypass the toggle and automatically enable controller mode
	local function determineDisplay()
		local mouseEnabled = userInputService.MouseEnabled
		local controllerEnabled = userInputService.GamepadEnabled
		local iconIsSelected = controllerOptionIcon.isSelected
		if mouseEnabled and controllerEnabled then
			-- Show icon
			controllerOptionIcon:setEnabled(true)
		elseif mouseEnabled and not controllerEnabled then
			-- Hide icon, disableControllerMode
			controllerOptionIcon:setEnabled(false)
			IconController._enableControllerMode(false)
			controllerOptionIcon:deselect()
		elseif not mouseEnabled and controllerEnabled then
			-- Hide icon, _enableControllerMode
			controllerOptionIcon:setEnabled(false)
			IconController._enableControllerMode(true)
		end
	end
	userInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(determineDisplay)
	userInputService.GamepadConnected:Connect(determineDisplay)
	userInputService.GamepadDisconnected:Connect(determineDisplay)
	determineDisplay()

	-- Enable/Disable Controller Mode when icon clicked
	local function iconClicked()
		local isSelected = controllerOptionIcon.isSelected
		local iconTip = (isSelected and "Normal mode") or "Controller mode"
		controllerOptionIcon:setTip(iconTip)
		IconController._enableControllerMode(isSelected)
	end
	controllerOptionIcon.selected:Connect(iconClicked)
	controllerOptionIcon.deselected:Connect(iconClicked)

	-- Hide/show topbar when indicator action selected in controller mode
	userInputService.InputBegan:Connect(function(input,gpe)
		if not IconController.controllerModeEnabled then return end
		if input.KeyCode == Enum.KeyCode.DPadDown then
			if not guiService.SelectedObject and checkTopbarEnabledAccountingForMimic() then
				IconController.setTopbarEnabled(true,false)
			end
		elseif input.KeyCode == Enum.KeyCode.ButtonB then
			IconController._previousSelectedObject = guiService.SelectedObject
			IconController._setControllerSelectedObject(nil)
			IconController.setTopbarEnabled(false,false)
		end
		input:Destroy()
	end)

	-- Setup overflow icons
	for alignment, detail in pairs(alignmentDetails) do
		if alignment ~= "mid" then
			local overflowName = "_overflowIcon-"..alignment
			local overflowIcon = Icon.new()
				:setImage(6069276526)
				:setName(overflowName)
				:setEnabled(false)
			detail.overflowIcon = overflowIcon
			overflowIcon.accountForWhenDisabled = true
			if alignment == "left" then
				overflowIcon:setOrder(math.huge)
				overflowIcon:setLeft()
				overflowIcon:set("dropdownAlignment", "right")
			elseif alignment == "right" then
				overflowIcon:setOrder(-math.huge)
				overflowIcon:setRight()
				overflowIcon:set("dropdownAlignment", "left")
			end
			overflowIcon.lockedSettings = {
				["iconImage"] = true,
				["order"] = true,
				["alignment"] = true,
			}
		end
	end
end)()

-- Mimic the enabling of the topbar when StarterGui:SetCore("TopbarEnabled", state) is called
coroutine.wrap(function()
	local chatScript = players.LocalPlayer.PlayerScripts:WaitForChild("ChatScript", 4) or game:GetService("Chat"):WaitForChild("ChatScript", 4)
	if not chatScript then return end
	local chatMain = chatScript:FindFirstChild("ChatMain")
	if not chatMain then return end
	local ChatMain = require(chatMain)
	ChatMain.CoreGuiEnabled:connect(function()
		local topbarEnabled = checkTopbarEnabled()
		if topbarEnabled == IconController.previousTopbarEnabled then
			IconController.updateTopbar()
			return "SetCoreGuiEnabled was called instead of SetCore"
		end
		if IconController.mimicCoreGui then
			IconController.previousTopbarEnabled = topbarEnabled
			if IconController.controllerModeEnabled then
				IconController.setTopbarEnabled(false,false)
			else
				IconController.setTopbarEnabled(topbarEnabled,false)
			end
		end
		IconController.updateTopbar()
	end)
	local makeVisible = checkTopbarEnabled()
	if not makeVisible and not IconController.mimicCoreGui then
		makeVisible = true
	end
	IconController.setTopbarEnabled(makeVisible, false)
end)()

-- Mimic roblox menu when opened and closed
guiService.MenuClosed:Connect(function()
	menuOpen = false
	if not IconController.controllerModeEnabled then
		IconController.setTopbarEnabled(IconController.topbarEnabled,false)
	end
end)
guiService.MenuOpened:Connect(function()
	menuOpen = true
	IconController.setTopbarEnabled(false,false)
end)

-- Add icons to an overflow if they overlap the screen bounds or other icons
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	IconController.updateTopbar()
end)



return IconController