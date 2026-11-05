<p align="center">
	<img src="https://nanoblox.com/topbarplus/assets/icon-192.png" width="96" alt="TopbarPlus">
</p>

<h1 align="center">TopbarPlus</h1>

<p align="center">
	<a href="https://github.com/1ForeverHD/TopbarPlus/actions/workflows/CI.yml"><img src="https://github.com/1ForeverHD/TopbarPlus/actions/workflows/CI.yml/badge.svg" alt="CI"></a>
	<a href="https://github.com/1ForeverHD/TopbarPlus/releases/latest"><img src="https://img.shields.io/github/v/release/1ForeverHD/TopbarPlus" alt="Latest release"></a>
	<a href="LICENSE"><img src="https://img.shields.io/badge/license-MPL%202.0%20%2B%20credit-blue" alt="License"></a>
</p>

<p align="center">Create topbar icons with ease. Enhance the appearance and behavior of these icons with features such as themes, dropdowns and menus.</p>

## Get it

- **Creator Store:** take the [TopbarPlus model](https://create.roblox.com/store/asset/92368439343389/TopbarPlus) and place it in `ReplicatedStorage`
- **Wally:** `TopbarPlus = "1foreverhd/topbarplus@3.5.0"`
- **Releases:** download `Icon.rbxm` from the [latest release](https://github.com/1ForeverHD/TopbarPlus/releases/latest)
- **Playground:** try it out at [TopbarPlus place](https://www.roblox.com/games/117501901079852/TopbarPlus)

## Example

```lua
local Icon = require(game:GetService("ReplicatedStorage").TopbarPlus.Icon)

Icon.new()
	:setLabel("Shop")
	:setImage(4882429582)
	:setCaption("Open the shop")
	:setDropdown({
		Icon.new():setLabel("Gamepasses"),
		Icon.new():setLabel("Coins"),
	})
```

## Docs

You can find everything from themes to the full API at [nanoblox.com/topbarplus](https://nanoblox.com/topbarplus/).

## Bugs and suggestions

Please post these at the HD Admin forum with the tag "TopbarPlus":

- [Report a bug](https://forum.hdadmin.com/bugs?area=topbarplus)
- [Suggest a feature](https://forum.hdadmin.com/suggestions?area=topbarplus)
- [Ask for help](https://forum.hdadmin.com/help?area=topbarplus)

New releases are announced on the [DevForum thread](https://devforum.roblox.com/t/topbarplus/1017485).

## Supporting TopbarPlus

TopbarPlus is free. If your experience has reached 100+ CCU, please consider a one-time donation (from 5 Robux) at [Try HD Admin](https://www.roblox.com/games/start?placeId=106966695720565).

## License

TopbarPlus is open source under the [Mozilla Public License 2.0](LICENSE) with one extra rule: keep the `Attribute` module unchanged, or credit TopbarPlus in your experience's description.

Made by [ForeverHD](https://github.com/1ForeverHD) and HD Admin.