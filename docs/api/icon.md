## Construtors

#### new
```lua
local icon = Icon.new()
```
Constructs an empty ``32x32`` icon on the topbar.

----
#### mimic
{unstable}
```lua
local icon = Icon.mimic(coreIconName)
```
Constructs an icon to replace its CoreGui equivalent and accurately mimic its behaviour. This allows for the persistence of core gui items (such as the chatbar, leaderboard, emotes, etc) while having full control over the appearance and behaviour of the icon to toggle it.

Mimicable Items: ``"PlayerList"``, ``"Backpack"``, ``"Chat"``, ``"EmotesMenu"``

!!! danger
    Due to recent unannounced changes Roblox have completely restricted the ability to accurately mimic core items such as Chat. Until this is resolved the ``mimic`` constructor will not work as intended.

----



## Methods

#### set
{chainable} {toggleable}
```lua
icon:set(settingName, value, toggleState)
```

----
#### get
{toggleable}
```lua
local value = icon:get(settingName, toggleState)
```

----
#### getToggleState
```lua
local selectedOrDeselectedString = icon:getToggleState()
```

----
#### setTheme
{chainable}
```lua
icon:setTheme(theme)
```

----
#### setEnabled
{chainable}
```lua
icon:setEnabled(bool)
```

----
#### setName
{chainable}
```lua
icon:setName(string)
```

----
#### select
{chainable}
```lua
icon:select()
```

----
#### deselect
{chainable}
```lua
icon:deselect()
```

----
#### notify
{chainable}
```lua
icon:notify(clearNoticeEvent)
```

----
#### clearNotices
{chainable}
```lua
icon:clearNotices()
```

----
#### disableStateOverlay
{chainable}
```lua
icon:disableStateOverlay(bool)
```

----
#### setLabel
{chainable} {toggleable}
```lua
icon:setLabel(text, toggleState)
```

----
#### setCornerRadius
{chainable} {toggleable}
```lua
icon:setCornerRadius(scale, offset, toggleState)
```

----
#### setImage
{chainable} {toggleable}
```lua
icon:setImage(imageId, toggleState)
```

----
#### setOrder
{chainable} {toggleable}
```lua
icon:setOrder(order, toggleState)
```

----
#### setLeft
{chainable} {toggleable}
```lua
icon:setLeft(toggleState)
```

----
#### setMid
{chainable} {toggleable}
```lua
icon:setMid(toggleState)
```

----
#### setRight
{chainable} {toggleable}
```lua
icon:setRight(toggleState)
```

----
#### setImageYScale
{chainable} {toggleable}
```lua
icon:setImageYScale(YScale, toggleState)
```

----
#### setImageRatio
{chainable} {toggleable}
```lua
icon:setImageRatio(ratio, toggleState)
```

----
#### setLabelYScale
{chainable} {toggleable}
```lua
icon:setLabelYScale(YScale, toggleState)
```

----
#### setBaseZIndex
{chainable} {toggleable}
```lua
icon:setBaseZIndex(ZIndex, toggleState)
```

----
#### setSize
{chainable} {toggleable}
```lua
icon:setSize(XOffset, YOffset, toggleState)
```

----
#### bindToggleItem
{chainable}
```lua
icon:bindToggleItem(guiObjectOrLayerCollector)
```

----
#### unbindToggleItem
{chainable}
```lua
icon:unbindToggleItem(guiObjectOrLayerCollector)
```

----
#### bindToggleKey
{chainable}
```lua
icon:bindToggleKey(keyCodeEnum)
```

----
#### unbindToggleKey
{chainable}
```lua
icon:unbindToggleKey(keyCodeEnum)
```

----
#### lock
{chainable}
```lua
icon:lock()
```

----
#### unlock
{chainable}
```lua
icon:unlock()
```

----
#### setTopPadding
{chainable}
```lua
icon:setTopPadding(offset, scale)
```

----
#### setTip
{chainable}
```lua
icon:setTip(text)
```

----
#### setCaption
{chainable}
```lua
icon:setCaption(text)
```

----
#### join
{chainable}
```lua
icon:join(parentIcon, featureName)
```

----
#### leave
{chainable}
```lua
icon:leave()
```

----
#### setDropdown
{chainable}
```lua
icon:setDropdown(arrayOfIcons)
```

----
#### setMenu
{chainable}
```lua
icon:setMenu(arrayOfIcons)
```

----
#### destroy
{chainable}
```lua
icon:destroy()
```

----



## Events
#### selected 
```lua
icon.selected:Connect(function()
    print()
end)
```

----
#### deselected 
```lua
icon.deselected:Connect(function()
    print()
end)
```

----
#### toggled 
```lua
icon.toggled:Connect(function(isSelected)
    print()
end)
```

----
#### hoverStarted 
```lua
icon.hoverStarted:Connect(function()
    print()
end)
```

----
#### hoverEnded 
```lua
icon.hoverEnded:Connect(function()
    print()
end)
```

----
#### dropdownOpened 
```lua
icon.dropdownOpened:Connect(function()
    print()
end)
```

----
#### dropdownClosed 
```lua
icon.dropdownClosed:Connect(function()
    print()
end)
```

----
#### menuOpened 
```lua
icon.menuOpened:Connect(function()
    print()
end)
```

----
#### menuClosed 
```lua
icon.menuClosed:Connect(function()
    print()
end)
```

----
#### notified 
```lua
icon.notified:Connect(function()
    print()
end)
```

----



## Properties
#### deselectWhenOtherIconSelected
```lua
local bool = icon.deselectWhenOtherIconSelected --[default: 'true']
```

----
#### name
{read-only}
```lua
local string = icon.name --[default: '"Unnamed Icon"']
```

----
#### isSelected
{read-only}
```lua
local bool = icon.isSelected
```

----
#### enabled
{read-only}
```lua
local bool = icon.enabled
```

----
#### hovering
{read-only}
```lua
local bool = icon.hovering
```

----
#### tipText
{read-only}
```lua
local stringOrNil = icon.tipText
```

----
#### captionText
{read-only}
```lua
local stringOrNil = icon.captionText
```

----
#### totalNotices
{read-only}
```lua
local BBB = icon.totalNotices
```

----
#### dropdownIcons
{read-only}
```lua
local arrayOfIcons = icon.dropdownIcons
```

----
#### menuIcons
{read-only}
```lua
local arrayOfIcons = icon.menuIcons
```

----
#### dropdownOpen
{read-only}
```lua
local bool = icon.dropdownOpen
```

----
#### menuOpen
{read-only}
```lua
local bool = icon.menuOpen
```

----
#### locked
{read-only}
```lua
local bool = icon.locked
```

----
#### topPadding
{read-only}
```lua
local udim = icon.topPadding
```

----
#### targetPosition
{read-only}
```lua
local udim2 = icon.targetPosition
```
