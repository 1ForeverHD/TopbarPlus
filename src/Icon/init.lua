-- LOCAL
local LocalizationService = game:GetService("LocalizationService")
local tweenService = game:GetService("TweenService")
local debris = game:GetService("Debris")
local userInputService = game:GetService("UserInputService")
local httpService = game:GetService("HttpService") -- This is to generate GUIDs
local runService = game:GetService("RunService")
local textService = game:GetService("TextService")
local starterGui = game:GetService("StarterGui")
local guiService = game:GetService("GuiService")
local localizationService = game:GetService("LocalizationService")
local playersService = game:GetService("Players")
local localPlayer = playersService.LocalPlayer
local iconModule = script
local TopbarPlusReference = require(iconModule.TopbarPlusReference)
local referenceObject = TopbarPlusReference.getObject()
local leadPackage = referenceObject and referenceObject.Value
if leadPackage and leadPackage ~= iconModule then
	return require(leadPackage)
end
if not referenceObject then
    TopbarPlusReference.addToReplicatedStorage()
end
local Icon = {}
Icon.__index = Icon
local IconController = require(iconModule.IconController)
local Signal = require(iconModule.Signal)
local Maid = require(iconModule.Maid)
local TopbarPlusGui = require(iconModule.TopbarPlusGui)
local Themes = require(iconModule.Themes)
local activeItems = TopbarPlusGui.ActiveItems
local topbarContainer = TopbarPlusGui.TopbarContainer
local iconTemplate = topbarContainer["IconContainer"]
local DEFAULT_THEME = Themes.Default
local THUMB_OFFSET = 55
local DEFAULT_FORCED_GROUP_VALUES = {}



