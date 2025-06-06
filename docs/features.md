[icon states]: https://1foreverhd.github.io/TopbarPlus/#states
[v3 Playground]: https://www.roblox.com/games/117501901079852/TopbarPlus


### Images
```lua
Icon.new:setImage(shopImageId)
```

<a><img src="https://i.imgur.com/IEJfUye.png" width="50%"/></a>

------------------------------

### Labels
```lua
icon:setLabel("Shop")
```

<a><img src="https://i.imgur.com/d0nVAc6.png" width="50%"/></a>

```lua
icon:setImage(shopImageId)
icon:setLabel("Shop")
```

<a><img src="https://i.imgur.com/vJHvJWI.png" width="50%"/></a>

------------------------------

### Alignments
```lua
-- Aligns the icon to the left bounds of the screen
-- This is the default behaviour so you do not need to do anything
-- This was formerly called :setLeft()
icon:align("Left")
```

```lua
-- Aligns the icon in the middle of the screen
-- This was formerly called :setMid()
icon:align("Center")
```

```lua
-- Aligns the icon to the right bounds of the screen
-- This was formerly called :setRight()
icon:align("Right")
```

------------------------------

### Notices
```lua
icon:notify()
```

<a><img src="https://i.imgur.com/xFBbVoA.png" width="50%"/></a>

------------------------------

### Captions
```lua
icon:setCaption("Open Shop")
```

<a><img src="https://i.imgur.com/QpecT2Y.gif" width="50%"/></a>

------------------------------

### Dropdowns
Dropdowns are vertical navigation frames that contain an array of icons:

```lua
Icon.new()
	:setLabel("Example")
	:modifyTheme({"Dropdown", "MaxIcons", 3})
	:modifyChildTheme({"Widget", "MinimumWidth", 158})
	:setDropdown({
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
		,
	})
```

<a><img src="https://i.imgur.com/ZMt6bhr.gif" width="50%"/></a>

!!! warning
	Icons containing a dropdown can join other menus but not dropdowns.

------------------------------

### Menus
Menus are horizontal navigation frames that contain an array of icons:

```lua
Icon.new()
	:setLabel("Example")
	:modifyTheme({"Menu", "MaxIcons", 2})
	:setMenu({
		Icon.new()
			:setLabel("Item 1")
		,
		Icon.new()
			:setLabel("Item 2")
		,
		Icon.new()
			:setLabel("Item 3")
		,
		Icon.new()
			:setLabel("Item 4")
		,
	})
```

<a><img src="https://i.imgur.com/tXLrD8t.gif" width="50%"/></a>

------------------------------

### Modify Theme
You can modify the appearance of an icon doing:
```lua
icon:modifyTheme(modifications)
```

You can modify the appearance of *all* icons doing:
```lua
Icon.modifyBaseTheme(modifications)
```

``modifications`` can be either a single array describing a change, or a *colllection* of these arrays. For example, both the following are valid:
```lua
-- Single array
icon:modifyTheme({"IconLabel", "TextSize", 16})

-- Collection of arrays
icon:modifyTheme({
	{"Widget", "MinimumWidth", 290},
	{"IconCorners", "CornerRadius", UDim.new(0, 0)}
})
```

A modification array has 4 components:
```lua
{name, property, value, iconState}
```

> **1. `name`** {required}

This can be:

- "Widget" (which is the icon container frame)
- The name of an instance within the widget such as ``IconGradient``, ``IconSpot``, ``Menu``, etc
- A 'collective' - the value of an attribute called 'Collective' applied to some instances. This enables them to be acted upon all at once. For example, 'IconCorners'.


> **2. `property`** {required}

This can be either:

- A property from the instance (Name, BackgroundColor3, Text, etc)
- Or if the property doesn't exist, an attribute of that property name will be set

> **3. `value`** {required}

The value you want the property to become (``"Hello"``, ``Color3.fromRGB(255, 100, 50)``, etc)

> **4. `iconState`** {optional}

This determines *when* the modification is applied. See [icon states] for more details.

You can find example arrays under the 'Default' module:

<a><img src="https://i.imgur.com/idH1SRi.png" width="100%"/></a>

------------------------------

### One Click Icons
You can convert icons into single click icons (icons which instantly
deselect when selected) by doing:
```lua
icon:oneClick()
```

For example:
```lua
Icon.new()
	:setImage(shopImageId)
	:setLabel("Shop")
	:bindEvent("deselected", function()
		shop.Visible = not shop.Visible
	end)
	:oneClick()
```

<a><img src="https://i.imgur.com/Ma2mpjB.gif" width="50%"/></a>

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
Binds a [keycode](https://developer.roblox.com/en-us/api-reference/enum/KeyCode) which toggles the icon when pressed. Also creates a caption hint of that keycode binding.
```lua
Icon.new()
	:setLabel("Shop")
	:bindToggleKey(Enum.KeyCode.V)
	:setCaption("Open Shop")
```

<a><img src="https://i.imgur.com/GsdNfXr.gif" width="50%"/></a>

------------------------------

### Gamepad & Console Support

TopbarPlus comes with inbuilt support for gamepads (such as Xbox and PlayStation
controllers) and console screens:

<a><img src="https://i.imgur.com/N0n2Zau.gif" width="100%"/></a>

To highlight the last-selected icon (or left-most if none have been selected yet) users simply press DPadUp or navigate to the topbar via the virtual cursor.
To change the default trigger keycode (from DPadUp) do:
```lua
Icon.highlightKey = Enum.KeyCode.NEW_KEYCODE
```

------------------------------

### Overflows
When accounting for device types and screen sizes, icons may occasionally overlap. This is especially common for phones when they enter portrait mode. TopbarPlus solves this with overflows:

<a><img src="https://i.imgur.com/9jrHBaJ.gif" width="100%"/></a>

Overflows will appear when left-set or right-set icons exceed the boundary of the closest opposite-aligned icon or viewport.

If a center-aligned icon exceeds the bounds of another icon, its alignment will be set to the alignment of the icon it exceeded:

<a><img src="https://i.imgur.com/fAds4Ph.gif" width="100%"/></a>

------------------------------

These examples and more can be tested, viewed and edited at the [v3 Playground].
