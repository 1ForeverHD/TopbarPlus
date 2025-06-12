-- The functions here are dedicated solely to managing theme state
-- and updating the appearance of instances to match that state.
-- You don't need to use any of these functions, the useful ones
-- have been abstracted as icon methods



-- LOCAL
local Themes = {}
local Utility = require(script.Parent.Parent.Utility)
local baseTheme = require(script.Default)



-- FUNCTIONS
function Themes.getThemeValue(stateGroup, instanceName, property, iconState)
	if stateGroup then
		for _, detail in pairs(stateGroup) do
			local checkingInstanceName, checkingPropertyName, checkingValue = unpack(detail)
			if instanceName == checkingInstanceName and property == checkingPropertyName then
				return checkingValue
			end
		end
	end
	return nil
end

function Themes.getInstanceValue(instance, property)
	local success, value = pcall(function()
		return instance[property]
	end)
	if not success then
		value = instance:GetAttribute(property)
	end
	return value
end

function Themes.getRealInstance(instance)
	if not instance:GetAttribute("IsAClippedClone") then
		return
	end
	local originalInstance = instance:FindFirstChild("OriginalInstance")
	if not originalInstance then
		return
	end
	return originalInstance.Value
end

function Themes.getClippedClone(instance)
	if not instance:GetAttribute("HasAClippedClone") then
		return
	end
	local clippedClone = instance:FindFirstChild("ClippedClone")
	if not clippedClone then
		return
	end
	return clippedClone.Value
end

function Themes.refresh(icon, instance, specificProperty)
	-- Some instances such as notices need immediate refreshing upon creation as
	-- they're added in after the initial refresh period
	if specificProperty then
		local stateGroup = icon:getStateGroup()
		local value = Themes.getThemeValue(stateGroup, instance.Name, specificProperty) or Themes.getInstanceValue(instance, specificProperty)
		Themes.apply(icon, instance, specificProperty, value, true)
		return
	end
	-- If no property is specified we update all properties that exist within
	-- the applied theme appearance
	local stateGroup = icon:getStateGroup()
	if not stateGroup then
		return
	end
	local validInstances = {[instance.Name] = instance}
	for _, child in pairs(instance:GetDescendants()) do
		local collective = child:GetAttribute("Collective")
		if collective then
			validInstances[collective] = child
		end
		validInstances[child.Name] = child
	end
	for _, detail in pairs(stateGroup) do
		local checkingInstanceName, checkingPropertyName, checkingValue = unpack(detail)
		local instanceToUpdate = validInstances[checkingInstanceName]
		if instanceToUpdate then
			Themes.apply(icon, instanceToUpdate.Name, checkingPropertyName, checkingValue, true)
		end
	end
	return
end

function Themes.apply(icon, collectiveOrInstanceNameOrInstance, property, value, forceApply)
	-- This is responsible for **applying** appearance changes to instances within the icon
	-- however it IS NOT responsible for updating themes. Use :modifyTheme for that.
	-- This also calls callbacks given by :setBehaviour before applying these property changes
	-- to the given instances
	if icon.isDestroyed then
		return
	end
	local instances
	local collectiveOrInstanceName = collectiveOrInstanceNameOrInstance
	if typeof(collectiveOrInstanceNameOrInstance) == "Instance" then
		instances = {collectiveOrInstanceNameOrInstance}
		collectiveOrInstanceName = collectiveOrInstanceNameOrInstance.Name
	else
		instances = icon:getInstanceOrCollective(collectiveOrInstanceNameOrInstance)
	end
	local key = collectiveOrInstanceName.."-"..property
	local customBehaviour = icon.customBehaviours[key]
	for _, instance in pairs(instances) do
		local clippedClone = Themes.getClippedClone(instance)
		if clippedClone then
			-- This means theme effects are applied to both the original
			-- instance and its clone (instead of just the instance).
			-- This is important for some properties such as position
			-- and size which might be dictated by the clone
			table.insert(instances, clippedClone)
		end
	end
	for _, instance in pairs(instances) do
		if property == "Position" and Themes.getClippedClone(instance) then
			-- The clone manages the position of the real instance so ignore
			continue
		elseif property == "Size" and Themes.getRealInstance(instance) then
			-- The real instance manages the size of the clone so ignore
			continue
		end
		local currentValue = Themes.getInstanceValue(instance, property)
		if not forceApply and value == currentValue then
			continue
		end
		if customBehaviour then
			local newValue = customBehaviour(value, instance, property)
			if newValue ~= nil then
				value = newValue
			end
		end
		local success = pcall(function()
			instance[property] = value
		end)
		if not success then
			-- If property is not a real property, we set
			-- the value as an attribute instead. This is useful
			-- for instance in :setWidth where we also want to
			-- specify a desired width for every state which can
			-- then be easily read by the widget element
			instance:SetAttribute(property, value)
		end
	end
