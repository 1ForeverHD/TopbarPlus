[themes]: https://1foreverhd.github.io/TopbarPlus/features/#modify-theme
[alignments]: https://1foreverhd.github.io/TopbarPlus/features/#alignments
[font family]: https://create.roblox.com/docs/reference/engine/datatypes/Font/#fromEnum
[toggle keys]: https://1foreverhd.github.io/TopbarPlus/features/#toggle-keys
[captions]: https://1foreverhd.github.io/TopbarPlus/features/#captions
[icon event]: https://1foreverhd.github.io/TopbarPlus/api/#events
[menus]: https://1foreverhd.github.io/TopbarPlus/features/#menus
[dropdowns]: https://1foreverhd.github.io/TopbarPlus/features/#dropdowns
[numberSpinner]: https://devforum.roblox.com/t/numberspinner-module/1105961

## Functions

#### getIcons
```lua
local icons = Icon.getIcons()
```
Returns a dictionary of icons where the key is the icon's UID and value the icon.

----
#### getIcon
```lua
local icon = Icon.getIcon(nameOrUID)
```
Returns an icon of the given name or UID.

----
#### setTopbarEnabled
```lua
Icon.setTopbarEnabled(bool)
```
When set to ``false`` all TopbarPlus ScreenGuis are hidden. This does not impact Roblox's Topbar.

----
#### modifyBaseTheme
```lua
Icon.modifyBaseTheme(modifications)
```
Updates the appearance of *all* icons. See [themes] for more details.

----
#### setDisplayOrder
```lua
Icon.setDisplayOrder(integer)
```
Sets the base DisplayOrder of all TopbarPlus ScreenGuis.

----



## Constructors

#### new
```lua
local icon = Icon.new()
```
Constructs an empty ``32x32`` icon on the topbar.

----



## Methods

#### setName
{chainable}
```lua
icon:setName(name)
```
Sets the name of the Widget instance. This can be used in conjunction with ``Icon.getIcon(name)``.

----
#### getInstance
```lua
local instance = icon:getInstance(instanceName)
```
Returns the first descendant found within the widget of name ``instanceName``.

----
#### modifyTheme
{chainable}
```lua
icon:modifyTheme(modifications)
```
Updates the appearance of the icon. See [themes] for more details.

----
#### modifyChildTheme
{chainable}
```lua
icon:modifyChildTheme(modifications)
```
Updates the appearance of all icons that are parented to this icon (for example when a menu or dropdown). See [themes] for more details.

----
#### setEnabled
{chainable}
```lua
icon:setEnabled(bool)
```
When set to ``false`` the icon will be disabled and hidden.

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
#### disableOverlay
{chainable}
```lua
icon:disableStateOverlay(bool)
```
When set to ``true``, disables the shade effect which appears when the icon is pressed and released.

----
#### setImage
{chainable} {toggleable}
```lua
icon:setImage(imageId, iconState)
```
Applies an image to the icon based on the given ``imageId``. ``imageId`` can be an assetId or a complete asset string.

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
#### align
{chainable}
```lua
icon:align(alignment)
```
This enables you to set the icon to the ``"Left"`` (default), ``"Center"`` or ``"Right"`` side of the screen. See [alignments] for more details.

----
#### setWidth
{chainable} {toggleable}
```lua
icon:setWidth(minimumSize, iconState)
```
This sets the minimum width the icon can be (it can be larger for instance when setting a long label). The default width is ``44``.

----
#### setImageScale
{chainable} {toggleable}
```lua
icon:setImageScale(number, iconState)
```
How large the image is relative to the icon. The default value is ``0.5``.

----
#### setImageRatio
{chainable} {toggleable}
```lua
icon:setImageRatio(number, iconState)
```
How stretched the image will appear. The default value is ``1`` (a perfect square).

----
#### setTextSize
{chainable} {toggleable}
```lua
icon:setTextSize(number, iconState)
```
The size of the icon labels' text. The default value is ``16``.

