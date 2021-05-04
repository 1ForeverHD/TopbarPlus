--[[
This file is necessary for constructing the default Icon template
Do not remove this module otherwise TopbarPlus will break
Modifying this file may also cause TopbarPlus to break
It's recommended instead to create a separate theme module and use that instead

To apply your theme after creating it, do:
```lua
local IconController = require(pathway.to.IconController)
local Themes = require(pathway.to.Themes)
IconController.setGameTheme(Themes.YourThemeName)
```

or by applying to an individual icon:
```lua
local Icon = require(pathway.to.Icon)
local Themes = require(pathway.to.Themes)
local newIcon = Icon.new()
    :setTheme(Themes.YourThemeName)
```
--]]

return {
    
    -- Settings which describe how an item behaves or transitions between states
    action =  {
        toggleTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        resizeInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        repositionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        captionFadeInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        tipFadeInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        dropdownSlideInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        menuSlideInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    },

    -- Settings which describe how an item appears when 'deselected' and 'selected'
    toggleable = {
        -- How items appear normally (i.e. when they're 'deselected')
        deselected = {
            iconBackgroundColor = Color3.fromRGB(0, 0, 0),
            iconBackgroundTransparency = 0.5,
            iconCornerRadius = UDim.new(0.25, 0),
            iconGradientColor = ColorSequence.new(Color3.fromRGB(255, 255, 255)),
            iconGradientRotation = 0,
            iconImage = "",
            iconImageColor =Color3.fromRGB(255, 255, 255),
            iconImageTransparency = 0,
            iconImageYScale = 0.63,
            iconImageRatio = 1,
            iconLabelYScale = 0.45,
            iconScale = UDim2.new(1, 0, 1, 0),
            forcedIconSize = UDim2.new(0, 32, 0, 32);
            iconSize = UDim2.new(0, 32, 0, 32),
            iconOffset = UDim2.new(0, 0, 0, 0),
            iconText = "",
            iconTextColor = Color3.fromRGB(255, 255, 255),
            iconFont = Enum.Font.GothamSemibold,
            noticeCircleColor = Color3.fromRGB(255, 255, 255),
            noticeCircleImage = "http://www.roblox.com/asset/?id=4871790969",
            noticeTextColor = Color3.fromRGB(31, 33, 35),
            baseZIndex = 1,
            order = 1,
            alignment = "left",
            clickSoundId = "rbxassetid://5273899897",
            clickVolume = 0,
            clickPlaybackSpeed = 1,
            clickTimePosition = 0.12
        },
        -- How items appear after the icon has been clicked (i.e. when they're 'selected')
        -- If a selected value is not specified, it will default to the deselected value
        selected = {
            iconBackgroundColor = Color3.fromRGB(245, 245, 245),
            iconBackgroundTransparency = 0.1,
            iconImageColor = Color3.fromRGB(57, 60, 65),
            iconTextColor = Color3.fromRGB(57, 60, 65),
            clickPlaybackSpeed = 1.5,
        }
    },

    -- Settings where toggleState doesn't matter (they have a singular state)
    other = {
        -- Caption settings
        captionBackgroundColor = Color3.fromRGB(0, 0, 0),
        captionBackgroundTransparency = 0.5,
        captionTextColor = Color3.fromRGB(255, 255, 255),
        captionTextTransparency = 0,
        captionFont = Enum.Font.GothamSemibold,
        captionOverlineColor = Color3.fromRGB(0, 170, 255),
        captionOverlineTransparency = 0,
        captionCornerRadius = UDim.new(0.25, 0),
        -- Tip settings
        tipBackgroundColor = Color3.fromRGB(255, 255, 255),
        tipBackgroundTransparency = 0.1,
        tipTextColor = Color3.fromRGB(27, 42, 53),
        tipTextTransparency = 0,
        tipFont = Enum.Font.GothamSemibold,
        tipCornerRadius = UDim.new(0.175, 0),
        -- Dropdown settings
        dropdownAlignment = "auto", -- 'left', 'mid', 'right' or 'auto' (auto is where the dropdown alignment matches the icons alignment)
        dropdownMaxIconsBeforeScroll = 3,
        dropdownMinWidth = 32,
        dropdownSquareCorners = false,
        dropdownBindToggleToIcon = true,
        dropdownToggleOnLongPress = false,
        dropdownToggleOnRightClick = false,
        dropdownCloseOnTapAway = false,
        dropdownHidePlayerlistOnOverlap = true,
        dropdownListPadding = UDim.new(0, 2),
        dropdownScrollBarColor = Color3.fromRGB(25, 25, 25),
        dropdownScrollBarTransparency = 0.2,
        dropdownScrollBarThickness = 4,
        -- Menu settings
        menuDirection = "auto", -- 'left', 'right' or 'auto' (for auto, if alignment is 'left' or 'mid', menuDirection will be 'right', else menuDirection is 'left')
        menuMaxIconsBeforeScroll = 4,
        menuBindToggleToIcon = true,
        menuToggleOnLongPress = false,
        menuToggleOnRightClick = false,
        menuCloseOnTapAway = false,
        menuScrollBarColor = Color3.fromRGB(25, 25, 25),
        menuScrollBarTransparency = 0.2,
        menuScrollBarThickness = 4,
    },
    
}