end

function Themes.getModifications(modifications)
	if typeof(modifications[1]) ~= "table" then
		-- This enables users to do :modifyTheme({a,b,c,d})
		-- in addition of :modifyTheme({{a,b,c,d}})
		modifications = {modifications}
	end
	return modifications
end

function Themes.merge(detail, modification, callback)
	local instanceName, property, value, stateName = table.unpack(modification)
	local checkingInstanceName, checkingPropertyName, _, checkingStateName = table.unpack(detail)
	if instanceName == checkingInstanceName and property == checkingPropertyName and Themes.statesMatch(stateName, checkingStateName) then
		detail[3] = value
		if callback then
			callback(detail)
		end
		return true
	end
	return false
end

function Themes.modify(icon, modifications, modificationsUID)
	-- This is what the 'old set' used to do (although for clarity that behaviour has now been
	-- split into two methods, .modifyTheme and .apply).
	-- modifyTheme is responsible for UPDATING the internal values within a theme for a particular
	-- state, then checking to see if the appearance of the icon needs to be updated.
	-- If no iconState is specified, the change is applied to both Deselected and Selected
	-- A modification can also be 'undone' using :removeModification and passing in
	-- the UID returned from this method
	task.spawn(function()
		modificationsUID = modificationsUID or Utility.generateUID()
		modifications = Themes.getModifications(modifications)
		for _, modification in pairs(modifications) do
			local instanceName, property, value, iconState = table.unpack(modification)
			if iconState == nil then
				-- If no state specified, apply to all states
				Themes.modify(icon, {instanceName, property, value, "Selected"}, modificationsUID)
				Themes.modify(icon, {instanceName, property, value, "Viewing"}, modificationsUID)
			end
			local chosenState = Utility.formatStateName(iconState or "Deselected")
			local stateGroup = icon:getStateGroup(chosenState)
			local function nowSetIt()
				if chosenState == icon.activeState then
					Themes.apply(icon, instanceName, property, value)
				end
			end
			local function updateRecord()
				for stateName, detail in pairs(stateGroup) do
					local didMerge = Themes.merge(detail, modification, function(detail)
						detail[5] = modificationsUID
						nowSetIt()
					end)
					if didMerge then
						return
					end
				end
				local detail = {instanceName, property, value, chosenState, modificationsUID}
				table.insert(stateGroup, detail)
				nowSetIt()
			end
			updateRecord()
		end
	end)
	return modificationsUID
end

function Themes.remove(icon, modificationsUID)
	for iconState, stateGroup in pairs(icon.appearance) do
		for i = #stateGroup, 1, -1 do
			local detail = stateGroup[i]
			local checkingUID = detail[5]
			if checkingUID == modificationsUID then
				table.remove(stateGroup, i)
			end
		end
	end
	Themes.rebuild(icon)
end

function Themes.removeWith(icon, instanceName, property, state)
	for iconState, stateGroup in pairs(icon.appearance) do
		if state == iconState or not state then
			for i = #stateGroup, 1, -1 do
				local detail = stateGroup[i]
				local detailName = detail[1]
				local detailProperty = detail[2]
				if detailName == instanceName and detailProperty == property then
					table.remove(stateGroup, i)
				end
			end
		end
	end
	Themes.rebuild(icon)
