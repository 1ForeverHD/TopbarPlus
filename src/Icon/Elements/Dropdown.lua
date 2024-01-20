return function(icon)

	local dropdown = Instance.new("Frame")
	dropdown.Name = "Dropdown"
	dropdown.AutomaticSize = Enum.AutomaticSize.XY
	dropdown.BackgroundTransparency = 1
	dropdown.BorderSizePixel = 0
	dropdown.AnchorPoint = Vector2.new(0.5, 0)
	dropdown.Position = UDim2.new(0.5, 0, 1, 8)
	dropdown.ZIndex = -2
	dropdown.ClipsDescendants = true
	dropdown.Visible = true
	dropdown.Selectable = false
	dropdown.Active = false

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "DropdownCorner"
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = dropdown

	local dropdownHolder = Instance.new("ScrollingFrame")
	dropdownHolder.Name = "DropdownHolder"
	dropdownHolder.AutomaticSize = Enum.AutomaticSize.XY
	dropdownHolder.BackgroundTransparency = 1
	dropdownHolder.BorderSizePixel = 0
	dropdownHolder.AnchorPoint = Vector2.new(0, 0)
	dropdownHolder.Position = UDim2.new(0, 0, 0, 0)
	dropdownHolder.Size = UDim2.new(1, 0, 1, 0)
	dropdownHolder.ZIndex = -1
	dropdownHolder.ClipsDescendants = false
	dropdownHolder.Visible = true
	dropdownHolder.TopImage = dropdownHolder.MidImage
	dropdownHolder.BottomImage = dropdownHolder.MidImage
	dropdownHolder.VerticalScrollBarInset = Enum.ScrollBarInset.Always
	dropdownHolder.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	dropdownHolder.Parent = dropdown
	dropdownHolder.Active = false
	dropdownHolder.Selectable = false
	dropdownHolder.ScrollingEnabled = false

	local dropdownList = Instance.new("UIListLayout")
	dropdownList.Name = "DropdownList"
	dropdownList.FillDirection = Enum.FillDirection.Vertical
	dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
	dropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	dropdownList.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
	dropdownList.Parent = dropdownHolder

	local dropdownPadding = Instance.new("UIPadding")
	dropdownPadding.Name = "DropdownPadding"
	dropdownPadding.PaddingTop = UDim.new(0, 8)
	dropdownPadding.PaddingBottom = UDim.new(0, 8)
	dropdownPadding.Parent = dropdownHolder

	local dropdownJanitor = icon.dropdownJanitor
	local function updatePosition()
		-- To complete: this currently does not account for
		-- exceeding the minimum or maximum boundaries of the screen
	end
	dropdownJanitor:add(icon.widget:GetPropertyChangedSignal("AbsolutePosition"):Connect(updatePosition))

	return dropdown
end