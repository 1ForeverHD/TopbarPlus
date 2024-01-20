return function(icon)

	-- Credit to lolmansReturn and Canary Software for
	-- retrieving these values
	local caption = Instance.new("CanvasGroup")
	caption.Name = "Caption"
	caption.AnchorPoint = Vector2.new(0.5, 0)
	caption.AutomaticSize = Enum.AutomaticSize.XY
	caption.BackgroundTransparency = 1
	caption.BorderSizePixel = 0
	caption.GroupTransparency = 1
	caption.Position = UDim2.fromOffset(0, 0)
	caption.Size = UDim2.fromOffset(32, 53)
	caption.Visible = true
	caption.Parent = icon.widget

	local box = Instance.new("Frame")
	box.Name = "Box"
	box.AutomaticSize = Enum.AutomaticSize.XY
	box.BackgroundColor3 = Color3.fromRGB(101, 102, 104)
	box.Position = UDim2.fromOffset(4, 7)
	box.ZIndex = 12
	box.Parent = caption

	local header = Instance.new("TextLabel")
	header.Name = "Header"
	header.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	header.Text = "Caption"
	header.TextColor3 = Color3.fromRGB(255, 255, 255)
	header.TextSize = 14
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
	labelContent.Name = "LabelContent"
	labelContent.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	labelContent.Text = ""
	labelContent.TextColor3 = Color3.fromRGB(189, 190, 190)
	labelContent.TextSize = 14
	labelContent.AutomaticSize = Enum.AutomaticSize.X
	labelContent.BackgroundTransparency = 1
	labelContent.Position = UDim2.fromOffset(0, -1)
	labelContent.Size = UDim2.fromScale(1, 1)
	labelContent.ZIndex = 16
	labelContent.Parent = keyTag1

	local caret = Instance.new("ImageLabel")
	caret.Name = "Caret"
	caret.Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png"
	caret.ImageColor3 = Color3.fromRGB(101, 102, 104)
	caret.ImageRectOffset = Vector2.new(260, 440)
	caret.ImageRectSize = Vector2.new(16, 8)
	caret.AnchorPoint = Vector2.new(0.5, 0.5)
	caret.BackgroundTransparency = 1
	caret.Position = UDim2.new(0.5, 0, 0, 4)
	caret.Rotation = 180
	caret.Size = UDim2.fromOffset(16, 8)
	caret.ZIndex = 12
	caret.Parent = caption

	local dropShadow = Instance.new("ImageLabel")
	dropShadow.Name = "DropShadow"
	dropShadow.Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png"
	dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	dropShadow.ImageRectOffset = Vector2.new(217, 486)
	dropShadow.ImageRectSize = Vector2.new(25, 25)
	dropShadow.ImageTransparency = 0.5
	dropShadow.ScaleType = Enum.ScaleType.Slice
	dropShadow.SliceCenter = Rect.new(12, 12, 13, 13)
	dropShadow.BackgroundTransparency = 1
	dropShadow.Position = UDim2.fromOffset(0, 5)
	dropShadow.Size = UDim2.new(1, 0, 0, 48)
	dropShadow.Parent = caption
	
	-- This handles the appearing/disappearing/positioning of the caption
	local widget = icon.widget
	local captionJanitor = icon.captionJanitor
	local captionHeader = caption.Box.Header
	caption:GetAttributeChangedSignal("CaptionText"):Connect(function()
		local text = caption:GetAttribute("CaptionText")
		captionHeader.Text = text
	end)

	local EASING_STYLE = Enum.EasingStyle.Quad
	local TWEEN_SPEED = 0.2
	local TWEEN_INFO_IN = TweenInfo.new(TWEEN_SPEED, EASING_STYLE, Enum.EasingDirection.In)
	local TWEEN_INFO_OUT = TweenInfo.new(TWEEN_SPEED, EASING_STYLE, Enum.EasingDirection.Out)
	local TweenService = game:GetService("TweenService")
	local captionCaret = caption.Caret
	local isCompletelyEnabled = false
	local function getCaptionPosition(customEnabled)
		local enabled = customEnabled or isCompletelyEnabled
		local yOffset = if enabled then 4 else -2
		return UDim2.new(0, (widget.AbsoluteSize.X/2), 1, yOffset)
	end
	local function updatePosition(updateWithTween, forcedEnabled)
		-- Currently the one thing which isn't accounted for are the bounds of the screen
		-- This would be an issue if someone sets a long caption text for the left or
		-- right most icon
		local enabled = forcedEnabled or isCompletelyEnabled
		local incomingCaptionPosition = getCaptionPosition()
		local captionY = incomingCaptionPosition.Y
		local newCaptionPosition = UDim2.new(0.5, 0, captionY.Scale, captionY.Offset)
		if updateWithTween ~= true then
			caption.Position = newCaptionPosition
			return
		end
		local tweenInfo = (enabled and TWEEN_INFO_IN) or TWEEN_INFO_OUT
		local slideTween = TweenService:Create(caption, tweenInfo, {Position = newCaptionPosition})
		slideTween:Play()
	end
	captionJanitor:add(widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
		updatePosition()
	end))
	captionJanitor:add(widget:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		updatePosition()
	end))
	updatePosition(nil, false)

	local function updateHotkey(keyCodeEnum)
		labelContent.Text = keyCodeEnum.Name
		hotkeys.Visible = true
	end
	captionJanitor:add(icon.toggleKeyAdded:Connect(updateHotkey))
	for keyCodeEnum, _ in pairs(icon.bindedToggleKeys) do
		updateHotkey(keyCodeEnum)
		break
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
		updatePosition(true)
	end
	
	local WAIT_DURATION = 0.5
	local RECOVER_PERIOD = 0.3
	local Icon = icon.Icon
	captionJanitor:add(icon.stateChanged:Connect(function(stateName)
		if stateName == "Hovering" then
			local lastClock = Icon.captionLastClosedClock
			local clockDifference = (lastClock and os.clock() - lastClock) or 999
			local waitDuration = (clockDifference < RECOVER_PERIOD and 0) or WAIT_DURATION
			task.delay(waitDuration, function()
				if icon.activeState == "Hovering" then
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