-- CONSTRUCTORS
function Icon.new()
	local self = {}
	setmetatable(self, Icon)

	-- Maids (for autocleanup)
	local maid = Maid.new()
	self._maid = maid
	self._hoveringMaid = maid:give(Maid.new())
	self._dropdownClippingMaid = maid:give(Maid.new())
	self._menuClippingMaid = maid:give(Maid.new())

	-- These are the GuiObjects that make up the icon
	local instances = {}
	self.instances = instances
	local iconContainer = maid:give(iconTemplate:Clone())
	iconContainer.Visible = true
	iconContainer.Parent = topbarContainer
	instances["iconContainer"] = iconContainer
	instances["iconButton"] = iconContainer.IconButton
	instances["iconImage"] = instances.iconButton.IconImage
	instances["iconLabel"] = instances.iconButton.IconLabel
	instances["fakeIconLabel"] = instances.iconButton.FakeIconLabel
	instances["iconGradient"] = instances.iconButton.IconGradient
	instances["iconCorner"] = instances.iconButton.IconCorner
	instances["iconOverlay"] = iconContainer.IconOverlay
	instances["iconOverlayCorner"] = instances.iconOverlay.IconOverlayCorner
	instances["noticeFrame"] = instances.iconButton.NoticeFrame
	instances["noticeLabel"] = instances.noticeFrame.NoticeLabel
	instances["captionContainer"] = iconContainer.CaptionContainer
	instances["captionFrame"] = instances.captionContainer.CaptionFrame
	instances["captionLabel"] = instances.captionContainer.CaptionLabel
	instances["captionCorner"] = instances.captionFrame.CaptionCorner
	instances["captionOverlineContainer"] = instances.captionContainer.CaptionOverlineContainer
	instances["captionOverline"] = instances.captionOverlineContainer.CaptionOverline
	instances["captionOverlineCorner"] = instances.captionOverline.CaptionOverlineCorner
	instances["captionVisibilityBlocker"] = instances.captionFrame.CaptionVisibilityBlocker
	instances["captionVisibilityCorner"] = instances.captionVisibilityBlocker.CaptionVisibilityCorner
	instances["tipFrame"] = iconContainer.TipFrame
	instances["tipLabel"] = instances.tipFrame.TipLabel
	instances["tipCorner"] = instances.tipFrame.TipCorner
	instances["dropdownContainer"] = iconContainer.DropdownContainer
	instances["dropdownFrame"] = instances.dropdownContainer.DropdownFrame
	instances["dropdownList"] = instances.dropdownFrame.DropdownList
	instances["menuContainer"] = iconContainer.MenuContainer
	instances["menuFrame"] = instances.menuContainer.MenuFrame
	instances["menuList"] = instances.menuFrame.MenuList
	instances["clickSound"] = iconContainer.ClickSound

	-- These determine and describe how instances behave and appear
	self._settings = {
		action = {
			["toggleTransitionInfo"] = {},
			["resizeInfo"] = {},
			["repositionInfo"] = {},
			["captionFadeInfo"] = {},
			["tipFadeInfo"] = {},
			["dropdownSlideInfo"] = {},
			["menuSlideInfo"] = {},
		},
		toggleable = {
			["iconBackgroundColor"] = {instanceNames = {"iconButton"}, propertyName = "BackgroundColor3"},
			["iconBackgroundTransparency"] = {instanceNames = {"iconButton"}, propertyName = "BackgroundTransparency"},
			["iconCornerRadius"] = {instanceNames = {"iconCorner", "iconOverlayCorner"}, propertyName = "CornerRadius"},
			["iconGradientColor"] = {instanceNames = {"iconGradient"}, propertyName = "Color"},
			["iconGradientRotation"] = {instanceNames = {"iconGradient"}, propertyName = "Rotation"},
			["iconImage"] = {callMethods = {self._updateIconSize}, instanceNames = {"iconImage"}, propertyName = "Image"},
			["iconImageColor"] = {instanceNames = {"iconImage"}, propertyName = "ImageColor3"},
			["iconImageTransparency"] = {instanceNames = {"iconImage"}, propertyName = "ImageTransparency"},
			["iconScale"] = {instanceNames = {"iconButton"}, propertyName = "Size"},
			["forcedIconSizeX"] = {},
			["forcedIconSizeY"] = {},
			["iconSize"] = {callSignals = {self.updated}, callMethods = {self._updateIconSize}, instanceNames = {"iconContainer"}, propertyName = "Size", tweenAction = "resizeInfo"},
			["iconOffset"] = {instanceNames = {"iconButton"}, propertyName = "Position"},
			["iconText"] = {callMethods = {self._updateIconSize}, instanceNames = {"iconLabel"}, propertyName = "Text"},
			["iconTextColor"] = {instanceNames = {"iconLabel"}, propertyName = "TextColor3"},
			["iconFont"] = {callMethods = {self._updateIconSize}, instanceNames = {"iconLabel"}, propertyName = "Font"},
			["iconImageYScale"] = {callMethods = {self._updateIconSize}},
			["iconImageRatio"] = {callMethods = {self._updateIconSize}},
			["iconLabelYScale"] = {callMethods = {self._updateIconSize}},
			["noticeCircleColor"] = {instanceNames = {"noticeFrame"}, propertyName = "ImageColor3"},
			["noticeCircleImage"] = {instanceNames = {"noticeFrame"}, propertyName = "Image"},
			["noticeTextColor"] = {instanceNames = {"noticeLabel"}, propertyName = "TextColor3"},
			["noticeImageTransparency"] = {instanceNames = {"noticeFrame"}, propertyName = "ImageTransparency"},
			["noticeTextTransparency"] = {instanceNames = {"noticeLabel"}, propertyName = "TextTransparency"},
			["baseZIndex"] = {callMethods = {self._updateBaseZIndex}},
			["order"] = {callSignals = {self.updated}, instanceNames = {"iconContainer"}, propertyName = "LayoutOrder"},
			["alignment"] = {callSignals = {self.updated}, callMethods = {self._updateDropdown}},
			["iconImageVisible"] = {instanceNames = {"iconImage"}, propertyName = "Visible"},
			["iconImageAnchorPoint"] = {instanceNames = {"iconImage"}, propertyName = "AnchorPoint"},
			["iconImagePosition"] = {instanceNames = {"iconImage"}, propertyName = "Position", tweenAction = "resizeInfo"},
			["iconImageSize"] = {instanceNames = {"iconImage"}, propertyName = "Size", tweenAction = "resizeInfo"},
			["iconImageTextXAlignment"] = {instanceNames = {"iconImage"}, propertyName = "TextXAlignment"},
			["iconLabelVisible"] = {instanceNames = {"iconLabel"}, propertyName = "Visible"},
			["iconLabelAnchorPoint"] = {instanceNames = {"iconLabel"}, propertyName = "AnchorPoint"},
			["iconLabelPosition"] = {instanceNames = {"iconLabel"}, propertyName = "Position", tweenAction = "resizeInfo"},
			["iconLabelSize"] = {instanceNames = {"iconLabel"}, propertyName = "Size", tweenAction = "resizeInfo"},
			["iconLabelTextXAlignment"] = {instanceNames = {"iconLabel"}, propertyName = "TextXAlignment"},
			["iconLabelTextSize"] = {instanceNames = {"iconLabel"}, propertyName = "TextSize"},
			["noticeFramePosition"] = {instanceNames = {"noticeFrame"}, propertyName = "Position"},
			["clickSoundId"] = {instanceNames = {"clickSound"}, propertyName = "SoundId"},
			["clickVolume"] = {instanceNames = {"clickSound"}, propertyName = "Volume"},
			["clickPlaybackSpeed"] = {instanceNames = {"clickSound"}, propertyName = "PlaybackSpeed"},
			["clickTimePosition"] = {instanceNames = {"clickSound"}, propertyName = "TimePosition"},
		},
		other = {
			["captionBackgroundColor"] = {instanceNames = {"captionFrame"}, propertyName = "BackgroundColor3"},
			["captionBackgroundTransparency"] = {instanceNames = {"captionFrame"}, propertyName = "BackgroundTransparency", group = "caption"},
			["captionBlockerTransparency"] = {instanceNames = {"captionVisibilityBlocker"}, propertyName = "BackgroundTransparency", group = "caption"},
			["captionOverlineColor"] = {instanceNames = {"captionOverline"}, propertyName = "BackgroundColor3"},
			["captionOverlineTransparency"] = {instanceNames = {"captionOverline"}, propertyName = "BackgroundTransparency", group = "caption"},
			["captionTextColor"] = {instanceNames = {"captionLabel"}, propertyName = "TextColor3"},
			["captionTextTransparency"] = {instanceNames = {"captionLabel"}, propertyName = "TextTransparency", group = "caption"},
			["captionFont"] = {instanceNames = {"captionLabel"}, propertyName = "Font"},
			["captionCornerRadius"] = {instanceNames = {"captionCorner", "captionOverlineCorner", "captionVisibilityCorner"}, propertyName = "CornerRadius"},
			["tipBackgroundColor"] = {instanceNames = {"tipFrame"}, propertyName = "BackgroundColor3"},
			["tipBackgroundTransparency"] = {instanceNames = {"tipFrame"}, propertyName = "BackgroundTransparency", group = "tip"},
			["tipTextColor"] = {instanceNames = {"tipLabel"}, propertyName = "TextColor3"},
			["tipTextTransparency"] = {instanceNames = {"tipLabel"}, propertyName = "TextTransparency", group = "tip"},
			["tipFont"] = {instanceNames = {"tipLabel"}, propertyName = "Font"},
			["tipCornerRadius"] = {instanceNames = {"tipCorner"}, propertyName = "CornerRadius"},
			["dropdownSize"] = {instanceNames = {"dropdownContainer"}, propertyName = "Size", unique = "dropdown"},
			["dropdownCanvasSize"] = {instanceNames = {"dropdownFrame"}, propertyName = "CanvasSize"},
			["dropdownMaxIconsBeforeScroll"] = {callMethods = {self._updateDropdown}},
			["dropdownMinWidth"] = {callMethods = {self._updateDropdown}},
			["dropdownSquareCorners"] = {callMethods = {self._updateDropdown}},
			["dropdownBindToggleToIcon"] = {},
			["dropdownToggleOnLongPress"] = {},
			["dropdownToggleOnRightClick"] = {},
			["dropdownCloseOnTapAway"] = {},
			["dropdownHidePlayerlistOnOverlap"] = {},
			["dropdownListPadding"] = {callMethods = {self._updateDropdown}, instanceNames = {"dropdownList"}, propertyName = "Padding"},
			["dropdownAlignment"] = {callMethods = {self._updateDropdown}},
			["dropdownScrollBarColor"] = {instanceNames = {"dropdownFrame"}, propertyName = "ScrollBarImageColor3"},
			["dropdownScrollBarTransparency"] = {instanceNames = {"dropdownFrame"}, propertyName = "ScrollBarImageTransparency"},
			["dropdownScrollBarThickness"] = {instanceNames = {"dropdownFrame"}, propertyName = "ScrollBarThickness"},
			["dropdownIgnoreClipping"] = {callMethods = {self._dropdownIgnoreClipping}},
			["menuSize"] = {instanceNames = {"menuContainer"}, propertyName = "Size", unique = "menu"},
			["menuCanvasSize"] = {instanceNames = {"menuFrame"}, propertyName = "CanvasSize"},
			["menuMaxIconsBeforeScroll"] = {callMethods = {self._updateMenu}},
			["menuBindToggleToIcon"] = {},
			["menuToggleOnLongPress"] = {},
			["menuToggleOnRightClick"] = {},
			["menuCloseOnTapAway"] = {},
			["menuListPadding"] = {callMethods = {self._updateMenu}, instanceNames = {"menuList"}, propertyName = "Padding"},
			["menuDirection"] = {callMethods = {self._updateMenu}},
			["menuScrollBarColor"] = {instanceNames = {"menuFrame"}, propertyName = "ScrollBarImageColor3"},
			["menuScrollBarTransparency"] = {instanceNames = {"menuFrame"}, propertyName = "ScrollBarImageTransparency"},
			["menuScrollBarThickness"] = {instanceNames = {"menuFrame"}, propertyName = "ScrollBarThickness"},
			["menuIgnoreClipping"] = {callMethods = {self._menuIgnoreClipping}},
		}
	}

	---------------------------------
	self._groupSettings = {}
	for _, settingsDetails in pairs(self._settings) do
		for settingName, settingDetail in pairs(settingsDetails) do
			local group = settingDetail.group
			if group then
				local groupSettings = self._groupSettings[group]
				if not groupSettings then
					groupSettings = {}
					self._groupSettings[group] = groupSettings
				end
				table.insert(groupSettings, settingName)
				settingDetail.forcedGroupValue = DEFAULT_FORCED_GROUP_VALUES[group]
				settingDetail.useForcedGroupValue = true
			end
		end
	end
	---------------------------------

	-- The setting values themselves will be set within _settings
	-- Setup a dictionary to make it quick and easy to reference setting by name
	self._settingsDictionary = {}
	-- Some instances require unique behaviours. These are defined with the 'unique' key
	-- for instance, we only want caption transparency effects to be applied on hovering
	self._uniqueSettings = {}
	self._uniqueSettingsDictionary = {}
	self.uniqueValues = {}
	local uniqueBehaviours = {
		["dropdown"] = function(settingName, instance, propertyName, value)
			local tweenInfo = self:get("dropdownSlideInfo")
			local bindToggleToIcon = self:get("dropdownBindToggleToIcon")
			local hidePlayerlist = self:get("dropdownHidePlayerlistOnOverlap") == true and self:get("alignment") == "right"
			local dropdownContainer = self.instances.dropdownContainer
			local dropdownFrame = self.instances.dropdownFrame
			local newValue = value
			local isOpen = true
			local isDeselected = not self.isSelected
			if bindToggleToIcon == false then
				isDeselected = not self.dropdownOpen
			end
			local isSpecialPressing = self._longPressing or self._rightClicking
			if self._tappingAway or (isDeselected and not isSpecialPressing) or (isSpecialPressing and self.dropdownOpen) then 
				local dropdownSize = self:get("dropdownSize")
				local XOffset = (dropdownSize and dropdownSize.X.Offset/1) or 0
				newValue = UDim2.new(0, XOffset, 0, 0)
				isOpen = false
			end
			-- if #self.dropdownIcons > 0 and isOpen and hidePlayerlist and self._parentIcon == nil and self._bringBackPlayerlist == nil then
			if #self.dropdownIcons > 0 and isOpen and hidePlayerlist then
				if starterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
					IconController._bringBackPlayerlist = (IconController._bringBackPlayerlist and IconController._bringBackPlayerlist + 1) or 1
					self._bringBackPlayerlist = true
					starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
				end
			elseif self._bringBackPlayerlist and not isOpen and IconController._bringBackPlayerlist then
				IconController._bringBackPlayerlist -= 1
				if IconController._bringBackPlayerlist <= 0 then
					IconController._bringBackPlayerlist = nil
					starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
				end
				self._bringBackPlayerlist = nil
			end
			local tween = tweenService:Create(instance, tweenInfo, {[propertyName] = newValue})
			local connection
			connection = tween.Completed:Connect(function()
				connection:Disconnect()
				--dropdownContainer.ClipsDescendants = not self.dropdownOpen
			end)
			tween:Play()
			if isOpen then
				--dropdownFrame.CanvasPosition = self._dropdownCanvasPos
			else
				self._dropdownCanvasPos = dropdownFrame.CanvasPosition
			end
			dropdownFrame.ScrollingEnabled = isOpen -- It's important scrolling is only enabled when the dropdown is visible otherwise it could block the scrolling behaviour of other icons
			self.dropdownOpen = isOpen
			self:_decideToCallSignal("dropdown")
		end,
		["menu"] = function(settingName, instance, propertyName, value)
			local tweenInfo = self:get("menuSlideInfo")
			local bindToggleToIcon = self:get("menuBindToggleToIcon")
			local menuContainer = self.instances.menuContainer
			local menuFrame = self.instances.menuFrame
			local newValue = value
			local isOpen = true
			local isDeselected = not self.isSelected
			if bindToggleToIcon == false then
				isDeselected = not self.menuOpen
			end
			local isSpecialPressing = self._longPressing or self._rightClicking
			if self._tappingAway or (isDeselected and not isSpecialPressing) or (isSpecialPressing and self.menuOpen) then 
				local menuSize = self:get("menuSize")
				local YOffset = (menuSize and menuSize.Y.Offset/1) or 0
				newValue = UDim2.new(0, 0, 0, YOffset)
				isOpen = false
			end
			if isOpen ~= self.menuOpen then
				self.updated:Fire()
			end
			if isOpen and tweenInfo.EasingDirection == Enum.EasingDirection.Out then
				tweenInfo = TweenInfo.new(tweenInfo.Time, tweenInfo.EasingStyle, Enum.EasingDirection.In)
			end
			local tween = tweenService:Create(instance, tweenInfo, {[propertyName] = newValue})
			local connection
			connection = tween.Completed:Connect(function()
				connection:Disconnect()
				--menuContainer.ClipsDescendants = not self.menuOpen
			end)
			tween:Play()
			if isOpen then
				if self._menuCanvasPos then
					menuFrame.CanvasPosition = self._menuCanvasPos
				end
			else
				self._menuCanvasPos = menuFrame.CanvasPosition
			end
			menuFrame.ScrollingEnabled = isOpen -- It's important scrolling is only enabled when the menu is visible otherwise it could block the scrolling behaviour of other icons
			self.menuOpen = isOpen
			self:_decideToCallSignal("menu")
		end,
	}
	for settingsType, settingsDetails in pairs(self._settings) do
		for settingName, settingDetail in pairs(settingsDetails) do
			if settingsType == "toggleable" then
				settingDetail.values = settingDetail.values or {
					deselected = nil,
					selected = nil,
				}
			else
				settingDetail.value = nil
			end
			settingDetail.additionalValues = {}
			settingDetail.type = settingsType
			self._settingsDictionary[settingName] = settingDetail
			--
			local uniqueCat = settingDetail.unique
			if uniqueCat then
				local uniqueCatArray = self._uniqueSettings[uniqueCat] or {}
				table.insert(uniqueCatArray, settingName)
				self._uniqueSettings[uniqueCat] = uniqueCatArray
				self._uniqueSettingsDictionary[settingName] = uniqueBehaviours[uniqueCat]
			end
			--
		end
	end
	
	-- Signals (events)
	self.updated = maid:give(Signal.new())
	self.selected = maid:give(Signal.new())
    self.deselected = maid:give(Signal.new())
    self.toggled = maid:give(Signal.new())
	self.userSelected = maid:give(Signal.new())
	self.userDeselected = maid:give(Signal.new())
	self.userToggled = maid:give(Signal.new())
	self.hoverStarted = maid:give(Signal.new())
	self.hoverEnded = maid:give(Signal.new())
	self.dropdownOpened = maid:give(Signal.new())
	self.dropdownClosed = maid:give(Signal.new())
	self.menuOpened = maid:give(Signal.new())
	self.menuClosed = maid:give(Signal.new())
	self.notified = maid:give(Signal.new())
	self._endNotices = maid:give(Signal.new())
	self._ignoreClippingChanged = maid:give(Signal.new())
	
	-- Connections
	-- This enables us to chain icons and features like menus and dropdowns together without them being hidden by parent frame with ClipsDescendants enabled
	local function setFeatureChange(featureName, value)
		local parentIcon = self._parentIcon
		self:set(featureName.."IgnoreClipping", value)
		if value == true and parentIcon then
			local connection = parentIcon._ignoreClippingChanged:Connect(function(_, value)
				self:set(featureName.."IgnoreClipping", value)
			end)
			local endConnection
			endConnection = self[featureName.."Closed"]:Connect(function()
				endConnection:Disconnect()
				connection:Disconnect()
			end)
		end
	end
	self.dropdownOpened:Connect(function()
		setFeatureChange("dropdown", true)
	end)
	self.dropdownClosed:Connect(function()
		setFeatureChange("dropdown", false)
	end)
	self.menuOpened:Connect(function()
		setFeatureChange("menu", true)
	end)
	self.menuClosed:Connect(function()
		setFeatureChange("menu", false)
	end)
	--]]

	-- Properties
	self.deselectWhenOtherIconSelected = true
	self.name = ""
	self.isSelected = false
	self.presentOnTopbar = true
	self.accountForWhenDisabled = false
	self.enabled = true
	self.hovering = false
	self.tipText = nil
	self.captionText = nil
	self.totalNotices = 0
	self.notices = {}
	self.dropdownIcons = {}
	self.menuIcons = {}
	self.dropdownOpen = false
	self.menuOpen = false
	self.locked = false
	self.topPadding = UDim.new(0, 4)
	self.targetPosition = nil
	self.toggleItems = {}
	self.lockedSettings = {}
	self.UID = httpService:GenerateGUID(true)
	self.blockBackBehaviourChecks = {}
	
	-- Private Properties
	self._draggingFinger = false
	self._updatingIconSize = true
	self._previousDropdownOpen = false
	self._previousMenuOpen = false
	self._bindedToggleKeys = {}
	self._bindedEvents = {}
	
	-- Apply start values
	self:setName("UnnamedIcon")
	self:setTheme(DEFAULT_THEME, true)

	-- Input handlers
	-- Calls deselect/select when the icon is clicked
	--[[instances.iconButton.MouseButton1Click:Connect(function()
		if self.locked then return end
		if self._draggingFinger then
			return false
		elseif self.isSelected then
			self:deselect()
			return true
		end
		self:select()
	end)--]]
	instances.iconButton.MouseButton1Click:Connect(function()
		if self.locked then return end
		if self.isSelected then
			self:deselect()
			self.userDeselected:Fire()
			self.userToggled:Fire(false)
			return true
		end
		self:select()
		self.userSelected:Fire()
		self.userToggled:Fire(true)
	end)
	instances.iconButton.MouseButton2Click:Connect(function()
		self._rightClicking = true
		if self:get("dropdownToggleOnRightClick") == true then
			self:_update("dropdownSize")
		end
		if self:get("menuToggleOnRightClick") == true then
			self:_update("menuSize")
		end
		self._rightClicking = false
	end)

	-- Shows/hides the dark overlay when the icon is presssed/released
	instances.iconButton.MouseButton1Down:Connect(function()
		if self.locked then return end
		self:_updateStateOverlay(0.7, Color3.new(0, 0, 0))
	end)
	instances.iconButton.MouseButton1Up:Connect(function()
		if self.overlayLocked then return end
		self:_updateStateOverlay(0.9, Color3.new(1, 1, 1))
	end)

	-- Tap away + KeyCode toggles
	userInputService.InputBegan:Connect(function(input, touchingAnObject)
		local validTapAwayInputs = {
			[Enum.UserInputType.MouseButton1] = true,
			[Enum.UserInputType.MouseButton2] = true,
			[Enum.UserInputType.MouseButton3] = true,
			[Enum.UserInputType.Touch] = true,
		}
		if not touchingAnObject and validTapAwayInputs[input.UserInputType] then
			self._tappingAway = true
			if self.dropdownOpen and self:get("dropdownCloseOnTapAway") == true then
				self:_update("dropdownSize")
			end
			if self.menuOpen and self:get("menuCloseOnTapAway") == true then
				self:_update("menuSize")
			end
			self._tappingAway = false
		end
		--
		if self._bindedToggleKeys[input.KeyCode] and not touchingAnObject and not self.locked then
			if self.isSelected then
				self:deselect()
				self.userDeselected:Fire()
				self.userToggled:Fire(false)
			else
				self:select()
				self.userSelected:Fire()
				self.userToggled:Fire(true)
			end
		end
		--
	end)
	
	-- hoverStarted and hoverEnded triggers and actions
	-- these are triggered when a mouse enters/leaves the icon with a mouse, is highlighted with
	-- a controller selection box, or dragged over with a touchpad
	self.hoverStarted:Connect(function(x, y)
		self.hovering = true
		if not self.locked then
			self:_updateStateOverlay(0.9, Color3.fromRGB(255, 255, 255))
		end
		self:_updateHovering()
	end)
	self.hoverEnded:Connect(function()
		self.hovering = false
		self:_updateStateOverlay(1)
		self._hoveringMaid:clean()
		self:_updateHovering()
	end)
	instances.iconButton.MouseEnter:Connect(function(x, y) -- Mouse (started)
		self.hoverStarted:Fire(x, y)
	end)
	instances.iconButton.MouseLeave:Connect(function() -- Mouse (ended)
		self.hoverEnded:Fire()
	end)
	instances.iconButton.SelectionGained:Connect(function() -- Controller (started)
		self.hoverStarted:Fire()
	end)
	instances.iconButton.SelectionLost:Connect(function() -- Controller (ended)
		self.hoverEnded:Fire()
	end)
	instances.iconButton.MouseButton1Down:Connect(function() -- TouchPad (started)
		if self._draggingFinger then
			self.hoverStarted:Fire()
		end
		-- Long press check
		local heartbeatConnection
		local releaseConnection
		local longPressTime = 0.7
		local endTick = tick() + longPressTime
		heartbeatConnection = runService.Heartbeat:Connect(function()
			if tick() >= endTick then
				releaseConnection:Disconnect()
				heartbeatConnection:Disconnect()
				self._longPressing = true
				if self:get("dropdownToggleOnLongPress") == true then
					self:_update("dropdownSize")
				end
				if self:get("menuToggleOnLongPress") == true then
					self:_update("menuSize")
				end
				self._longPressing = false
			end
		end)
		releaseConnection = instances.iconButton.MouseButton1Up:Connect(function()
			releaseConnection:Disconnect()
			heartbeatConnection:Disconnect()
		end)
	end)
	if userInputService.TouchEnabled then
		instances.iconButton.MouseButton1Up:Connect(function() -- TouchPad (ended), this was originally enabled for non-touchpads too
			if self.hovering then
				self.hoverEnded:Fire()
			end
		end)
		-- This is used to highlight when a mobile/touch device is dragging their finger accross the screen
		-- this is important for determining the hoverStarted and hoverEnded events on mobile
		local dragCount = 0
		userInputService.TouchMoved:Connect(function(touch, touchingAnObject)
			if touchingAnObject then
				return
			end
			self._draggingFinger = true
		end)
		userInputService.TouchEnded:Connect(function()
			self._draggingFinger = false
		end)
	end

	-- Finish
	self._updatingIconSize = false
	self:_updateIconSize()
	IconController.iconAdded:Fire(self)
	
	return self
