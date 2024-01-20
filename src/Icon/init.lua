-- Explain here the changes in performance, codebase, organisation, readability, modularisation, separation of logic etc



-- SERVICES
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService") -- This is to generate GUIDs
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local StarterGui = game:GetService("StarterGui")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")



-- REFERENCE HANDLER
-- Multiple Icons packages may exist at runtime (for instance if the developer additionally uses HD Admin)
-- therefore this ensures that the first required package becomes the dominant and only functioning module
local iconModule = script
local Reference = require(iconModule.Reference)
local referenceObject = Reference.getObject()
local leadPackage = referenceObject and referenceObject.Value
if leadPackage and leadPackage ~= iconModule then
	return require(leadPackage)
end
if not referenceObject then
	Reference.addToReplicatedStorage()
end



-- MODULES
--local Controller = require(iconModule.Controller)
local Signal = require(iconModule.Packages.GoodSignal)
local Janitor = require(iconModule.Packages.Janitor)
local Utility = require(iconModule.Utility)
local Icon = {}
Icon.__index = Icon



--- LOCAL
local localPlayer = Players.LocalPlayer
local themes = iconModule.Themes
local defaultTheme = require(themes.Default)
local playerGui = localPlayer:WaitForChild("PlayerGui")
local icons = {}
local anyIconSelected = Signal.new()
local elements = iconModule.Elements
local container = require(elements.Container)()
for _, screenGui in pairs(container) do
	screenGui.Parent = playerGui
end


-- PUBLIC VARIABLES
Icon.container = container



