[BasePart.CanTouch]: https://developer.roblox.com/en-us/api-reference/property/BasePart/CanTouch
[baseparts]: https://developer.roblox.com/en-us/api-reference/class/BasePart
[zone]: https://1foreverhd.github.io/ZonePlus/zone/
[Zone module docs]: https://1foreverhd.github.io/ZonePlus/zone/

ZonePlus is a module enabling the construction of dynamic zones. These zones utilise region checking, raycasting and the new [BasePart.CanTouch] property to effectively determine players and parts within their boundaries.

Creating a zone is as simple as:

``` lua
-- Assuming we place ZonePlus in ReplicatedStorage
local Zone = require(game:GetService("ReplicatedStorage").Zone)
local zoneGroup = workspace.SafeZoneGroup
local zone = Zone.new(zoneGroup)
```

Zones take one argument: a **group**. A group can be any non-basepart instance (such as a Model, Folder, etc) that contain descendant [baseparts]. Alternatively a group can be a singular basepart instance, or a table containing an array of baseparts. 

!!! info
    Zones are compatible with all basepart classes, however it's recommended to use simple parts (blocks, balls, cylinders, wedges, etc) where possible as these are more efficient and accurate. Some classes for instance, such as MeshParts and UnionOperations, require additional raycast checks to verify their surface geometries.

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