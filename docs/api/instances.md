### instances.iconButton.MouseButton1Click:Connect(function()

if self.locked then return end
if self._draggingFinger then
return false
elseif self.isSelected then
self:deselect()
return true
end
self:select()
end)--]]
instances.iconButton.MouseButton1Click:Connect(function()
if self.locked then return end
if self.isSelected then
self:deselect()
self.userDeselected:Fire()
self.userToggled:Fire(false)
return true
end
self:select()
self.userSelected:Fire()
self.userToggled:Fire(true)
end)
instances.iconButton.MouseButton2Click:Connect(function()
self._rightClicking = true
if self:get("dropdownToggleOnRightClick") == true then
self:_update("dropdownSize")
end
if self:get("menuToggleOnRightClick") == true then
self:_update("menuSize")
end
self._rightClicking = false
end)

-- Shows/hides the dark overlay when the icon is presssed/released
instances.iconButton.MouseButton1Down:Connect(function()
if self.locked then return end
self:_updateStateOverlay(0.7, Color3.new(0, 0, 0))
end)
instances.iconButton.MouseButton1Up:Connect(function()
if self.overlayLocked then return end
self:_updateStateOverlay(0.9, Color3.new(1, 1, 1))
end)

-- Tap away + KeyCode toggles
userInputService.InputBegan:Connect(function(input, touchingAnObject)
local validTapAwayInputs = {
[Enum.UserInputType.MouseButton1] = true,
[Enum.UserInputType.MouseButton2] = true,
[Enum.UserInputType.MouseButton3] = true,
[Enum.UserInputType.Touch] = true,
}
if not touchingAnObject and validTapAwayInputs[input.UserInputType] then
self._tappingAway = true
if self.dropdownOpen and self:get("dropdownCloseOnTapAway") == true then
self:_update("dropdownSize")
end
if self.menuOpen and self:get("menuCloseOnTapAway") == true then
self:_update("menuSize")
end
self._tappingAway = false
end
--
if self._bindedToggleKeys[input.KeyCode] and not touchingAnObject and not self.locked then
if self.isSelected then
self:deselect()
self.userDeselected:Fire()
self.userToggled:Fire(false)
else
self:select()
self.userSelected:Fire()
self.userToggled:Fire(true)
end
end
--
end)

-- hoverStarted and hoverEnded triggers and actions
-- these are triggered when a mouse enters/leaves the icon with a mouse, is highlighted with
-- a controller selection box, or dragged over with a touchpad
self.hoverStarted:Connect(function(x, y)
self.hovering = true
if not self.locked then
self:_updateStateOverlay(0.9, Color3.fromRGB(255, 255, 255))
end
self:_updateHovering()
end)
self.hoverEnded:Connect(function()
self.hovering = false
self:_updateStateOverlay(1)
self._hoveringMaid:clean()
self:_updateHovering()
end)
instances.iconButton.MouseEnter:Connect(function(x, y) -- Mouse (started)
self.hoverStarted:Fire(x, y)
end)
instances.iconButton.MouseLeave:Connect(function() -- Mouse (ended)
self.hoverEnded:Fire()
end)
instances.iconButton.SelectionGained:Connect(function() -- Controller (started)
self.hoverStarted:Fire()
end)
instances.iconButton.SelectionLost:Connect(function() -- Controller (ended)
self.hoverEnded:Fire()
end)
instances.iconButton.MouseButton1Down:Connect(function() -- TouchPad (started)
if self._draggingFinger then
self.hoverStarted:Fire()
end
-- Long press check
local heartbeatConnection
local releaseConnection
local longPressTime = 0.7
local endTick = tick() + longPressTime
heartbeatConnection = runService.Heartbeat:Connect(function()
if tick() >= endTick then
releaseConnection:Disconnect()
heartbeatConnection:Disconnect()
self._longPressing = true
if self:get("dropdownToggleOnLongPress") == true then
self:_update("dropdownSize")
end
if self:get("menuToggleOnLongPress") == true then
self:_update("menuSize")
end
self._longPressing = false
end
end)
releaseConnection = instances.iconButton.MouseButton1Up:Connect(function()
releaseConnection:Disconnect()
heartbeatConnection:Disconnect()
end)
end)
if userInputService.TouchEnabled then
instances.iconButton.MouseButton1Up:Connect(function() -- TouchPad (ended), this was originally enabled for non-touchpads too
if self.hovering then
self.hoverEnded:Fire()
end
end)
-- This is used to highlight when a mobile/touch device is dragging their finger accross the screen
-- this is important for determining the hoverStarted and hoverEnded events on mobile
local dragCount = 0
userInputService.TouchMoved:Connect(function(touch, touchingAnObject)
if touchingAnObject then
return
end
self._draggingFinger = true
end)
userInputService.TouchEnded:Connect(function()
self._draggingFinger = false
end)
end