-- CONSTRUCTOR
function Icon.new()
	local self = {}
	setmetatable(self, Icon)

	--- Janitors (for cleanup)
	local janitor = Janitor.new()
	self.janitor = janitor
	self.themesJanitor = janitor:add(Janitor.new())
	self.singleClickJanitor = janitor:add(Janitor.new())
	self.captionJanitor = janitor:add(Janitor.new())
	self.joinJanitor = janitor:add(Janitor.new())
	self.menuJanitor = janitor:add(Janitor.new())
	self.dropdownJanitor = janitor:add(Janitor.new())

	-- Signals (events)
	self.selected = janitor:add(Signal.new())
	self.deselected = janitor:add(Signal.new())
	self.toggled = janitor:add(Signal.new())
	self.hoverStarted = janitor:add(Signal.new())
	self.hoverEnded = janitor:add(Signal.new())
	self.pressStarted = janitor:add(Signal.new())
	self.pressEnded = janitor:add(Signal.new())
	self.stateChanged = janitor:add(Signal.new())
	self.notified = janitor:add(Signal.new())
	self.noticeChanged = janitor:add(Signal.new())
	self.endNotices = janitor:add(Signal.new())
	self.dropdownOpened = janitor:add(Signal.new())
	self.dropdownClosed = janitor:add(Signal.new())
	self.menuOpened = janitor:add(Signal.new())
	self.menuClosed = janitor:add(Signal.new())
	self.toggleKeyAdded = janitor:add(Signal.new())
	self.alignmentChanged = janitor:add(Signal.new())
	self.updateSize = janitor:add(Signal.new())
	self.resizingComplete = janitor:add(Signal.new())
	self.joinedParent = janitor:add(Signal.new())

	-- Properties
	self.Icon = Icon
	self.UID = HttpService:GenerateGUID(true)
	self.isEnabled = true
	self.isSelected = false
	self.isHovering = false
	self.isPressing = false
	self.isDragging = false
	self.joinedFrame = false
	self.parentIcon = false
	self.deselectWhenOtherIconSelected = true
	self.totalNotices = 0
	self.activeState = "Deselected"
	self.alignment = ""
	self.originalAlignment = ""
	self.appliedTheme = {}
	self.cachedInstances = {}
	self.cachedNamesToInstances = {}
	self.cachedCollectives = {}
	self.bindedToggleKeys = {}
	self.customBehaviours = {}
	self.toggleItems = {}
	self.bindedEvents = {}
	self.notices = {}
	self.menuIcons = {}
	self.dropdownIcons = {}
	self.childIconsDict = {}

	-- Widget is the name name for an icon
	local widget = janitor:add(require(elements.Widget)(self))
	self.widget = widget
	self:setAlignment()

	-- This applies the default them
	self:setTheme(defaultTheme)

	-- Button Clicked (for states "Selected" and "Deselected")
	local clickRegion = self:getInstance("ClickRegion")
	local function handleToggle()
		if self.locked then
			return
		end
		if self.isSelected then
			self:deselect(self)
		else
			self:select(self)
		end
	end
	clickRegion.MouseButton1Click:Connect(handleToggle)

	-- Keys can be bound to toggle between Selected and Deselected
	janitor:add(UserInputService.InputBegan:Connect(function(input, touchingAnObject)
		if self.locked then
			return
		end
		if self.bindedToggleKeys[input.KeyCode] and not touchingAnObject then
			handleToggle()
		end
	end))

	-- Button Pressing (for state "Pressing")
	clickRegion.MouseButton1Down:Connect(function()
		if self.locked then
			return
		end
		self:setState("Pressing", self)
	end)

	-- Button Hovering (for state "Hovering")
	local function hoveringStarted()
		if self.locked then
			return
		end
		self.isHovering = true
		self.hoverStarted:Fire(true)
		self:setState("Hovering", self)
	end
	local function hoveringEnded()
		if self.locked then
			return
		end
		self.isHovering = false
		self.hoverEnded:Fire(true)
		self:setState(nil, self)
	end
	self.joinedParent:Connect(function()
		if self.isHovering then
			hoveringEnded()
		end
	end)
	clickRegion.MouseEnter:Connect(hoveringStarted)
	clickRegion.MouseLeave:Connect(hoveringEnded)
	clickRegion.SelectionGained:Connect(hoveringStarted)
	clickRegion.SelectionLost:Connect(hoveringEnded)
	clickRegion.MouseButton1Down:Connect(function()
		if self.isDragging then
			hoveringStarted()
		end
	end)
	if UserInputService.TouchEnabled then
		clickRegion.MouseButton1Up:Connect(function()
			if self.locked then
				return
			end
			if self.hovering then
				hoveringEnded()
			end
		end)
		-- This is used to highlight when a mobile/touch device is dragging their finger accross the screen
		-- this is important for determining the hoverStarted and hoverEnded events on mobile
		local dragCount = 0
		janitor:add(UserInputService.TouchMoved:Connect(function(touch, touchingAnObject)
			if touchingAnObject then
				return
			end
			self.isDragging = true
		end))
		janitor:add(UserInputService.TouchEnded:Connect(function()
			self.isDragging = false
		end))
	end

	-- Handle overlay on hovering
	local iconOverlay = self:getInstance("IconOverlay")
	self.hoverStarted:Connect(function()
		iconOverlay.Visible = not self.overlayDisabled
	end)
	self.hoverEnded:Connect(function()
		iconOverlay.Visible = false
	end)

	-- Deselect when another icon is selected
	janitor:add(anyIconSelected:Connect(function(incomingIcon)
		if incomingIcon ~= self and self.deselectWhenOtherIconSelected and incomingIcon.deselectWhenOtherIconSelected then
			self:deselect()
		end
	end))

	-- This checks if the script calling this module is a descendant of a ScreenGui
	-- with 'ResetOnSpawn' set to true. If it is, then we destroy the icon the
	-- client respawns. This solves one of the most asked about questions on the post
	-- The only caveat this may not work if the player doesn't uniquely name their ScreenGui and the frames
	-- the LocalScript rests within
	local source =  debug.info(2, "s")
	local sourcePath = string.split(source, ".")
	local origin = game
	local originsScreenGui
	for i, sourceName in pairs(sourcePath) do
		origin = origin:FindFirstChild(sourceName)
		if not origin then
			break
		end
		if origin:IsA("ScreenGui") then
			originsScreenGui = origin
		end
	end
	if origin and originsScreenGui and originsScreenGui.ResetOnSpawn == true then
		Utility.localPlayerRespawned(function()
			self:destroy()
		end)
	end

	-- Additional notice behaviour
	local noticeLabel = self:getInstance("NoticeLabel")
	self.toggled:Connect(function()
		self.noticeChanged:Fire(self.totalNotices)
		for childIcon, _ in pairs(self.childIconsDict) do
			childIcon.noticeChanged:Fire(childIcon.totalNotices)
		end
	end)

	-- Final
	task.defer(function()
		-- We defer so that if a deselected event is binded, the action
		-- inside can now be called to apply the default appearance
		-- We set the state to selected so that calling :deselect()
		-- will now correctly register the state to deselected (therefore
		-- triggering the events we want)
		self.activeState = ""
		self.isSelected = true
		self:deselect()
		self:refresh()
	end)

	return self
