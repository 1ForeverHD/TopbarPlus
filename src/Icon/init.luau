-- Due to how typechecker work, we need to require the typing module directly without using the reference handler
local Typing = require(script.Typing)
return require(script.Icon) :: Typing.Icon
