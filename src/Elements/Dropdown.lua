local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Themes = require(script.Parent.Parent.Features.Themes)
local PADDING = 0 -- used to be 8
return function(icon)
	
	local dropdown = Instance.new("Frame") -- Instance.new("CanvasGroup")
	dropdown.Name = "Dropdown"
	dropdown.AutomaticSize = Enum.AutomaticSize.X
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

	local TweenDuration = Instance.new("NumberValue") -- this helps to change the speed to open / close in modifyTheme()
	TweenDuration.Name = "DropdownSpeed"
	TweenDuration.Value = 0.07
	TweenDuration.Parent = dropdown

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
		for i, otherIconUID in pairs(icon.dropdownIcons) do
			local otherIcon = Icon.getIconByUID(otherIconUID)
			otherIcon:destroy()
		end
		if type(arrayOfIcons) == "table" then
			for i, otherIcon in pairs(arrayOfIcons) do
				otherIcon:joinDropdown(icon)
			end
		end
	end)

	local function updateMaxIcons()
		--icon:modifyTheme({"Dropdown", "Visible", icon.isSelected})
		local maxIcons = dropdown:GetAttribute("MaxIcons")
		if not maxIcons then return 0 end
		local children = {}
		for _, child in pairs(dropdownScroller:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				table.insert(children, child)
			end
		end

		table.sort(children, function(a, b) return a.AbsolutePosition.Y < b.AbsolutePosition.Y end)
		local totalHeight = 0
		local maxIconsRoundedUp = math.ceil(maxIcons)
		for i = 1, maxIconsRoundedUp do
			local child = children[i]
			if not child then break end
			local height = child.AbsoluteSize.Y
			local isReduced = i == maxIconsRoundedUp and maxIconsRoundedUp ~= maxIcons
			if isReduced then
				height *= (maxIcons - maxIconsRoundedUp + 1)
			end
			totalHeight += height
		end
		totalHeight += dropdownPadding.PaddingTop.Offset + dropdownPadding.PaddingBottom.Offset
		return totalHeight
	end
	
	local openTween = nil
	local closeTween = nil
	local currentSpeedMultiplier = nil
	local currentTweenInfo = nil
	local function getTweenInfo()
		local speedMultiplier = Themes.getInstanceValue(dropdown, "MaxIcons") or 1
		if currentSpeedMultiplier and currentSpeedMultiplier == speedMultiplier and currentTweenInfo then
			return currentTweenInfo
		end
		local newTweenInfo = TweenInfo.new(
			TweenDuration.Value * speedMultiplier,
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out
		)
		currentTweenInfo = newTweenInfo
		currentSpeedMultiplier = speedMultiplier
		return newTweenInfo
	end
	local function updateVisibility()
		-- Update visibiliy of dropdown using tween transition
		local tweenInfo = getTweenInfo()
		
		if openTween then
			openTween:Cancel()
			openTween = nil
		end
		if closeTween then
			closeTween:Cancel()
			closeTween = nil
		end

		if icon.isSelected then
			local height = updateMaxIcons()
			dropdown.Visible = true
			dropdown.BackgroundTransparency = 0 -- no transparency so it looks solid
			dropdown.Size = UDim2.new(0, dropdown.Size.X.Offset, 0, 0) -- reset height to 0 before tween

			openTween = TweenService:Create(dropdown, tweenInfo, {Size = UDim2.new(0, dropdown.Size.X.Offset, 0, height)})
			openTween:Play()
			openTween.Completed:Connect(function()
				openTween = nil
			end)
		else
			local closeTweenInfo = TweenInfo.new(0)
			closeTween = TweenService:Create(dropdown, closeTweenInfo, {Size = UDim2.new(0, dropdown.Size.X.Offset, 0, 0)})
			closeTween:Play()
			closeTween.Completed:Connect(function()
				closeTween = nil
			end)
		end
	end

	dropdownJanitor:add(icon.toggled:Connect(updateVisibility))
	updateVisibility()
	--task.delay(0.2, updateVisibility)

	local function updateChildSize()
		local tweenInfo = getTweenInfo()
		if not icon.isSelected then return end
		if openTween then
			openTween:Cancel()
			openTween = nil
		end
		if closeTween then
			closeTween:Cancel()
			closeTween = nil
		end
		
		RunService.Heartbeat:Wait()
		
		local height = updateMaxIcons()

		openTween = TweenService:Create(dropdown, tweenInfo, {Size = UDim2.new(0, dropdown.Size.X.Offset, 0, height)})
		openTween:Play()
		openTween.Completed:Connect(function()	
			openTween = nil
		end)
	end

	dropdownJanitor:add(icon.toggled:Connect(updateVisibility))

	-- Ensures canvas and size stay synced (original updateMaxIcons logic)
	local updateCount = 0
	local isUpdating = false

	-- This updates the scrolling frame to only display a scroll
	-- length equal to the distance produced by its MaxIcons
	local function updateMaxIconsListener()
		updateCount += 1
		if isUpdating then return end
		local myUpdateCount = updateCount
		isUpdating = true
		task.defer(function()
			isUpdating = false
			if updateCount ~= myUpdateCount then
				updateMaxIconsListener()
			end
		end)
		local maxIcons = dropdown:GetAttribute("MaxIcons")
		if not maxIcons then return end

		local orderedInstances = {}
		for _, child in pairs(dropdownScroller:GetChildren()) do
			if child:IsA("GuiObject") and child.Visible then
				table.insert(orderedInstances, {child, child.AbsolutePosition.Y})
			end
		end
		table.sort(orderedInstances, function(a, b) return a[2] < b[2] end)

		local totalHeight = 0
		local hasSetNextSelection = false
		local maxIconsRoundedUp = math.ceil(maxIcons)
		for i = 1, maxIconsRoundedUp do
			local group = orderedInstances[i]
			if not group then break end
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
		totalHeight += dropdownPadding.PaddingTop.Offset + dropdownPadding.PaddingBottom.Offset

		dropdownScroller.Size = UDim2.fromOffset(0, totalHeight)

	end

	dropdownJanitor:add(dropdownScroller:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateMaxIconsListener))
	dropdownJanitor:add(dropdownScroller.ChildAdded:Connect(updateMaxIconsListener))
	dropdownJanitor:add(dropdownScroller.ChildRemoved:Connect(updateChildSize)) -- rezise the dropdown when icon delects or adds
	dropdownJanitor:add(dropdownScroller.ChildRemoved:Connect(updateMaxIconsListener))
	dropdownJanitor:add(dropdown:GetAttributeChangedSignal("MaxIcons"):Connect(updateMaxIconsListener))
	dropdownJanitor:add(dropdown:GetAttributeChangedSignal("MaxIcons"):Connect(updateChildSize))
	dropdownJanitor:add(icon.childThemeModified:Connect(updateMaxIconsListener))
	updateMaxIconsListener()

	-- Ensures each child listens to visibility changes
	local function connectVisibilityListeners(child)
		if child:IsA("GuiObject") then
			child:GetPropertyChangedSignal("Visible"):Connect(updateChildSize)
		end
	end
	
	-- For existing children
	for _, child in pairs(dropdownScroller:GetChildren()) do
		connectVisibilityListeners(child)
	end
	-- For new children
	dropdownScroller.ChildAdded:Connect(function(child)
		RunService.Heartbeat:Wait()
		connectVisibilityListeners(child)
		updateChildSize()
	end)

	-- On start, hide dropdown (prevent it showing as opened)
	dropdown.Visible = false

	return dropdown
end