end



-- METHODS
function Icon:setName(name)
	self.widget.Name = name
	self.name = name
	return self
end

function Icon:setState(incomingStateName, fromInput)
	-- This is responsible for acknowleding a change in stage (such as from "Deselected" to "Hovering" when
	-- a users mouse enters the widget), then informing other systems of this state change to then act upon
	-- (such as the theme handler applying the theme which corresponds to that state).
	if not incomingStateName then
		incomingStateName = (self.isSelected and "Selected") or "Deselected"
	end
	local stateName = Utility.formatStateName(incomingStateName)
	local previousStateName = self.activeState
	if previousStateName == stateName then
		return
	end
	local currentIsSelected = self.isSelected
	self.activeState = stateName
	if stateName == "Deselected" then
		self.isSelected = false
		if currentIsSelected then
			self.toggled:Fire(false, fromInput)
			self.deselected:Fire(fromInput)
		end
		self:_setToggleItemsVisible(false, fromInput)
	elseif stateName == "Selected" then
		self.isSelected = true
		if not currentIsSelected then
			self.toggled:Fire(true, fromInput)
			self.selected:Fire(fromInput)
			anyIconSelected:Fire(self)
		end
		self:_setToggleItemsVisible(true, fromInput)
	elseif stateName == "Pressing" then
		self.isPressing = true
		self.pressStarted:Fire(fromInput)
	end
	if previousStateName == "Pressing" then
		self.isPressing = false
		self.pressEnded:Fire(fromInput)
	end
	self.stateChanged:Fire(stateName, fromInput)
end

function Icon:getInstance(name)
	-- This enables us to easily retrieve instances located within the icon simply by passing its name.
	-- Every important/significant instance is named uniquely therefore this is no worry of overlap.
	-- We cache the result for more performant retrieval in the future.
	local instance = self.cachedNamesToInstances[name]
	if instance then
		return instance
	end
	local function cacheInstance(childName, child)
		local currentCache = self.cachedInstances[child]
		if not currentCache then
			local collectiveName = child:GetAttribute("Collective")
			local cachedCollective = collectiveName and self.cachedCollectives[collectiveName]
			if cachedCollective then
				table.insert(cachedCollective, child)
			end
			self.cachedNamesToInstances[childName] = child
			self.cachedInstances[child] = true
			child.Destroying:Once(function()
				self.cachedNamesToInstances[childName] = nil
				self.cachedInstances[child] = nil
			end)
		end
	end
	local widget = self.widget
	cacheInstance("Widget", widget)
	if name == "Widget" then
		return widget
	end

	local returnChild
	local function scanChildren(parentInstance)
		for _, child in pairs(parentInstance:GetChildren()) do
			local widgetUID = child:GetAttribute("WidgetUID")
			if widgetUID and widgetUID ~= self.UID then
				-- This prevents instances within other icons from being recorded
				-- (for instance when other icons are added to this icons menu)
				continue
			end
			scanChildren(child)
			if child:IsA("GuiBase") or child:IsA("UIBase") or child:IsA("ValueBase") then
				local childName = child.Name
				cacheInstance(childName, child)
				if childName == name then
					returnChild = child
				end
			end
		end
	end
	scanChildren(widget)
	return returnChild
end

function Icon:getCollective(name)
	-- A collective is an array of instances within the Widget that have been
	-- grouped together based on a given name. This just makes it easy
	-- to act on multiple instances at once which share similar behaviours.
	-- For instance, if we want to change the icons corner size, all corner instances
	-- with the attribute "Collective" and value "WidgetCorner" could be updated
	-- instantly by doing icon:set("WidgetCorner", newSize)
	local collective = self.cachedCollectives[name]
	if collective then
		return collective
	end
	collective = {}
	for instance, _ in pairs(self.cachedInstances) do
		if instance:GetAttribute("Collective") == name then
			table.insert(collective, instance)
		end
	end
	self.cachedCollectives[name] = collective
	return collective
end

