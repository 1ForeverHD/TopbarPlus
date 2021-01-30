## Functions

#### setGameTheme
```lua
IconController.setGameTheme(theme)
```

----
#### setDisplayOrder
```lua
IconController.setDisplayOrder(number)
```

----
#### setTopbarEnabled
```lua
IconController.setTopbarEnabled(bool)
```

----
#### setGap
```lua
IconController.setGap(number, alignment)
```

----
#### getIcons
```lua
local arrayOfIcons = IconController.getIcons()
```

----
#### getIcon
```lua
local icon = IconController.getIcon(name)
```

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
