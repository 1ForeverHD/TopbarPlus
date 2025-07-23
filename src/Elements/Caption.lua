local CAPTION_COLOR = Color3.fromRGB(39, 41, 48)
local TEXT_SIZE = 15
return function(icon)

	-- Credit to lolmansReturn and Canary Software for
	-- retrieving these values
	local clickRegion = icon:getInstance("ClickRegion")
	local caption = Instance.new("CanvasGroup")
	caption.Name = "Caption"
	caption.AnchorPoint = Vector2.new(0.5, 0)
	caption.BackgroundTransparency = 1
	caption.BorderSizePixel = 0
	caption.GroupTransparency = 1
	caption.Position = UDim2.fromOffset(0, 0)
	caption.Visible = true
	caption.ZIndex = 30
	caption.Parent = clickRegion

	local box = Instance.new("Frame")
	box.Name = "Box"
	box.AutomaticSize = Enum.AutomaticSize.XY
	box.BackgroundColor3 = CAPTION_COLOR
	box.Position = UDim2.fromOffset(4, 7)
	box.ZIndex = 12
	box.Parent = caption

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.FontFace = Font.new(
		"rbxasset://fonts/families/BuilderSans.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	header.Text = "Caption"
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.TextSize = TEXT_SIZE
	header.TextTruncate = Enum.TextTruncate.None
	header.TextWrapped = false
	header.TextXAlignment = Enum.TextXAlignment.Left
	header.AutomaticSize = Enum.AutomaticSize.X
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Size = UDim2.fromOffset(0, 16)
	header.ZIndex = 18
	header.Parent = box

	local layout = Instance.new("UIListLayout")
	layout.Name = "Layout"
	layout.Padding = UDim.new(0, 8)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = box

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "CaptionCorner"
	UICorner.Parent = box

	local padding = Instance.new("UIPadding")
	padding.Name = "Padding"
	padding.PaddingBottom = UDim.new(0, 12)
	padding.PaddingLeft = UDim.new(0, 12)
	padding.PaddingRight = UDim.new(0, 12)
	padding.PaddingTop = UDim.new(0, 12)
	padding.Parent = box

	local hotkeys = Instance.new("Frame")
	hotkeys.Name = "Hotkeys"
	hotkeys.AutomaticSize = Enum.AutomaticSize.Y
	hotkeys.BackgroundTransparency = 1
	hotkeys.LayoutOrder = 3
	hotkeys.Size = UDim2.fromScale(1, 0)
	hotkeys.Visible = false
	hotkeys.Parent = box

	local layout1 = Instance.new("UIListLayout")
	layout1.Name = "Layout1"
	layout1.Padding = UDim.new(0, 6)
	layout1.FillDirection = Enum.FillDirection.Vertical
	layout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout1.HorizontalFlex = Enum.UIFlexAlignment.None
	layout1.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	layout1.VerticalFlex = Enum.UIFlexAlignment.None
	layout1.SortOrder = Enum.SortOrder.LayoutOrder
	layout1.Parent = hotkeys

	local keyTag1 = Instance.new("ImageLabel")
	keyTag1.Name = "Key1"
	keyTag1.Image = "rbxasset://textures/ui/Controls/key_single.png"
	keyTag1.ImageTransparency = 0.7
	keyTag1.ScaleType = Enum.ScaleType.Slice
	keyTag1.SliceCenter = Rect.new(5, 5, 23, 24)
	keyTag1.AutomaticSize = Enum.AutomaticSize.X
	keyTag1.BackgroundTransparency = 1
	keyTag1.LayoutOrder = 1
	keyTag1.Size = UDim2.fromOffset(0, 30)
	keyTag1.ZIndex = 15
	keyTag1.Parent = hotkeys

	local inset = Instance.new("UIPadding")
	inset.Name = "Inset"
	inset.PaddingLeft = UDim.new(0, 8)
	inset.PaddingRight = UDim.new(0, 8)
	inset.Parent = keyTag1

	local labelContent = Instance.new("TextLabel")
	labelContent.AutoLocalize = false
	labelContent.Name = "LabelContent"
	labelContent.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	labelContent.Text = ""
	labelContent.TextColor3 = Color3.fromRGB(189, 190, 190)
	labelContent.TextSize = TEXT_SIZE
	labelContent.AutomaticSize = Enum.AutomaticSize.X
	labelContent.BackgroundTransparency = 1
	labelContent.Position = UDim2.fromOffset(0, -1)
	labelContent.Size = UDim2.fromScale(1, 1)
	labelContent.ZIndex = 16
	labelContent.Parent = keyTag1
	
	local caret = Instance.new("ImageLabel")
	caret.Name = "Caret"
	caret.Image = "rbxassetid://101906294438076"
	caret.ImageColor3 = CAPTION_COLOR
	caret.AnchorPoint = Vector2.new(0, 0.5)
	caret.BackgroundTransparency = 1
	caret.Position = UDim2.new(0, 0, 0, 4)
	caret.Size = UDim2.fromOffset(16, 8)
	caret.ZIndex = 12
	caret.Parent = caption

	local dropShadow = Instance.new("ImageLabel")
	dropShadow.Visible = true
	dropShadow.Name = "DropShadow"
	dropShadow.Image = "rbxassetid://124920646932671"
	dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	dropShadow.ImageTransparency = 0.45
	dropShadow.ScaleType = Enum.ScaleType.Slice
	dropShadow.SliceCenter = Rect.new(12, 12, 13, 13)
	dropShadow.BackgroundTransparency = 1
	dropShadow.Position = UDim2.fromOffset(0, 5)
	dropShadow.Size = UDim2.new(1, 0, 0, 48)
	dropShadow.Parent = caption
	box:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		dropShadow.Size = UDim2.new(1, 0, 0, box.AbsoluteSize.Y + 8)
	end)
	
	-- It's important we match the sizes as this is not
	-- handles within clipOutside (as it assumes the sizes
	-- are already the same)
	local captionJanitor = icon.captionJanitor
	local _, captionClone = icon:clipOutside(caption)
	captionClone.AutomaticSize = Enum.AutomaticSize.None
	local function matchSize()
		local absolute = caption.AbsoluteSize
		captionClone.Size = UDim2.fromOffset(absolute.X, absolute.Y)
	end
	captionJanitor:add(caption:GetPropertyChangedSignal("AbsoluteSize"):Connect(matchSize))
	matchSize()
	
	
	
	-- This handles the appearing/disappearing/positioning of the caption
	local isCompletelyEnabled = false
	local captionHeader = caption.Box.Header
	local UserInputService = game:GetService("UserInputService")
	local function updateHotkey(keyCodeEnum)
		local hasKeyboard = UserInputService.KeyboardEnabled
		local text = caption:GetAttribute("CaptionText") or ""
		local hideHeader = text == "_hotkey_"
		if not hasKeyboard and hideHeader then
			icon:setCaption()
			return
		end
		captionHeader.Text = text
		captionHeader.Visible = not hideHeader
		if keyCodeEnum then
			labelContent.Text = keyCodeEnum.Name
			hotkeys.Visible = true
		end
		if not hasKeyboard then
			hotkeys.Visible = false
		end
	end
	caption:GetAttributeChangedSignal("CaptionText"):Connect(updateHotkey)

	local EASING_STYLE = Enum.EasingStyle.Quad
	local TWEEN_SPEED = 0.2
	local TWEEN_INFO_IN = TweenInfo.new(TWEEN_SPEED, EASING_STYLE, Enum.EasingDirection.In)
	local TWEEN_INFO_OUT = TweenInfo.new(TWEEN_SPEED, EASING_STYLE, Enum.EasingDirection.Out)
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")
	local function getCaptionPosition(customEnabled)
		local enabled = if customEnabled ~= nil then customEnabled else isCompletelyEnabled
		local yOut = 2
		local yIn = yOut + 8
		local yOffset = if enabled then yIn else yOut
		return UDim2.new(0.5, 0, 1, yOffset)
	end
	local function updatePosition(forcedEnabled)
		
		-- Ignore changes if not enabled to reduce redundant calls
		if not isCompletelyEnabled then
			return
		end
		
		-- Currently the one thing which isn't accounted for are the bounds of the screen
		-- This would be an issue if someone sets a long caption text for the left or
		-- right most icon
		local enabled = if forcedEnabled ~= nil then forcedEnabled else isCompletelyEnabled
		local startPosition = getCaptionPosition(not enabled)
		local endPosition = getCaptionPosition(enabled)
		
		-- It's essential we reset the carets position to prevent the x sizing bounds
		-- of the caption from infinitely scaling up
		if enabled then
			local caretY = caret.Position.Y.Offset
			caret.Position = UDim2.fromOffset(0, caretY)
			caption.AutomaticSize = Enum.AutomaticSize.XY
			caption.Size = UDim2.fromOffset(32, 53)
		else
			local absolute = caption.AbsoluteSize
			caption.AutomaticSize = Enum.AutomaticSize.Y
			caption.Size = UDim2.fromOffset(absolute.X, absolute.Y)
		end
		
		-- We initially default to the opposite state
		local previousCaretX
		local function updateCaret()
			local caretX = clickRegion.AbsolutePosition.X - caption.AbsolutePosition.X + clickRegion.AbsoluteSize.X/2 - caret.AbsoluteSize.X/2
			local caretY = caret.Position.Y.Offset
			local newCaretPosition = UDim2.fromOffset(caretX, caretY)
			if previousCaretX ~= caretX then
				-- Again, it's essential we reset the caret if
				-- a difference in X position is detected otherwise
				-- a slight quirk with AutomaticCanvas can cause
				-- the caption to infinitely scale
				previousCaretX = caretX
				caret.Position = UDim2.fromOffset(0, caretY)
				task.wait()
			end
			caret.Position = newCaretPosition
		end
		captionClone.Position = startPosition
		updateCaret()
		
		-- Now we tween into the new state
		local tweenInfo = (enabled and TWEEN_INFO_IN) or TWEEN_INFO_OUT
		local tween = TweenService:Create(captionClone, tweenInfo, {Position = endPosition})
		local updateCaretConnection = RunService.Heartbeat:Connect(updateCaret)
		tween:Play()
		tween.Completed:Once(function()
			updateCaretConnection:Disconnect()
		end)
		
	end
	captionJanitor:add(clickRegion:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		updatePosition()
	end))
	updatePosition(false)
	
	captionJanitor:add(icon.toggleKeyAdded:Connect(updateHotkey))
	for keyCodeEnum, _ in pairs(icon.bindedToggleKeys) do
		updateHotkey(keyCodeEnum)
		break
	end
	captionJanitor:add(icon.fakeToggleKeyChanged:Connect(updateHotkey))
	local fakeToggleKey = icon.fakeToggleKey
	if fakeToggleKey then
		updateHotkey(fakeToggleKey)
	end

	local function setCaptionEnabled(enabled)
		if isCompletelyEnabled == enabled then
			return
		end
		local joinedFrame = icon.joinedFrame
		if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then
			enabled = false
		end
		isCompletelyEnabled = enabled
		local newTransparency = (enabled and 0) or 1
		local tweenInfo = (enabled and TWEEN_INFO_IN) or TWEEN_INFO_OUT
		local tweenTransparency = TweenService:Create(caption, tweenInfo, {
			GroupTransparency = newTransparency
		})
		tweenTransparency:Play()
		if enabled then
			captionClone:SetAttribute("ForceUpdate", true)
		end
		updatePosition()
		updateHotkey()
	end
	
	local WAIT_DURATION = 0.5
	local RECOVER_PERIOD = 0.3
	local Icon = require(icon.iconModule)
	captionJanitor:add(icon.stateChanged:Connect(function(stateName)
		if stateName == "Viewing" then
			local lastClock = Icon.captionLastClosedClock
			local clockDifference = (lastClock and os.clock() - lastClock) or 999
			local waitDuration = (clockDifference < RECOVER_PERIOD and 0) or WAIT_DURATION
			task.delay(waitDuration, function()
				if icon.activeState == "Viewing" then
					setCaptionEnabled(true)
				end
			end)
		else
			Icon.captionLastClosedClock = os.clock()
			setCaptionEnabled(false)
		end
	end))
	
	return caption
end