return function(icon)
	local menu = Instance.new("ScrollingFrame")
	menu.Name = "Menu"
	menu.BackgroundTransparency = 1
	menu.Visible = true
	menu.ZIndex = 1
	menu.Size = UDim2.fromScale(1, 1)
	menu.ClipsDescendants = true
	menu.TopImage = ""
	menu.BottomImage = ""
	menu.HorizontalScrollBarInset = Enum.ScrollBarInset.Always
	menu.CanvasSize = UDim2.new(0, 0, 1, -1) -- This -1 prevents a dropdown scrolling appearance bug
	menu.ScrollingEnabled = true
	menu.ScrollingDirection = Enum.ScrollingDirection.X
	menu.ZIndex = 20
	menu.ScrollBarThickness = 3
	menu.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	menu.ScrollBarImageTransparency = 0.8
	menu.BorderSizePixel = 0
	menu.Selectable = false

	local Icon = require(icon.iconModule)
	local menuUIListLayout = Icon.container.TopbarStandard:FindFirstChild("UIListLayout", true):Clone()
	menuUIListLayout.Name = "MenuUIListLayout"
	menuUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	menuUIListLayout.Parent = menu

	local menuGap = Instance.new("Frame")
	menuGap.Name = "MenuGap"
	menuGap.BackgroundTransparency = 1
	menuGap.Visible = false
	menuGap.AnchorPoint = Vector2.new(0, 0.5)
	menuGap.ZIndex = 5
	menuGap.Parent = menu

	local hasStartedMenu = false
	local function totalChildrenChanged()
		local menuJanitor = icon.menuJanitor
		local totalIcons = #icon.menuIcons
		if hasStartedMenu then
			if totalIcons <= 0 then
				menuJanitor:Cleanup()
				hasStartedMenu = false
			end
			return
		end
		hasStartedMenu = true

		-- Listen for changes
		menuJanitor:Add(
			icon.toggled:Connect(function()
				if #icon.menuIcons > 0 then
					icon.updateSize:Fire()
				end
			end),
			"Disconnect"
		)

		-- Modify appearance of menu icon when joined
		local _, modificationUID = icon:modifyTheme({
			{ "Menu", "Active", true },
		})
		task.defer(function()
			menuJanitor:Add(function()
				icon:removeModification(modificationUID)
			end)
		end)

		-- For right-aligned icons, this ensures their menus
		-- close button appear instantly when selected (instead
		-- of partially hidden from view)
		local previousCanvasX = menu.AbsoluteCanvasSize.X
		local function rightAlignCanvas()
			if icon.alignment == "Right" then
				local newCanvasX = menu.AbsoluteCanvasSize.X
				local difference = previousCanvasX - newCanvasX
				previousCanvasX = newCanvasX
				menu.CanvasPosition = Vector2.new(menu.CanvasPosition.X - difference, 0)
			end
		end
		menuJanitor:Add(icon.selected:Connect(rightAlignCanvas), "Disconnect")
		menuJanitor:Add(menu:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(rightAlignCanvas))

		-- Apply a close selected image if the user hasn't applied thier own
		local fontLink = "rbxasset://fonts/families/FredokaOne.json"
		local fontFace = Font.new(fontLink, Enum.FontWeight.Light, Enum.FontStyle.Normal)
		icon:removeModificationWith("IconLabel", "Text", "Viewing")
		icon:removeModificationWith("IconLabel", "Image", "Viewing")
		icon:modifyTheme({
			{ "IconLabel", "FontFace", fontFace, "Selected" },
			{ "IconLabel", "Text", "X", "Selected" },
			{ "IconLabel", "TextSize", 20, "Selected" },
			{ "IconLabel", "TextStrokeTransparency", 0.8, "Selected" },
			{ "IconImage", "Image", "", "Selected" },
		})

		-- Change order of spot when alignment changes
		local iconSpot = icon:getInstance("IconSpot")
		local menuGap = icon:getInstance("MenuGap")
		local function updateAlignent()
			local alignment = icon.alignment
			if alignment == "Right" then
				iconSpot.LayoutOrder = 99999
				menuGap.LayoutOrder = 99998
			else
				iconSpot.LayoutOrder = -99999
				menuGap.LayoutOrder = -99998
			end
		end
		menuJanitor:Add(icon.alignmentChanged:Connect(updateAlignent), "Disconnect")
		updateAlignent()

		-- This updates the scrolling frame to only display a scroll
		-- length equal to the distance produced by its MaxIcons
		menu:GetAttributeChangedSignal("MenuCanvasWidth"):Connect(function()
			local canvasWidth = menu:GetAttribute("MenuCanvasWidth")
			local canvasY = menu.CanvasSize.Y
			menu.CanvasSize = UDim2.new(0, canvasWidth, canvasY.Scale, canvasY.Offset)
		end)
		menuJanitor:Add(
			icon.updateMenu:Connect(function()
				local maxIcons = menu:GetAttribute("MaxIcons")
				if not maxIcons then
					return
				end
				local orderedInstances = {}
				for _, child in menu:GetChildren() do
					local widgetUID = child:GetAttribute("WidgetUID")
					if widgetUID and child.Visible then
						table.insert(orderedInstances, { child, child.AbsolutePosition.X })
					end
				end
				table.sort(orderedInstances, function(groupA, groupB)
					return groupA[2] < groupB[2]
				end)
				local totalWidth = 0
				for i = 1, maxIcons do
					local group = orderedInstances[i]
					if not group then
						break
					end
					local child = group[1]
					local width = child.AbsoluteSize.X + menuUIListLayout.Padding.Offset
					totalWidth += width
				end
				menu:SetAttribute("MenuWidth", totalWidth)
			end),
			"Disconnect"
		)
		local function startMenuUpdate()
			task.delay(0.1, function()
				icon.startMenuUpdate:Fire()
			end)
		end
		menuJanitor:Add(menu.ChildAdded:Connect(startMenuUpdate))
		menuJanitor:Add(menu.ChildRemoved:Connect(startMenuUpdate))
		menuJanitor:Add(menu:GetAttributeChangedSignal("MaxIcons"):Connect(startMenuUpdate))
		menuJanitor:Add(menu:GetAttributeChangedSignal("MaxWidth"):Connect(startMenuUpdate))
		startMenuUpdate()
	end

	icon.menuChildAdded:Connect(totalChildrenChanged)
	icon.menuSet:Connect(function(arrayOfIcons)
		-- Reset any previous icons
		for _, otherIconUID in icon.menuIcons do
			local otherIcon = Icon.getIconByUID(otherIconUID)
			otherIcon:Destroy()
		end
		-- Apply new icons
		if type(arrayOfIcons) == "table" then
			for _, otherIcon in arrayOfIcons do
				otherIcon:joinMenu(icon)
			end
		end
	end)

	return menu
end
