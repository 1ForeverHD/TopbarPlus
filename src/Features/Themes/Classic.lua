-- This is to provide backwards compatability with the old Roblox
-- topbar while experiences transition over to the new topbar
-- You don't need to apply this yourself, topbarplus automatically
-- applies it if the old roblox topbar is detected


return {
	{"Selection", "Size", UDim2.new(1, -6, 1, -5)},
	{"Selection", "Position", UDim2.new(0, 3, 0, 3)},
	
	{"Widget", "MinimumWidth", 32, "Deselected"},
	{"Widget", "MinimumHeight", 32, "Deselected"},
	{"Widget", "BorderSize", 0, "Deselected"},
	{"IconCorners", "CornerRadius", UDim.new(0, 9), "Deselected"},
	{"IconButton", "BackgroundTransparency", 0.5, "Deselected"},
	{"IconLabel", "TextSize", 14, "Deselected"},
	{"Dropdown", "BackgroundTransparency", 0.5, "Deselected"},
	{"Notice", "Position", UDim2.new(1, -12, 0, -3), "Deselected"},
	{"Notice", "Size", UDim2.new(0, 15, 0, 15), "Deselected"},
	{"NoticeLabel", "TextSize", 11, "Deselected"},
	
	{"IconSpot", "BackgroundColor3", Color3.fromRGB(0, 0, 0), "Selected"},
	{"IconSpot", "BackgroundTransparency", 0.702, "Selected"},
	{"IconSpotGradient", "Enabled", false, "Selected"},
	{"IconOverlay", "BackgroundTransparency", 0.97, "Selected"},
	
}