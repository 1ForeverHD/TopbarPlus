return function(Icon)

	-- Credit to lolmansReturn and Canary Software for
	-- retrieving these values
	local selectionContainer = Instance.new("Frame")
	selectionContainer.Name = "SelectionContainer"
	selectionContainer.Visible = false
	
	local selection = Instance.new("Frame")
	selection.Name = "Selection"
	selection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	selection.BackgroundTransparency = 1
	selection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	selection.BorderSizePixel = 0
	selection.Parent = selectionContainer

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Name = "UIStroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 3
	UIStroke.Parent = selection

	local selectionGradient = Instance.new("UIGradient")
	selectionGradient.Name = "SelectionGradient"
	selectionGradient.Parent = UIStroke

	local UICorner = Instance.new("UICorner")
	UICorner:SetAttribute("Collective", "IconCorners")
	UICorner.Name = "UICorner"
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = selection
	
	local RunService = game:GetService("RunService")
	local GuiService = game:GetService("GuiService")
	local rotationSpeed = 1
	selection:GetAttributeChangedSignal("RotationSpeed"):Connect(function()
		rotationSpeed = selection:GetAttribute("RotationSpeed")
	end)
	RunService.Heartbeat:Connect(function()
		if not GuiService.SelectedObject then
			return
		end
		selectionGradient.Rotation = (os.clock() * rotationSpeed * 100) % 360
	end)

	return selectionContainer
	
end