-- SETUP ICON TEMPLATE
local topbarPlusGui = Instance.new("ScreenGui")
topbarPlusGui.Enabled = true
topbarPlusGui.DisplayOrder = 0
topbarPlusGui.IgnoreGuiInset = true
topbarPlusGui.ResetOnSpawn = false
topbarPlusGui.Name = "TopbarPlus"

local activeItems = Instance.new("Folder")
activeItems.Name = "ActiveItems"
activeItems.Parent = topbarPlusGui

local topbarContainer = Instance.new("Frame")
topbarContainer.BackgroundTransparency = 1
topbarContainer.Name = "TopbarContainer"
topbarContainer.Position = UDim2.new(0, 0, 0, 0)
topbarContainer.Size = UDim2.new(1, 0, 0, 36)
topbarContainer.Visible = true
topbarContainer.ZIndex = 1
topbarContainer.Parent = topbarPlusGui
topbarContainer.Active = false

local iconContainer = Instance.new("Frame")
iconContainer.BackgroundTransparency = 1
iconContainer.Name = "IconContainer"
iconContainer.Position = UDim2.new(0, 104, 0, 4)
iconContainer.Visible = false
iconContainer.ZIndex = 1
iconContainer.Parent = topbarContainer
iconContainer.Active = false

local iconButton = Instance.new("TextButton")
iconButton.Name = "IconButton"
iconButton.Visible = true
iconButton.Text = ""
iconButton.ZIndex = 10--2
iconButton.BorderSizePixel = 0
iconButton.AutoButtonColor = false
iconButton.Parent = iconContainer
iconButton.Active = false

local iconImage = Instance.new("ImageLabel")
iconImage.BackgroundTransparency = 1
iconImage.Name = "IconImage"
iconImage.AnchorPoint = Vector2.new(0, 0.5)
iconImage.Visible = true
iconImage.ZIndex = 11--3
iconImage.ScaleType = Enum.ScaleType.Fit
iconImage.Parent = iconButton
iconImage.Active = false

local iconLabel = Instance.new("TextLabel")
iconLabel.BackgroundTransparency = 1
iconLabel.Name = "IconLabel"
iconLabel.AnchorPoint = Vector2.new(0, 0.5)
iconLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
iconLabel.Text = ""
iconLabel.RichText = true
iconLabel.TextScaled = false
iconLabel.ClipsDescendants = true
iconLabel.ZIndex = 11--3
iconLabel.Parent = iconButton
iconLabel.Active = false

local iconGradient = Instance.new("UIGradient")
iconGradient.Name = "IconGradient"
iconGradient.Enabled = true
iconGradient.Parent = iconButton

local iconCorner = Instance.new("UICorner")
iconCorner.Name = "IconCorner"
iconCorner.Parent = iconButton

local iconOverlay = Instance.new("Frame")
iconOverlay.Name = "IconOverlay"
iconOverlay.BackgroundTransparency = 1
iconOverlay.Position = iconButton.Position
iconOverlay.Size = UDim2.new(1, 0, 1, 0)
iconOverlay.Visible = true
iconOverlay.ZIndex = iconButton.ZIndex + 1
iconOverlay.BorderSizePixel = 0
iconOverlay.Parent = iconContainer
iconOverlay.Active = false

local iconOverlayCorner = iconCorner:Clone()
iconOverlayCorner.Name = "IconOverlayCorner"
iconOverlayCorner.Parent = iconOverlay


-- Notice prompts
local noticeFrame = Instance.new("ImageLabel")
noticeFrame.BackgroundTransparency = 1
noticeFrame.Name = "NoticeFrame"
noticeFrame.Position = UDim2.new(0.45, 0, 0, -2)
noticeFrame.Size = UDim2.new(1, 0, 0.7, 0)
noticeFrame.Visible = true
noticeFrame.ZIndex = 12--4
noticeFrame.ImageTransparency = 1
noticeFrame.ScaleType = Enum.ScaleType.Fit
noticeFrame.Parent = iconButton
noticeFrame.Active = false