end

function Themes.change(icon)
	-- This changes the theme to the appearance of whatever
	-- state is currently active
	local stateGroup = icon:getStateGroup()
	for _, detail in pairs(stateGroup) do
		local instanceName, property, value = unpack(detail)
		Themes.apply(icon, instanceName, property, value)
	end
end

function Themes.set(icon, theme)
	-- This is responsible for processing the final appearance of a given theme (such as
	-- ensuring Deselected merge into missing Selected, saving that internal state,
	-- then checking to see if the appearance of the icon needs to be updated
	local themesJanitor = icon.themesJanitor
	themesJanitor:clean()
	themesJanitor:add(icon.stateChanged:Connect(function()
		Themes.change(icon)
	end))
	if typeof(theme) == "Instance" and theme:IsA("ModuleScript") then
		theme = require(theme)
	end
	icon.appliedTheme = theme
	Themes.rebuild(icon)
end

function Themes.statesMatch(state1, state2)
	-- States match if they have the same name OR if nil (because unspecified represents all states)
	local state1lower = (state1 and string.lower(state1))
	local state2lower = (state2 and string.lower(state2))
	return state1lower == state2lower or not state1 or not state2
end

function Themes.rebuild(icon)
	-- A note for my future self: this code can be optimised further by
	-- converting appearance into a instanceName-property dictionary
	-- as apposed to an array of every potential change. When converting
	-- in the future, .modify and .apply would also have to be updated.
	local appliedTheme = icon.appliedTheme
	local statesArray = {"Deselected", "Selected", "Viewing"}
	local function generateTheme()
		for _, stateName in pairs(statesArray) do
			-- This applies themes in layers
			-- The last layers take higher priority as they overwrite
			-- any duplicate earlier applied effects
			local stateAppearance = {}
			local function updateDetails(theme, incomingStateName)
				-- This ensures there's always a base 'default' layer
				if not theme then
					return
				end
				for _, detail in pairs(theme) do
					local modificationsUID = detail[5]
					local detailStateName = detail[4]
					if Themes.statesMatch(incomingStateName, detailStateName) then
						local key = detail[1].."-"..detail[2]
						local newDetail = Utility.copyTable(detail)
						newDetail[5] = modificationsUID
						stateAppearance[key] = newDetail
					end
				end
			end
			-- First we apply the base theme (i.e. the Default module)
			if stateName == "Selected" then
				updateDetails(baseTheme, "Deselected")
			end
			updateDetails(baseTheme, "Empty")
			updateDetails(baseTheme, stateName)
			-- Next we apply any custom themes by the games developer
			if appliedTheme ~= baseTheme then
				if stateName == "Selected" then
					updateDetails(appliedTheme, "Deselected")
				end
				updateDetails(baseTheme, "Empty")
				updateDetails(appliedTheme, stateName)
			end
			-- Finally we apply any modifications that have already been made
			-- Modifiers are all the changes made using icon:modifyTheme(...)
			local alreadyAppliedTheme = {}
			local alreadyAppliedGroup = icon.appearance[stateName]
			if alreadyAppliedGroup then
				for _, modifier in pairs(alreadyAppliedGroup) do
					local modificationsUID = modifier[5]
					if modificationsUID ~= nil then
						local modification = {modifier[1], modifier[2], modifier[3], stateName, modificationsUID}
						table.insert(alreadyAppliedTheme, modification)
					end
				end
			end
			updateDetails(alreadyAppliedTheme, stateName)
			-- This now converts it into our final appearance
			local finalStateAppearance = {}
			for _, detail in pairs(stateAppearance) do
				table.insert(finalStateAppearance, detail)
			end
			icon.appearance[stateName] = finalStateAppearance
		end
		Themes.change(icon)
	end
	generateTheme()
end



return Themes