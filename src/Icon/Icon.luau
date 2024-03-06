--[[
	
	The majority of this code is an interface designed to make it easy for you to
	work with TopbarPlus (most methods for instance reference :modifyTheme()).
	The processing overhead mainly consists of applying themes and calculating 
	appearance (such as size and width of labels) which is handled in about
	200 lines of code here and the Widget UI module. This has been achieved
	in v3 by outsourcing a majority of previous calculations to inbuilt Roblox
	features like UIListLayouts.


	v3 provides inbuilt support for controllers (simply press DPadUp),
	touch devices (phones, tablets , etc), localization (automatic resizing
	of widgets, autolocalize for relevant labels), backwards compatability
	with the old topbar, and more.


	My primary goals for the v3 re-write have been to:
		
	1. Improve code readability and organisation (reduced lines of code within
	   Icon+IconController from 3200 to ~950, separated UI elements, etc)
		
	2. Improve ease-of-use (themes now actually make sense and can account
	   for any modifications you want, converted to a package for
	   quick installation and easy-comparisons of new updates, etc)
	
	3. Provide support for all key features of the new Roblox topbar
	   while improving performance of the module (deferring and collecting
	   changes then calling as a singular, utilizing inbuilt Roblox features
	   such as UILIstLayouts, etc)

--]]
--!strict

-- SERVICES
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

-- REFERENCE HANDLER
-- Multiple Icons packages may exist at runtime (for instance if the developer additionally uses HD Admin)
-- therefore this ensures that the first required package becomes the dominant and only functioning module
local iconModule = script.Parent
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
local Typing = require(iconModule.Typing)
local Signal = require(iconModule.Packages.GoodSignal)
local Janitor = require(iconModule.Packages.Janitor) :: Typing.Janitor
local Utility = require(iconModule.Utility) :: Typing.Utility
local Themes = require(iconModule.Features.Themes) :: Typing.Themes
local Gamepad = require(iconModule.Features.Gamepad) :: Typing.Gamepad
local Overflow = require(iconModule.Features.Overflow) :: Typing.Overflow
local Icon = {} :: Icon
Icon.__index = Icon

--- LOCAL
local localPlayer = Players.LocalPlayer
local themes = iconModule.Features.Themes
local playerGui = localPlayer:WaitForChild("PlayerGui")
local iconsDict = {}
local anyIconSelected = Signal.new() :: Typing.StrictGoodSignal<Icon>
local elements = iconModule.Elements

-- PRESETUP
-- This is only used to determine if we need to apply the old topbar theme
-- I'll be removing this and associated functions once all games have
-- fully transitioned over to the new topbar
if GuiService.TopbarInset.Height == 0 then
	GuiService:GetPropertyChangedSignal("TopbarInset"):Wait()
end

type StateName = Typing.StateName
type IconProto = Typing.IconProto
type IconImpl = Typing.IconImpl
export type Icon = Typing.Icon

--[[

]]
--

-- PUBLIC VARIABLES
Icon.baseTheme = require(themes.Default)
Icon.isOldTopbar = GuiService.TopbarInset.Height == 36
Icon.iconsDictionary = iconsDict
Icon.container = require(elements.Container)(Icon)
Icon.topbarEnabled = true

-- PUBLIC FUNCTIONS
function Icon.getIcons(): { [string]: Icon }
	return Icon.iconsDictionary
end

function Icon.getIconByUID(UID: string): Icon?
	return Icon.iconsDictionary[UID]
end

function Icon.getIcon(nameOrUID: string): Icon?
	local match = Icon.getIconByUID(nameOrUID)
	if match then
		return match
	end

	for _, icon in iconsDict do
		if icon.name == nameOrUID then
			return icon
		end
	end

	return
end

function Icon.setTopbarEnabled(bool: boolean?, isInternal: boolean?): ()
	if typeof(bool) ~= "boolean" then
		bool = Icon.topbarEnabled
	end
	if not isInternal then
		Icon.topbarEnabled = bool
	end
	for _, screenGui in Icon.container do
		screenGui.Enabled = bool
	end
end

function Icon.modifyBaseTheme(modifications: Typing.Theme): ()
	modifications = Themes.getModifications(modifications)
	for _, modification in modifications do
		for _, detail in Icon.baseTheme do
			Themes.merge(detail, modification)
		end
	end
	for _, icon in iconsDict do
		icon:setTheme(Icon.baseTheme)
	end