function Icon:get(collectiveOrInstanceName)
	-- Similar to :getInstance but also accounts for 'Collectives', such as UICorners and returns
	-- an array of instances instead of a single instance
	local instances = {}
	local instance = self:getInstance(collectiveOrInstanceName)
	if instance then
		table.insert(instances, instance)
	end
	if #instances == 0 then
		instances = self:getCollective(collectiveOrInstanceName)
	end
	return instances
end

function Icon:getValue(instance, property)
	local success, value = pcall(function()
		return instance[property]
	end)
	if not success then
		value = instance:GetAttribute(property)
	end
	return value
end

function Icon:refreshAppearance(instance, property)
	local value = self:getValue(instance, property)
	self:set(instance, property, value, true)
end

function Icon:set(collectiveOrInstanceNameOrInstance, property, value, forceApply)
	-- This is responsible for **applying** appearance changes to instances within the icon
	-- however it IS NOT responsible for updating themes. Use :modifyTheme for that.
	-- This also calls callbacks given by :setBehaviour before applying these property changes
	-- to the given instances
	local instances
	local collectiveOrInstanceName = collectiveOrInstanceNameOrInstance
	if typeof(collectiveOrInstanceNameOrInstance) == "Instance" then
		instances = {collectiveOrInstanceNameOrInstance}
		collectiveOrInstanceName = collectiveOrInstanceNameOrInstance.Name
	else
		instances = self:get(collectiveOrInstanceNameOrInstance)
	end
	local key = collectiveOrInstanceName.."-"..property
	local customBehaviour = self.customBehaviours[key]
	for _, instance in pairs(instances) do
		local currentValue = self:getValue(instance, property)
		if not forceApply and value == currentValue then
			continue
		end
		if customBehaviour then
			local newValue = customBehaviour(value, instance, property)
			if newValue ~= nil then
				value = newValue
			end
		end
		local success = pcall(function()
			instance[property] = value
		end)
		if not success then
			-- If property is not a real property, we set
			-- the value as an attribute instead. This is useful
			-- for instance in :setWidth where we also want to
			-- specify a desired width for every state which can
			-- then be easily read by the widget element
			instance:SetAttribute(property, value)
		end
	end
	return self
end

function Icon:setBehaviour(collectiveOrInstanceName, property, callback, refreshAppearance)
	-- You can specify your own custom callback to handle custom logic just before
	-- an instances property is changed by using :setBehaviour()
	local key = collectiveOrInstanceName.."-"..property
	self.customBehaviours[key] = callback
	if refreshAppearance then
		local instances = self:get(collectiveOrInstanceName)
		for _, instance in pairs(instances) do
			self:refreshAppearance(instance, property)
		end
	end
end

function Icon:getThemeValue(instanceName, property, iconState)
	if not iconState then
		iconState = self.activeState
	end
	local stateGroup = self.appliedTheme[iconState]
	for _, detail in pairs(stateGroup) do
		local checkingInstanceName, checkingPropertyName, checkingValue = unpack(detail)
		if instanceName == checkingInstanceName and property == checkingPropertyName then
			return checkingValue
		end
	end
end

function Icon:modifyTheme(instanceName, property, value, iconState)
	-- This is what the 'old set' used to do (although for clarity that behaviour has now been
	-- split into two methods, :modifyTheme and :set).
	-- modifyTheme is responsible for UPDATING the internal values within a theme for a particular
	-- state, then checking to see if the appearance of the icon needs to be updated.
	-- If no iconState is specified, the change is applied to both Deselected and Selected
	task.spawn(function()
		if iconState == nil then
			-- If no state specified, apply to both Deselected and Selected
			self:modifyTheme(instanceName, property, value, "Selected")
		end
		local chosenState = Utility.formatStateName(iconState or "Deselected")
		local stateGroup = self.appliedTheme[chosenState]
		local function nowSetIt()
			if chosenState == self.activeState then
				self:set(instanceName, property, value)
			end
		end
		for _, detail in pairs(stateGroup) do
			local checkingInstanceName, checkingPropertyName, _ = unpack(detail)
			if instanceName == checkingInstanceName and property == checkingPropertyName then
				detail[3] = value
				nowSetIt()
				return
			end
		end
		local detail = {instanceName, property, value}
		table.insert(stateGroup, detail)
		nowSetIt()
	end)
	return self
