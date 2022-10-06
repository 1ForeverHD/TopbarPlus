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
#### setLeftOffset
```lua
IconController.setLeftOffset(integer)
```
Defines the offset from the left side of the screen to the nearest left-set icon. 

----
#### setRightOffset
```lua
IconController.setRightOffset(integer)
```
Defines the offset from the right side of the screen to the nearest right-set icon. 

----
#### updateTopbar
```lua
IconController.updateTopbar()
```
Determines how icons should be positioned on the topbar and moves them accordingly.  

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
#### disableHealthbar
```lua
IconController.disableHealthbar(bool)
```
Hides the fake healthbar (if currently visible) and prevents it becoming visible again (which normally occurs when the player takes damage).

----
#### disableControllerOption
```lua
IconController.disableControllerOption(bool)
```
Hides the 'enter controller mode' icon which otherwise appears when a mouse and controller are enabled.

----



## Properties
#### voiceChatEnabled
```lua
local bool = IconController.voiceChatEnabled --[default: 'false']
```
It's important you set this to true ``IconController.voiceChatEnabled = true`` after enabling Voice Chat within your experience so that TopbarPlus can account for the BETA VoiceChat label. More information here: https://devforum.roblox.com/t/introduce-a-voicechatservice-property-or-method-to-see-if-voice-chat-is-enabled-in-that-experience/1999526

----
#### mimicCoreGui
```lua
local bool = IconController.mimicCoreGui --[default: 'true']
```
Set to ``false`` to have the topbar persist even when ``game:GetService("StarterGui"):SetCore("TopbarEnabled", false)`` is called.

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

----
#### leftOffset
{read-only}
```lua
local offset = IconController.leftGap --[default: '0']
```

----
#### rightOffset
{read-only}
```lua
local offset = IconController.rightGap --[default: '0']
```
