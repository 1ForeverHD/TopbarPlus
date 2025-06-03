[icon:setOrder]: https://1foreverhd.github.io/TopbarPlus/api/#setorder
[Feature Guide]: https://1foreverhd.github.io/TopbarPlus/features
[Icon API]: https://1foreverhd.github.io/TopbarPlus/api
[TopbarPlus DevForum Thread]: https://devforum.roblox.com/t/topbarplus/1017485

### About
TopbarPlus is a module enabling the construction of dynamic topbar icons. These icons can be enhanced with features and methods like themes, dropdowns and menus to expand upon their appearance and behaviour.

TopbarPlus fully supports PC, Mobile, Tablet and Gamepads (Consoles), and comes with internal features such as 'overflows' to ensure icons remain within suitable bounds.

----------

### Construction
Creating an icon is as simple as:

``` lua
-- Within a LocalScript in StarterPlayerScripts and assuming the Icon package is placed in ReplicatedStorage
local Icon = require(game:GetService("ReplicatedStorage").Icon)
local icon = Icon.new()
```

This constructs an empty ``32x32`` icon on the topbar.

!!! info
    The order icons appear are determined by their construction sequence. Icons constructed first will have a smaller order therefore will appear left of icons with a higher order. You can modify this behaviour using [icon:setOrder]. Icon orders by default are ``1+(totalCreatedIcons*0.01)``, so 1.01, 1.02, 1.03, etc.

To add an image and label, do:
```lua
icon:setImage(imageId)
icon:setLabel("Label")
```

----------

### Chaining
These methods are 'chainable' therefore can alternatively be called doing:
```lua
Icon.new()
    :setImage(imageId)
    :setLabel("Label")
```

You may want to act upon nested icons. You can achieve this using ``:call``
which returns the icon as the first argument within the function you pass:
```lua
Icon.new()
    :setName("TestIcon")
    :call(function(icon)
        print(icon.name)
        -- This will print 'TestIcon'!
    end)
```

!!! info
    Chainable methods have a ``chainable`` tag next to their name within the API Icon docs.

----------

### States
Sometimes you'll want an item to appear only when *deselected* and similarily only when *selected*. You can achieve this by specifying a string value within the ``iconState`` parameter of methods containing the ``toggleable`` tag. These are:

```lua
"Deselected" -- Applies the value when the icon is deselected (i.e. not pressed)
"Selected" -- Applies the value when the icon is selected (i.e. pressed)
"Viewing" -- Formerly known as Hovering, applies the value when a cursor is hovering above, a controller highlighting, or touchpad (mobile) long-pressing (but before releasing) an icon
```

!!! info
    If no ``iconState`` is specified (i.e. is nil) the value will be applied to all states.

```lua
-- It doesn't matter if you do "deselected", "Deselected" or "dEsElEcTeD"; iconStates are not case sensitive
Icon.new()
	:setImage(4882429582)
	:setLabel("Closed", "Deselected")
	:setLabel("Open", "Selected")
	:setLabel("Viewing", "Viewing")
```

<a><img src="https://i.imgur.com/0QrDmi6.gif" width="50%"/></a>

----------

### Additional
By default icons will deselect when another icon is selected. You can disable this behaviour doing:
```lua
icon:autoDeselect(false)
```

You can enhance icons further with features like modifyTheme, dropdowns and menus, or by binding GuiObjects and KeyCodes to their toggle. This and much more can be achieved by exploring the [Feature Guide] and [Icon API].

Have a question or issue? Feel free to reach out at the [TopbarPlus DevForum Thread].