local noticeLabel = Instance.new("TextLabel")
noticeLabel.Name = "NoticeLabel"
noticeLabel.BackgroundTransparency = 1
noticeLabel.Position = UDim2.new(0.25, 0, 0.15, 0)
noticeLabel.Size = UDim2.new(0.5, 0, 0.7, 0)
noticeLabel.Visible = true
noticeLabel.ZIndex = 13--5
noticeLabel.Font = Enum.Font.Arial
noticeLabel.Text = "0"
noticeLabel.TextTransparency = 1
noticeLabel.TextScaled = true
noticeLabel.Parent = noticeFrame
noticeLabel.Active = false


-- Captions
local captionContainer = Instance.new("Frame")
captionContainer.Name = "CaptionContainer"
captionContainer.BackgroundTransparency = 1
captionContainer.AnchorPoint = Vector2.new(0, 0)
captionContainer.ClipsDescendants = true
captionContainer.ZIndex = 30
captionContainer.Visible = true
captionContainer.Parent = iconContainer
captionContainer.Active = false

local captionFrame = Instance.new("Frame")
captionFrame.Name = "CaptionFrame"
captionFrame.BorderSizePixel = 0
captionFrame.AnchorPoint = Vector2.new(0.5,0.5)
captionFrame.Position = UDim2.new(0.5,0,0.5,0)
captionFrame.Size = UDim2.new(1,0,1,0)
captionFrame.ZIndex = 31
captionFrame.Parent = captionContainer
captionFrame.Active = false

local captionLabel = Instance.new("TextLabel")
captionLabel.Name = "CaptionLabel"
captionLabel.BackgroundTransparency = 1
captionLabel.AnchorPoint = Vector2.new(0.5,0.5)
captionLabel.Position = UDim2.new(0.5,0,0.56,0)
captionLabel.TextXAlignment = Enum.TextXAlignment.Center
captionLabel.RichText = true
captionLabel.ZIndex = 32
captionLabel.Parent = captionContainer
captionLabel.Active = false

local captionCorner = Instance.new("UICorner")
captionCorner.Name = "CaptionCorner"
captionCorner.Parent = captionFrame

local captionOverlineContainer = Instance.new("Frame")
captionOverlineContainer.Name = "CaptionOverlineContainer"
captionOverlineContainer.BackgroundTransparency = 1
captionOverlineContainer.AnchorPoint = Vector2.new(0.5,0.5)
captionOverlineContainer.Position = UDim2.new(0.5,0,-0.5,3)
captionOverlineContainer.Size = UDim2.new(1,0,1,0)
captionOverlineContainer.ZIndex = 33
captionOverlineContainer.ClipsDescendants = true
captionOverlineContainer.Parent = captionContainer
captionOverlineContainer.Active = false

local captionOverline = Instance.new("Frame")
captionOverline.Name = "CaptionOverline"
captionOverline.AnchorPoint = Vector2.new(0.5,0.5)
captionOverline.Position = UDim2.new(0.5,0,1.5,-3)
captionOverline.Size = UDim2.new(1,0,1,0)
captionOverline.ZIndex = 34
captionOverline.Parent = captionOverlineContainer
captionOverline.Active = false

local captionOverlineCorner = captionCorner:Clone()
captionOverlineCorner.Name = "CaptionOverlineCorner"
captionOverlineCorner.Parent = captionOverline

local captionVisibilityBlocker = captionFrame:Clone()
captionVisibilityBlocker.Name = "CaptionVisibilityBlocker"
captionVisibilityBlocker.BackgroundTransparency = 1
captionVisibilityBlocker.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
captionVisibilityBlocker.ZIndex -= 1
captionVisibilityBlocker.Parent = captionFrame
captionVisibilityBlocker.Active = false

local captionVisibilityCorner = captionVisibilityBlocker.CaptionCorner
captionVisibilityCorner.Name = "CaptionVisibilityCorner"


-- Tips
local tipFrame = Instance.new("Frame")
tipFrame.Name = "TipFrame"
tipFrame.BorderSizePixel = 0
tipFrame.AnchorPoint = Vector2.new(0, 0)
tipFrame.Position = UDim2.new(0,50,0,50)
tipFrame.Size = UDim2.new(1,0,1,-8)
tipFrame.ZIndex = 40
tipFrame.Parent = iconContainer
tipFrame.Active = false

