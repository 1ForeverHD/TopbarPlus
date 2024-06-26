return function(Icon)
	
	local GuiService = game:GetService("GuiService")
	local isOldTopbar = Icon.isOldTopbar
	local container = {}
	local guiInset = GuiService:GetGuiInset()
	local isConsoleScreen = GuiService:IsTenFootInterface()
	local startInset = if isOldTopbar then 12 else guiInset.Y - (44 + 2)
	if isConsoleScreen then
		startInset = 10
	end
	local screenGui = Instance.new("ScreenGui")
	screenGui:SetAttribute("StartInset", startInset)
	screenGui.Name = "TopbarStandard"
	screenGui.Enabled = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	container[screenGui.Name] = screenGui
	screenGui.DisplayOrder = Icon.baseDisplayOrder
	Icon.baseDisplayOrderChanged:Connect(function()
		screenGui.DisplayOrder = Icon.baseDisplayOrder
	end)

	local holders = Instance.new("Frame")
	local yDownOffset = if isOldTopbar then 2 else 0
	local ySizeOffset = -2
	if isConsoleScreen then
		yDownOffset += 13
		ySizeOffset = 50
	end
	holders.Name = "Holders"
	holders.BackgroundTransparency = 1
	holders.Position = UDim2.new(0, 0, 0, yDownOffset)
	holders.Size = UDim2.new(1, 0, 1, ySizeOffset)
	holders.Visible = true
	holders.ZIndex = 1
	holders.Parent = screenGui
	
	local screenGuiCenter = screenGui:Clone()
	local holdersCenter = screenGuiCenter.Holders
	local GuiService = game:GetService("GuiService")
	local function updateCenteredHoldersHeight()
		holdersCenter.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height+ySizeOffset)
	end
	screenGuiCenter.Name = "TopbarCentered"
	screenGuiCenter.ScreenInsets = Enum.ScreenInsets.None
	Icon.baseDisplayOrderChanged:Connect(function()
		screenGuiCenter.DisplayOrder = Icon.baseDisplayOrder
	end)
	container[screenGuiCenter.Name] = screenGuiCenter
	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(updateCenteredHoldersHeight)
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
	
	if isOldTopbar then
		task.defer(function()
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
	
	local holderReduction = -24
	local left = Instance.new("ScrollingFrame")
	left:SetAttribute("IsAHolder", true)
	left.Name = "Left"
	left.Position = UDim2.fromOffset(startInset, 0)
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
	UIListLayout.Padding = UDim.new(0, startInset)
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout.Parent = left
	
	local center = left:Clone()
	center.ScrollingEnabled = false
	center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	center.Name = "Center"
	center.Parent = holdersCenter
	
	local right = left:Clone()
	right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	right.Name = "Right"
	right.AnchorPoint = Vector2.new(1, 0)
	right.Position = UDim2.new(1, -12, 0, 0)
	right.Parent = holders

	return container
end