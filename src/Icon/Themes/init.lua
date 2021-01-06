-- Require all children and return their references
local Themes = {}
for _, module in pairs(script:GetChildren()) do
    if module:IsA("ModuleScript") then
        Themes[module.Name] = require(module)
    end
end
return Themes