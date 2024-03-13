### Images
```lua
icon:setImage(shopImageId)
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

<a><img src="AAA" width="50%"/></a>

------------------------------

### Captions
```lua
icon:setCaption("Open Shop")
```

<a><img src="AAA" width="50%"/></a>

------------------------------

### Dropdowns
Dropdowns are vertical navigation frames that contain an array of icons:

```lua
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
		,
})
```

<a><img src="AAA" width="50%"/></a>

------------------------------

### Menus
Menus are horizontal navigation frames that contain an array of icons:

```lua
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
})
```

<a><img src="AAA" width="100%"/></a>

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

<a><img src="AAA" width="50%"/></a>

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

### Gamepad & Console Support

TopbarPlus comes with inbuilt support for gamepads (such as XBbox and PlayStation
controllers) and console screens:

<a><img src="https://i.imgur.com/dJSC8rD.png" width="50%"/></a>

To highlight the last-selected icon (or left-most if none have been selected yet)
users simply press DPadUp or navigate to the topbar via the virtual cursor.
To change the default trigger keycode (from DPadUp) do:
```lua
Icon.highlightKey = Enum.KeyCode.NEW_KEYCODE
```

------------------------------

### Overflows
AAAA

<video src="AAA" width="100%" controls></video>

------------------------------

These examples and more can be tested, viewed and edited at the [Playground](https://www.roblox.com/games/6199274521/TopbarPlus-Playground).
