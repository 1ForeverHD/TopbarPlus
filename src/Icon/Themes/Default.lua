return {
	
	
	-- How items appear when the icon is deselected (i.e. its default state)
	Deselected = {
		{"Widget", "MinimumWidth", 44},
		{"Widget", "MinimumHeight", 44},
		{"Widget", "BorderSize", 4},
		{"IconCorners", "CornerRadius", UDim.new(1, 0)},
		{"IconButton", "BackgroundColor3", Color3.fromRGB(0, 0, 0)},
		{"IconButton", "BackgroundTransparency", 0.3},
		{"IconImageScale", "Value", 0.5},
		{"IconImageCorner", "CornerRadius", UDim.new(0, 0)},
		{"IconImage", "ImageColor3", Color3.fromRGB(255, 255, 255)},
		{"IconImage", "ImageTransparency", 0},
		{"IconImage", "Image", ""},
		{"IconLabel", "FontFace", Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)},
		{"IconLabel", "Text", ""},
		{"IconLabel", "TextSize", 16},
		{"IconLabel", "Position", UDim2.fromOffset(0, -1)},
		{"IconSpot", "BackgroundTransparency", 1},
		{"IconOverlay", "BackgroundTransparency", 0.925},
		{"IconSpotGradient", "Enabled", false},
		{"IconGradient", "Enabled", false},
		{"Dropdown", "BackgroundColor3", Color3.fromRGB(0, 0, 0)},
		{"Dropdown", "BackgroundTransparency", 0.3},
	},
	
	
	-- How items appear when the icon is selected
	Selected = {
		{"IconSpot", "BackgroundTransparency", 0.7},
		{"IconSpot", "BackgroundColor3", Color3.fromRGB(255, 255, 255)},
		{"IconSpotGradient", "Enabled", true},
		{"IconSpotGradient", "Rotation", 45},
		{"IconSpotGradient", "Color", ColorSequence.new(Color3.fromRGB(96, 98, 100), Color3.fromRGB(77, 78, 80))},
	},
	
	-- How items appear when a cursor is above (but not pressing) the frame, or when focused with a controller
	Hovering = {
		
	},
	
	
	-- How items appear when the icon is initially clicked until released
	Pressing = {
		
	},
	
}