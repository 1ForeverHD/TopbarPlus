-- As the name suggests, this handles everything related to gamepads
-- (i.e. Xbox or Playstation controllers) and their navigation
-- I created a separate module for gamepads (and not touchpads or
-- keyboards) because gamepads are greatly more unqiue and require
-- additional tailored programming



-- SERVICES
local GamepadService = game:GetService("GamepadService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")



-- LOCAL
local Gamepad = {}
local Icon



-- FUNCTIONS
-- This is called upon the Icon initializing
function Gamepad.start(incomingIcon)
	
	-- Public variables
	Icon = incomingIcon
	Icon.highlightKey = Enum.KeyCode.DPadUp -- What controller key to highlight the topbar (or set to false to disable)
	Icon.highlightIcon = false -- Change to a specific icon if you'd like to highlight a specific icon instead of the left-most
	
	-- We defer so the developer can make changes before the
	-- gamepad controls are initialized
	task.delay(1, function()
		-- Some local utility
		local iconsDict = Icon.iconsDictionary
		local function getIconFromSelectedObject()
			local clickRegion = GuiService.SelectedObject
			local iconUID = clickRegion and clickRegion:GetAttribute("CorrespondingIconUID")
			local icon = iconUID and iconsDict[iconUID]
			return icon
		end
		
		-- This enables users to instantly open up their last selected icon
		local previousHighlightedIcon
		local iconDisplayingHighlightKey
		local usedIndicatorOnce = false
		local usedBOnce = false
		local Utility = require(script.Parent.Parent.Utility)
		local Selection = require(script.Parent.Parent.Elements.Selection)
		local function updateSelectedObject()
			local icon = getIconFromSelectedObject()
			local gamepadEnabled = UserInputService.GamepadEnabled
			if icon then
				if gamepadEnabled then
					local clickRegion = icon:getInstance("ClickRegion")
					local selection = icon.selection
					if not selection then
						selection = icon.janitor:add(Selection(Icon))
						selection:SetAttribute("IgnoreVisibilityUpdater", true)
						selection.Parent = icon.widget
						icon.selection = selection
						icon:refreshAppearance(selection) --icon:clipOutside(selection)
					end
					clickRegion.SelectionImageObject = selection.Selection
				end
				if previousHighlightedIcon and previousHighlightedIcon ~= icon then
					previousHighlightedIcon:setIndicator()
				end
				local newIndicator = if gamepadEnabled and not usedBOnce and not icon.parentIconUID then Enum.KeyCode.ButtonB else nil
				previousHighlightedIcon = icon
				Icon.lastHighlightedIcon = icon
				icon:setIndicator(newIndicator)
			else
				local newIndicator = if gamepadEnabled and not usedIndicatorOnce then Icon.highlightKey else nil
				if not previousHighlightedIcon then
					previousHighlightedIcon = Gamepad.getIconToHighlight()
				end
				if newIndicator == Icon.highlightKey then
					-- We only display the highlightKey once to show
					-- the user how to highlight the topbar icon
					usedIndicatorOnce = true
				else
					--usedBOnce = true
				end
				if previousHighlightedIcon then
					previousHighlightedIcon:setIndicator(newIndicator)
				end
			end
		end
		GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(updateSelectedObject)

		-- This listens for a gamepad being present/added/removed
		local function checkGamepadEnabled()
			local gamepadEnabled = UserInputService.GamepadEnabled
			if not gamepadEnabled then
				usedIndicatorOnce = false
				usedBOnce = false
			end
			updateSelectedObject()
		end
		UserInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(checkGamepadEnabled)
		checkGamepadEnabled()

		-- This allows for easy highlighting of the topbar when the
		-- when ``Icon.highlightKey`` (i.e. DPadUp) is pressed.
		-- If you'd like to disable, do ``Icon.highlightKey = false``
		UserInputService.InputBegan:Connect(function(input, touchingAnObject)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				-- Sometimes the Roblox gamepad glitches when combined with a cursor
				-- This fixes that by unhighlighting if the cursor is pressed down
				-- (i.e. a mouse click)
				local icon = getIconFromSelectedObject()
				if icon then
					GuiService.SelectedObject = nil
				end
				return
			end
			if input.KeyCode ~= Icon.highlightKey then
				return
			end
			local iconToHighlight = Gamepad.getIconToHighlight()
			if iconToHighlight then
				if GamepadService.GamepadCursorEnabled then
					task.wait(0.2)
					GamepadService:DisableGamepadCursor()
				end
				local clickRegion = iconToHighlight:getInstance("ClickRegion")
				GuiService.SelectedObject = clickRegion
			end
		end)
	end)
end

function Gamepad.getIconToHighlight()
	-- If an icon has already been selected, returns the last selected icon
	-- Else if more than 0 icons, it selects the left-most icon
	local iconsDict = Icon.iconsDictionary
	local iconToHighlight = Icon.highlightIcon or Icon.lastHighlightedIcon
	if not iconToHighlight then
		local currentX
		for _, icon in pairs(iconsDict) do
			if icon.parentIconUID then
				continue
			end
			local thisX = icon.widget.AbsolutePosition.X
			if not currentX or thisX < currentX then
				iconToHighlight = icon
				currentX = iconToHighlight.widget.AbsolutePosition.X
			end
		end
	end
	return iconToHighlight
end

-- This called when the icon's ClickRegion is created
function Gamepad.registerButton(buttonInstance)
	-- This provides a basic level of support for controllers by making
	-- the icons easy to highlight via the virtual cursor, then
	-- when selected, focuses in on the selected icon and hops
	-- between other nearby icons simply by toggling the joystick
	local inputBegan = false
	buttonInstance.InputBegan:Connect(function(input)
		-- Two wait frames required to ensure inputBegan is detected within
		-- UserInputService.InputBegan. We do this because object.InputBegan
		-- does not return the correct input objects (unlike the service)
		inputBegan = true
		task.wait()
		task.wait()
		inputBegan = false
	end)
	local connection = UserInputService.InputBegan:Connect(function(input)
		task.wait()
		if input.KeyCode == Enum.KeyCode.ButtonA and inputBegan then
			-- We focus on an icon when selected via the virtual cursor
			task.wait(0.2)
			GamepadService:DisableGamepadCursor()
			GuiService.SelectedObject = buttonInstance
			return
		end
		local isSelected = GuiService.SelectedObject == buttonInstance
		local unselectKeyCodes = {"ButtonB", "ButtonSelect"}
		local keyName = input.KeyCode.Name
		if table.find(unselectKeyCodes, keyName) and isSelected then
			-- We unfocus when back button is pressed, but ignore
			-- if the virtual cursor is disabled otherwise it will be
			-- impossible to select the topbar
			if not(keyName == "ButtonSelect" and not GamepadService.GamepadCursorEnabled) then
				GuiService.SelectedObject = nil
			end
		end
	end)
	buttonInstance.Destroying:Once(function()
		connection:Disconnect()
	end)
end



return Gamepad