end

-- This is the same as Icon.new(), except it adds additional behaviour for certain specified names designed to mimic core icons, such as 'Chat'
function Icon.mimic(coreIconToMimic)
	local iconName = coreIconToMimic.."Mimic"
	local icon = IconController.getIcon(iconName)
	if icon then
		return icon
	end
	icon = Icon.new()
	icon:setName(iconName)

	if coreIconToMimic == "Chat" then
		icon:setOrder(-1)
		icon:setImage("rbxasset://textures/ui/TopBar/chatOff.png", "deselected")
		icon:setImage("rbxasset://textures/ui/TopBar/chatOn.png", "selected")
		icon:setImageYScale(0.625)
		-- Since roblox's core gui api sucks melons I reverted to listening for signals within the chat modules
		-- unfortunately however they've just gone and removed *these* signals therefore 
		-- this mimic chat and similar features are now impossible to recreate accurately, so I'm disabling for now
		-- ill go ahead and post a feature request; fingers crossed we get something by the next decade

		--[[
		-- Setup maid and cleanup actioon
		local maid = icon._maid
		icon._fakeChatMaid = maid:give(Maid.new())
		maid.chatMimicCleanup = function()
			starterGui:SetCoreGuiEnabled("Chat", icon.enabled)
		end
		-- Tap into chat module
		local chatMainModule = localPlayer.PlayerScripts:WaitForChild("ChatScript").ChatMain
		local ChatMain = require(chatMainModule)
		local function displayChatBar(visibility)
			icon.ignoreVisibilityStateChange = true
			ChatMain.CoreGuiEnabled:fire(visibility)
			ChatMain.IsCoreGuiEnabled = false
			ChatMain:SetVisible(visibility)
			icon.ignoreVisibilityStateChange = nil
		end
		local function setIconEnabled(visibility)
			icon.ignoreVisibilityStateChange = true
			ChatMain.CoreGuiEnabled:fire(visibility)
			icon:setEnabled(visibility)
			starterGui:SetCoreGuiEnabled("Chat", false)
			icon:deselect()
			icon.updated:Fire()
			icon.ignoreVisibilityStateChange = nil
		end
		-- Open chat via Slash key
		icon._fakeChatMaid:give(userInputService.InputEnded:Connect(function(inputObject, gameProcessedEvent)
			if gameProcessedEvent then
				return "Another menu has priority"
			elseif not(inputObject.KeyCode == Enum.KeyCode.Slash or inputObject.KeyCode == Enum.SpecialKey.ChatHotkey) then
				return "No relavent key pressed"
			elseif ChatMain.IsFocused() then
				return "Chat bar already open"
			elseif not icon.enabled then
				return "Icon disabled"
			end
			ChatMain:FocusChatBar(true)
			icon:select()
		end))
		-- ChatActive
		icon._fakeChatMaid:give(ChatMain.VisibilityStateChanged:Connect(function(visibility)
			if not icon.ignoreVisibilityStateChange then
				if visibility == true then
					icon:select()
				else
					icon:deselect()
				end
			end
		end))
		-- Keep when other icons selected
		icon.deselectWhenOtherIconSelected = false
		-- Mimic chat notifications
		icon._fakeChatMaid:give(ChatMain.MessagesChanged:connect(function()
			if ChatMain:GetVisibility() == true then
				return "ChatWindow was open"
			end
			icon:notify(icon.selected)
		end))
		-- Mimic visibility when StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state) is called
		coroutine.wrap(function()
			runService.Heartbeat:Wait()
			icon._fakeChatMaid:give(ChatMain.CoreGuiEnabled:connect(function(newState)
				if icon.ignoreVisibilityStateChange then
					return "ignoreVisibilityStateChange enabled"
				end
				local topbarEnabled = starterGui:GetCore("TopbarEnabled")
				if topbarEnabled ~= IconController.previousTopbarEnabled then
					return "SetCore was called instead of SetCoreGuiEnabled"
				end
				if not icon.enabled and userInputService:IsKeyDown(Enum.KeyCode.LeftShift) and userInputService:IsKeyDown(Enum.KeyCode.P) then
					icon:setEnabled(true)
				else
					setIconEnabled(newState)
				end
			end))
		end)()
		icon.deselected:Connect(function()
			displayChatBar(false)
		end)
		icon.selected:Connect(function()
			displayChatBar(true)
		end)
		setIconEnabled(starterGui:GetCoreGuiEnabled("Chat"))
		--]]
	end
	return icon