end

-- SETUP
task.defer(Gamepad.start, Icon)
task.defer(Overflow.start, Icon)
for _, screenGui in Icon.container do
	screenGui.Parent = playerGui
end
if Icon.isOldTopbar then
	Icon.modifyBaseTheme(require(themes.Classic))
end

-- CONSTRUCTOR
function Icon.new(): Icon
	local self = (setmetatable({}, Icon) :: any) :: Icon

	--- Janitors (for cleanup)
	local janitor = Janitor.new()
	self.janitor = janitor
	self.themesJanitor = janitor:add(Janitor.new())
	self.singleClickJanitor = janitor:add(Janitor.new())
	self.captionJanitor = janitor:add(Janitor.new())
	self.joinJanitor = janitor:add(Janitor.new())
	self.menuJanitor = janitor:add(Janitor.new())
	self.dropdownJanitor = janitor:add(Janitor.new())

	-- Register
	local iconUID = Utility.generateUID()
	iconsDict[iconUID] = (self :: any) :: Icon
	janitor:add(function()
		iconsDict[iconUID] = nil
	end)

	-- Signals (events)
	self.selected = janitor:add(Signal.new())
	self.deselected = janitor:add(Signal.new())
	self.toggled = janitor:add(Signal.new())
	self.viewingStarted = janitor:add(Signal.new())
	self.viewingEnded = janitor:add(Signal.new())
	self.stateChanged = janitor:add(Signal.new())
	self.notified = janitor:add(Signal.new())
	self.noticeStarted = janitor:add(Signal.new())
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
	self.menuSet = janitor:add(Signal.new())
	self.dropdownSet = janitor:add(Signal.new())
	self.updateMenu = janitor:add(Signal.new())
	self.startMenuUpdate = janitor:add(Signal.new())
	self.childThemeModified = janitor:add(Signal.new())
	self.indicatorSet = janitor:add(Signal.new())
	self.dropdownChildAdded = janitor:add(Signal.new())
	self.menuChildAdded = janitor:add(Signal.new())

	-- Properties
	self.iconModule = iconModule
	self.UID = iconUID
	self.isEnabled = true
	self.isSelected = false
	self.isViewing = false
	self.joinedFrame = false
	self.parentIconUID = false
	self.deselectWhenOtherIconSelected = true
	self.totalNotices = 0
	self.activeState = "Deselected"
	self.alignment = "Center"
	self.originalAlignment = "Center"
	self.appliedTheme = {}
	self.appearance = {}
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
	self.isOldTopbar = Icon.isOldTopbar

	-- Widget is the new name for an icon
	local widget = janitor:add(require(elements.Widget)(self))
	self.widget = widget
	self:setAlignment()

	-- This applies the default them
	self:setTheme(Icon.baseTheme)

	-- Button Clicked (for states "Selected" and "Deselected")
	local clickRegion = self:getInstance("ClickRegion") :: GuiButton
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
	local isTouchTapping = false
	local isClicking = false
	clickRegion.MouseButton1Click:Connect(function()
		if isTouchTapping then
			return
		end
		isClicking = true
		task.delay(0.01, function()
			isClicking = false
		end)
		handleToggle()
	end)
	clickRegion.TouchTap:Connect(function()
		-- This resolves the bug report by @28Pixels:
		-- https://devforum.roblox.com/t/topbarplus/1017485/1104
		if isClicking then
			return
		end
		isTouchTapping = true
		task.delay(0.01, function()
			isTouchTapping = false
		end)
		handleToggle()
	end)

	-- Keys can be bound to toggle between Selected and Deselected
	janitor:add(UserInputService.InputBegan:Connect(function(input, touchingAnObject)
		if self.locked then
			return
		end
		if self.bindedToggleKeys[input.KeyCode] and not touchingAnObject then
			handleToggle()
		end
	end))

	-- Button Hovering (for state "Viewing")
	-- Hovering is a state only for devices with keyboards
	-- and controllers (not touchpads)
	local function viewingStarted(dontSetState: boolean?)
		if self.locked then
			return
		end
		self.isViewing = true
		self.viewingStarted:Fire(true)
		if not dontSetState then
			self:setState("Viewing", self)
		end
	end
	local function viewingEnded()
		if self.locked then
			return
		end
		self.isViewing = false
		self.viewingEnded:Fire(true)
		self:setState(nil, self)
	end
	self.joinedParent:Connect(function()
		if self.isViewing then
			viewingEnded()
		end
	end)
	clickRegion.MouseEnter:Connect(function()
		local dontSetState = not UserInputService.KeyboardEnabled
		viewingStarted(dontSetState)
	end)
	local touchCount = 0
	janitor:add(UserInputService.TouchEnded:Connect(viewingEnded))
	clickRegion.MouseLeave:Connect(viewingEnded)
	clickRegion.SelectionGained:Connect(viewingStarted)
	clickRegion.SelectionLost:Connect(viewingEnded)
	clickRegion.MouseButton1Down:Connect(function()
		if not self.locked and UserInputService.TouchEnabled then
			touchCount += 1
			local myTouchCount = touchCount
			task.delay(0.2, function()
				if myTouchCount == touchCount then
					viewingStarted()
				end
			end)
		end
	end)
	clickRegion.MouseButton1Up:Connect(function()
		touchCount += 1
	end)

	-- Handle overlay on viewing
	local iconOverlay = self:getInstance("IconOverlay") :: GuiObject
	self.viewingStarted:Connect(function()
		iconOverlay.Visible = not self.overlayDisabled
	end)
	self.viewingEnded:Connect(function()
		iconOverlay.Visible = false
	end)

	-- Deselect when another icon is selected
	janitor:add(anyIconSelected:Connect(function(incomingIcon)
		if
			incomingIcon ~= self
			and self.deselectWhenOtherIconSelected
			and incomingIcon.deselectWhenOtherIconSelected
		then
			self:deselect()
		end
	end))

	-- This checks if the script calling this module is a descendant of a ScreenGui
	-- with 'ResetOnSpawn' set to true. If it is, then we destroy the icon the
	-- client respawns. This solves one of the most asked about questions on the post
	-- The only caveat this may not work if the player doesn't uniquely name their ScreenGui and the frames
	-- the LocalScript rests within
	local source = debug.info(2, "s")
	local sourcePath = string.split(source, ".")
	local origin = game
	local originsScreenGui
	for _, sourceName in sourcePath do
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

	-- Additional children behaviour when toggled (mostly notices)
	self.toggled:Connect(function(isSelected)
		self.noticeChanged:Fire(self.totalNotices)
		for childIconUID, _ in self.childIconsDict do
			local childIcon = Icon.getIconByUID(childIconUID)
			childIcon.noticeChanged:Fire(childIcon.totalNotices)
			if not isSelected and childIcon.isSelected then
				-- If an icon within a menu or dropdown is also
				-- a dropdown or menu, then close it
				for _, _ in childIcon.childIconsDict do
					childIcon:deselect()
				end
			end
		end
	end)

	task.delay(0.1, function()
		-- There's a rare occassion where the appearance is not
		-- fully set to deselected so this ensures the icons
		-- appearance is fully as it should be
		--print("self.activeState =", self.activeState)
		if self.activeState == "Deselected" then
			--print("YOOOOOO!")
			self.stateChanged:Fire("Deselected")
			self:refresh()
		end
	end)

	return self