end

function Icon:setTheme(theme)
	-- This is responsible for processing the final appearance of a given theme (such as
	-- ensuring missing Pressing values mirror Hovering), saving that internal state,
	-- then checking to see if the appearance of the icon needs to be updated
	local themesJanitor = self.themesJanitor
	themesJanitor:clean()
	if typeof(theme) == "Instance" and theme:IsA("ModuleScript") then
		theme = require(theme)
	end
	local function applyTheme()
		local stateGroup = self.appliedTheme[self.activeState]
		for _, detail in pairs(stateGroup) do
			local instanceName, property, value = unpack(detail)
			self:set(instanceName, property, value)
		end
	end
	local function generateTheme()
		for stateName, defaultStateGroup in pairs(defaultTheme) do
			local finalDetails = {}
			local function updateDetails(group)
				-- This ensures there's always a base 'default' layer
				if not group then
					return
				end
				for _, detail in pairs(group) do
					local key = detail[1].."-"..detail[2]
					finalDetails[key] = detail
				end
			end
			-- This applies themes in layers
			-- The last layers take higher priority as they overwrite
			-- any duplicate earlier applied effects
			if stateName == "Selected" then
				updateDetails(defaultTheme.Deselected)
			end
			if stateName == "Pressing" then
				updateDetails(theme.Hovering)
			end
			updateDetails(theme[stateName])
			local finalStateGroup = {}
			for _, detail in pairs(finalDetails) do
				table.insert(finalStateGroup, detail)
			end
			self.appliedTheme[stateName] = Utility.copyTable(finalStateGroup)
		end
		applyTheme()
	end
	generateTheme()
	themesJanitor:add(self.stateChanged:Connect(applyTheme))
	return self
end

function Icon:setEnabled(bool)
	self.isEnabled = bool
	self.widget.Visible = bool
	return self
end

function Icon:select(fromInput)
	self:setState("Selected", fromInput)
	return self
end

function Icon:deselect(fromInput)
	self:setState("Deselected", fromInput)
	return self
end

function Icon:notify(customClearSignal, noticeId)
	-- Generates a notification which appears in the top right of the icon. Useful for example for prompting
	-- users of changes/updates within your UI such as a Catalog
	-- 'customClearSignal' is a signal object (e.g. icon.deselected) or
	-- Roblox event (e.g. Instance.new("BindableEvent").Event)
	if not customClearSignal then
		customClearSignal = self.deselected
	end
	if self.parentIcon then
		self.parentIcon:notify(customClearSignal)
	end
	local noticeJanitor = self.janitor:add(Janitor.new())
	local noticeComplete = noticeJanitor:add(Signal.new())
	noticeJanitor:add(self.endNotices:Connect(function()
		noticeComplete:Fire()
	end))
	noticeJanitor:add(customClearSignal:Connect(function()
		noticeComplete:Fire()
	end))
	noticeId = noticeId or HttpService:GenerateGUID(true)
	self.notices[noticeId] = {
		completeSignal = noticeComplete,
		clearNoticeEvent = customClearSignal,
	}
	local noticeLabel = self:getInstance("NoticeLabel")
	local function updateNotice()
		self.noticeChanged:Fire(self.totalNotices)
	end
	self.notified:Fire(noticeId)
	self.totalNotices += 1
	updateNotice()
	noticeComplete:Once(function()
		noticeJanitor:destroy()
		self.totalNotices -= 1
		self.notices[noticeId] = nil
		updateNotice()
	end)
	return self
end

function Icon:clearNotices()
	self.endNotices:Fire()
	return self
end

function Icon:disableOverlay(bool)
	self.overlayDisabled = bool
	return self
end
Icon.disableStateOverlay = Icon.disableOverlay

function Icon:setImage(imageId, iconState)
	self:modifyTheme("IconImage", "Image", imageId, iconState)
	return self
end

function Icon:setLabel(text, iconState)
	self:modifyTheme("IconLabel", "Text", text, iconState)
	return self
end

function Icon:setOrder(int, iconState)
	self:modifyTheme("Widget", "LayoutOrder", int, iconState)
	return self
end

function Icon:setCornerRadius(udim, iconState)
	self:modifyTheme("IconCorners", "CornerRadius", udim, iconState)
	return self
end