----
#### setTextFont
{chainable} {toggleable}
```lua
icon:setTextFont(font, fontWeight, fontStyle, iconState)
```
Sets the labels FontFace. ``font`` can be a [font family] name (such as `"Creepster"`), a font enum (such as `Enum.Font.Bangers`), a font ID (such as `12187370928`) or [font family] link (such as `"rbxasset://fonts/families/Sarpanch.json"`).

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
icon:bindEvent(iconEventName, callback)
```
Connects to an [icon event] with ``iconEventName``. It's important to remember all event names are in camelCase. ``callback`` is called with arguments ``(self, ...)`` when the event is triggered.

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
Binds a [keycode](https://developer.roblox.com/en-us/api-reference/enum/KeyCode) which toggles the icon when pressed. See [toggle keys] for more details.

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
Calls the function immediately via ``task.spawn``. The first argument passed is the icon itself. This is useful when needing to extend the behaviour of an icon while remaining in the chain.

----
#### addToJanitor
{chainable}
```lua
icon:addToJanitor(userdata)
```
Passes the given userdata to the icons janitor to be destroyed/disconnected on the icons destruction. If a function is passed, it will be called when the icon is destroyed.

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
When set to ``true`` (the default) the icon is deselected when another icon (with autoDeselect enabled) is pressed. Set to ``false`` to prevent the icon being deselected when another icon is selected (a useful behaviour in dropdowns).

----
#### oneClick
{chainable}
```lua
icon:oneClick(bool)
```
When set to true the icon will automatically deselect when selected. This creates the effect of a single click button.

----
#### setCaption
{chainable}
```lua
icon:setCaption(text)
```
Sets a caption. To remove, pass ``nil`` as ``text``. See [captions] for more details.

----
#### setCaptionHint
{chainable}
```lua
icon:setCaptionHint(keyCodeEnum)
```
This customizes the appearance of the caption's hint without having to use ``icon:bindToggleKey``. 

----
#### setDropdown
{chainable}
```lua
icon:setDropdown(arrayOfIcons)
```
Creates a vertical dropdown based upon the given ``table array`` of ``icons``. Pass an empty table ``{}`` to remove the dropdown. See [dropdowns] for more details.

----
#### joinDropdown
{chainable}
```lua
icon:joinDropdown(parentIcon)
```
Joins the dropdown of `parentIcon`. This is what ``icon:setDropdown`` calls internally on the icons within its array.

----
#### setMenu
{chainable}
```lua
icon:setMenu(arrayOfIcons)
```
Creates a horizontal menu based upon the given array of icons. Pass an empty table ``{}`` to remove the menu. See [menus] for more details.

----
#### joinMenu
{chainable}
```lua
icon:joinMenu(parentIcon)
```
Joins the menu of `parentIcon`. This is what ``icon:setMenu`` calls internally on the icons within its array.

----
#### leave
{chainable}
```lua
icon:leave()
```
Unparents an icon from a parentIcon if it belongs to a dropdown or menu.

----
#### convertLabelToNumberSpinner
{chainable}
```lua
icon:convertLabelToNumberSpinner(numberSpinner)
```
Accepts a [numberSpinner] and converts the icon's label into that spinner. For example:
```lua
Icon.new()
	:align("Right")
	:setLabel("Points")
	:setWidth(80)
	:call(function(pointsIcon)
		local NumberSpinner = require(ReplicatedStorage.NumberSpinner)
		local numberSpinner = NumberSpinner.new()
		pointsIcon:convertLabelToNumberSpinner(numberSpinner)
		numberSpinner.Name = "LabelSpinner"
		numberSpinner.Prefix = "$"
		numberSpinner.Commas = true
		numberSpinner.Decimals = 0
		numberSpinner.Duration = 0.25
		while true do
			numberSpinner.Value = math.random(1,1000)
			task.wait(1)
		end
	end)
```

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
icon.selected:Connect(function(fromSource)
    -- fromSource can be useful for checking if the behaviour was triggered by a user (such as clicking)
    -- fromSource values include "User", "OneClick", "AutoDeselect", "HideParentFeature", "Overflow"
    local sourceName = fromSource or "Unknown"
    print("The icon was selected by the "..sourceName)
end)
```

----
#### deselected 
```lua
icon.deselected:Connect(function(fromSource)
    local sourceName = fromSource or "Unknown"
    print("The icon was deselected by the "..sourceName)
end)
```

----
#### toggled 
```lua
icon.toggled:Connect(function(isSelected, fromSource)
    local stateName = (isSelected and "selected") or "deselected"
    print(`The icon was {stateName}!`)
end)
```

----
#### viewingStarted 
```lua
icon.viewingStarted:Connect(function()
    print("A mouse, long-pressed finger or gamepad selection is hovering over the icon")
end)
```

----
#### viewingEnded 
```lua
icon.viewingEnded:Connect(function()
    print("The input is no longer viewing (hovering over) the icon")
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
#### name
{read-only}
```lua
local string = icon.name --[default: "Widget"]
```

----
#### isSelected
{read-only}
```lua
local bool = icon.isSelected
```

----
#### isEnabled
{read-only}
```lua
local bool = icon.isEnabled
```

----
#### totalNotices
{read-only}
```lua
local int = icon.totalNotices
```

----
#### locked
{read-only}
```lua
local bool = icon.locked
```
