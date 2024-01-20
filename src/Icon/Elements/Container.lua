return function()
	
	local container = {}
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "TopbarStandard"
	screenGui.Enabled = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 10 -- We make it 10 so items like Captions appear in front of the chat
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.ScreenInsets = Enum.ScreenInsets.TopbarSafeInsets
	container[screenGui.Name] = screenGui

	local holders = Instance.new("Frame")
	holders.Name = "Holders"
	holders.BackgroundTransparency = 1
	holders.Position = UDim2.new(0, 0, 0, 0)
	holders.Size = UDim2.new(1, 0, 1, -1)
	holders.Visible = true
	holders.ZIndex = 1
	holders.Active = false
	holders.Parent = screenGui
	
	local screenGuiCenter = screenGui:Clone()
	local holdersCenter = screenGuiCenter.Holders
	local GuiService = game:GetService("GuiService")
	local function updateCenteredHoldersHeight()
		holdersCenter.Size = UDim2.new(1, 0, 0, GuiService.TopbarInset.Height-1)
	end
	screenGuiCenter.Name = "TopbarCentered"
	screenGuiCenter.ScreenInsets = Enum.ScreenInsets.None
	container[screenGuiCenter.Name] = screenGuiCenter
	GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(updateCenteredHoldersHeight)
	updateCenteredHoldersHeight()
	
	local left = holders:Clone()
	local UIListLayout = Instance.new("UIListLayout")
	local GuiService = game:GetService("GuiService")
	local guiInset = GuiService:GetGuiInset()
	local newOffset = guiInset.Y - (44 + 2)
	local DEFAULT_POSITION = UDim2.fromOffset(12, 0)
	UIListLayout.Padding = UDim.new(0, newOffset)
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout.Parent = left
	left.Name = "Left"
	left.Position = DEFAULT_POSITION
	left.Size = UDim2.new(1, -24, 1, 0)
	left.Parent = holders
	
	local center = left:Clone()
	center.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	center.Name = "Center"
	center.Parent = holdersCenter
	
	local right = left:Clone()
	right.UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	right.Name = "Right"
	right.Parent = holders

	return container
end