-- Finish
self._updatingIconSize = false
self:_updateIconSize()
IconController.iconAdded:Fire(self)

return self
end

-- This is the same as Icon.new(), except it adds additional behaviour for certain specified names designed to mimic core icons, such as 'Chat'
function Icon.mimic(coreIconToMimic)
local iconName = coreIconToMimic.."Mimic"
local icon = IconController.getIcon(iconName)
if icon then
return icon
end
icon = Icon.new()
icon:setName(iconName)

if coreIconToMimic == "Chat" then
icon:setOrder(-1)
icon:setImage("rbxasset://textures/ui/TopBar/chatOff.png", "deselected")
icon:setImage("rbxasset://textures/ui/TopBar/chatOn.png", "selected")
icon:setImageYScale(0.625)
-- Since roblox's core gui api sucks melons I reverted to listening for signals within the chat modules
-- unfortunately however they've just gone and removed *these* signals therefore 
-- this mimic chat and similar features are now impossible to recreate accurately, so I'm disabling for now
-- ill go ahead and post a feature request; fingers crossed we get something by the next decade

--[[
-- Setup maid and cleanup actioon
local maid = icon._maid
icon._fakeChatMaid = maid:give(Maid.new())
maid.chatMimicCleanup = function()
starterGui:SetCoreGuiEnabled("Chat", icon.enabled)
end
-- Tap into chat module
local chatMainModule = players.LocalPlayer.PlayerScripts:WaitForChild("ChatScript").ChatMain
local ChatMain = require(chatMainModule)
local function displayChatBar(visibility)
icon.ignoreVisibilityStateChange = true
ChatMain.CoreGuiEnabled:fire(visibility)
ChatMain.IsCoreGuiEnabled = false
ChatMain:SetVisible(visibility)
icon.ignoreVisibilityStateChange = nil
end
local function setIconEnabled(visibility)
icon.ignoreVisibilityStateChange = true
ChatMain.CoreGuiEnabled:fire(visibility)
icon:setEnabled(visibility)
starterGui:SetCoreGuiEnabled("Chat", false)
icon:deselect()
icon.updated:Fire()
icon.ignoreVisibilityStateChange = nil
end
-- Open chat via Slash key
icon._fakeChatMaid:give(userInputService.InputEnded:Connect(function(inputObject, gameProcessedEvent)
if gameProcessedEvent then
return "Another menu has priority"
elseif not(inputObject.KeyCode == Enum.KeyCode.Slash or inputObject.KeyCode == Enum.SpecialKey.ChatHotkey) then
return "No relavent key pressed"
elseif ChatMain.IsFocused() then
return "Chat bar already open"
elseif not icon.enabled then
return "Icon disabled"
end
ChatMain:FocusChatBar(true)
icon:select()
end))
-- ChatActive
icon._fakeChatMaid:give(ChatMain.VisibilityStateChanged:Connect(function(visibility)
if not icon.ignoreVisibilityStateChange then
if visibility == true then
icon:select()
else
icon:deselect()
end
end
end))
-- Keep when other icons selected
icon.deselectWhenOtherIconSelected = false
-- Mimic chat notifications
icon._fakeChatMaid:give(ChatMain.MessagesChanged:connect(function()
if ChatMain:GetVisibility() == true then
return "ChatWindow was open"
end
icon:notify(icon.selected)
end))
-- Mimic visibility when StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, state) is called
coroutine.wrap(function()
runService.Heartbeat:Wait()
icon._fakeChatMaid:give(ChatMain.CoreGuiEnabled:connect(function(newState)
if icon.ignoreVisibilityStateChange then
return "ignoreVisibilityStateChange enabled"
end
local topbarEnabled = starterGui:GetCore("TopbarEnabled")
if topbarEnabled ~= IconController.previousTopbarEnabled then
return "SetCore was called instead of SetCoreGuiEnabled"
end
if not icon.enabled and userInputService:IsKeyDown(Enum.KeyCode.LeftShift) and userInputService:IsKeyDown(Enum.KeyCode.P) then
icon:setEnabled(true)
else
setIconEnabled(newState)
end
end))
end)()
icon.deselected:Connect(function()
displayChatBar(false)
end)
icon.selected:Connect(function()
displayChatBar(true)
end)
setIconEnabled(starterGui:GetCoreGuiEnabled("Chat"))