end

-- METHODS
function Icon.setName(self: Icon, name: string): Icon
	self.widget.Name = name
	self.name = name
	return self
end

function Icon.setState(self: Icon, incomingStateName: StateName?, fromInput: Icon?): ()
	-- This is responsible for acknowleding a change in stage (such as from "Deselected" to "Viewing" when
	-- a users mouse enters the widget), then informing other systems of this state change to then act upon
	-- (such as the theme handler applying the theme which corresponds to that state).
	if not incomingStateName then
		incomingStateName = (self.isSelected and "Selected") or "Deselected"
	end
	local stateName = Utility.formatStateName((incomingStateName :: any) :: string) :: Typing.StateName
	local previousStateName = self.activeState
	if previousStateName == stateName then
		return
	end
	local currentIsSelected = self.isSelected
	self.activeState = stateName :: StateName
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
	end
	self.stateChanged:Fire(stateName :: StateName, fromInput)
end

function Icon.getInstance(self: Icon, name: string): Instance
	-- This enables us to easily retrieve instances located within the icon simply by passing its name.
	-- Every important/significant instance is named uniquely therefore this is no worry of overlap.
	-- We cache the result for more performant retrieval in the future.
	local instance = self.cachedNamesToInstances[name]
	if instance then
		return instance
	end
	local function cacheInstance(childName: string, child: Instance)
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
		for _, child in parentInstance:GetChildren() do
			local widgetUID = child:GetAttribute("WidgetUID")
			if widgetUID and widgetUID ~= self.UID then
				-- This prevents instances within other icons from being recorded
				-- (for instance when other icons are added to this icons menu)
				continue
			end
			-- If the child is a fake placeholder instance (such as dropdowns, notices, etc)
			-- then its important we scan the real original instance instead of this clone
			local realChild = Themes.getRealInstance(child)
			if realChild then
				child = realChild
			end
			-- Finally scan its children
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

