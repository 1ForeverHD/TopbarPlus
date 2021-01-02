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
local HDAdmin = replicatedStorage:WaitForChild("HDAdmin")
local Signal = require(HDAdmin:WaitForChild("Signal"))
local topbarIcons = {}
local fakeChatName = "_FakeChat"
local forceTopbarDisabled = false
local menuOpen
local topbarUpdating = false
local STUPID_ROBLOX_CONTROLLER_OFFSET = 32



-- LOCAL METHODS
local function getTopbarPlusGui()
	local player = game:GetService("Players").LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	local topbarPlusGui = playerGui:WaitForChild("Topbar+")
	return topbarPlusGui
end
local function checkTopbarEnabled()
	local success, bool = xpcall(function()
		return starterGui:GetCore("TopbarEnabled")
	end,function(err)
		--has not been registered yet, but default is that is enabled
		return true	
	end)
	return (success and bool)
end



-- PROPERTIES
IconController.topbarEnabled = true
IconController.controllerModeEnabled = false
IconController.previousTopbarEnabled = checkTopbarEnabled()
IconController.leftGap = 24
IconController.midGap = 12
IconController.rightGap = 12



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
		local toggleTransitionInfo = icon:get("toggleTransitionInfo")
		IconController.updateTopbar(toggleTransitionInfo)
	end)
	-- When this icon is selected, deselect other icons if necessary
	icon.selected:Connect(function()
		local allIcons = IconController.getIcons()
		for _, otherIcon in pairs(allIcons) do
			if icon.deselectWhenOtherIconSelected and otherIcon ~= icon and otherIcon.deselectWhenOtherIconSelected and otherIcon:getToggleState() == "selected" then
				otherIcon:deselect()
			end
		end
	end)
	-- Order by creation if no order specified
	iconCreationCount = iconCreationCount + 1
	if not icon._orderWasSet then
		icon:setOrder(iconCreationCount)
	end
	-- Apply controller view if enabled
	if IconController.controllerModeEnabled then
		IconController._enableControllerModeForIcon(icon, true)
	end
	IconController:_updateSelectionGroup()
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
	local topbarPlusGui = getTopbarPlusGui()
	value = tonumber(value) or topbarPlusGui.DisplayOrder
	topbarPlusGui.DisplayOrder = value
end
IconController.setDisplayOrder(10)

function IconController.getIcon(name)
	for otherIcon, _ in pairs(topbarIcons) do
		if otherIcon.name == name then
			return otherIcon
		end
	end
	return false
end

function IconController.getIcons()
	local allIcons = {}
	for otherIcon, _ in pairs(topbarIcons) do
		table.insert(allIcons, otherIcon)
	end
	return allIcons
end