function Icon:setAlignment(leftMidOrRight, isFromParentIcon)
	-- Determines the side of the screen the icon will be ordered
	local direction = tostring(leftMidOrRight):lower()
	if direction == "mid" or direction == "centre" then
		direction = "center"
	end
	if direction ~= "left" and direction ~= "center" and direction ~= "right" then
		direction = "left"
	end
	local screenGui = (direction == "center" and container.TopbarCentered) or container.TopbarStandard
	local holders = screenGui.Holders
	local finalDirection = string.upper(string.sub(direction, 1, 1))..string.sub(direction, 2)
	if not isFromParentIcon then
		self.originalAlignment = finalDirection
	end
	local joinedFrame = self.joinedFrame
	self.widget.Parent = joinedFrame or holders[finalDirection]
	self.alignment = finalDirection
	self.alignmentChanged:Fire(finalDirection)
	return self
end

function Icon:setLeft()
	self:setAlignment("Left")
	return self
end

function Icon:setMid()
	self:setAlignment("Center")
	return self
end

function Icon:setRight()
	self:setAlignment("Right")
	return self
end

function Icon:setWidth(offsetMinimum, iconState)
	-- This sets a minimum X offset size for the widget, useful
	-- for example if you're constantly changing the label
	-- but don't want the icon to resize every time
	local newSize = UDim2.fromOffset(offsetMinimum, self.widget.Size.Y.Offset)
	self:modifyTheme("Widget", "Size", newSize, iconState)
	self:modifyTheme("Widget", "DesiredWidth", offsetMinimum, iconState)
	return self
end

function Icon:setImageScale(number, iconState)
	self:modifyTheme("IconImageScale", "Value", number, iconState)
	return self
end

function Icon:setImageRatio(number, iconState)
	self:modifyTheme("IconImageRatio", "AspectRatio", number, iconState)
	return self
end

function Icon:setTextSize(number, iconState)
	self:modifyTheme("IconLabel", "TextSize", number, iconState)
	return self
end

function Icon:setTextFont(fontNameOrAssetId, fontWeight, fontStyle, iconState)
	fontWeight = fontWeight or Enum.FontWeight.Regular
	fontStyle = fontStyle or Enum.FontStyle.Normal
	local fontFace = Font.new(fontNameOrAssetId, fontWeight, fontStyle)
	self:modifyTheme("IconLabel", "FontFace", fontFace, iconState)
	return self
end

function Icon:bindToggleItem(guiObjectOrLayerCollector)
	if not guiObjectOrLayerCollector:IsA("GuiObject") and not guiObjectOrLayerCollector:IsA("LayerCollector") then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end
	self.toggleItems[guiObjectOrLayerCollector] = true
	self:_updateSelectionInstances()
	return self
end

function Icon:unbindToggleItem(guiObjectOrLayerCollector)
	self.toggleItems[guiObjectOrLayerCollector] = nil
	self:_updateSelectionInstances()
	return self
end

function Icon:_updateSelectionInstances()
	-- This is to assist with controller navigation and selection
	-- It converts the value true to an array
	for guiObjectOrLayerCollector, _ in pairs(self.toggleItems) do
		local buttonInstancesArray = {}
		for _, instance in pairs(guiObjectOrLayerCollector:GetDescendants()) do
			if (instance:IsA("TextButton") or instance:IsA("ImageButton")) and instance.Active then
				table.insert(buttonInstancesArray, instance)
			end
		end
		self.toggleItems[guiObjectOrLayerCollector] = buttonInstancesArray
	end
end

function Icon:_setToggleItemsVisible(bool, fromInput)
	for toggleItem, _ in pairs(self.toggleItems) do
		if not fromInput or fromInput == self or fromInput.toggleItems[toggleItem] == nil then
			local property = "Visible"
			if toggleItem:IsA("LayerCollector") then
				property = "Enabled"
			end
			toggleItem[property] = bool
		end
	end
end

function Icon:bindEvent(iconEventName, eventFunction)
	local event = self[iconEventName]
	assert(event and typeof(event) == "table" and event.Connect, "argument[1] must be a valid topbarplus icon event name!")
	assert(typeof(eventFunction) == "function", "argument[2] must be a function!")
	self.bindedEvents[iconEventName] = event:Connect(function(...)
		eventFunction(self, ...)
	end)
	return self