function Icon.getCollective(self: Icon, name: string): { Instance }
	-- A collective is an array of instances within the Widget that have been
	-- grouped together based on a given name. This just makes it easy
	-- to act on multiple instances at once which share similar behaviours.
	-- For instance, if we want to change the icons corner size, all corner instances
	-- with the attribute "Collective" and value "WidgetCorner" could be updated
	-- instantly by doing Themes.apply(icon, "WidgetCorner", newSize)
	local collective = self.cachedCollectives[name]
	if collective then
		return collective
	end
	collective = {}
	for instance, _ in self.cachedInstances do
		if instance:GetAttribute("Collective") == name then
			table.insert(collective, instance)
		end
	end
	self.cachedCollectives[name] = collective
	return collective
end

function Icon.getInstanceOrCollective(self: Icon, collectiveOrInstanceName: string): { Instance }
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

function Icon.getStateGroup(self: Icon, iconState: StateName?): Typing.StateGroup
	local chosenState = iconState or self.activeState
	local stateGroup = self.appearance[chosenState :: StateName]
	if not stateGroup then
		stateGroup = {}
		self.appearance[chosenState :: StateName] = stateGroup
	end
	return stateGroup
end

function Icon.refreshAppearance(self: Icon, instance: Instance, specificProperty: string?): Icon
	Themes.refresh(self, instance, specificProperty)
	return self
end

function Icon.refresh(self: Icon): Icon
	self:refreshAppearance((self.widget :: any) :: Instance)
	self.updateSize:Fire()
	return self
end

function Icon.updateParent(self: Icon): ()
	local parentIcon = Icon.getIconByUID(self.parentIconUID :: string)
	if parentIcon then
		parentIcon.updateSize:Fire()
	end
end

function Icon.setBehaviour(
	self: Icon,
	collectiveOrInstanceName: string,
	property: string,
	callback: ((...any) -> any?)?,
	refreshAppearance: boolean?
): ()
	-- You can specify your own custom callback to handle custom logic just before
	-- an instances property is changed by using :setBehaviour()
	local key = `{collectiveOrInstanceName}-{property}`
	self.customBehaviours[key] = callback
	if refreshAppearance then
		local instances = self:getInstanceOrCollective(collectiveOrInstanceName)
		for _, instance in instances do
			self:refreshAppearance(instance, property)
		end
	end
end

function Icon.modifyTheme(
	self: Icon,
	modifications: Typing.ThemeData | { Typing.ThemeData },
	modificationUID: string?
): (Icon, string)
	return self, Themes.modify(self, modifications, modificationUID) :: string
end

function Icon.modifyChildTheme(
	self: Icon,
	modifications: Typing.ThemeData | { Typing.ThemeData },
	modificationUID: string
): ()
	-- Same as modifyTheme except for its children (i.e. icons
	-- within its dropdown or menu)
	self.childModifications = modifications
	self.childModificationsUID = modificationUID
	for childIconUID, _ in self.childIconsDict do
		local childIcon = Icon.getIconByUID(childIconUID)
		childIcon:modifyTheme(modifications, modificationUID)
	end
	self.childThemeModified:Fire()
end

function Icon.removeModification(self: Icon, modificationUID: string): Icon
	Themes.remove(self, modificationUID)
	return self
end

function Icon.removeModificationWith(self: Icon, instanceName: string, property: string, state: StateName?): Icon
	Themes.removeWith(self, instanceName, property, state)
	return self
end

function Icon.setTheme(self: Icon, theme: Typing.Theme): Icon
	Themes.set(self, theme)
	return self