-- This is responsible for positioning the topbar icons
function IconController.updateTopbar(toggleTransitionInfo)
	local function getIncrement(otherIcon, alignment)
		--local container = otherIcon.instances.iconContainer
		--local sizeX = container.Size.X.Offset
		local iconSize = otherIcon:get("iconSize") or UDim2.new(0, 32, 0, 32)
		local sizeX = iconSize.X.Offset
		local alignmentGap = IconController[alignment.."Gap"]
		local iconWidthAndGap = (sizeX + alignmentGap)
		local increment = iconWidthAndGap
		local preOffset = 0
		--
		if otherIcon._parentIcon == nil and otherIcon.menuOpen then
			local menuSize = otherIcon:get("menuSize")
			local direction = otherIcon:_getMenuDirection()
			increment = increment + menuSize.X.Offset
			if direction == "right" then
				increment += alignmentGap/6--2
			elseif direction == "left" then
				preOffset = increment - iconWidthAndGap + 4
				increment += alignmentGap/3--4
			end
		end
		--
		return increment, preOffset
	end
	local furthestRightIcon
	local furthestLeftIcon
	local function overflowCheck(otherIcon, newPositon)
		local Icon = require(script.Parent.Icon)
		local overflowIcon = IconController.getIcon("_overFlowIcon")
		if not overflowIcon then
			overflowIcon = Icon.new()
				:setImage(6069276526)
				:setName("_overFlowIcon")
		end
	end
	coroutine.wrap(function()
		if topbarUpdating then -- This prevents the topbar updating and shifting icons more than it needs to
			return false
		end
		topbarUpdating = true
		runService.Heartbeat:Wait()
		topbarUpdating = false
		
		local alignmentDetails = {
			left = {
				startScale = 0,
				getStartOffset = function(_, alignment)
					local alignmentGap = IconController[alignment.."Gap"]
					local offset = 48 + alignmentGap
					if starterGui:GetCoreGuiEnabled("Chat") then
						offset = offset + 12 + 32
					end
					return offset
				end,
				records = {}
			},
			mid = {
				startScale = 0.5,
				getStartOffset = function(totalIconX, alignment) 
					local alignmentGap = IconController[alignment.."Gap"]
					return -totalIconX/2 + (alignmentGap/2)
				end,
				records = {}
			},
			right = {
				startScale = 1,
				getStartOffset = function(totalIconX, alignment) 
					local alignmentGap = IconController[alignment.."Gap"]
					local offset = -totalIconX + alignmentGap - 48
					if starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) or starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) or starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu) then
						offset = offset - alignmentGap
					end
					return offset
				end,
				records = {}
				--reverseSort = true
			},
		}
		for otherIcon, _ in pairs(topbarIcons) do
			if otherIcon.enabled == true and otherIcon.presentOnTopbar then
				local alignment = otherIcon:get("alignment")
				table.insert(alignmentDetails[alignment].records, otherIcon)
			end
		end
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
			local topbar = getTopbarPlusGui()
			local containerX = topbar.TopbarContainer.AbsoluteSize.X
			for i, otherIcon in pairs(records) do
				local increment, preOffset = getIncrement(otherIcon, alignment)
				local newAbsoluteX = alignmentInfo.startScale*containerX + preOffsetX+preOffset
				local thisOverflowBoundary = 0
				local currentOverflowBoundary = alignmentInfo.overflowBoundary
				if currentOverflowBoundary == nil or currentOverflowBoundary then
					alignmentInfo.overflowBoundary = thisOverflowBoundary
				end
				preOffsetX = preOffsetX + increment
			end
			for i, otherIcon in pairs(records) do
				local container = otherIcon.instances.iconContainer
				local increment, preOffset = getIncrement(otherIcon, alignment)
				local newPositon = UDim2.new(alignmentInfo.startScale, offsetX+preOffset, 0, 4)
				if toggleTransitionInfo then
					tweenService:Create(container, toggleTransitionInfo, {Position = newPositon}):Play()
				else
					container.Position = newPositon
				end
				overflowCheck(otherIcon, newPositon)
				offsetX = offsetX + increment
			end
		end
		return true
	end)()
end