end

function Icon:unbindEvent(iconEventName)
	local eventConnection = self.bindedEvents[iconEventName]
	if eventConnection then
		eventConnection:Disconnect()
		self.bindedEvents[iconEventName] = nil
	end
	return self
end

function Icon:bindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[keyCodeEnum] = true
	self.toggleKeyAdded:Fire(keyCodeEnum)
	return self
end

function Icon:unbindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[keyCodeEnum] = nil
	return self
end

function Icon:call(callback)
	task.spawn(function()
		callback(self)
	end)
	return self
end

function Icon:addToJanitor(callback)
	self.janitor:add(callback)
	return self
end

function Icon:lock()
	-- This disables all user inputs related to the icon (such as clicking buttons, pressing keys, etc)
	local iconButton = self:getInstance("IconButton")
	iconButton.Active = false
	self.locked = true
	return self
end

function Icon:unlock()
	local iconButton = self:getInstance("IconButton")
	iconButton.Active = true
	self.locked = false
	return self
end

function Icon:debounce(seconds)
	self:lock()
	task.wait(seconds)
	self:unlock()
	return self
end

function Icon:autoDeselect(bool)
	-- When set to true the icon will deselect itself automatically whenever
	-- another icon is selected
	if bool == nil then
		bool = true
	end
	self.deselectWhenOtherIconSelected = bool
	return self
end

function Icon:oneClick(bool)
	-- When set to true the icon will automatically deselect when selected, this creates
	-- the effect of a single click button
	local singleClickJanitor = self.singleClickJanitor
	singleClickJanitor:clean()
	if bool or bool == nil then
		singleClickJanitor:add(self.selected:Connect(function()
			self:deselect()
		end))
	end
	return self
end

function Icon:setCaption(text)
	local captionJanitor = self.captionJanitor
	self.captionJanitor:clean()
	if not text or text == "" then
		self.caption = nil
		self.captionText = nil
		return
	end
	local caption = captionJanitor:add(require(elements.Caption)(self))
	caption:SetAttribute("CaptionText", text)
	self.caption = caption
	self.captionText = text
	return self
end

function Icon:refresh()
	self.updateSize:Fire()
end

function Icon:_join(parentIcon, iconsArray, scrollingFrameOrFrame)

	-- This is resonsible for moving the icon under a feature like a dropdown
	local joinJanitor = self.joinJanitor
	joinJanitor:clean()
	if not scrollingFrameOrFrame then
		self:leave()
		return
	end
	self.parentIcon = parentIcon
	self.joinedFrame = scrollingFrameOrFrame
	local function updateAlignent()
		local parentAlignment = parentIcon.alignment
		if parentAlignment == "Center" then
			parentAlignment = "Left"
		end
		self:setAlignment(parentAlignment, true)
	end
	joinJanitor:add(parentIcon.alignmentChanged:Connect(updateAlignent))
	updateAlignent()
	self:setBehaviour("IconButton", "BackgroundTransparency", function()
		if self.joinedFrame then
			return 1
		end
	end, true)
	self.parentIconsArray = iconsArray
	table.insert(iconsArray, self)
	parentIcon:autoDeselect(false)
	parentIcon.childIconsDict[self] = true
	if not parentIcon.isEnabled then
		parentIcon:setEnabled(true)
	end
	self.joinedParent:Fire(parentIcon)

	-- This is responsible for removing it from that feature and updating
	-- their parent icon so its informed of the icon leaving it
	joinJanitor:add(function()
		local joinedFrame = self.joinedFrame
		if not joinedFrame then
			return
		end
		local parentIcon = self.parentIcon
		self:setAlignment(self.originalAlignment)
		self.parentIcon = false
		self.joinedFrame = false
		self:setBehaviour("IconButton", "BackgroundTransparency", nil, true)
		local iconsArray = self.parentIconsArray
		local remaining = #iconsArray
		for i, iconToCompare in pairs(iconsArray) do
			if iconToCompare == self then
				table.remove(iconsArray, i)
				remaining -= 1
				break
			end
		end
		if remaining <= 0 then
			parentIcon:setEnabled(false)
		end
		parentIcon.childIconsDict[self] = nil
	end)

	return self
end

function Icon:leave()
	local joinJanitor = self.joinJanitor
	joinJanitor:clean()
	return self