end

function Icon.setEnabled(self: Icon, bool: boolean): Icon
	self.isEnabled = bool
	self.widget.Visible = bool
	self:updateParent()
	return self
end

function Icon.select(self: Icon, fromInput: Icon?): Icon
	self:setState("Selected", fromInput)
	return self
end

function Icon.deselect(self: Icon, fromInput: Icon?): Icon
	self:setState("Deselected", fromInput)
	return self
end

function Icon.notify(self: Icon, customClearSignal: Typing.StrictGoodSignal?, noticeId: string?): Icon
	-- Generates a notification which appears in the top right of the icon. Useful for example for prompting
	-- users of changes/updates within your UI such as a Catalog
	-- 'customClearSignal' is a signal object (e.g. icon.deselected) or
	-- Roblox event (e.g. Instance.new("BindableEvent").Event)
	local notice = self.notice
	if not notice then
		notice = require(elements.Notice)(self, Icon)
		self.notice = notice
	end
	self.noticeStarted:Fire(customClearSignal, noticeId)
	return self
end

function Icon.clearNotices(self: Icon): Icon
	self.endNotices:Fire()
	return self
end

function Icon.disableOverlay(self: Icon, bool: boolean): Icon
	self.overlayDisabled = bool
	return self
end
Icon.disableStateOverlay = Icon.disableOverlay

function Icon.setImage(self: Icon, imageId: string | number, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "IconImage", "Image", imageId, iconState })
	return self
end

function Icon.setLabel(self: Icon, text: string, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "IconLabel", "Text", text, iconState })
	return self
end

function Icon.setOrder(self: Icon, int: number, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "Widget", "LayoutOrder", int, iconState })
	return self
end

function Icon.setCornerRadius(self: Icon, udim: UDim, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "IconCorners", "CornerRadius", udim, iconState })
	return self
end

function Icon.align(self: Icon, leftCenterOrRight: Typing.Alignment?, isFromParentIcon: boolean?): Icon
	-- Determines the side of the screen the icon will be ordered
	local direction = tostring(leftCenterOrRight):lower()
	if direction == "mid" or direction == "centre" then
		direction = "center"
	end
	if direction ~= "left" and direction ~= "center" and direction ~= "right" then
		direction = "left"
	end
	local screenGui = (direction == "center" and Icon.container.TopbarCentered) or Icon.container.TopbarStandard
	local holders = screenGui.Holders
	local finalDirection = (`{string.upper(string.sub(direction, 1, 1))}{string.sub(direction, 2)}`) :: Typing.Alignment
	if not isFromParentIcon then
		self.originalAlignment = finalDirection :: Typing.Alignment
	end
	local joinedFrame = self.joinedFrame
	local alignmentHolder = holders[finalDirection]
	self.screenGui = screenGui
	self.alignmentHolder = alignmentHolder
	self.widget.Parent = joinedFrame or alignmentHolder
	self.alignment = finalDirection :: Typing.Alignment
	self.alignmentChanged:Fire(finalDirection :: Typing.Alignment)
	return self
end
Icon.setAlignment = Icon.align

function Icon.setLeft(self: Icon): Icon
	self:setAlignment("Left")
	return self
end

function Icon.setMid(self: Icon): Icon
	self:setAlignment("Center")
	return self
end

function Icon.setRight(self: Icon): Icon
	self:setAlignment("Right")
	return self
end

function Icon.setWidth(self: Icon, offsetMinimum: number, iconState: Typing.StateName?): Icon
	-- This sets a minimum X offset size for the widget, useful
	-- for example if you're constantly changing the label
	-- but don't want the icon to resize every time
	local newSize = UDim2.fromOffset(offsetMinimum, self.widget.Size.Y.Offset)
	self:modifyTheme({ "Widget", "Size", newSize, iconState })
	self:modifyTheme({ "Widget", "DesiredWidth", offsetMinimum, iconState })
	return self
end

function Icon.setImageScale(self: Icon, number: number, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "IconImageScale", "Value", number, iconState })
	return self
end

function Icon.setImageRatio(self: Icon, number: number, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "IconImageRatio", "AspectRatio", number, iconState })
	return self
end

function Icon.setTextSize(self: Icon, number: number, iconState: Typing.StateName?): Icon
	self:modifyTheme({ "IconLabel", "TextSize", number, iconState })
	return self