end



-- CORE UTILITY METHODS
function Icon:set(settingName, value, iconState, setAdditional)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	if type(iconState) == "string" then
		iconState = iconState:lower()
	end
	local previousValue = self:get(settingName, iconState)

	if iconState == "hovering" then
		-- Apply hovering state if valid
		settingDetail.hoveringValue = value
		if setAdditional ~= "_ignorePrevious" then
			settingDetail.additionalValues["previous_"..iconState] = previousValue
		end
		if type(setAdditional) == "string" then
			settingDetail.additionalValues[setAdditional.."_"..iconState] = previousValue
		end
		self:_update(settingName)

	else
		-- Update the settings value
		local toggleState = iconState
		local settingType = settingDetail.type
		if settingType == "toggleable" then
			local valuesToSet = {}
			if toggleState == "deselected" or toggleState == "selected" then
				table.insert(valuesToSet, toggleState)
			else
				table.insert(valuesToSet, "deselected")
				table.insert(valuesToSet, "selected")
				toggleState = nil
			end
			for i, v in pairs(valuesToSet) do
				settingDetail.values[v] = value
				if setAdditional ~= "_ignorePrevious" then
					settingDetail.additionalValues["previous_"..v] = previousValue
				end
				if type(setAdditional) == "string" then
					settingDetail.additionalValues[setAdditional.."_"..v] = previousValue
				end
			end
		else
			settingDetail.value = value
			if type(setAdditional) == "string" then
				if setAdditional ~= "_ignorePrevious" then
					settingDetail.additionalValues["previous"] = previousValue
				end
				settingDetail.additionalValues[setAdditional] = previousValue
			end
		end

		-- Check previous and new are not the same
		if previousValue == value then
			return self, "Value was already set"
		end

		-- Update appearances of associated instances
		local currentToggleState = self:getToggleState()
		if not self._updateAfterSettingAll and settingDetail.instanceNames and (currentToggleState == toggleState or toggleState == nil) then
			local ignoreTweenAction = (settingName == "iconSize" and previousValue and previousValue.X.Scale == 1)
			local tweenInfo = (settingDetail.tweenAction and not ignoreTweenAction and self:get(settingDetail.tweenAction)) or TweenInfo.new(0)
			self:_update(settingName, currentToggleState, tweenInfo)
		end
	end

	-- Call any methods present
	if settingDetail.callMethods then
		for _, callMethod in pairs(settingDetail.callMethods) do
			callMethod(self, value, iconState)
		end
	end
	
	-- Call any signals present
	if settingDetail.callSignals then
		for _, callSignal in pairs(settingDetail.callSignals) do
			callSignal:Fire()
		end
	end
	return self
end

function Icon:setAdditionalValue(settingName, setAdditional, value, iconState)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	local stringMatch = setAdditional.."_"
	if iconState then
		stringMatch = stringMatch..iconState
	end
	for key, _ in pairs(settingDetail.additionalValues) do
		if string.match(key, stringMatch) then
			settingDetail.additionalValues[key] = value
		end
	end
end

function Icon:get(settingName, iconState, getAdditional)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	local valueToReturn, additionalValueToReturn
	if typeof(iconState) == "string" then
		iconState = iconState:lower()
	end

	--if ((self.hovering and settingDetail.hoveringValue) or iconState == "hovering") and getAdditional == nil then
	if (iconState == "hovering") and getAdditional == nil then
		valueToReturn = settingDetail.hoveringValue
		additionalValueToReturn = type(getAdditional) == "string" and settingDetail.additionalValues[getAdditional.."_"..iconState]
	end

	local settingType = settingDetail.type
	if settingType == "toggleable" then
		local toggleState = ((iconState == "deselected" or iconState == "selected") and iconState) or self:getToggleState()
		if additionalValueToReturn == nil then
			additionalValueToReturn = type(getAdditional) == "string" and settingDetail.additionalValues[getAdditional.."_"..toggleState]
		end
		if valueToReturn == nil then
			valueToReturn = settingDetail.values[toggleState]
		end
	
	else
		if additionalValueToReturn == nil then
			additionalValueToReturn = type(getAdditional) == "string" and settingDetail.additionalValues[getAdditional]
		end
		if valueToReturn == nil then
			valueToReturn = settingDetail.value
		end
	end

	return valueToReturn, additionalValueToReturn
end

function Icon:getHovering(settingName)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	return settingDetail.hoveringValue
end

function Icon:getToggleState(isSelected)
	isSelected = isSelected or self.isSelected
	return (isSelected and "selected") or "deselected"
end

function Icon:getIconState()
	if self.hovering then
		return "hovering"
	else
		return self:getToggleState()
	end
end

function Icon:_update(settingName, toggleState, customTweenInfo)
	local settingDetail = self._settingsDictionary[settingName]
	assert(settingDetail ~= nil, ("setting '%s' does not exist"):format(settingName))
	toggleState = toggleState or self:getToggleState()
	local value = settingDetail.value or (settingDetail.values and settingDetail.values[toggleState])
	if self.hovering and settingDetail.hoveringValue then
		value = settingDetail.hoveringValue
	end
	if value == nil then return end
	local tweenInfo = customTweenInfo or (settingDetail.tweenAction and settingDetail.tweenAction ~= "" and self:get(settingDetail.tweenAction)) or self:get("toggleTransitionInfo") or TweenInfo.new(0.15)
	local propertyName = settingDetail.propertyName
	local invalidPropertiesTypes = {
		["string"] = true,
		["NumberSequence"] = true,
		["Text"] = true,
		["EnumItem"] = true,
		["ColorSequence"] = true,
	}
	local uniqueSetting = self._uniqueSettingsDictionary[settingName]
	local newValue = value
	if settingDetail.useForcedGroupValue then
		newValue = settingDetail.forcedGroupValue
	end
	if settingDetail.instanceNames then
		for _, instanceName in pairs(settingDetail.instanceNames) do
			local instance = self.instances[instanceName]
			local propertyType = typeof(instance[propertyName])
			local cannotTweenProperty = invalidPropertiesTypes[propertyType] or typeof(instance) == "table"
			if uniqueSetting then
				uniqueSetting(settingName, instance, propertyName, newValue)
			elseif cannotTweenProperty then
				instance[propertyName] = value
			else
				tweenService:Create(instance, tweenInfo, {[propertyName] = newValue}):Play()
			end
			--
			if settingName == "iconSize" and instance[propertyName] ~= newValue then
				self.updated:Fire()
			end
			--
		end
	end
end

function Icon:_updateAll(iconState, customTweenInfo)
	for settingName, settingDetail in pairs(self._settingsDictionary) do
		if settingDetail.instanceNames then
			self:_update(settingName, iconState, customTweenInfo)
		end
	end
	-- It's important we adapt the size of anything that could be changed through Localization
	-- In this case, the icon label, caption and tip
	self:_updateIconSize()
	self:_updateCaptionSize()
	self:_updateTipSize()
end

function Icon:_updateHovering(customTweenInfo)
	for settingName, settingDetail in pairs(self._settingsDictionary) do
		if settingDetail.instanceNames and settingDetail.hoveringValue ~= nil then
			self:_update(settingName, nil, customTweenInfo)
		end
	end
end

function Icon:_updateStateOverlay(transparency, color)
	local stateOverlay = self.instances.iconOverlay
	stateOverlay.BackgroundTransparency = transparency or 1
	stateOverlay.BackgroundColor3 = color or Color3.new(1, 1, 1)
end

function Icon:setTheme(theme, updateAfterSettingAll)
	self._updateAfterSettingAll = updateAfterSettingAll
	for settingsType, settingsDetails in pairs(theme) do
		if settingsType == "toggleable" then
			for settingName, settingValue in pairs(settingsDetails.deselected) do
				if not self.lockedSettings[settingName] then
					self:set(settingName, settingValue, "both")
				end
			end
			for settingName, settingValue in pairs(settingsDetails.selected) do
				if not self.lockedSettings[settingName] then
					self:set(settingName, settingValue, "selected")
				end
			end
		else
			for settingName, settingValue in pairs(settingsDetails) do
				if not self.lockedSettings[settingName] then
					local settingDetail = self._settingsDictionary[settingName]
					if settingsType == "action" and settingDetail == nil then
						settingDetail = {}
						self._settingsDictionary[settingName] = {}
					end
					self:set(settingName, settingValue)
				end
			end
		end
	end
	self._updateAfterSettingAll = nil
	if updateAfterSettingAll then
		self:_updateAll()
	end
	return self
end

function Icon:getInstance(instanceName)
	return self.instances[instanceName]
end

function Icon:setInstance(instanceName, instance)
	local originalInstance = self.instances[instanceName]
	self.instances[instanceName] = instance
	if originalInstance then
		originalInstance:Destroy()
	end
	return self
end

function Icon:getSettingDetail(targetSettingName)
	for _, settingsDetails in pairs(self._settings) do
		for settingName, settingDetail in pairs(settingsDetails) do
			if settingName == targetSettingName then
				return settingDetail
			end
		end
	end
	return false
end

function Icon:modifySetting(settingName, dictionary)
	local settingDetail = self:getSettingDetail(settingName)
	for key, value in pairs(dictionary) do
		settingDetail[key] = value
	end
	return self
end

function Icon:convertLabelToNumberSpinner(numberSpinner)
	-- This updates the number spinners appearance
	self:set("iconLabelSize", UDim2.new(1,0,1,0))
	numberSpinner.Parent = self:getInstance("iconButton")

	-- This creates a fake iconLabel which updates the property of all descendant spinner TextLabels when indexed
	local textLabel = {}
	setmetatable(textLabel, {__newindex = function(_, index, value)
		for _, label in pairs(numberSpinner.Frame:GetDescendants()) do
			if label:IsA("TextLabel") then
				label[index] = value
			end
		end
	end})

	-- This overrides existing instances and settings so that they update the spinners properties (instead of the old textlabel)
	local iconButton = self:getInstance("iconButton")
	iconButton.ZIndex = 0
	self:setInstance("iconLabel", textLabel)
	self:modifySetting("iconText", {instanceNames = {}}) -- We do this to prevent text being modified within the metatable above
	self:setInstance("iconLabelSpinner", numberSpinner.Frame)
	local settingsToConvert = {"iconLabelVisible", "iconLabelAnchorPoint", "iconLabelPosition", "iconLabelSize"}
	for _, settingName in pairs(settingsToConvert) do
		self:modifySetting(settingName, {instanceNames = {"iconLabelSpinner"}})
	end

	-- This applies all the values we just updated
	self:_updateAll()
	return self