local tipCorner = Instance.new("UICorner")
tipCorner.Name = "TipCorner"
tipCorner.CornerRadius = UDim.new(0.25,0)
tipCorner.Parent = tipFrame

local tipLabel = Instance.new("TextLabel")
tipLabel.Name = "TipLabel"
tipLabel.BackgroundTransparency = 1
tipLabel.TextScaled = false
tipLabel.TextSize = 12
tipLabel.Position = UDim2.new(0,3,0,3)
tipLabel.Size = UDim2.new(1,-6,1,-6)
tipLabel.ZIndex = 41
tipLabel.Parent = tipFrame
tipLabel.Active = false


-- Dropdowns
local dropdownContainer = Instance.new("Frame")
dropdownContainer.Name = "DropdownContainer"
dropdownContainer.BackgroundTransparency = 1
dropdownContainer.BorderSizePixel = 0
dropdownContainer.AnchorPoint = Vector2.new(0.5, 0)
dropdownContainer.ZIndex = -2
dropdownContainer.ClipsDescendants = true
dropdownContainer.Visible = true
dropdownContainer.Parent = iconContainer
dropdownContainer.Active = false

local dropdownFrame = Instance.new("ScrollingFrame")
dropdownFrame.Name = "DropdownFrame"
dropdownFrame.BackgroundTransparency = 1
dropdownFrame.BorderSizePixel = 0
dropdownFrame.AnchorPoint = Vector2.new(0.5, 0)
dropdownFrame.Position = UDim2.new(0.5, 0, 0, 0)
dropdownFrame.Size = UDim2.new(0.5, 2, 1, 0)
dropdownFrame.ZIndex = -1
dropdownFrame.ClipsDescendants = false
dropdownFrame.Visible = true
dropdownFrame.TopImage = dropdownFrame.MidImage
dropdownFrame.BottomImage = dropdownFrame.MidImage
dropdownFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
dropdownFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
dropdownFrame.Parent = dropdownContainer
dropdownFrame.Active = false

local dropdownList = Instance.new("UIListLayout")
dropdownList.Name = "DropdownList"
dropdownList.FillDirection = Enum.FillDirection.Vertical
dropdownList.SortOrder = Enum.SortOrder.LayoutOrder
dropdownList.Parent = dropdownFrame

local dropdownPadding = Instance.new("UIPadding")
dropdownPadding.Name = "DropdownPadding"
dropdownPadding.PaddingRight = UDim.new(0, 2)
dropdownPadding.Parent = dropdownFrame


-- Menus
local menuContainer = Instance.new("Frame")
menuContainer.Active = true
menuContainer.Selectable = false
menuContainer.Name = "MenuContainer"
menuContainer.BackgroundTransparency = 1
menuContainer.BorderSizePixel = 0
menuContainer.AnchorPoint = Vector2.new(1, 0)
menuContainer.Size = UDim2.new(0, 500, 0, 50)
menuContainer.ZIndex = -2
menuContainer.ClipsDescendants = true
menuContainer.Visible = true
menuContainer.Parent = iconContainer
menuContainer.Active = false

local menuFrame = Instance.new("ScrollingFrame")
menuFrame.Active = true
menuFrame.Selectable = true
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


-- Click Sound
local clickSound = Instance.new("Sound")
clickSound.Name = "ClickSound"
clickSound.Volume = 0
clickSound.Parent = iconContainer


-- Other
local indicator = Instance.new("ImageLabel")
indicator.Name = "Indicator"
indicator.BackgroundTransparency = 1
indicator.Image = "rbxassetid://5278151556"
indicator.Size = UDim2.new(0,32,0,32)
indicator.AnchorPoint = Vector2.new(0.5,0)
indicator.Position = UDim2.new(0.5,0,0,5)
indicator.ScaleType = Enum.ScaleType.Fit
indicator.Visible = false
indicator.Active = true
indicator.Parent = topbarPlusGui
indicator.Active = false



-- PARENT
local localPlayer = game:GetService("Players").LocalPlayer
local playerGui = localPlayer.PlayerGui
topbarPlusGui.Parent = playerGui



return topbarPlusGui