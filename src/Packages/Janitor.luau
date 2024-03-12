--!optimize 2
--!strict
-- Compiled with L+ C Edition
-- Janitor
-- Original by Validark
-- Modifications by pobammer
-- roblox-ts support by OverHash and Validark
-- LinkToInstance fixed by Elttob.
-- Cleanup edge cases fixed by codesenseAye.

local Promise = if script.Parent:FindFirstChild("Promise") then require(script.Parent.Promise) else nil

local IndicesReference = setmetatable({}, {
	__tostring = function()
		return "IndicesReference"
	end,
})

local LinkToInstanceIndex = setmetatable({}, {
	__tostring = function()
		return "LinkToInstanceIndex"
	end,
})

local INVALID_METHOD_NAME =
	"Object is a %* and as such expected `true?` for the method name and instead got %*. Traceback: %*"
local METHOD_NOT_FOUND_ERROR = "Object %* doesn't have method %*, are you sure you want to add it? Traceback: %*"
local NOT_A_PROMISE = "Invalid argument #1 to 'Janitor:AddPromise' (Promise expected, got %* (%*)) Traceback: %*"

--[=[
	Janitor is a light-weight, flexible object for cleaning up connections, instances, or anything. This implementation covers all use cases,
	as it doesn't force you to rely on naive typechecking to guess how an instance should be cleaned up.
	Instead, the developer may specify any behavior for any object.

	@class Janitor
]=]
local Janitor = {}
Janitor.ClassName = "Janitor"
Janitor.CurrentlyCleaning = true
Janitor.SuppressInstanceReDestroy = false
Janitor[IndicesReference] = nil
Janitor.__index = Janitor

--[=[
	@prop CurrentlyCleaning boolean
	@readonly
	@within Janitor

	Whether or not the Janitor is currently cleaning up.
]=]

--[=[
	@prop SuppressInstanceReDestroy boolean
	@within Janitor
	@since 1.15.4

	Whether or not you want to suppress the re-destroying
	of instances. Default is false, which is the original
	behavior.
]=]

local TypeDefaults = {
	["function"] = true,
	thread = true,
	RBXScriptConnection = "Disconnect",
}

--[=[
	Instantiates a new Janitor object.
	@return Janitor
]=]
function Janitor.new(): Janitor
	return setmetatable({
		CurrentlyCleaning = false,
		[IndicesReference] = nil,
	}, Janitor) :: any
end

--[=[
	Determines if the passed object is a Janitor. This checks the metatable directly.

	@param Object any -- The object you are checking.
	@return boolean -- `true` if `Object` is a Janitor.
]=]
function Janitor.Is(Object: any): boolean
	return type(Object) == "table" and getmetatable(Object) == Janitor
end