end

function Icon:setEnabled(bool)
	self.enabled = bool
	self.instances.iconContainer.Visible = bool
	self.updated:Fire()
	return self
end

function Icon:setName(string)
	self.name = string
	self.instances.iconContainer.Name = string
	return self
end

function Icon:setProperty(propertyName, value)
	self[propertyName] = value
	return self
end

function Icon:_playClickSound()
	local clickSound = self.instances.clickSound
	if clickSound.SoundId ~= nil and #clickSound.SoundId > 0 and clickSound.Volume > 0 then
		local clickSoundCopy = clickSound:Clone()
		clickSoundCopy.Parent = clickSound.Parent
		clickSoundCopy:Play()
		debris:AddItem(clickSoundCopy, clickSound.TimeLength)
	end
end

function Icon:select(byIcon)
	--if self.locked then return self end
	self.isSelected = true
	self:_setToggleItemsVisible(true, byIcon)
	self:_updateNotice()
	self:_updateAll()
	self:_playClickSound()
	if #self.dropdownIcons > 0 or #self.menuIcons > 0 then
		IconController:_updateSelectionGroup()
	end
	if userInputService.GamepadEnabled then
		-- If a corresponding guiObject is found (set via :setToggleItem()) then this automatically
		-- moves the controller selection to a selectable and active instance within that guiObject.
		-- It also support back (Controller B) being pressed by navigating to previous pages or
		-- closing the icon and focusing selection back on the controller navigation topbar.
		for toggleItem, buttonInstancesArray in pairs(self.toggleItems) do
			if #buttonInstancesArray > 0 then
				local focusMaid = Maid.new()
				guiService:AddSelectionTuple(self.UID, unpack(buttonInstancesArray))
				guiService.SelectedObject = buttonInstancesArray[1]
				IconController.activeButtonBCallbacks += 1
				focusMaid:give(userInputService.InputEnded:Connect(function(input, processed)
					local blockBackBehaviour = false
					for _, func in pairs(self.blockBackBehaviourChecks) do
						if func() == true then
							blockBackBehaviour = true
							break
						end
					end
					if input.KeyCode == Enum.KeyCode.ButtonB and not blockBackBehaviour then
						guiService.SelectedObject = self.instances.iconButton
						self:deselect()
					end
				end))
				focusMaid:give(self.deselected:Connect(function()
					focusMaid:clean()
				end))
				focusMaid:give(function()
					IconController.activeButtonBCallbacks -= 1
					if IconController.activeButtonBCallbacks < 0 then
						IconController.activeButtonBCallbacks = 0
					end
				end)
			end
		end
	end
	self.selected:Fire()
    self.toggled:Fire(self.isSelected)
	return self
end

function Icon:deselect(byIcon)
	--if self.locked then return self end
	self.isSelected = false
	self:_setToggleItemsVisible(false, byIcon)
	self:_updateNotice()
	self:_updateAll()
	self:_playClickSound()
	if #self.dropdownIcons > 0 or #self.menuIcons > 0 then
		IconController:_updateSelectionGroup()
	end
    self.deselected:Fire()
    self.toggled:Fire(self.isSelected)
	if userInputService.GamepadEnabled then
		guiService:RemoveSelectionGroup(self.UID)
	end
	return self
end

function Icon:notify(clearNoticeEvent, noticeId)
	coroutine.wrap(function()
		if not clearNoticeEvent then
			clearNoticeEvent = self.deselected
		end
		if self._parentIcon then
			self._parentIcon:notify(clearNoticeEvent)
		end
		
		local notifComplete = Signal.new()
		local endEvent = self._endNotices:Connect(function()
			notifComplete:Fire()
		end)
		local customEvent = clearNoticeEvent:Connect(function()
			notifComplete:Fire()
		end)
		
		noticeId = noticeId or httpService:GenerateGUID(true)
		self.notices[noticeId] = {
			completeSignal = notifComplete,
			clearNoticeEvent = clearNoticeEvent,
		}
		self.totalNotices += 1
		self:_updateNotice()

		self.notified:Fire(noticeId)
		notifComplete:Wait()
		
		endEvent:Disconnect()
		customEvent:Disconnect()
		notifComplete:Disconnect()
		
		self.totalNotices -= 1
		self.notices[noticeId] = nil
		self:_updateNotice()
	end)()
	return self
end

