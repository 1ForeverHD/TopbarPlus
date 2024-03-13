[icon:setOrder]: https://1foreverhd.github.io/TopbarPlus/api/icon/#setorder
[Feature Guide]: https://1foreverhd.github.io/TopbarPlus/features
[Icon API]: https://1foreverhd.github.io/TopbarPlus/api
[TopbarPlus DevForum Thread]: https://devforum.roblox.com/t/topbarplus/1017485

TopbarPlus is a module enabling the construction of dynamic topbar icons. These icons can be enhanced with features and methods like themes, dropdowns and menus to expand upon their appearance and behaviour.

TopbarPlus fully supports PC, Mobile, Tablet and Console, and comes with internal features such as 'overflows' to ensure icons remain within suitable bounds.

Creating an icon is as simple as:

``` lua
-- Within a LocalScript in StarterPlayerScripts and assuming TopbarPlus is placed in ReplicatedStorage
local Icon = require(game:GetService("ReplicatedStorage").Icon)
local icon = Icon.new()
```

!!! info
    The order icons appear are determined by their construction sequence. Icons constructed first will have a smaller order number, therefore will appear left of icons with a higher order. For instance, if you construct a shop icon then an inventory icon, the shop icon will appear furthest left. You can modify this behaviour using [icon:setOrder].

This constructs an empty ``32x32`` icon on the topbar. To add an image and label, do:
```lua
icon:setImage(imageId)
icon:setLabel("Label")
```

These methods are 'chainable' therefore can alternatively be called by doing:
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

Sometimes you'll want an item to appear only when *deselected*, and similarily only when *selected*. You can achieve this by specifying a string value within the ``iconState`` parameter of methods containing the ``toggleable`` tag. These are:

```lua
"Deselected" -- Applies the value when the icon is deselected (i.e. not pressed)
"Selected" -- Applies the value when the icon is selected (i.e. pressed)
"Viewing" -- Formerly known as Hovering, applies the value when a cursor is hovering above, a controller highlighting, or touchpad (mobile) long-pressing (but before releasing) an icon
```

!!! info
    If no argument is specified, the value will be applied to all states

```lua
Icon.new()
	:setImage(4882429582)
	:setLabel("Closed", "deselected")
	:setLabel("Open", "selected")
	:setLabel("Viewing", "viewing")
```

<a><img src="https://i.imgur.com/0QrDmi6.gif" width="50%"/></a>

By default icons will deselect when another icon is selected. You can disable this behaviour by doing:
```lua
icon:autoDeselect(false)
```

You can enhance icons further with features like themes, dropdowns and menus, or by binding GuiObjects and KeyCodes to their toggle. This and much more can be achieved by exploring the [Feature Guide] and [Icon API].

Have a question or issue? Feel free to reach out at the [TopbarPlus DevForum Thread].