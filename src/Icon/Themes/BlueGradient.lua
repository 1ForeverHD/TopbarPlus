-- BlueGradient by ForeverHD
local selectedColor = Color3.fromRGB(0, 170, 255)
local selectedColorDarker = Color3.fromRGB(0, 120, 180)
local neutralColor = Color3.fromRGB(255, 255, 255)
return {
    
    -- Settings which describe how an item behaves or transitions between states
    action =  {
        resizeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back),
        repositionInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back),
    },
    
    -- Settings which describe how an item appears when 'deselected' and 'selected'
    toggleable = {
        -- How items appear normally (i.e. when they're 'deselected')
        deselected = {
            iconGradientColor = ColorSequence.new(selectedColor, selectedColorDarker),
            iconGradientRotation = 90,
            noticeCircleColor = selectedColor,
            noticeCircleImage = "http://www.roblox.com/asset/?id=4882430005",
            noticeTextColor = neutralColor,
            captionOverlineColor = selectedColor,
        },
        -- How items appear after the icon has been clicked (i.e. when they're 'selected')
        -- If a selected value is not specified, it will default to the deselected value
        selected = {
            iconBackgroundColor = Color3.fromRGB(255, 255, 255),
            iconBackgroundTransparency = 0.1,
            iconGradientColor = ColorSequence.new(selectedColor, selectedColorDarker),
            iconGradientRotation = 90,
            iconImageColor = Color3.fromRGB(255, 255, 255),
            iconTextColor = Color3.fromRGB(255, 255, 255),
            noticeCircleColor = neutralColor,
            noticeTextColor = selectedColor,
        }
    },
    
    -- Settings where toggleState doesn't matter (they have a singular state)
    other =  {},
    
}