function Icon:_updateNotice()
	local enabled = true
	if self.totalNotices < 1 then
		enabled = false
	end
	-- Deselect
	if not self.isSelected then
		if (#self.dropdownIcons > 0 or #self.menuIcons > 0) and self.totalNotices > 0 then
			enabled = true
		end
	end
	-- Select
	if self.isSelected then
		if #self.dropdownIcons > 0 or #self.menuIcons > 0 then
			enabled = false
		end
	end
	local value = (enabled and 0) or 1
	self:set("noticeImageTransparency", value)
	self:set("noticeTextTransparency", value)
	self.instances.noticeLabel.Text = (self.totalNotices < 100 and self.totalNotices) or "99+"
end

function Icon:clearNotices()
	self._endNotices:Fire()
	return self
end

function Icon:disableStateOverlay(bool)
	if bool == nil then
		bool = true
	end
	local stateOverlay = self.instances.iconOverlay
	stateOverlay.Visible = not bool
	return self
end



-- TOGGLEABLE METHODS
function Icon:setLabel(text, iconState)
	text = text or ""
	self:set("iconText", text, iconState)
	return self
end

function Icon:setCornerRadius(scale, offset, iconState)
	local oldCornerRadius = self.instances.iconCorner.CornerRadius
	local newCornerRadius = UDim.new(scale or oldCornerRadius.Scale, offset or oldCornerRadius.Offset)
	self:set("iconCornerRadius", newCornerRadius, iconState)
	return self
end

function Icon:setImage(imageId, iconState)
	local textureId = (tonumber(imageId) and "http://www.roblox.com/asset/?id="..imageId) or imageId or ""
	return self:set("iconImage", textureId, iconState)
end

function Icon:setOrder(order, iconState)
	local newOrder = tonumber(order) or 1
	return self:set("order", newOrder, iconState)
end

function Icon:setLeft(iconState)
	return self:set("alignment", "left", iconState)
end

function Icon:setMid(iconState)
	return self:set("alignment", "mid", iconState)
end

function Icon:setRight(iconState)
	if not self.internalIcon then
		IconController.setupHealthbar()
	end
	return self:set("alignment", "right", iconState)
end

function Icon:setImageYScale(YScale, iconState)
	local newYScale = tonumber(YScale) or 0.63
	return self:set("iconImageYScale", newYScale, iconState)
end

function Icon:setImageRatio(ratio, iconState)
	local newRatio = tonumber(ratio) or 1
	return self:set("iconImageRatio", newRatio, iconState)
end

function Icon:setLabelYScale(YScale, iconState)
	local newYScale = tonumber(YScale) or 0.45
	return self:set("iconLabelYScale", newYScale, iconState)
end
	
function Icon:setBaseZIndex(ZIndex, iconState)
	local newBaseZIndex = tonumber(ZIndex) or 1
	return self:set("baseZIndex", newBaseZIndex, iconState)
end

function Icon:_updateBaseZIndex(baseValue)
	local container = self.instances.iconContainer
	local newBaseValue = tonumber(baseValue) or container.ZIndex
	local difference = newBaseValue - container.ZIndex
	if difference == 0 then return "The baseValue is the same" end
	for _, object in pairs(self.instances) do
		if object:IsA("GuiObject") then
			object.ZIndex = object.ZIndex + difference
		end
	end
	return true
end

function Icon:setSize(XOffset, YOffset, iconState)
	if tonumber(XOffset) then
		self.forcefullyAppliedXSize = true
		self:set("forcedIconSizeX", tonumber(XOffset), iconState)
	else
		self.forcefullyAppliedXSize = false
		self:set("forcedIconSizeX", 32, iconState)
	end
	if tonumber(YOffset) then
		self.forcefullyAppliedYSize = true
		self:set("forcedIconSizeY", tonumber(YOffset), iconState)
	else
		self.forcefullyAppliedYSize = false
		self:set("forcedIconSizeY", 32, iconState)
	end
	local newXOffset = tonumber(XOffset) or 32
	local newYOffset = tonumber(YOffset) or (YOffset ~= "_NIL" and newXOffset) or 32
	self:set("iconSize", UDim2.new(0, newXOffset, 0, newYOffset), iconState)
	return self
end

function Icon:setXSize(XOffset, iconState)
	self:setSize(XOffset, "_NIL", iconState)
	return self
end

function Icon:setYSize(YOffset, iconState)
	self:setSize("_NIL", YOffset, iconState)
	return self
end

function Icon:_getContentText(text)
	-- This converts richtext (e.g. "<b>Shop</b>") to normal text (e.g. "Shop")
	-- This also converts richtext/normaltext into its localized (translated) version
	-- This is important when calculating the size of the label/box for instance
	self.instances.fakeIconLabel.Text = text
	local textToTranslate = self.instances.fakeIconLabel.ContentText
	local translatedContentText = typeof(self.instances.iconLabel) == "Instance" and IconController.translator:Translate(self.instances.iconLabel, textToTranslate)
	if typeof(translatedContentText) ~= "string" or translatedContentText == "" then
		translatedContentText = textToTranslate
	end
	self.instances.fakeIconLabel.Text = ""
	return translatedContentText
end

function Icon:_updateIconSize(_, iconState)
	if self._destroyed then return end
	-- This is responsible for handling the appearance and size of the icons label and image, in additon to its own size
	local X_MARGIN = 12
	local X_GAP = 8

	local values = {
		iconImage = self:get("iconImage", iconState) or "_NIL",
		iconText = self:get("iconText", iconState) or "_NIL",
		iconFont = self:get("iconFont", iconState) or "_NIL",
		iconSize = self:get("iconSize", iconState) or "_NIL",
		forcedIconSizeX = self:get("forcedIconSizeX", iconState) or "_NIL",
		iconImageYScale = self:get("iconImageYScale", iconState) or "_NIL",
		iconImageRatio = self:get("iconImageRatio", iconState) or "_NIL",
		iconLabelYScale = self:get("iconLabelYScale", iconState) or "_NIL",
	}
	for k,v in pairs(values) do
		if v == "_NIL" then
			return
		end
	end

	local iconContainer = self.instances.iconContainer
	if not iconContainer.Parent then return end

	-- We calculate the cells dimensions as apposed to reading because there's a possibility the cells dimensions were changed at the exact time and have not yet updated
	-- this essentially saves us from waiting a heartbeat which causes additonal complications
	local cellSizeXOffset = values.iconSize.X.Offset
	local cellSizeXScale = values.iconSize.X.Scale
	local cellWidth = cellSizeXOffset + (cellSizeXScale * iconContainer.Parent.AbsoluteSize.X)
	local minCellWidth = values.forcedIconSizeX--cellWidth
	local maxCellWidth = (cellSizeXScale > 0 and cellWidth) or (self.forcefullyAppliedXSize and minCellWidth) or 9999
	local cellSizeYOffset = values.iconSize.Y.Offset
	local cellSizeYScale = values.iconSize.Y.Scale
	local cellHeight = cellSizeYOffset + (cellSizeYScale * iconContainer.Parent.AbsoluteSize.Y)
	local labelHeight = cellHeight * values.iconLabelYScale
	local iconContentText = self:_getContentText(values.iconText)
	local labelWidth = textService:GetTextSize(iconContentText, labelHeight, values.iconFont, Vector2.new(10000, labelHeight)).X
	local imageWidth = cellHeight * values.iconImageYScale * values.iconImageRatio
	
	local usingImage = values.iconImage ~= ""
	local usingText = values.iconText ~= ""
	local notifPosYScale = 0.5
	local desiredCellWidth
	local preventClippingOffset = labelHeight/2
	
	if usingImage and not usingText then
		desiredCellWidth = 0
		notifPosYScale = 0.45
		self:set("iconImageVisible", true, iconState)
		self:set("iconImageAnchorPoint", Vector2.new(0.5, 0.5), iconState)
		self:set("iconImagePosition", UDim2.new(0.5, 0, 0.5, 0), iconState)
		self:set("iconImageSize", UDim2.new(values.iconImageYScale*values.iconImageRatio, 0, values.iconImageYScale, 0), iconState)
		self:set("iconLabelVisible", false, iconState)

	elseif not usingImage and usingText then
		desiredCellWidth = labelWidth+(X_MARGIN*2)
		self:set("iconLabelVisible", true, iconState)
		self:set("iconLabelAnchorPoint", Vector2.new(0, 0.5), iconState)
		self:set("iconLabelPosition", UDim2.new(0, X_MARGIN, 0.5, 0), iconState)
		self:set("iconLabelSize", UDim2.new(1, -X_MARGIN*2, values.iconLabelYScale, preventClippingOffset), iconState)
		self:set("iconLabelTextXAlignment", Enum.TextXAlignment.Center, iconState)
		self:set("iconImageVisible", false, iconState)

	elseif usingImage and usingText then
		local labelGap = X_MARGIN + imageWidth + X_GAP
		desiredCellWidth = labelGap + labelWidth + X_MARGIN
		self:set("iconImageVisible", true, iconState)
		self:set("iconImageAnchorPoint", Vector2.new(0, 0.5), iconState)
		self:set("iconImagePosition", UDim2.new(0, X_MARGIN, 0.5, 0), iconState)
		self:set("iconImageSize", UDim2.new(0, imageWidth, values.iconImageYScale, 0), iconState)
		----
		self:set("iconLabelVisible", true, iconState)
		self:set("iconLabelAnchorPoint", Vector2.new(0, 0.5), iconState)
		self:set("iconLabelPosition", UDim2.new(0, labelGap, 0.5, 0), iconState)
		self:set("iconLabelSize", UDim2.new(1, -labelGap-X_MARGIN, values.iconLabelYScale, preventClippingOffset), iconState)
		self:set("iconLabelTextXAlignment", Enum.TextXAlignment.Left, iconState)
	end
	if desiredCellWidth then
		if not self._updatingIconSize then
			self._updatingIconSize = true
			local widthScale = (cellSizeXScale > 0 and cellSizeXScale) or 0
			local widthOffset = (cellSizeXScale > 0 and 0) or math.clamp(desiredCellWidth, minCellWidth, maxCellWidth)
			self:set("iconSize", UDim2.new(widthScale, widthOffset, values.iconSize.Y.Scale, values.iconSize.Y.Offset), iconState, "_ignorePrevious")

			-- This ensures that if an icon is within a dropdown or menu, its container adapts accordingly with this new iconSize value
			local parentIcon = self._parentIcon
			if parentIcon then
				local originalIconSize = UDim2.new(0, desiredCellWidth, 0, values.iconSize.Y.Offset)
				if #parentIcon.dropdownIcons > 0 then
					self:setAdditionalValue("iconSize", "beforeDropdown", originalIconSize, iconState)
					parentIcon:_updateDropdown()
				end
				if #parentIcon.menuIcons > 0 then
					self:setAdditionalValue("iconSize", "beforeMenu", originalIconSize, iconState)
					parentIcon:_updateMenu()
				end
			end

			self._updatingIconSize = false
		end
	end
	self:set("iconLabelTextSize", labelHeight, iconState)
	self:set("noticeFramePosition", UDim2.new(notifPosYScale, 0, 0, -2), iconState)

	self._updatingIconSize = false
end



-- FEATURE METHODS
function Icon:bindEvent(iconEventName, eventFunction)
	local event = self[iconEventName]
	assert(event and typeof(event) == "table" and event.Connect, "argument[1] must be a valid topbarplus icon event name!")
	assert(typeof(eventFunction) == "function", "argument[2] must be a function!")
	self._bindedEvents[iconEventName] = event:Connect(function(...)
		eventFunction(self, ...)
	end)
	return self
end

function Icon:unbindEvent(iconEventName)
	local eventConnection = self._bindedEvents[iconEventName]
	if eventConnection then
		eventConnection:Disconnect()
		self._bindedEvents[iconEventName] = nil
	end
	return self
end

function Icon:bindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self._bindedToggleKeys[keyCodeEnum] = true
	return self
end

function Icon:unbindToggleKey(keyCodeEnum)
	assert(typeof(keyCodeEnum) == "EnumItem", "argument[1] must be a KeyCode EnumItem!")
	self._bindedToggleKeys[keyCodeEnum] = nil
	return self
end

function Icon:lock()
	self.instances.iconButton.Active = false
	self.locked = true
	task.defer(function()
		-- We do this to prevent the overlay remaining enabled if :lock is called right after an icon is selected
		if self.locked then
			self.overlayLocked = true
		end
	end)
	return self
end

function Icon:unlock()
	self.instances.iconButton.Active = true
	self.locked = false
	self.overlayLocked = false
	return self
end

function Icon:debounce(seconds)
	self:lock()
	task.wait(seconds)
	self:unlock()
	return self
end

function Icon:autoDeselect(bool)
	if bool == nil then
		bool = true
	end
	self.deselectWhenOtherIconSelected = bool
	return self
end

function Icon:setTopPadding(offset, scale)
	local newOffset = offset or 4
	local newScale = scale or 0
	self.topPadding = UDim.new(newScale, newOffset)
	self.updated:Fire()
	return self
end

function Icon:bindToggleItem(guiObjectOrLayerCollector)
	if not guiObjectOrLayerCollector:IsA("GuiObject") and not guiObjectOrLayerCollector:IsA("LayerCollector") then
		error("Toggle item must be a GuiObject or LayerCollector!")
	end
	self.toggleItems[guiObjectOrLayerCollector] = true
	self:updateSelectionInstances()
	return self
end

function Icon:updateSelectionInstances()
	-- This is to assist with controller navigation and selection
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

function Icon:addBackBlocker(func)
	-- This is custom behaviour that can block the default behaviour of going back or closing a page when Controller B is pressed
	-- If the function returns ``true`` then the B Back behaviour is blocked
	-- This is useful for instance when a user is purchasing an item and you don't want them to return to the previous page
	-- if they pressed B during this pending period
	table.insert(self.blockBackBehaviourChecks, func)
	return self
end

function Icon:unbindToggleItem(guiObjectOrLayerCollector)
	self.toggleItems[guiObjectOrLayerCollector] = nil
	return self
end

function Icon:_setToggleItemsVisible(bool, byIcon)
	for toggleItem, _ in pairs(self.toggleItems) do
		if not byIcon or byIcon.toggleItems[toggleItem] == nil then
			local property = "Visible"
			if toggleItem:IsA("LayerCollector") then
				property = "Enabled"
			end
			toggleItem[property] = bool
		end
	end
end

function Icon:call(func)
	task.spawn(func, self)
	return self
end

function Icon:give(userdata)
	local valueToGive = userdata
	if typeof(userdata) == "function" then
		local returnValue = userdata(self)
		if typeof(userdata) ~= "function" then
			valueToGive = returnValue
		else
			valueToGive = nil
		end
	end
	if valueToGive ~= nil then
		self._maid:give(valueToGive)
	end
	return self
end

-- Tips
DEFAULT_FORCED_GROUP_VALUES["tip"] = 1

function Icon:setTip(text)
	assert(typeof(text) == "string" or text == nil, "Expected string, got "..typeof(text))
	local realText = text or ""
	local isVisible = realText ~= ""
	self.tipText = text
	self.instances.tipLabel.Text = realText
	self.instances.tipFrame.Parent = (isVisible and activeItems) or self.instances.iconContainer
	self._maid.tipFrame = self.instances.tipFrame
	self:_updateTipSize()
	
	local tipMaid = Maid.new()
	self._maid.tipMaid = tipMaid
	if isVisible then
		tipMaid:give(self.hoverStarted:Connect(function()
			if not self.isSelected then
				self:displayTip(true)
			end
		end))
		tipMaid:give(self.hoverEnded:Connect(function()
			self:displayTip(false)
		end))
		tipMaid:give(self.selected:Connect(function()
			if self.hovering then
				self:displayTip(false)
			end
		end))
	end
	self:displayTip(self.hovering and isVisible)
	return self
end

function Icon:_updateTipSize()
	local realText = self.tipText or ""
	local isVisible = realText ~= ""
	local iconContentText = self:_getContentText(realText)
	local textSize = textService:GetTextSize(iconContentText, 12, Enum.Font.GothamSemibold, Vector2.new(1000, 20-6))
	self.instances.tipFrame.Size = (isVisible and UDim2.new(0, textSize.X+6, 0, 20)) or UDim2.new(0, 0, 0, 0)
end

function Icon:displayTip(bool)
	if userInputService.TouchEnabled and not self._draggingFinger then return end

	-- Determine caption visibility
	local isVisible = self.tipVisible or false
	if typeof(bool) == "boolean" then
		isVisible = bool
	end
	self.tipVisible = isVisible

	-- Have tip position track mouse or finger
	local tipFrame = self.instances.tipFrame
	if isVisible then
		-- When the user moves their cursor/finger, update tip to match the position
		local function updateTipPositon(x, y)
			local newX = x
			local newY = y
			local camera = workspace.CurrentCamera
			local viewportSize = camera and camera.ViewportSize
			if userInputService.TouchEnabled then
				--tipFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				local desiredX = newX - tipFrame.Size.X.Offset/2
				local minX = 0
				local maxX = viewportSize.X - tipFrame.Size.X.Offset
				local desiredY = newY + THUMB_OFFSET + 60
				local minY = tipFrame.AbsoluteSize.Y + THUMB_OFFSET + 64 + 3
				local maxY = viewportSize.Y - tipFrame.Size.Y.Offset
				newX = math.clamp(desiredX, minX, maxX)
				newY = math.clamp(desiredY, minY, maxY)
			elseif IconController.controllerModeEnabled then
				local indicator = TopbarPlusGui.Indicator
				local newPos = indicator.AbsolutePosition
				newX = newPos.X - tipFrame.Size.X.Offset/2 + indicator.AbsoluteSize.X/2
				newY = newPos.Y + 90
			else
				local desiredX = newX
				local minX = 0
				local maxX = viewportSize.X - tipFrame.Size.X.Offset - 48
				local desiredY = newY
				local minY = tipFrame.Size.Y.Offset+3
				local maxY = viewportSize.Y
				newX = math.clamp(desiredX, minX, maxX)
				newY = math.clamp(desiredY, minY, maxY)
			end
			--local difX = tipFrame.AbsolutePosition.X - tipFrame.Position.X.Offset
			--local difY = tipFrame.AbsolutePosition.Y - tipFrame.Position.Y.Offset
			--local globalX = newX - difX
			--local globalY = newY - difY
			--tipFrame.Position = UDim2.new(0, globalX, 0, globalY-55)
			tipFrame.Position = UDim2.new(0, newX, 0, newY-20)
		end
		local cursorLocation = userInputService:GetMouseLocation()
		if cursorLocation then
			updateTipPositon(cursorLocation.X, cursorLocation.Y)
		end
		self._hoveringMaid:give(self.instances.iconButton.MouseMoved:Connect(updateTipPositon))
	end

	-- Change transparency of relavent tip instances
	for _, settingName in pairs(self._groupSettings.tip) do
		local settingDetail = self._settingsDictionary[settingName]
		settingDetail.useForcedGroupValue = not isVisible
		self:_update(settingName)
	end
end

-- Captions
DEFAULT_FORCED_GROUP_VALUES["caption"] = 1

function Icon:setCaption(text)
	assert(typeof(text) == "string" or text == nil, "Expected string, got "..typeof(text))
	local realText = text or ""
	local isVisible = realText ~= ""
	self.captionText = text
	self.instances.captionLabel.Text = realText
	self.instances.captionContainer.Parent = (isVisible and activeItems) or self.instances.iconContainer
	self._maid.captionContainer = self.instances.captionContainer
	self:_updateIconSize(nil, self:getIconState())
	local captionMaid = Maid.new()
	self._maid.captionMaid = captionMaid
	if isVisible then
		captionMaid:give(self.hoverStarted:Connect(function()
			if not self.isSelected then
				self:displayCaption(true)
			end
		end))
		captionMaid:give(self.hoverEnded:Connect(function()
			self:displayCaption(false)
		end))
		captionMaid:give(self.selected:Connect(function()
			if self.hovering then
				self:displayCaption(false)
			end
		end))
		local iconContainer = self.instances.iconContainer
		captionMaid:give(iconContainer:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			if self.hovering then
				self:displayCaption()
			end
		end))
		captionMaid:give(iconContainer:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
			if self.hovering then
				self:displayCaption()
			end
		end))
	end
	self:_updateCaptionSize()
	self:displayCaption(self.hovering and isVisible)
	return self
