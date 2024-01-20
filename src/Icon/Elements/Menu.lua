return function(icon)

	local menuContainer = Instance.new("Frame")
	menuContainer.Name = "MenuContainer"
	menuContainer.BackgroundTransparency = 1
	menuContainer.BorderSizePixel = 0
	menuContainer.AnchorPoint = Vector2.new(1, 0)
	menuContainer.Size = UDim2.new(0, 500, 0, 50)
	menuContainer.ZIndex = -2
	menuContainer.ClipsDescendants = true
	menuContainer.Visible = true
	menuContainer.Active = false
	menuContainer.Selectable = false

	local menuFrame = Instance.new("ScrollingFrame")
	menuFrame.Name = "MenuFrame"
	menuFrame.BackgroundTransparency = 1
	menuFrame.BorderSizePixel = 0
	menuFrame.AnchorPoint = Vector2.new(0, 0)
	menuFrame.Position = UDim2.new(0, 0, 0, 0)
	menuFrame.Size = UDim2.new(1, 0, 1, 0)
	menuFrame.ZIndex = -1 + 10
	menuFrame.ClipsDescendants = false
	menuFrame.Visible = true
	menuFrame.TopImage = ""--menuFrame.MidImage
	menuFrame.BottomImage = ""--menuFrame.MidImage
	menuFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	menuFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	menuFrame.Parent = menuContainer
	menuFrame.Active = false
	menuFrame.Selectable = false
	menuFrame.ScrollingEnabled = false

	local menuList = Instance.new("UIListLayout")
	menuList.Name = "MenuList"
	menuList.FillDirection = Enum.FillDirection.Horizontal
	menuList.HorizontalAlignment = Enum.HorizontalAlignment.Right
	menuList.SortOrder = Enum.SortOrder.LayoutOrder
	menuList.Parent = menuFrame

	local menuInvisBlocker = Instance.new("Frame")
	menuInvisBlocker.Name = "MenuInvisBlocker"
	menuInvisBlocker.BackgroundTransparency = 1
	menuInvisBlocker.Size = UDim2.new(0, -2, 1, 0)
	menuInvisBlocker.Visible = true
	menuInvisBlocker.LayoutOrder = 999999999
	menuInvisBlocker.Parent = menuFrame
	menuInvisBlocker.Active = false
	
	return menuContainer
end