end

function Icon.setTextFont(
	self: Icon,
	fontNameOrAssetId: string,
	fontWeight: Enum.FontWeight,
	fontStyle: Enum.FontStyle,
	iconState: Typing.StateName?
): Icon
	fontWeight = fontWeight or Enum.FontWeight.Regular
	fontStyle = fontStyle or Enum.FontStyle.Normal
	local fontFace = Font.new(fontNameOrAssetId, fontWeight, fontStyle)
	self:modifyTheme({ "IconLabel", "FontFace", fontFace, iconState })
	return self
end

function Icon.bindToggleItem(self: Icon, guiObjectOrLayerCollector): Icon
	if not guiObjectOrLayerCollector:IsA("GuiObject") and not guiObjectOrLayerCollector:IsA("LayerCollector") then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end
	self.toggleItems[guiObjectOrLayerCollector] = true
	self:_updateSelectionInstances()
	return self
end

function Icon.unbindToggleItem(self: Icon, guiObjectOrLayerCollector: GuiObject | LayerCollector): Icon
	self.toggleItems[guiObjectOrLayerCollector] = nil
	self:_updateSelectionInstances()
	return self
end

function Icon._updateSelectionInstances(self: Icon): ()
	-- This is to assist with controller navigation and selection
	-- It converts the value true to an array
	for guiObjectOrLayerCollector, _ in self.toggleItems do
		local buttonInstancesArray = {}
		for _, instance in guiObjectOrLayerCollector:GetDescendants() do
			if (instance:IsA("TextButton") or instance:IsA("ImageButton")) and instance.Active then
				table.insert(buttonInstancesArray, instance)
			end
		end
		self.toggleItems[guiObjectOrLayerCollector] = buttonInstancesArray :: any
	end
end

function Icon._setToggleItemsVisible(self: Icon, bool: boolean, fromInput: Icon?): ()
	for toggleItem, _ in self.toggleItems do
		if not fromInput or fromInput == self or fromInput.toggleItems[toggleItem] == nil then
			local property = "Visible"
			if toggleItem:IsA("LayerCollector") then
				property = "Enabled"
			end
			toggleItem[property] = bool
		end
	end
end

function Icon.bindEvent(self: Icon, iconEventName: string, eventFunction: (...any) -> ())
	local event = self[iconEventName]
	assert(
		event and typeof(event) == "table" and event.Connect,
		"argument[1] must be a valid topbarplus icon event name!"
	)
	assert(typeof(eventFunction) == "function", "argument[2] must be a function!")
	self.bindedEvents[iconEventName] = event:Connect(function(...)
		eventFunction(self, ...)
	end)
	return self
end

function Icon.unbindEvent(self: Icon, iconEventName: string): Icon
	local eventConnection = self.bindedEvents[iconEventName]
	if eventConnection then
		eventConnection:Disconnect()
		self.bindedEvents[iconEventName] = nil
	end
	return self
end

function Icon.bindToggleKey(self: Icon, keyCodeEnum: Enum.KeyCode): Icon
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[keyCodeEnum] = true
	self.toggleKeyAdded:Fire(keyCodeEnum)
	self:setCaption("_hotkey_")
	return self
end

function Icon.unbindToggleKey(self: Icon, keyCodeEnum: Enum.KeyCode): Icon
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self.bindedToggleKeys[keyCodeEnum] = nil
	return self
end

function Icon.call<T...>(self: Icon, callback: (Icon, T...) -> (), ...: T...): Icon
	local packedArgs = table.pack(...)
	task.spawn(function()
		callback(self, table.unpack(packedArgs))
	end)
	return self
end

function Icon.addToJanitor(self: Icon, callback: unknown): Icon
	self.janitor:add(callback)
	return self
end

function Icon.lock(self: Icon): Icon
	-- This disables all user inputs related to the icon (such as clicking buttons, pressing keys, etc)
	local clickRegion = self:getInstance("ClickRegion")
	clickRegion.Visible = false
	self.locked = true
	return self
end

function Icon.unlock(self: Icon): Icon
	local clickRegion = self:getInstance("ClickRegion")
	clickRegion.Visible = true
	self.locked = false
	return self
end

function Icon.debounce(self: Icon, seconds: number): Icon
	self:lock()
	task.wait(seconds)
	self:unlock()
	return self