end

function Icon:_updateCaptionSize()
	-- This adapts the caption size
	local CAPTION_X_MARGIN = 6
	local CAPTION_CONTAINER_Y_SIZE_SCALE = 0.8
	local CAPTION_LABEL_Y_SCALE = 0.58
	local iconSize = self:get("iconSize")
	local labelFont = self:get("captionFont")
	if iconSize and labelFont then
		local cellSizeYOffset = iconSize.Y.Offset
		local cellSizeYScale = iconSize.Y.Scale
		local iconContainer = self.instances.iconContainer
		local captionContainer = self.instances.captionContainer
		local realText = self.captionText or ""
		local isVisible = realText ~= ""
		if isVisible then
			local cellHeight = cellSizeYOffset + (cellSizeYScale * iconContainer.Parent.AbsoluteSize.Y)
			local captionLabel = self.instances.captionLabel
			local captionContainerHeight = cellHeight * CAPTION_CONTAINER_Y_SIZE_SCALE
			local captionLabelHeight = captionContainerHeight * CAPTION_LABEL_Y_SCALE
			local iconContentText = self:_getContentText(self.captionText)
			local textWidth = textService:GetTextSize(iconContentText, captionLabelHeight, labelFont, Vector2.new(10000, captionLabelHeight)).X
			captionLabel.TextSize = captionLabelHeight
			captionLabel.Size = UDim2.new(0, textWidth, CAPTION_LABEL_Y_SCALE, 0)
			captionContainer.Size = UDim2.new(0, textWidth + CAPTION_X_MARGIN*2, 0, cellHeight*CAPTION_CONTAINER_Y_SIZE_SCALE)
		else
			captionContainer.Size = UDim2.new(0, 0, 0, 0)
		end
	end
end

function Icon:displayCaption(bool)
	if userInputService.TouchEnabled and not self._draggingFinger then return end
	local yOffset = 8
	
	-- Determine caption position
	if self._draggingFinger then
		yOffset = yOffset + THUMB_OFFSET
	end
	local iconContainer = self.instances.iconContainer
	local captionContainer = self.instances.captionContainer
	local newPos = UDim2.new(0, iconContainer.AbsolutePosition.X+iconContainer.AbsoluteSize.X/2-captionContainer.AbsoluteSize.X/2, 0, iconContainer.AbsolutePosition.Y+(iconContainer.AbsoluteSize.Y*2)+yOffset)
	captionContainer.Position = newPos

	-- Determine caption visibility
	local isVisible = self.captionVisible or false
	if typeof(bool) == "boolean" then
		isVisible = bool
	end
	self.captionVisible = isVisible

	-- Change transparency of relavent caption instances
	local captionFadeInfo = self:get("captionFadeInfo")
	for _, settingName in pairs(self._groupSettings.caption) do
		local settingDetail = self._settingsDictionary[settingName]
		settingDetail.useForcedGroupValue = not isVisible
		self:_update(settingName)
	end
end

-- Join or leave a special feature such as a Dropdown or Menu
function Icon:join(parentIcon, featureName, dontUpdate)
	if self._parentIcon then
		self:leave()
	end
	local newFeatureName = (featureName and featureName:lower()) or "dropdown"
	local beforeName = "before"..featureName:sub(1,1):upper()..featureName:sub(2)
	local parentFrame = parentIcon.instances[featureName.."Frame"]
	self.presentOnTopbar = false
	self.joinedFeatureName = featureName
	self._parentIcon = parentIcon
	self.instances.iconContainer.Parent = parentFrame
	for noticeId, noticeDetail in pairs(self.notices) do
		parentIcon:notify(noticeDetail.clearNoticeEvent, noticeId)
		--parentIcon:notify(noticeDetail.completeSignal, noticeId)
	end
	
	if featureName == "dropdown" then
		local squareCorners = parentIcon:get("dropdownSquareCorners")
		self:set("iconSize", UDim2.new(1, 0, 0, self:get("iconSize", "deselected").Y.Offset), "deselected", beforeName)
		self:set("iconSize", UDim2.new(1, 0, 0, self:get("iconSize", "selected").Y.Offset), "selected", beforeName)
		if squareCorners then
			self:set("iconCornerRadius", UDim.new(0, 0), "deselected", beforeName)
			self:set("iconCornerRadius", UDim.new(0, 0), "selected", beforeName)
		end
		self:set("captionBlockerTransparency", 0.4, nil, beforeName)
	end
	local array = parentIcon[newFeatureName.."Icons"]
	table.insert(array, self)
	if not dontUpdate then
		if featureName == "dropdown" then
			parentIcon:_updateDropdown()
		elseif featureName == "menu" then
			parentIcon:_updateMenu()
		end
	end
	parentIcon.deselectWhenOtherIconSelected = false
	--
	IconController:_updateSelectionGroup()
	self:_decideToCallSignal("dropdown")
	self:_decideToCallSignal("menu")
	--
	return self
end

function Icon:leave()
	if self._destroyed or self.instances.iconContainer.Parent == nil then
		return
	end
	local settingsToReset = {"iconSize", "captionBlockerTransparency", "iconCornerRadius"}
	local parentIcon = self._parentIcon
	self.instances.iconContainer.Parent = topbarContainer
	self.presentOnTopbar = true
	self.joinedFeatureName = nil
	local function scanFeature(t, prevReference, updateMethod)
		for i, otherIcon in pairs(t) do
			if otherIcon == self then
				for _, settingName in pairs(settingsToReset) do
					local states = {"deselected", "selected"}
					for _, toggleState in pairs(states) do
						local currentSetting, previousSetting = self:get(settingName, toggleState, prevReference)
						if previousSetting then
							self:set(settingName, previousSetting, toggleState)
						end
					end
				end
				table.remove(t, i)
				updateMethod(parentIcon)
				if #t == 0 then
					self._parentIcon.deselectWhenOtherIconSelected = true
				end
				break
			end
		end
	end
	scanFeature(parentIcon.dropdownIcons, "beforeDropdown", parentIcon._updateDropdown)
	scanFeature(parentIcon.menuIcons, "beforeMenu", parentIcon._updateMenu)
	--
	for noticeId, noticeDetail in pairs(self.notices) do
		local parentIconNoticeDetail = parentIcon.notices[noticeId]
		if parentIconNoticeDetail then
			parentIconNoticeDetail.completeSignal:Fire()
		end
	end
	--
	self._parentIcon = nil
	--
	IconController:_updateSelectionGroup()
	self:_decideToCallSignal("dropdown")
	self:_decideToCallSignal("menu")
	--
	return self
end

function Icon:_decideToCallSignal(featureName)
	local isOpen = self[featureName.."Open"]
	local previousIsOpenName = "_previous"..string.sub(featureName, 1, 1):upper()..featureName:sub(2).."Open"
	local previousIsOpen = self[previousIsOpenName]
	local totalIcons = #self[featureName.."Icons"]
	if isOpen and totalIcons > 0 and previousIsOpen == false then
		self[previousIsOpenName] = true
		self[featureName.."Opened"]:Fire()
	elseif (not isOpen or totalIcons == 0) and previousIsOpen == true then
		self[previousIsOpenName] = false
		self[featureName.."Closed"]:Fire()
	end
end

