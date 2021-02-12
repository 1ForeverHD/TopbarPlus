## Functions

#### setGameTheme
```lua
IconController.setGameTheme(theme)
```
Sets the default theme which is applied to all existing and future icons.

----
#### setDisplayOrder
```lua
IconController.setDisplayOrder(number)
```
Changes the DisplayOrder of the TopbarPlus ScreenGui to the given value.

----
#### setTopbarEnabled
```lua
IconController.setTopbarEnabled(bool)
```
When set to ``false``, hides all icons created with TopbarPlus. This can also be achieved by calling ``starterGui:SetCore("TopbarEnabled", false)``.

----
#### setGap
```lua
IconController.setGap(integer, alignment)
```
Defines the offset width (i.e. gap) between each icon for the given alignment, ``left``, ``mid``, ``right``, or all alignments if not specified. 

----
#### clearIconOnSpawn
```lua
IconController.clearIconOnSpawn(icon)
```
Calls destroy on the given icon when the player respawns. This is useful for scenarious where you wish to cleanup icons that are constructed within a Gui with ``ResetOnSpawn`` set to ``true``. For example:

```lua
-- Place at the bottom of your icon creator localscript
local icons = IconController.getIcons()
for _, icon in pairs(icons) do
IconController.clearIconOnSpawn(icon)
end
```

----
#### getIcons
```lua
local arrayOfIcons = IconController.getIcons()
```
Returns all icons as an array.

----
#### getIcon
```lua
local icon = IconController.getIcon(name)
```
Returns the icon with the given name (or ``false`` if not found). If multiple icons have the same name, then one will be returned randomly.

----



## Properties
#### topbarEnabled
{read-only}
```lua
local bool = IconController.topbarEnabled
```

----
#### controllerModeEnabled
{read-only}
```lua
local bool = IconController.controllerModeEnabled
```

----
#### leftGap
{read-only}
```lua
local gapNumber = IconController.leftGap --[default: '12']
```

----
#### midGap
{read-only}
```lua
local gapNumber = IconController.midGap --[default: '12']
```

----
#### rightGap
{read-only}
```lua
local gapNumber = IconController.rightGap --[default: '12']
```
