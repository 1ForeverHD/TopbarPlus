### Images
```lua
icon:setImage(shopImageId)
```

<a><img src="https://i.imgur.com/rQUyEtO.png" width="50%"/></a>

------------------------------

### Labels
```lua
icon:setLabel("Shop")
```

<a><img src="https://i.imgur.com/4PuNDfU.png" width="50%"/></a>

```lua
icon:setImage(shopImageId)
icon:setLabel("Shop")
```

<a><img src="https://i.imgur.com/VrAFEp0.png" width="50%"/></a>

------------------------------

### Notices
```lua
icon:notify()
```

<a><img src="https://i.imgur.com/Z0mTUTz.png" width="50%"/></a>

------------------------------

### Themes
Themes are configurable tables of information that can be applied to icons to enhance their appearance and behaviour.

When constructed, an icon will automatically apply the 'Default' theme. To expand upon this, you can create your own theme modules under ``Icon -> Themes``) then apply these to your desired icons.

The Default theme and all theme settings can be found [here](https://github.com/1ForeverHD/TopbarPlus/blob/main/src/Icon/Themes/Default.lua).

Themes can be applied in two ways:

1. To all icons and future icons at once:
    ```lua
    local Themes = require(game:GetService("ReplicatedStorage").Icon.Themes)
    IconController.setGameTheme(Themes.YourThemeName)
    ```

2. Individually to an icon:
    ```lua
    local Themes = require(game:GetService("ReplicatedStorage").Icon.Themes)
    icon:setTheme(Themes.YourThemeName)
    ```

In this example, we'll apply the [BlueGradient](https://github.com/1ForeverHD/TopbarPlus/blob/main/src/Icon/Themes/BlueGradient.lua) theme which automatically comes with TopbarPlus:

```lua
local iconModule = game:GetService("ReplicatedStorage").Icon
local IconController = require(iconModule.IconController)
local Themes = require(iconModule.Themes)
IconController.setGameTheme(Themes["BlueGradient"])
```

*Deselected*

<a><img src="https://i.imgur.com/JNHC33R.png" width="50%"/></a>

*Selected*

<a><img src="https://i.imgur.com/RZJ0bbj.png" width="50%"/></a>

------------------------------

### Dropdowns
Dropdowns are vertical navigation frames that contain an array of icons:

```lua
icon:set("dropdownSquareCorners", true)
icon:setDropdown({
	Icon.new()
		:setLabel("Category 1")
		,
	Icon.new()
		:setLabel("Category 2")
		,
	Icon.new()
		:setLabel("Category 3")
		,
	Icon.new()
		:setLabel("Category 4")
		:setName("CategoryFourIcon")
		:bindEvent("selected", function(self)
			print(("%s was selected!"):format(self.name))
		end)
		:bindEvent("deselected", function(self)
			print(("%s was deselected!"):format(self.name))
		end)
		,
})
```

<a><img src="https://i.imgur.com/iqKYfPP.gif" width="50%"/></a>

------------------------------

### Menus
Menus are horizontal navigation frames that contain an array of icons:

```lua
icon:set("menuMaxIconsBeforeScroll", 2)
icon:setMenu({
	Icon.new()
		:setLabel("Category 1")
		,
	Icon.new()
		:setLabel("Category 2")
		,
	Icon.new()
		:setLabel("Category 3")
		,
	Icon.new()
		:setLabel("Category 4")
		:setName("CategoryFourIcon")
		:bindEvent("selected", function(self)
			print(("%s was selected!"):format(self.name))
		end)
		:bindEvent("deselected", function(self)
			print(("%s was deselected!"):format(self.name))
		end)
		,
})
```

<a><img src="https://i.imgur.com/t1jRleX.gif" width="100%"/></a>

------------------------------

### Captions
```lua
icon:setCaption("Shop Caption")
```

<a><img src="https://i.imgur.com/ZFJdHkh.png" width="50%"/></a>

------------------------------

### Tips
```lua
icon:setTip("Open Shop (v)")
```

<a><img src="https://i.imgur.com/ukNbqZx.png" width="50%"/></a>

------------------------------

### Toggle Items
Binds a GuiObject (such as a frame) to appear or disappear when the icon is toggled
```lua
icon:bindToggleItem(shopFrame)
```

It is equivalent to doing:
```lua
icon.deselected:Connect(function()
    shopFrame.Visible = false
end)
icon.selected:Connect(function()
    shopFrame.Visible = true
end)
```

------------------------------

### Toggle Keys
Binds a [keycode](https://developer.roblox.com/en-us/api-reference/enum/KeyCode) which toggles the icon when pressed.
```lua
-- When the 'v' key is pressed, the shop icon will open
-- When pressed again it will close
icon:bindToggleKey(Enum.KeyCode.V)
```

------------------------------

### Corners
```lua
icon:setCornerRadius(0, 0)
```

<a><img src="https://i.imgur.com/Xf4aFCU.png" width="50%"/></a>

```lua
icon:setCornerRadius(0, 8)
```

<a><img src="https://i.imgur.com/6m10YuC.png" width="50%"/></a>

```lua
icon:setCornerRadius(1, 0)
```

<a><img src="https://i.imgur.com/ysfcz07.png" width="50%"/></a>

------------------------------

### Alignments
```lua
-- Aligns the icon to the left of the screen (next to chat if present)
-- This is the default behaviour
icon:setLeft()
```

```lua
-- Aligns the icon in the middle of the screen
icon:setMid()
```

```lua
-- Aligns the icon to the right of the screen (next to (...) if present)
icon:setRight()
```

------------------------------

### Console Support

<a><img src="https://i.imgur.com/dJSC8rD.png" width="50%"/></a>

------------------------------

### Overflows
When accounting for many device types and screen sizes, icons may occasionally, particularly for smaller devices like phones, overlap with other icons or the bounds of the screen. TopbarPlus solves this problem with automatic overflows which prevent overlaps occuring.

An overflow will appear when left-set or right-set icons exceed the boundary of the:

- Viewport
- Closest enabled opposite-aligned icon
- Closest enabled center-aligned icon

<video src="https://thumbs.gfycat.com/BronzeFocusedCanadagoose-mobile.mp4" width="100%" controls></video>

------------------------------

These examples and more can be tested, viewed and edited at the [Playground](https://www.roblox.com/games/6199274521/TopbarPlus-Playground).