function Icon:_ignoreClipping(featureName)
	local ignoreClipping = self:get(featureName.."IgnoreClipping")
	if self._parentIcon then
		local maid = self["_"..featureName.."ClippingMaid"]
		local frame = self.instances[featureName.."Container"]
		maid:clean()
		if ignoreClipping then
			local fakeFrame = Instance.new("Frame")
			fakeFrame.Name = frame.Name.."FakeFrame"
			fakeFrame.ClipsDescendants = true
			fakeFrame.BackgroundTransparency = 1
			fakeFrame.Size = frame.Size
			fakeFrame.Position = frame.Position
			fakeFrame.Parent = activeItems
			--
			for a,b in pairs(frame:GetChildren()) do
				b.Parent = fakeFrame
			end
			--
			local function updateSize()
				local absoluteSize = frame.AbsoluteSize
				fakeFrame.Size = UDim2.new(0, absoluteSize.X, 0, absoluteSize.Y)
			end
			maid:give(frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				updateSize()
			end))
			updateSize()
			local function updatePos()
				local absolutePosition = frame.absolutePosition
				fakeFrame.Position = UDim2.new(0, absolutePosition.X, 0, absolutePosition.Y+36)
			end
			maid:give(frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				updatePos()
			end))
			updatePos()
			maid:give(function()
				for a,b in pairs(fakeFrame:GetChildren()) do
					b.Parent = frame
				end
				fakeFrame.Name = "Destroying..."
				fakeFrame:Destroy()
			end)
		end
	end
	self._ignoreClippingChanged:Fire(featureName, ignoreClipping)
end

-- Dropdowns
function Icon:setDropdown(arrayOfIcons)
	-- Reset any previous icons
	for i, otherIcon in pairs(self.dropdownIcons) do
		otherIcon:leave()
	end
	-- Apply new icons
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:join(self, "dropdown", true)
		end
	end
	-- Update dropdown
	self:_updateDropdown()
	return self
end

function Icon:_updateDropdown()
	local values = {
		maxIconsBeforeScroll = self:get("dropdownMaxIconsBeforeScroll") or "_NIL",
		minWidth = self:get("dropdownMinWidth") or "_NIL",
		padding = self:get("dropdownListPadding") or "_NIL",
		dropdownAlignment = self:get("dropdownAlignment") or "_NIL",
		iconAlignment = self:get("alignment") or "_NIL",
		scrollBarThickness = self:get("dropdownScrollBarThickness") or "_NIL",
	}
	for k, v in pairs(values) do if v == "_NIL" then return end end
	
	local YPadding = values.padding.Offset
	local dropdownContainer = self.instances.dropdownContainer
	local dropdownFrame = self.instances.dropdownFrame
	local dropdownList = self.instances.dropdownList
	local totalIcons = #self.dropdownIcons

	local lastVisibleIconIndex = (totalIcons > values.maxIconsBeforeScroll and values.maxIconsBeforeScroll) or totalIcons
	local newCanvasSizeY = -YPadding
	local newFrameSizeY = 0
	local newMinWidth = values.minWidth
	table.sort(self.dropdownIcons, function(a,b) return a:get("order") < b:get("order") end)
	for i = 1, totalIcons do
		local otherIcon = self.dropdownIcons[i]
		local _, otherIconSize = otherIcon:get("iconSize", nil, "beforeDropdown")
		local increment = otherIconSize.Y.Offset + YPadding
		if i <= lastVisibleIconIndex then
			newFrameSizeY = newFrameSizeY + increment
		end
		if i == totalIcons then
			newFrameSizeY = newFrameSizeY + increment/4
		end
		newCanvasSizeY = newCanvasSizeY + increment
		local otherIconWidth = otherIconSize.X.Offset --+ 4 + 100 -- the +100 is to allow for notices
		if otherIconWidth > newMinWidth then
			newMinWidth = otherIconWidth
		end
		-- This ensures the dropdown is navigated fully and correctly with a controller
		local prevIcon = (i == 1 and self) or self.dropdownIcons[i-1]
		local nextIcon = self.dropdownIcons[i+1]
		otherIcon.instances.iconButton.NextSelectionUp = prevIcon and prevIcon.instances.iconButton
		otherIcon.instances.iconButton.NextSelectionDown = nextIcon and nextIcon.instances.iconButton
	end

	local finalCanvasSizeY = (lastVisibleIconIndex == totalIcons and 0) or newCanvasSizeY
	self:set("dropdownCanvasSize", UDim2.new(0, 0, 0, finalCanvasSizeY))
	self:set("dropdownSize", UDim2.new(0, (newMinWidth+4)*2, 0, newFrameSizeY))

	-- Set alignment while considering screen bounds
	local dropdownAlignment = values.dropdownAlignment:lower()
	local alignmentDetails = {
		left = {
			AnchorPoint = Vector2.new(0, 0),
			PositionXScale = 0,
			ThicknessMultiplier = 0,
		},
		mid = {
			AnchorPoint = Vector2.new(0.5, 0),
			PositionXScale = 0.5,
			ThicknessMultiplier = 0.5,
		},
		right = {
			AnchorPoint = Vector2.new(0.5, 0),
			PositionXScale = 1,
			FrameAnchorPoint = Vector2.new(0, 0),
			FramePositionXScale = 0,
			ThicknessMultiplier = 1,
		}
	}
	local alignmentDetail = alignmentDetails[dropdownAlignment]
	if not alignmentDetail then
		alignmentDetail = alignmentDetails[values.iconAlignment:lower()]
	end
	dropdownContainer.AnchorPoint = alignmentDetail.AnchorPoint
	dropdownContainer.Position = UDim2.new(alignmentDetail.PositionXScale, 0, 1, YPadding+0)
	local scrollbarThickness = values.scrollBarThickness
	local newThickness = scrollbarThickness * alignmentDetail.ThicknessMultiplier
	local additionalOffset = (dropdownFrame.VerticalScrollBarPosition == Enum.VerticalScrollBarPosition.Right and newThickness) or -newThickness
	dropdownFrame.AnchorPoint = alignmentDetail.FrameAnchorPoint or alignmentDetail.AnchorPoint
	dropdownFrame.Position = UDim2.new(alignmentDetail.FramePositionXScale or alignmentDetail.PositionXScale, additionalOffset, 0, 0)
	self._dropdownCanvasPos = Vector2.new(0, 0)
end

function Icon:_dropdownIgnoreClipping()
	self:_ignoreClipping("dropdown")
end


-- Menus
function Icon:setMenu(arrayOfIcons)
	-- Reset any previous icons
	for i, otherIcon in pairs(self.menuIcons) do
		otherIcon:leave()
	end
	-- Apply new icons
	if type(arrayOfIcons) == "table" then
		for i, otherIcon in pairs(arrayOfIcons) do
			otherIcon:join(self, "menu", true)
		end
	end
	-- Update menu
	self:_updateMenu()
	return self
end

function Icon:_getMenuDirection()
	local direction = (self:get("menuDirection") or "_NIL"):lower()
	local alignment = (self:get("alignment") or "_NIL"):lower()
	if direction ~= "left" and direction ~= "right" then
		direction = (alignment == "left" and "right") or "left" 
	end
	return direction
end

function Icon:_updateMenu()
	local values = {
		maxIconsBeforeScroll = self:get("menuMaxIconsBeforeScroll") or "_NIL",
		direction = self:get("menuDirection") or "_NIL",
		iconAlignment = self:get("alignment") or "_NIL",
		scrollBarThickness = self:get("menuScrollBarThickness") or "_NIL",
	}
	for k, v in pairs(values) do if v == "_NIL" then return end end
	
	local XPadding = IconController[values.iconAlignment.."Gap"]--12
	local menuContainer = self.instances.menuContainer
	local menuFrame = self.instances.menuFrame
	local menuList = self.instances.menuList
	local totalIcons = #self.menuIcons

	local direction = self:_getMenuDirection()
	local lastVisibleIconIndex = (totalIcons > values.maxIconsBeforeScroll and values.maxIconsBeforeScroll) or totalIcons
	local newCanvasSizeX = -XPadding
	local newFrameSizeX = 0
	local newMinHeight = 0
	local sortFunc = (direction == "right" and function(a,b) return a:get("order") < b:get("order") end) or function(a,b) return a:get("order") > b:get("order") end
	table.sort(self.menuIcons, sortFunc)
	for i = 1, totalIcons do
		local otherIcon = self.menuIcons[i]
		local otherIconSize = otherIcon:get("iconSize")
		local increment = otherIconSize.X.Offset + XPadding
		if i <= lastVisibleIconIndex then
			newFrameSizeX = newFrameSizeX + increment
		end
		if i == lastVisibleIconIndex and i ~= totalIcons then
			newFrameSizeX = newFrameSizeX -2--(increment/4)
		end
		newCanvasSizeX = newCanvasSizeX + increment
		local otherIconHeight = otherIconSize.Y.Offset
		if otherIconHeight > newMinHeight then
			newMinHeight = otherIconHeight
		end
		-- This ensures the menu is navigated fully and correctly with a controller
		local prevIcon = self.menuIcons[i-1]
		local nextIcon = self.menuIcons[i+1]
		otherIcon.instances.iconButton.NextSelectionRight = prevIcon and prevIcon.instances.iconButton
		otherIcon.instances.iconButton.NextSelectionLeft = nextIcon and nextIcon.instances.iconButton
	end

	local canvasSize = (lastVisibleIconIndex == totalIcons and 0) or newCanvasSizeX + XPadding
	self:set("menuCanvasSize", UDim2.new(0, canvasSize, 0, 0))
	self:set("menuSize", UDim2.new(0, newFrameSizeX, 0, newMinHeight + values.scrollBarThickness + 3))

	-- Set direction
	local directionDetails = {
		left = {
			containerAnchorPoint = Vector2.new(1, 0),
			containerPosition = UDim2.new(0, -4, 0, 0),
			canvasPosition = Vector2.new(canvasSize, 0)
		},
		right = {
			containerAnchorPoint = Vector2.new(0, 0),
			containerPosition = UDim2.new(1, XPadding-2, 0, 0),
			canvasPosition = Vector2.new(0, 0),
		}
	}
	local directionDetail = directionDetails[direction]
	menuContainer.AnchorPoint = directionDetail.containerAnchorPoint
	menuContainer.Position = directionDetail.containerPosition
	menuFrame.CanvasPosition = directionDetail.canvasPosition
	self._menuCanvasPos = directionDetail.canvasPosition

	menuList.Padding = UDim.new(0, XPadding)
end

function Icon:_menuIgnoreClipping()
	self:_ignoreClipping("menu")
end



-- DESTROY/CLEANUP METHOD
function Icon:destroy()
	if self._destroyed then return end
	IconController.iconRemoved:Fire(self)
	self:clearNotices()
	if self._parentIcon then
		self:leave()
	end
	self:setDropdown()
	self:setMenu()
	self._destroyed = true
	self._maid:clean()
end
Icon.Destroy = Icon.destroy



return Icon