end

function Icon:joinMenu(parentIcon)
	self:_join(parentIcon, parentIcon.menuIcons, parentIcon:getInstance("IconHolder"))
end

function Icon:setMenu(arrayOfIcons)

	-- Reset any previous icons
	for i, otherIcon in pairs(self.menuIcons) do
		otherIcon:leave()
	end

	-- Listen for changes
	local menuJanitor = self.menuJanitor
	menuJanitor:clean()
	menuJanitor:add(self.toggled:Connect(function()
		if #self.menuIcons > 0 then
			self.updateSize:Fire()
		end
	end))

	-- Apply new icons
	local totalNewIcons = #arrayOfIcons
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:joinMenu(self)
		end
	end

	-- Apply a close selected image if the user hasn't applied thier own 
	local imageDeselected = self:getThemeValue("IconImage", "Image", "Deselected")
	local imageSelected = self:getThemeValue("IconImage", "Image", "Selected")
	if imageDeselected == imageSelected then
		local fontLink = "rbxasset://fonts/families/FredokaOne.json"
		local fontFace = Font.new(fontLink, Enum.FontWeight.Light, Enum.FontStyle.Normal)
		self:modifyTheme("IconLabel", "FontFace", fontFace, "Selected")
		self:modifyTheme("IconLabel", "Text", "X", "Selected")
		self:modifyTheme("IconLabel", "TextSize", 20, "Selected")
		self:modifyTheme("IconLabel", "TextStrokeTransparency", 0.8, "Selected")
		self:modifyTheme("IconImage", "Image", "", "Selected") --16027684411
	end

	-- Change order of spot when alignment changes
	local iconSpot = self:getInstance("IconSpot")
	local menuGap = self:getInstance("MenuGap")
	local function updateAlignent()
		local alignment = self.alignment
		if alignment == "Right" then
			iconSpot.LayoutOrder = 99999
			menuGap.LayoutOrder = 99998
		else
			iconSpot.LayoutOrder = -99999
			menuGap.LayoutOrder = -99998
		end
	end
	menuJanitor:add(self.alignmentChanged:Connect(updateAlignent))
	updateAlignent()

	return self
end

function Icon:joinDropdown(parentIcon)
	--!!! only for testing, I'm going to create an additiional feature
	-- to make to easy to apply a temporary theme then to remove it
	local appliedThemeCopy = Utility.copyTable(self.appliedTheme)
	task.defer(function()
		self.joinJanitor:add(function()
			self:setTheme(appliedThemeCopy)
		end)
	end)
	self:modifyTheme("Widget", "BorderSize", 0)
	self:modifyTheme("IconCorners", "CornerRadius", UDim.new(0, 4))
	self:modifyTheme("Widget", "MinimumWidth", 190) --225
	self:modifyTheme("Widget", "MinimumHeight", 56)
	self:modifyTheme("IconLabel", "TextSize", 19)
	self:modifyTheme("PaddingLeft", "Size", UDim2.fromOffset(20, 0))
	--
	self:_join(parentIcon, parentIcon.dropdownIcons, parentIcon:getInstance("DropdownHolder"))
end

function Icon:setDropdown(arrayOfIcons)

	-- Reset any previous icons
	for i, otherIcon in pairs(self.dropdownIcons) do
		otherIcon:leave()
	end

	-- Setup janitor
	local dropdownJanitor = self.dropdownJanitor
	dropdownJanitor:clean()

	-- Apply new icons
	local totalNewIcons = #arrayOfIcons
	local dropdown = dropdownJanitor:add(require(elements.Dropdown)(self))
	local holder = dropdown.DropdownHolder
	dropdown.Parent = self.widget
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:joinDropdown(self)
		end
	end

	-- Update visibiliy of dropdown
	local function updateVisibility()
		dropdown.Visible = self.isSelected
	end
	dropdownJanitor:add(self.toggled:Connect(updateVisibility))
	updateVisibility()

	return self
end



-- DESTROY/CLEANUP
function Icon:destroy()
	if self.isDestroyed then
		return
	end
	self:clearNotices()
	if self.parentIcon then
		self:leave()
	end
	self.isDestroyed = true
	self.janitor:clean()
end
Icon.Destroy = Icon.destroy



return Icon