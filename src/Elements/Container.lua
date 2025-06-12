local hasBecomeOldTheme = false
local previousInsetHeight = 0
return function(Icon)
	
	local GuiService = game:GetService("GuiService")
	local isConsoleScreen = GuiService:IsTenFootInterface()
	local container = {}

	-- Has to be included for the time being due to this bug mentioned here:
	-- https://devforum.roblox.com/t/bug/2973508/7
	local Signal = require(script.Parent.Parent.Packages.GoodSignal)
	local insetChanged = Signal.new()
	local guiInset = GuiService:GetGuiInset()
	local startInset = 0
	local yDownOffset = 0
	local ySizeOffset = 0
	local function checkInset()
		local isOldTopbar = GuiService.TopbarInset.Height == 36
		Icon.isOldTopbar = isOldTopbar
		if Icon.isOldTopbar and hasBecomeOldTheme == false then
			task.defer(function()
				-- If oldtopbar, apply the Classic theme
				local themes = script.Parent.Parent.Features.Themes
				local Classic = require(themes.Classic)
				hasBecomeOldTheme = true
				Icon.modifyBaseTheme(Classic)

				-- Also configure the oldtopbar correctly
				local function decideToHideTopbar()
					if GuiService.MenuIsOpen then
						Icon.setTopbarEnabled(false, true)
					else
						Icon.setTopbarEnabled()
					end
				end
				GuiService:GetPropertyChangedSignal("MenuIsOpen"):Connect(decideToHideTopbar)
				decideToHideTopbar()
			end)
		end
		guiInset = GuiService:GetGuiInset()
		startInset = if isOldTopbar then 12 else guiInset.Y - 50
		yDownOffset = if isOldTopbar then 2 else 0
		ySizeOffset = -2
		if isConsoleScreen then
			startInset = 10
		end
		if GuiService.TopbarInset.Height == 0 then
			yDownOffset += 13
			ySizeOffset = 50
		end
		insetChanged:Fire(guiInset)
		local insetHeight = guiInset.Y
		if insetHeight ~= previousInsetHeight then
			previousInsetHeight = insetHeight
			task.defer(function()
				Icon.insetHeightChanged:Fire(insetHeight)
			end)
		end
	end
	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(checkInset)
	checkInset()

	local screenGui = Instance.new("ScreenGui")
	insetChanged:Connect(function()
		screenGui:SetAttribute("StartInset", startInset)
	end)
	screenGui.Name = "TopbarStandard"
	screenGui.Enabled = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	container[screenGui.Name] = screenGui
	Icon.baseDisplayOrderChanged:Connect(function()
		screenGui.DisplayOrder = Icon.baseDisplayOrder
	end)

	local holders = Instance.new("Frame")
	holders.Name = "Holders"
	holders.BackgroundTransparency = 1
	insetChanged:Connect(function()
		holders.Position = UDim2.new(0, 0, 0, yDownOffset)
		holders.Size = UDim2.new(1, 0, 1, ySizeOffset)
	end)
	holders.Visible = true
	holders.ZIndex = 1
	holders.Parent = screenGui
	
	local screenGuiCenter = screenGui:Clone()
	local holdersCenter = screenGuiCenter.Holders
	local function updateCenteredHoldersHeight()
		holdersCenter.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height+ySizeOffset)
	end
	screenGuiCenter.Name = "TopbarCentered"
	screenGuiCenter.ScreenInsets = Enum.ScreenInsets.None
	Icon.baseDisplayOrderChanged:Connect(function()
		screenGuiCenter.DisplayOrder = Icon.baseDisplayOrder
	end)
	container[screenGuiCenter.Name] = screenGuiCenter
	
	insetChanged:Connect(updateCenteredHoldersHeight)
	updateCenteredHoldersHeight()
	
	local screenGuiClipped = screenGui:Clone()
	screenGuiClipped.Name = screenGuiClipped.Name.."Clipped"
	screenGuiClipped.DisplayOrder += 1
	Icon.baseDisplayOrderChanged:Connect(function()
		screenGuiClipped.DisplayOrder = Icon.baseDisplayOrder + 1
	end)
	container[screenGuiClipped.Name] = screenGuiClipped
	
	local screenGuiCenterClipped = screenGuiCenter:Clone()
	screenGuiCenterClipped.Name = screenGuiCenterClipped.Name.."Clipped"
	screenGuiCenterClipped.DisplayOrder += 1
	Icon.baseDisplayOrderChanged:Connect(function()
		screenGuiCenterClipped.DisplayOrder = Icon.baseDisplayOrder + 1
	end)
	container[screenGuiCenterClipped.Name] = screenGuiCenterClipped
	
	local holderReduction = -24
	local left = Instance.new("ScrollingFrame")
	left:SetAttribute("IsAHolder", true)
	left.Name = "Left"
	insetChanged:Connect(function()
		left.Position = UDim2.fromOffset(startInset, 0)
	end)
	left.Size = UDim2.new(1, holderReduction, 1, 0)
	left.BackgroundTransparency = 1
	left.Visible = true
	left.ZIndex = 1
	left.Active = false
	left.ClipsDescendants = true
	left.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	left.CanvasSize = UDim2.new(0, 0, 1, -1) -- This -1 prevents a dropdown scrolling appearance bug
	left.AutomaticCanvasSize = Enum.AutomaticSize.X
	left.ScrollingDirection = Enum.ScrollingDirection.X
	left.ScrollBarThickness = 0
	left.BorderSizePixel = 0
	left.Selectable = false
	left.ScrollingEnabled = false--true
	left.ElasticBehavior = Enum.ElasticBehavior.Never
	left.Parent = holders
	
	local UIListLayout = Instance.new("UIListLayout")
	insetChanged:Connect(function()
		UIListLayout.Padding = UDim.new(0, startInset)
	end)
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout.Parent = left
	
	local center = left:Clone()
	insetChanged:Connect(function()
		center.UIListLayout.Padding = UDim.new(0, startInset)
	end)
	center.ScrollingEnabled = false
	center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	center.Name = "Center"
	center.Parent = holdersCenter
	
	local right = left:Clone()
	insetChanged:Connect(function()
		right.UIListLayout.Padding = UDim.new(0, startInset)
	end)
	right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	right.Name = "Right"
	right.AnchorPoint = Vector2.new(1, 0)
	right.Position = UDim2.new(1, -12, 0, 0)
	right.Parent = holders

	-- This is important so that all elements update instantly
	insetChanged:Fire(guiInset)

	return container
end