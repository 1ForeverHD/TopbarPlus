[BasePart.CanTouch]: https://developer.roblox.com/en-us/api-reference/property/BasePart/CanTouch
[baseparts]: https://developer.roblox.com/en-us/api-reference/class/BasePart
[zone]: https://1foreverhd.github.io/ZonePlus/zone/
[Zone module docs]: https://1foreverhd.github.io/ZonePlus/zone/
[zone:setOrder]: https://1foreverhd.github.io/TopbarPlus/API/Icon/#setorder

TopbarPlus is a module enabling the construction of dynamic topbar icons. These icons 

Creating an icon is as simple as:

``` lua
-- Assuming we place TopbarPlus in ReplicatedStorage
local Icon = require(game:GetService("ReplicatedStorage").Icon)
local icon = Icon.new()
```

!!! info
    The order icons appear are determined by their construction sequence. Icons constructed first will have a smaller order number, therefore will appear left of icons with a higher order. For instance, if you construct a shop icon then an inventory icon, the shop icon will appear furthest left. You can modify this behaviour using [zone:setOrder].


These group parts are then used to define the region and precise bounds of the zone.

!!! info
    Zones are dynamic. This means if a group part changes size or position, or if a basepart is added to or removed from the zone group, then an internal ``_update()`` method will be called to recalculate its bounds.

Once constructed, you can utilise zone events to determine players, parts and the localplayer *entering* or *exiting* a zone. For instance, to listen for a *player* entering and exiting a zone, do:

```lua
zone.playerEntered:Connect(function(player)
    print(("%s entered the zone!"):format(player.Name))
end)

zone.playerExited:Connect(function(player)
    print(("%s exited the zone!"):format(player.Name))
end)
```

!!! info
    On the client you may only wish to listen for the LocalPlayer (such as for an ambient system). To achieve this you would alternatively use the ``.localPlayer`` events.

If you don't intend to frequently check for items entering and exiting a zone, you can utilise zone methods:

```lua
local playersArray = zone:getPlayers()
```

Discover the full set of methods, events and properties at the [Zone module docs].