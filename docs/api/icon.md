[themes]: https://1foreverhd.github.io/TopbarPlus/features/#themes
[set method]: https://1foreverhd.github.io/TopbarPlus/api/icon/#set

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
{chainable}
```lua
icon:set(settingName, value, toggleState)
```
Applies a specific setting to an icon. All settings can be found [here](https://github.com/1ForeverHD/TopbarPlus/blob/main/src/Icon/Themes/Default.lua). If the setting falls under the 'toggleable' category then "deselected" or "selected" can be specified, otherwise if left empty or ``nil`` will apply to both states. For most scenarious, it's recommended instead to apply settings using [themes].

----
#### get
```lua
local value = icon:get(settingName, toggleState)
```
Retrieves the given settings value. If the setting falls under the 'toggleable' category then "deselected" or "selected" can be specified, otherwise if left empty or ``nil`` will default to retrieving the deselected value.

----
#### getToggleState
```lua
local selectedOrDeselectedString = icon:getToggleState()
```
Returns the current toggleState, either "deselected" or "selected".

----
#### setTheme
{chainable}
```lua
icon:setTheme(theme)
```
Applies a theme to the given icon. See [themes] for more information.

----
#### setEnabled
{chainable}
```lua
icon:setEnabled(bool)
```
When set to ``false``, the icon will be disabled and hidden.

----
#### setName
{chainable}
```lua
icon:setName(string)
```
Associates the given name to the icon which enables it to be retrieved with ``IconController.getIcon(name)``.

----
#### select
{chainable}
```lua
icon:select()
```
Selects the icon (as if it were clicked once).

----
#### deselect
{chainable}
```lua
icon:deselect()
```
Deselects the icon (as if it were clicked, then clicked again).

----
#### notify
{chainable}
```lua
icon:notify(clearNoticeEvent)
```
Prompts a notice bubble which accumulates the further it is prompted. If the icon belongs to a dropdown or menu, then the notice will appear on the parent icon when the parent icon is deselected.

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
When set to ``true``, disables the shade effect which appears when the icon is pressed and released.

----
#### setImage
{chainable} {toggleable}
```lua
icon:setImage(imageId, toggleState)
```
Applies an image to the icon based on the given ``imaageId``. ``imageId`` can be an assetId or a complete asset string.

----
#### setLabel
{chainable} {toggleable}
```lua
icon:setLabel(text, toggleState)
```

----
#### setOrder
{chainable} {toggleable}
```lua
icon:setOrder(order, toggleState)
```

----
#### setCornerRadius
{chainable} {toggleable}
```lua
icon:setCornerRadius(scale, offset, toggleState)
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
Defines the proportional space the icons image takes up within the icons container.

----
#### setImageRatio
{chainable} {toggleable}
```lua
icon:setImageRatio(ratio, toggleState)
```
Defines the x:y ratio dimensions as a number. By default ``ratio`` is ``1.00``.

----
#### setLabelYScale
{chainable} {toggleable}
```lua
icon:setLabelYScale(YScale, toggleState)
```
Defines how large label text appears.By default ``YScale`` is ``0.45``.

----
#### setBaseZIndex
{chainable} {toggleable}
```lua
icon:setBaseZIndex(ZIndex, toggleState)
```
Calculates the difference between the existing baseZIndex (i.e. ``instances.iconContainer.ZIndex``) and new value, then updates the ZIndex of all objects within the icon accoridngly using this difference.

----
#### setSize
{chainable} {toggleable}
```lua
icon:setSize(XOffset, YOffset, toggleState)
```
Determines the icons container size. By default ``XOffset`` and ``YOffset`` are ``32``.

----
#### bindToggleItem
{chainable}
```lua
icon:bindToggleItem(guiObjectOrLayerCollector)
```
Binds a GuiObject or LayerCollector to appear and disappeared when the icon is toggled.

----
#### unbindToggleItem
{chainable}
```lua
icon:unbindToggleItem(guiObjectOrLayerCollector)
```
Unbinds the given GuiObject or LayerCollector from the toggle.

----
#### bindEvent
{chainable}
```lua
icon:bindEvent(iconEventName, eventFunction)
```
Connects to an [icon event](https://1foreverhd.github.io/TopbarPlus/api/icon/#events) based upon the given ``iconEventName`` and call ``eventFunction`` with arguments ``(self, ...)`` when the event is triggered.

----
#### unbindEvent
{chainable}
```lua
icon:unbindEvent(iconEventName)
```
Unbinds the connection of the associated ``iconEventName``.

----
#### bindToggleKey
{chainable}
```lua
icon:bindToggleKey(keyCodeEnum)
```
Binds a [keycode](https://developer.roblox.com/en-us/api-reference/enum/KeyCode) which toggles the icon when pressed.

----
#### unbindToggleKey
{chainable}
```lua
icon:unbindToggleKey(keyCodeEnum)
```
Unbinds the given keycode.

----
#### lock
{chainable}
```lua
icon:lock()
```
Prevents the icon from being pressed and toggled.

----
#### unlock
{chainable}
```lua
icon:unlock()
```
Enables the icon to be pressed and toggled.

----
#### setTopPadding
{chainable}
```lua
icon:setTopPadding(offset, scale)
```
The gap between the top of the screen and the icon.

----
#### setTip
{chainable}
```lua
icon:setTip(text)
```
Sets a tip. To remove, pass ``nil`` as ``text``.

----
#### setCaption
{chainable}
```lua
icon:setCaption(text)
```
Sets a caption. To remove, pass ``nil`` as ``text``.

----
#### join
{chainable}
```lua
icon:join(parentIcon, featureName)
```
Parents the icon to the given parentIcon under the specified feature, either "dropdown" or "menu".

----
#### leave
{chainable}
```lua
icon:leave()
```
Unparents an icon from a parentIcon if it belongs to a dropdown or menu.

----
#### setDropdown
{chainable}
```lua
icon:setDropdown(arrayOfIcons)
```
Creates a vertical dropdown based upon the given ``table array`` of ``icons``. Pass an empty table ``{}`` to remove the dropdown. Dropdown settings can be configured using [themes] or the [set method].

----
#### setMenu
{chainable}
```lua
icon:setMenu(arrayOfIcons)
```
Creates a horizontal menu based upon the given ``table array`` of ``icons``. Pass an empty table ``{}`` to remove the menu. Menu settings can be configured using [themes] or the [set method].

----
#### destroy
{chainable}
```lua
icon:destroy()
```
Clears all connections and destroys all instances associated with the icon.

----



## Events
#### selected 
```lua
icon.selected:Connect(function()
    print("The icon was selected")
end)
```

----
#### deselected 
```lua
icon.deselected:Connect(function()
    print("The icon was deselected")
end)
```

----
#### toggled 
```lua
icon.toggled:Connect(function(isSelected)
    print(("The icon was %s"):format(icon:getToggleState(isSelected)))
end)
```

----
#### hoverStarted 
```lua
icon.hoverStarted:Connect(function()
    print("A mouse, finger or controller selection is hovering over the icon")
end)
```

----
#### hoverEnded 
```lua
icon.hoverEnded:Connect(function()
    print("The item is no longer hovering over the icon")
end)
```

----
#### dropdownOpened 
```lua
icon.dropdownOpened:Connect(function()
    print("The dropdown was opened")
end)
```

----
#### dropdownClosed 
```lua
icon.dropdownClosed:Connect(function()
    print("The dropdown was closed")
end)
```

----
#### menuOpened 
```lua
icon.menuOpened:Connect(function()
    print("The menu was opened")
end)
```

----
#### menuClosed 
```lua
icon.menuClosed:Connect(function()
    print("The menu was closed")
end)
```

----
#### notified 
```lua
icon.notified:Connect(function()
    print("New notice")
end)
```

----



## Properties
#### deselectWhenOtherIconSelected
```lua
local bool = icon.deselectWhenOtherIconSelected --[default: 'true']
```
A bool deciding whether the icon will be deselected when another icon is selected. Defaults to ``true``.

----
#### accountForWhenDisabled
```lua
local bool = icon.accountForWhenDisabled --[default: 'false']
```
A bool deciding whether to continue accounting for and updating the icons position on the topbar when disabled

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
local int = icon.totalNotices
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
The position the icon is at or aims to move to.