--[=[
	An alias for [Janitor.Is](#Is). This is intended for roblox-ts support.

	@function instanceof
	@within Janitor
	@param Object any -- The object you are checking.
	@return boolean -- `true` if `Object` is a Janitor.
]=]
Janitor.instanceof = Janitor.Is

type BooleanOrString = boolean | string

--[=[
	Adds an `Object` to Janitor for later cleanup, where `MethodName` is the key of the method within `Object` which should be called at cleanup time.
	If the `MethodName` is `true` the `Object` itself will be called if it's a function or have `task.cancel` called on it if it is a thread. If passed
	an index it will occupy a namespace which can be `Remove()`d or overwritten. Returns the `Object`.

	:::info
	Objects not given an explicit `MethodName` will be passed into the `typeof` function for a very naive typecheck.
	RBXConnections will be assigned to "Disconnect", functions and threads will be assigned to `true`, and everything else will default to "Destroy".
	Not recommended, but hey, you do you.
	:::

	### Luau:

	```lua
	local Workspace = game:GetService("Workspace")
	local TweenService = game:GetService("TweenService")

	local Obliterator = Janitor.new()
	local Part = Workspace.Part

	-- Queue the Part to be Destroyed at Cleanup time
	Obliterator:Add(Part, "Destroy")

	-- Queue function to be called with `true` MethodName
	Obliterator:Add(print, true)

	-- Close a thread.
	Obliterator:Add(task.defer(function()
		while true do
			print("Running!")
			task.wait(0.5)
		end
	end), true)

	-- This implementation allows you to specify behavior for any object
	Obliterator:Add(TweenService:Create(Part, TweenInfo.new(1), {Size = Vector3.new(1, 1, 1)}), "Cancel")

	-- By passing an Index, the Object will occupy a namespace
	-- If "CurrentTween" already exists, it will call :Remove("CurrentTween") before writing
	Obliterator:Add(TweenService:Create(Part, TweenInfo.new(1), {Size = Vector3.new(1, 1, 1)}), "Destroy", "CurrentTween")
	```

	### TypeScript:

	```ts
	import { Workspace, TweenService } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ CurrentTween: Tween }>();
	const Part = Workspace.FindFirstChild("Part") as Part;

	// Queue the Part to be Destroyed at Cleanup time
	Obliterator.Add(Part, "Destroy");

	// Queue function to be called with `true` MethodName
	Obliterator.Add(print, true);

	// Close a thread.
	Obliterator.Add(task.defer(() => {
		while (true) {
			print("Running!");
			task.wait(0.5);
		}
	}), true);

	// This implementation allows you to specify behavior for any object
	Obliterator.Add(TweenService.Create(Part, new TweenInfo(1), {Size: new Vector3(1, 1, 1)}), "Cancel");

	// By passing an Index, the Object will occupy a namespace
	// If "CurrentTween" already exists, it will call :Remove("CurrentTween") before writing
	Obliterator.Add(TweenService.Create(Part, new TweenInfo(1), {Size: new Vector3(1, 1, 1)}), "Destroy", "CurrentTween");
	```

	@param Object T -- The object you want to clean up.
	@param MethodName? boolean | string -- The name of the method that will be used to clean up. If not passed, it will first check if the object's type exists in TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	@param Index? any -- The index that can be used to clean up the object manually.
	@return T -- The object that was passed as the first argument.
]=]
function Janitor:Add<T>(Object: T, MethodName: BooleanOrString?, Index: any?): T
	if Index then
		self:Remove(Index)

		local This = self[IndicesReference]
		if not This then
			This = {}
			self[IndicesReference] = This
		end

		This[Index] = Object
	end

	local TypeOf = typeof(Object)
	local NewMethodName = MethodName or TypeDefaults[TypeOf] or "Destroy"

	if TypeOf == "function" or TypeOf == "thread" then
		if NewMethodName ~= true then
			warn(string.format(INVALID_METHOD_NAME, TypeOf, tostring(NewMethodName), debug.traceback(nil, 2)))
		end
	else
		if not (Object :: any)[NewMethodName] then
			warn(
				string.format(
					METHOD_NOT_FOUND_ERROR,
					tostring(Object),
					tostring(NewMethodName),
					debug.traceback(nil, 2)
				)
			)
		end
	end

	self[Object] = NewMethodName
	return Object
end

--[=[
	Adds a [Promise](https://github.com/evaera/roblox-lua-promise) to the Janitor. If the Janitor is cleaned up and the Promise is not completed, the Promise will be cancelled.

	### Luau:

	```lua
	local Obliterator = Janitor.new()
	Obliterator:AddPromise(Promise.delay(3)):andThenCall(print, "Finished!"):catch(warn)
	task.wait(1)
	Obliterator:Cleanup()
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor();
	Obliterator.AddPromise(Promise.delay(3)).andThenCall(print, "Finished!").catch(warn);
	task.wait(1);
	Obliterator.Cleanup();
	```

	@param PromiseObject Promise -- The promise you want to add to the Janitor.
	@return Promise
]=]
function Janitor:AddPromise(PromiseObject)
	if not Promise then
		return PromiseObject
	end

	if not Promise.is(PromiseObject) then
		error(string.format(NOT_A_PROMISE, typeof(PromiseObject), tostring(PromiseObject), debug.traceback(nil, 2)))
	end

	if PromiseObject:getStatus() == Promise.Status.Started then
		local Id = newproxy(false)
		local NewPromise = self:Add(
			Promise.new(function(Resolve, _, OnCancel)
				if OnCancel(function()
					PromiseObject:cancel()
				end) then
					return
				end

				Resolve(PromiseObject)
			end),
			"cancel",
			Id
		)

		NewPromise:finallyCall(self.Remove, self, Id)
		return NewPromise
	else
		return PromiseObject
	end
end

--[=[
	Cleans up whatever `Object` was set to this namespace by the 3rd parameter of [Janitor.Add](#Add).

	### Luau:

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(workspace.Baseplate, "Destroy", "Baseplate")
	Obliterator:Remove("Baseplate")
	```

	### TypeScript:

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ Baseplate: Part }>();
	Obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	Obliterator.Remove("Baseplate");
	```

	@param Index any -- The index you want to remove.
	@return Janitor
]=]
function Janitor:Remove(Index: any)
	local This = self[IndicesReference]

	if This then
		local Object = This[Index]

		if Object then
			local MethodName = self[Object]

			if MethodName then
				if MethodName == true then
					if type(Object) == "function" then
						Object()
					else
						local Cancelled
						if coroutine.running() ~= Object then
							Cancelled = pcall(function()
								task.cancel(Object)
							end)
						end

						if not Cancelled then
							task.defer(function()
								if Object then
									task.cancel(Object)
								end
							end)
						end
					end
				else
					local ObjectMethod = Object[MethodName]
					if ObjectMethod then
						if
							self.SuppressInstanceReDestroy
							and MethodName == "Destroy"
							and typeof(Object) == "Instance"
						then
							pcall(ObjectMethod, Object)
						else
							ObjectMethod(Object)
						end
					end
				end

				self[Object] = nil
			end

			This[Index] = nil
		end
	end

	return self
end

--[=[
	Removes an object from the Janitor without running a cleanup.

	### Luau

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(function()
		print("Removed!")
	end, true, "Function")

	Obliterator:RemoveNoClean("Function") -- Does not print.
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ Function: () => void }>();
	Obliterator.Add(() => print("Removed!"), true, "Function");

	Obliterator.RemoveNoClean("Function"); // Does not print.
	```

	@since v1.15
	@param Index any -- The index you are removing.
	@return Janitor
]=]
function Janitor:RemoveNoClean(Index: any)
	local This = self[IndicesReference]

	if This then
		local Object = This[Index]
		if Object then
			self[Object] = nil
		end

		This[Index] = nil
	end

	return self
end

--[=[
	Cleans up multiple objects at once.

	### Luau:

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(function()
		print("Removed One")
	end, true, "One")

	Obliterator:Add(function()
		print("Removed Two")
	end, true, "Two")

	Obliterator:Add(function()
		print("Removed Three")
	end, true, "Three")

	Obliterator:RemoveList("One", "Two", "Three") -- Prints "Removed One", "Removed Two", and "Removed Three"
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	type NoOp = () => void

	const Obliterator = new Janitor<{ One: NoOp, Two: NoOp, Three: NoOp }>();
	Obliterator.Add(() => print("Removed One"), true, "One");
	Obliterator.Add(() => print("Removed Two"), true, "Two");
	Obliterator.Add(() => print("Removed Three"), true, "Three");

	Obliterator.RemoveList("One", "Two", "Three"); // Prints "Removed One", "Removed Two", and "Removed Three"
	```

	@since v1.14
	@param ... any -- The indices you want to remove.
	@return Janitor
]=]
function Janitor:RemoveList(...: any)
	local This = self[IndicesReference]
	if This then
		local Length = select("#", ...)
		if Length == 1 then
			return self:Remove(...)
		else
			for SelectIndex = 1, Length do
				self:Remove(select(SelectIndex, ...))
			end
		end
	end

	return self
end

--[=[
	Cleans up multiple objects at once without running their cleanup.

	### Luau:

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(function()
		print("Removed One")
	end, true, "One")

	Obliterator:Add(function()
		print("Removed Two")
	end, true, "Two")

	Obliterator:Add(function()
		print("Removed Three")
	end, true, "Three")

	Obliterator:RemoveListNoClean("One", "Two", "Three") -- Nothing is printed.
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	type NoOp = () => void

	const Obliterator = new Janitor<{ One: NoOp, Two: NoOp, Three: NoOp }>();
	Obliterator.Add(() => print("Removed One"), true, "One");
	Obliterator.Add(() => print("Removed Two"), true, "Two");
	Obliterator.Add(() => print("Removed Three"), true, "Three");

	Obliterator.RemoveListNoClean("One", "Two", "Three"); // Nothing is printed.
	```

	@since v1.15
	@param ... any -- The indices you want to remove.
	@return Janitor
]=]
function Janitor:RemoveListNoClean(...: any)
	local This = self[IndicesReference]
	if This then
		local Length = select("#", ...)
		if Length == 1 then
			return self:RemoveNoClean(...)
		else
			for SelectIndex = 1, Length do
				-- MACRO
				local Index = select(SelectIndex, ...)
				local Object = This[Index]
				if Object then
					self[Object] = nil
				end

				This[Index] = nil
			end
		end
	end

	return self
end

--[=[
	Gets whatever object is stored with the given index, if it exists. This was added since Maid allows getting the task using `__index`.

	### Luau:

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(workspace.Baseplate, "Destroy", "Baseplate")
	print(Obliterator:Get("Baseplate")) -- Returns Baseplate.
	```

	### TypeScript:

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ Baseplate: Part }>();
	Obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	print(Obliterator.Get("Baseplate")); // Returns Baseplate.
	```

	@param Index any -- The index that the object is stored under.
	@return any? -- This will return the object if it is found, but it won't return anything if it doesn't exist.
]=]
function Janitor:Get(Index: any): any?
	local This = self[IndicesReference]
	return if This then This[Index] else nil
end

--[=[
	Returns a frozen copy of the Janitor's indices.

	### Luau:

	```lua
	local Obliterator = Janitor.new()
	Obliterator:Add(workspace.Baseplate, "Destroy", "Baseplate")
	print(Obliterator:GetAll().Baseplate) -- Prints Baseplate.
	```

	### TypeScript:

	```ts
	import { Workspace } from "@rbxts/services";
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor<{ Baseplate: Part }>();
	Obliterator.Add(Workspace.FindFirstChild("Baseplate") as Part, "Destroy", "Baseplate");
	print(Obliterator.GetAll().Baseplate); // Prints Baseplate.
	```

	@since v1.15.1
	@return {[any]: any}
]=]
function Janitor:GetAll(): { [any]: any }
	local This = self[IndicesReference]
	return if This then table.freeze(table.clone(This)) else {}
end

local function GetFenv(self)
	return function()
		for Object, MethodName in next, self do
			if Object ~= IndicesReference and Object ~= "SuppressInstanceReDestroy" then
				return Object, MethodName
			end
		end
	end
end

--[=[
	Calls each Object's `MethodName` (or calls the Object if `MethodName == true`) and removes them from the Janitor. Also clears the namespace.
	This function is also called when you call a Janitor Object (so it can be used as a destructor callback).

	### Luau:

	```lua
	Obliterator:Cleanup() -- Valid.
	Obliterator() -- Also valid.
	```

	### TypeScript:

	```ts
	Obliterator.Cleanup()
	```
]=]
function Janitor:Cleanup()
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil

		local Get = GetFenv(self)
		local Object, MethodName = Get()

		while Object and MethodName do -- changed to a while loop so that if you add to the janitor inside of a callback it doesn't get untracked (instead it will loop continuously which is a lot better than a hard to pindown edgecase)
			if MethodName == true then
				if type(Object) == "function" then
					Object()
				else
					local Cancelled
					if coroutine.running() ~= Object then
						Cancelled = pcall(function()
							task.cancel(Object)
						end)
					end

					if not Cancelled then
						task.defer(function()
							if Object then
								task.cancel(Object)
							end
						end)
					end
				end
			else
				local ObjectMethod = Object[MethodName]
				if ObjectMethod then
					if self.SuppressInstanceReDestroy and MethodName == "Destroy" and typeof(Object) == "Instance" then
						pcall(ObjectMethod, Object)
					else
						ObjectMethod(Object)
					end
				end
			end

			self[Object] = nil
			Object, MethodName = Get()
		end

		local This = self[IndicesReference]
		if This then
			table.clear(This)
			self[IndicesReference] = {}
		end

		self.CurrentlyCleaning = false
	end
end

--[=[
	Calls [Janitor.Cleanup](#Cleanup) and renders the Janitor unusable.

	:::warning
	Running this will make any further attempts to call a method of Janitor error.
	:::
]=]
function Janitor:Destroy()
	self:Cleanup()
	table.clear(self)
	setmetatable(self, nil)
end

Janitor.__call = Janitor.Cleanup

--[=[
	"Links" this Janitor to an Instance, such that the Janitor will `Cleanup` when the Instance is `Destroyed()` and garbage collected.
	A Janitor may only be linked to one instance at a time, unless `AllowMultiple` is true. When called with a truthy `AllowMultiple` parameter,
	the Janitor will "link" the Instance without overwriting any previous links, and will also not be overwritable.
	When called with a falsy `AllowMultiple` parameter, the Janitor will overwrite the previous link which was also called with a falsy `AllowMultiple` parameter, if applicable.

	### Luau:

	```lua
	local Obliterator = Janitor.new()

	Obliterator:Add(function()
		print("Cleaning up!")
	end, true)

	do
		local Folder = Instance.new("Folder")
		Obliterator:LinkToInstance(Folder)
		Folder:Destroy()
	end
	```

	### TypeScript:

	```ts
	import { Janitor } from "@rbxts/janitor";

	const Obliterator = new Janitor();
	Obliterator.Add(() => print("Cleaning up!"), true);

	{
		const Folder = new Instance("Folder");
		Obliterator.LinkToInstance(Folder, false);
		Folder.Destroy();
	}
	```

	@param Object Instance -- The instance you want to link the Janitor to.
	@param AllowMultiple? boolean -- Whether or not to allow multiple links on the same Janitor.
	@return RBXScriptConnection -- A RBXScriptConnection that can be disconnected to prevent the cleanup of LinkToInstance.
]=]
function Janitor:LinkToInstance(Object: Instance, AllowMultiple: boolean?): RBXScriptConnection
	local IndexToUse = if AllowMultiple then newproxy(false) else LinkToInstanceIndex

	return self:Add(
		Object.Destroying:Connect(function()
			self:Cleanup()
		end),
		"Disconnect",
		IndexToUse
	)
end

Janitor.LegacyLinkToInstance = Janitor.LinkToInstance

--[=[
	Links several instances to a new Janitor, which is then returned.

	@param ... Instance -- All the Instances you want linked.
	@return Janitor -- A new Janitor that can be used to manually disconnect all LinkToInstances.
]=]
function Janitor:LinkToInstances(...: Instance)
	local ManualCleanup = Janitor.new()
	for Index = 1, select("#", ...) do
		local Object = select(Index, ...)
		if typeof(Object) ~= "Instance" then
			continue
		end

		ManualCleanup:Add(self:LinkToInstance(Object, true), "Disconnect")
	end

	return ManualCleanup
end

function Janitor:__tostring()
	return "Janitor"
end

export type Janitor = {
	ClassName: "Janitor",
	CurrentlyCleaning: boolean,
	SuppressInstanceReDestroy: boolean,

	Add: <T>(self: Janitor, Object: T, MethodName: BooleanOrString?, Index: any?) -> T,
	AddPromise: <T>(self: Janitor, PromiseObject: T) -> T,

	Remove: (self: Janitor, Index: any) -> Janitor,
	RemoveNoClean: (self: Janitor, Index: any) -> Janitor,

	RemoveList: (self: Janitor, ...any) -> Janitor,
	RemoveListNoClean: (self: Janitor, ...any) -> Janitor,

	Get: (self: Janitor, Index: any) -> any?,
	GetAll: (self: Janitor) -> { [any]: any },

	Cleanup: (self: Janitor) -> (),
	Destroy: (self: Janitor) -> (),

	LinkToInstance: (self: Janitor, Object: Instance, AllowMultiple: boolean?) -> RBXScriptConnection,
	LinkToInstances: (self: Janitor, ...Instance) -> Janitor,
}

table.freeze(Janitor)
return Janitor
