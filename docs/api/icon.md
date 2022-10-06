[themes]: https://1foreverhd.github.io/TopbarPlus/features/#themes
[set method]: https://1foreverhd.github.io/TopbarPlus/api/icon/#set

## Constructors

#### new
```lua
local icon = Icon.new()
```
Constructs an empty ``32x32`` icon on the topbar.

----



## Methods

#### set
{chainable}
```lua
icon:set(settingName, value, iconState)
```
Applies a specific setting to an icon. All settings can be found [here](https://github.com/1ForeverHD/TopbarPlus/blob/main/src/Icon/Themes/Default.lua). If the setting falls under the 'toggleable' category then an iconState can be specified. For most scenarious it's recommended instead to apply settings using [themes].

----
#### get
```lua
local value = icon:get(settingName, iconState)
```
Retrieves the given settings value. If the setting falls under the 'toggleable' category then an iconState can be specified.

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
#### setProperty
{chainable}
```lua
icon:setProperty(propertyName, value)
```
An alternative way of doing ``zone[propertyName] = value``. This enables the easy-configuration of icon properties within chained methods.

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
#### convertLabelToNumberSpinner
{chainable}
```lua
icon:convertLabelToNumberSpinner(numberSpinner)
```
Takes a [NumberSpinner](https://devforum.roblox.com/t/numberspinner-module/1105961) object (by boatbomber) and converts it into the icons label.

Example usage:

```lua
Icon.new()
    :setName("CashSpinnerIcon")
    :setRight()
    :lock()
    :setSize(100, 32)
    :give(function(icon)
        local NumberSpinner = require(replicatedStorage.NumberSpinner)
        local labelSpinner = NumberSpinner.new()
        icon:convertLabelToNumberSpinner(labelSpinner)
        labelSpinner.Name = "LabelSpinner"
        labelSpinner.Decimals = 3
        labelSpinner.Duration = 0.25
        coroutine.wrap(function()
            while wait(0.5) do
                labelSpinner.Value = math.random(100000)/1000
            end
        end)()
    end)
```

----
#### setImage
{chainable} {toggleable}
```lua
icon:setImage(imageId, iconState)
```
Applies an image to the icon based on the given ``imaageId``. ``imageId`` can be an assetId or a complete asset string.

----
#### setLabel
{chainable} {toggleable}
```lua
icon:setLabel(text, iconState)
```

----
#### setOrder
{chainable} {toggleable}
```lua
icon:setOrder(order, iconState)
```

----
#### setCornerRadius
{chainable} {toggleable}
```lua
icon:setCornerRadius(scale, offset, iconState)
```

----
#### setLeft
{chainable} {toggleable}
```lua
icon:setLeft(iconState)
```

----
#### setMid
{chainable} {toggleable}
```lua
icon:setMid(iconState)
```

----
#### setRight
{chainable} {toggleable}
```lua
icon:setRight(iconState)
```

----
#### setImageYScale
{chainable} {toggleable}
```lua
icon:setImageYScale(YScale, iconState)
```
Defines the proportional space the icons image takes up within the icons container.

----
#### setImageRatio
{chainable} {toggleable}
```lua
icon:setImageRatio(ratio, iconState)
```
Defines the x:y ratio dimensions as a number. By default ``ratio`` is ``1.00``.

----
#### setLabelYScale
{chainable} {toggleable}
```lua
icon:setLabelYScale(YScale, iconState)
```
Defines how large label text appears.By default ``YScale`` is ``0.45``.

----
#### setBaseZIndex
{chainable} {toggleable}
```lua
icon:setBaseZIndex(ZIndex, iconState)
```
Calculates the difference between the existing baseZIndex (i.e. ``instances.iconContainer.ZIndex``) and new value, then updates the ZIndex of all objects within the icon accoridngly using this difference.

----
#### setSize
{chainable} {toggleable}
```lua
icon:setSize(XOffset, YOffset, iconState)
```
Determines the icons container size. By default ``XOffset`` and ``YOffset`` are ``32``.

----
#### setXSize
{chainable} {toggleable}
```lua
icon:setXSize(XOffset, iconState)
```
Same as ``icon:setSize`` except only for the X Offset (the Y offset is generated automatically).

----
#### setYSize
{chainable} {toggleable}
```lua
icon:setYSize(XOffset, iconState)
```
Same as ``icon:setSize`` except only for the Y Offset (the X offset is generated automatically).

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
#### call
{chainable}
```lua
icon:call(func)
```
Calls the function as a separate coroutine with the first argument being the icon itself. This is useful when needing to extend the behaviour of an icon while remaining in the chain.

----
#### give
{chainable}
```lua
icon:give(userdata)
```
Passes the given userdata to the Icons maid to be destroyed/disconnected on the icons destruction. If a function is passed, it will be executed right away with its self (the icon) being passed as the first argument. The return value is then given to the maid (instead of the function).

----
#### lock
{chainable}
```lua
icon:lock()
```
Prevents the icon being toggled by user-input (such as clicking) however the icon can still be toggled via localscript using methods such as ``icon:select()``.

----
#### unlock
{chainable}
```lua
icon:unlock()
```
Re-enables user-input to toggle the icon again.

----
#### debounce
{chainable} {yields}
```lua
icon:debounce(seconds)
```
Locks the icon, yields for the given time, then unlocks the icon, effectively shorthand for ``icon:lock() task.wait(seconds) icon:unlock()``. This is useful for applying cooldowns (to prevent an icon from being pressed again) after an icon has been selected or deselected. 

----
#### autoDeselect
{chainable}
```lua
icon:autoDeselect(true)
```
When set to ``true`` (the default) the icon is deselected when another icon (with autoDeselect enabled) is pressed. Set to ``false`` to prevent the icon being deselected when another icon is selected (a useful behaviour in dropdowns). This is a shorthand alternative to doing ``icon:setProperty("deselectWhenOtherIconSelected", true)``.

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
    print("The icon was selected (either via localscript or the user)")
end)
```

----
#### deselected 
```lua
icon.deselected:Connect(function()
    print("The icon was deselected (either via localscript or the user)")
end)
```

----
#### toggled 
```lua
icon.toggled:Connect(function(isSelected)
    print(("The icon was %s (either via localscript or the user)"):format(icon:getToggleState(isSelected)))
end)
```

#### userSelected 
```lua
icon.userSelected:Connect(function()
    print("The icon was selected (solely by the user)")
end)
```

----
#### userDeselected 
```lua
icon.userDeselected:Connect(function()
    print("The icon was deselected (solely by the user)")
end)
```

----
#### userToggled 
```lua
icon.userToggled:Connect(function(isSelected)
    print(("The icon was %s (solely by the user)"):format(icon:getToggleState(isSelected)))
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
This property can be updated either by doing ``icon:autoDeselect(bool)`` or ``icon:setProperty("deselectWhenOtherIconSelected", bool)``.

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