function IconController.setTopbarEnabled(bool, forceBool)
	if forceBool == nil then
		forceBool = true
	end
	local topbar = getTopbarPlusGui()
	if not topbar then return end
	local indicator = topbar.Indicator
	if forceBool and not bool then
		forceTopbarDisabled = true
	elseif forceBool and bool then
		forceTopbarDisabled = false
	end
	if IconController.controllerModeEnabled then
		if bool then
			if topbar.TopbarContainer.Visible or forceTopbarDisabled or menuOpen or not checkTopbarEnabled() then return end
			if forceBool then
				indicator.Visible = checkTopbarEnabled()
			else
				if hapticService:IsVibrationSupported(Enum.UserInputType.Gamepad1) and hapticService:IsMotorSupported(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small) then
					hapticService:SetMotor(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small,1)
					delay(0.2,function()
						pcall(function()
							hapticService:SetMotor(Enum.UserInputType.Gamepad1,Enum.VibrationMotor.Small,0)
						end)
					end)
				end
				topbar.TopbarContainer.Visible = true
				topbar.TopbarContainer:TweenPosition(
					UDim2.new(0,0,0,5 + STUPID_ROBLOX_CONTROLLER_OFFSET),
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
					if otherIcon.enabled == true and otherIcon.presentOnTopbar and (selectIcon == nil or otherIcon:get("order") > selectIcon:get("order")) then
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
					UDim2.new(0.5,0,0,targetOffset + STUPID_ROBLOX_CONTROLLER_OFFSET),
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
				indicator.Visible = checkTopbarEnabled()
			end
			if not topbar.TopbarContainer.Visible then return end
			guiService.AutoSelectGuiEnabled = true
			IconController:_updateSelectionGroup(true)
			topbar.TopbarContainer:TweenPosition(
				UDim2.new(0,0,0,-topbar.TopbarContainer.Size.Y.Offset + STUPID_ROBLOX_CONTROLLER_OFFSET),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.1,
				true,
				function()
					topbar.TopbarContainer.Visible = false
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
		local topbarContainer = topbar.TopbarContainer
		if checkTopbarEnabled() then
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
		return
	end
	IconController.leftGap = newValue
	IconController.midGap = newValue
	IconController.rightGap = newValue
	IconController.updateTopbar()
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
	local topbar = getTopbarPlusGui()
	local indicator = topbar.Indicator
	local controllerOptionIcon = IconController.getIcon("_TopbarControllerOption")
	if IconController.controllerModeEnabled == bool then
		return
	end
	IconController.controllerModeEnabled = bool
	if bool then
		topbar.TopbarContainer.Position = UDim2.new(0,0,0,5)
		topbar.TopbarContainer.Visible = false
		local scaleMultiplier = getScaleMultiplier()
		indicator.Position = UDim2.new(0.5,0,0,5)
		indicator.Size = UDim2.new(0, 18*scaleMultiplier, 0, 18*scaleMultiplier)
		indicator.Image = "rbxassetid://5278151556"
		indicator.Visible = checkTopbarEnabled()
		indicator.Position = UDim2.new(0.5,0,0,5)
	else
		topbar.TopbarContainer.Position = UDim2.new(0,0,0,0)
		topbar.TopbarContainer.Visible = checkTopbarEnabled()
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
		icon:set("iconSize", UDim2.new(0, currentSizeDeselected.X.Offset*scaleMultiplier, 0, currentSizeDeselected.Y.Offset*scaleMultiplier), "deselected", "controllerMode")
		icon:set("iconSize", UDim2.new(0, currentSizeSelected.X.Offset*scaleMultiplier, 0, currentSizeSelected.Y.Offset*scaleMultiplier), "selected", "controllerMode")
		icon:set("alignment", "mid", "deselected", "controllerMode")
		icon:set("alignment", "mid", "selected", "controllerMode")
	else
		local states = {"deselected", "selected"}
		for _, toggleState in pairs(states) do
			local _, previousAlignment = icon:get("alignment", toggleState, "controllerMode")
			if previousAlignment then
				icon:set("alignment", previousAlignment, toggleState)
			end
			local currentSize, previousSize = icon:get("iconSize", toggleState, "controllerMode")
			if previousSize then
				icon:set("iconSize", previousSize, toggleState)
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
	local Icon = require(script.Parent.Icon)
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
		local topbar = getTopbarPlusGui()
		if not topbar then return end
		if not IconController.controllerModeEnabled then return end
		if input.KeyCode == Enum.KeyCode.DPadDown then
			if not guiService.SelectedObject and checkTopbarEnabled() then
				IconController.setTopbarEnabled(true,false)
			end
		elseif input.KeyCode == Enum.KeyCode.ButtonB then
			IconController._previousSelectedObject = guiService.SelectedObject
			IconController._setControllerSelectedObject(nil)
			IconController.setTopbarEnabled(false,false)
		end
		input:Destroy()
	end)
end)()

-- Mimic the enabling of the topbar when StarterGui:SetCore("TopbarEnabled", state) is called
coroutine.wrap(function()
	local ChatMain = require(players.LocalPlayer.PlayerScripts:WaitForChild("ChatScript").ChatMain)
	ChatMain.CoreGuiEnabled:connect(function()
		local topbarEnabled = checkTopbarEnabled()
		if topbarEnabled == IconController.previousTopbarEnabled then
			IconController.updateTopbar()
			return "SetCoreGuiEnabled was called instead of SetCore"
		end
		IconController.previousTopbarEnabled = topbarEnabled
		if IconController.controllerModeEnabled then
			IconController.setTopbarEnabled(false,false)
		else
			IconController.setTopbarEnabled(topbarEnabled,false)
		end
		IconController.updateTopbar()
	end)
	IconController.setTopbarEnabled(checkTopbarEnabled(),false)
	
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