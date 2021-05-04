It's important only a single TopbarPlus applications initiates at runtime otherwise issues such as overlapping icons will occur.

A developer may rename and/or place their Icon module anywhere within ReplicatedStorage therefore it's important for third party runtime applications (such as admin commands) to check and reference this correctly.

To achieve this:

1. When initiated, an ObjectValue called ``TopbarPlusReference`` is added directly under ``ReplicatedStorage``.
2. Check for this. If present, require its value otherwise initiate your own TopbarPlus.

```lua
local replicatedStorage = game:GetService("ReplicatedStorage")

-- This checks for the reference module under ReplicatedStorage
local topbarPlusReference = replicatedStorage:FindFirstChild("TopbarPlusReference")
local iconModule = pathway.to.your.topbarplus
if topbarPlusReference then
	iconModule = topbarPlusReference.Value
end

-- Now use TopbarPlus as normal
local Icon = require(iconModule)
local icon = Icon.new()
```

