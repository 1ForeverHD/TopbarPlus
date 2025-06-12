local PADDING = 0 -- used to be 8
return function(icon)
	
	local dropdown = Instance.new("Frame") -- Instance.new("CanvasGroup")
	dropdown.Name = "Dropdown"
	dropdown.AutomaticSize = Enum.AutomaticSize.XY
	dropdown.BackgroundTransparency = 1
	dropdown.BorderSizePixel = 0
	dropdown.AnchorPoint = Vector2.new(0.5, 0)
	dropdown.Position = UDim2.new(0.5, 0, 1, 10)
	dropdown.ZIndex = -2
	dropdown.ClipsDescendants = true
	dropdown.Parent = icon.widget

	-- Account for PreferredTransparency which can be set by every player
	local GuiService = game:GetService("GuiService")
	icon:setBehaviour("Dropdown", "BackgroundTransparency", function(value)
		local preference = GuiService.PreferredTransparency
		local newValue = value * preference
		if value == 1 then
			return value
		end
		return newValue
	end)
	icon.janitor:add(GuiService:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
		icon:refreshAppearance(dropdown, "BackgroundTransparency")
	end))

	local UICorner = Instance.new("UICorner")
	UICorner.Name = "DropdownCorner"
	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = dropdown

	local dropdownScroller = Instance.new("ScrollingFrame")
	dropdownScroller.Name = "DropdownScroller"
	dropdownScroller.AutomaticSize = Enum.AutomaticSize.X
	dropdownScroller.BackgroundTransparency = 1
	dropdownScroller.BorderSizePixel = 0
	dropdownScroller.AnchorPoint = Vector2.new(0, 0)
	dropdownScroller.Position = UDim2.new(0, 0, 0, 0)
	dropdownScroller.ZIndex = -1
	dropdownScroller.ClipsDescendants = true
	dropdownScroller.Visible = true
	dropdownScroller.VerticalScrollBarInset = Enum.ScrollBarInset.None --ScrollBar
	dropdownScroller.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
	dropdownScroller.Active = false
	dropdownScroller.ScrollingEnabled = true
	dropdownScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
	dropdownScroller.ScrollBarThickness = 5
	dropdownScroller.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	dropdownScroller.ScrollBarImageTransparency = 0.8
	dropdownScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
	dropdownScroller.Selectable = false
	dropdownScroller.Active = true
	dropdownScroller.Parent = dropdown
	
	local dropdownPadding = Instance.new("UIPadding")
	dropdownPadding.Name = "DropdownPadding"
	dropdownPadding.PaddingTop = UDim.new(0, PADDING)
	dropdownPadding.PaddingBottom = UDim.new(0, PADDING)
	dropdownPadding.Parent = dropdownScroller

	local dropdownList = Instance.new("UIListLayout")
	dropdownList.Name = "DropdownList"
	dropdownList.FillDirection = Enum.FillDirection.Vertical
	dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
	dropdownList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	dropdownList.HorizontalFlex = Enum.UIFlexAlignment.SpaceEvenly
	dropdownList.Parent = dropdownScroller
	
	local dropdownJanitor = icon.dropdownJanitor
	local Icon = require(icon.iconModule)
	icon.dropdownChildAdded:Connect(function(childIcon)
		-- Modify appearance of child when joined
		local _, modificationUID = childIcon:modifyTheme({
			{"Widget", "BorderSize", 0},
			{"IconCorners", "CornerRadius", UDim.new(0, 10)},
			{"Widget", "MinimumWidth", 190},
			{"Widget", "MinimumHeight", 58},
			{"IconLabel", "TextSize", 20},
			{"IconOverlay", "Size", UDim2.new(1, 0, 1, 0)},
			{"PaddingLeft", "Size", UDim2.fromOffset(25, 0)},
			{"Notice", "Position", UDim2.new(1, -24, 0, 5)},
			{"ContentsList", "HorizontalAlignment", Enum.HorizontalAlignment.Left},
			{"Selection", "Size", UDim2.new(1, -PADDING, 1, -PADDING)},
			{"Selection", "Position", UDim2.new(0, PADDING/2, 0, PADDING/2)},
		})
		task.defer(function()
			childIcon.joinJanitor:add(function()
				childIcon:removeModification(modificationUID)
			end)
		end)
	end)
	icon.dropdownSet:Connect(function(arrayOfIcons)
		-- Destroy any previous icons
		for i, otherIconUID in pairs(icon.dropdownIcons) do
			local otherIcon = Icon.getIconByUID(otherIconUID)
			otherIcon:destroy()
		end
		-- Add new icons
		if type(arrayOfIcons) == "table" then
			for i, otherIcon in pairs(arrayOfIcons) do
				otherIcon:joinDropdown(icon)
			end
		end
	end)

	-- Update visibiliy of dropdown
	local Utility = require(script.Parent.Parent.Utility)
	local function updateVisibility()
		--icon:modifyTheme({"Dropdown", "Visible", icon.isSelected})
		Utility.setVisible(dropdown, icon.isSelected, "InternalDropdown")
	end
	dropdownJanitor:add(icon.toggled:Connect(updateVisibility))
	updateVisibility()
	--task.delay(0.2, updateVisibility)
	
	-- This updates the scrolling frame to only display a scroll
	-- length equal to the distance produced by its MaxIcons
	local updateCount = 0
	local isUpdating = false
	local function updateMaxIcons()
		
		-- This prevents more than 1 update occurring every frame
		updateCount += 1
		if isUpdating then
			return
		end
		local myUpdateCount = updateCount
		isUpdating = true
		task.defer(function()
			isUpdating = false
			if updateCount ~= myUpdateCount then
				updateMaxIcons()
			end
		end)
			
		local maxIcons = dropdown:GetAttribute("MaxIcons")
		if not maxIcons then
			return
		end
		local orderedInstances = {}
		for _, child in pairs(dropdownScroller:GetChildren()) do
			if child:IsA("GuiObject") then
				table.insert(orderedInstances, {child, child.AbsolutePosition.Y})
			end
		end
		table.sort(orderedInstances, function(groupA, groupB)
			return groupA[2] < groupB[2]
		end)
		local totalHeight = 0
		local hasSetNextSelection = false
		local maxIconsRoundedUp = math.ceil(maxIcons)
		for i = 1, maxIconsRoundedUp do
			local group = orderedInstances[i]
			if not group then
				break
			end
			local child = group[1]
			local height = child.AbsoluteSize.Y
			local isReduced = i == maxIconsRoundedUp and maxIconsRoundedUp ~= maxIcons
			if isReduced then
				height = height * (maxIcons - maxIconsRoundedUp + 1)
			end
			totalHeight += height
			if isReduced then
				continue
			end
			local iconUID = child:GetAttribute("WidgetUID")
			local childIcon = iconUID and Icon.getIconByUID(iconUID)
			if childIcon then
				local nextSelection = nil
				if not hasSetNextSelection then
					hasSetNextSelection = true
					nextSelection = icon:getInstance("ClickRegion")
				end
				childIcon:getInstance("ClickRegion").NextSelectionUp = nextSelection
			end
		end
		totalHeight += dropdownPadding.PaddingTop.Offset
		totalHeight += dropdownPadding.PaddingBottom.Offset
		dropdownScroller.Size = UDim2.fromOffset(0, totalHeight)
	end
	dropdownJanitor:add(dropdownScroller:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIcons))
	dropdownJanitor:add(dropdownScroller.ChildAdded:Connect(updateMaxIcons))
	dropdownJanitor:add(dropdownScroller.ChildRemoved:Connect(updateMaxIcons))
	dropdownJanitor:add(dropdown:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIcons))
	dropdownJanitor:add(icon.childThemeModified:Connect(updateMaxIcons))
	updateMaxIcons()
	
	return dropdown
end