end

function Icon.autoDeselect(self: Icon, bool: boolean?): Icon
	-- When set to true the icon will deselect itself automatically whenever
	-- another icon is selected
	if bool == nil then
		bool = true
	end
	self.deselectWhenOtherIconSelected = bool :: boolean
	return self
end

function Icon.oneClick(self: Icon, bool: boolean?): Icon
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

function Icon.setCaption(self: Icon, text: string?): Icon
	if text == "_hotkey_" and self.captionText then
		return self
	end
	local captionJanitor = self.captionJanitor
	self.captionJanitor:clean()
	if not text or text == "" then
		self.caption = nil
		self.captionText = nil
		return self
	end
	local caption = captionJanitor:add(require(elements.Caption)(self))
	caption:SetAttribute("CaptionText", text)
	self.caption = caption
	self.captionText = text
	return self
end

function Icon.leave(self: Icon): Icon
	local joinJanitor = self.joinJanitor
	joinJanitor:clean()
	return self
end

function Icon.joinMenu(self: Icon, parentIcon: Icon): Icon
	Utility.joinFeature(self, parentIcon, parentIcon.menuIcons, parentIcon:getInstance("Menu"))
	parentIcon.menuChildAdded:Fire(self)
	return self
end

function Icon.setMenu(self: Icon, arrayOfIcons: { Icon }): Icon
	self.menuSet:Fire(arrayOfIcons)
	return self
end

function Icon.setFrozenMenu(self: Icon, arrayOfIcons): ()
	self:freezeMenu()
	self:setMenu(arrayOfIcons)
end

function Icon.freezeMenu(self: Icon): ()
	-- A frozen menu is a menu which is permanently locked in the
	-- the selected state (with its toggle hidden)
	self:select()
	self:bindEvent("deselected", function(icon)
		icon:select()
	end)
	self:modifyTheme({ "IconSpot", "Visible", false })
end

function Icon.joinDropdown(self: Icon, parentIcon: Icon): Icon
	parentIcon:getDropdown()
	Utility.joinFeature(
		self,
		parentIcon,
		parentIcon.dropdownIcons,
		parentIcon:getInstance("DropdownScroller") :: ScrollingFrame
	)
	parentIcon.dropdownChildAdded:Fire(self)
	return self
end

function Icon.getDropdown(self: Icon): Frame
	local dropdown = self.dropdown
	if not dropdown then
		dropdown = require(elements.Dropdown)(self)
		self.dropdown = dropdown
		self:clipOutside(dropdown)
	end
	return dropdown
end

function Icon.setDropdown(self: Icon, arrayOfIcons: { Icon }): Icon
	self:getDropdown()
	self.dropdownSet:Fire(arrayOfIcons)
	return self
end

function Icon.clipOutside(self: Icon, instance: GuiObject): (Icon, GuiObject)
	-- This is essential for items such as notices and dropdowns which will exceed the bounds of the widget. This is an issue
	-- because the widget must have ClipsDescendents enabled to hide items for instance when the menu is closing or opening.
	-- This creates an invisible frame which matches the size and position of the instance, then the instance is parented outside of
	-- the widget and tracks the clone to match its size and position. In order for themes, etc to work the applying system checks
	-- to see if an instance is a clone, then if it is, it applies it to the original instance instead of the clone.
	local instanceClone = Utility.clipOutside(self, instance)
	self:refreshAppearance(instance)
	return self, instanceClone
end

function Icon.setIndicator(self: Icon, keyCode: Enum.KeyCode): ()
	-- An indicator is a direction button prompt with an image of the given keycode. This is useful for instance
	-- with controllers to show the user what button to press to highlight the topbar. You don't need
	-- to set an indicator for controllers as this is handled internally within the Gamepad module
	local indicator = self.indicator
	if not indicator then
		indicator = self.janitor:add(require(elements.Indicator)(self))
		self.indicator = indicator
	end
	self.indicatorSet:Fire(keyCode)
end

-- DESTROY/CLEANUP
function Icon.destroy(self: Icon): ()
	if self.isDestroyed then
		return
	end
	self:clearNotices()
	if self.parentIconUID then
		self:leave()
	end
	self.isDestroyed = true
	self.janitor:clean()
end
Icon.Destroy = Icon.destroy

return Icon
