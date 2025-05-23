-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local CollectionService = _services.CollectionService
local RunService = _services.RunService
local ServerScriptService = _services.ServerScriptService
local StarterPlayer = _services.StarterPlayer
local Workspace = _services.Workspace
local Controller = TS.import(script, script.Parent.Parent, "Controller").default
local ComponentService = TS.import(script, script.Parent.Parent.Parent, "Services", "ComponentService").default
local ComponentController
do
	local super = Controller
	ComponentController = setmetatable({}, {
		__tostring = function()
			return "ComponentController"
		end,
		__index = super,
	})
	ComponentController.__index = ComponentController
	function ComponentController.new(...)
		local self = setmetatable({}, ComponentController)
		return self:constructor(...) or self
	end
	function ComponentController:constructor(...)
		super.constructor(self, ...)
	end
	function ComponentController:GetComponentsFolder()
		local BasePath = if RunService:IsClient() then StarterPlayer:FindFirstChild("StarterPlayerScripts") else ServerScriptService
		local _result = BasePath
		if _result ~= nil then
			_result = _result:FindFirstChild("TS")
			if _result ~= nil then
				_result = _result:FindFirstChild("Logic")
				if _result ~= nil then
					_result = _result:FindFirstChild("Classes")
					if _result ~= nil then
						_result = _result:FindFirstChild("Components")
					end
				end
			end
		end
		return _result
	end
	ComponentController.Initialize = TS.async(function(self)
		super.Initialize(self)
		local ComponentsFolder = ComponentController:GetComponentsFolder()
		if not ComponentsFolder then
			warn("Failed to find Components folder")
			return nil
		end
		local _exp = ComponentsFolder:GetChildren()
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(Component)
			if Component:IsA("ModuleScript") then
				require(Component)
			end
		end
		for _k, _v in _exp do
			_callback(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
		for _, ComponentToRegister in ComponentController.ComponentManifest do
			local ComponentAdded
			ComponentAdded = function(Instance)
				if not Instance:IsDescendantOf(Workspace) then
					Instance.AncestryChanged:Once(function()
						if Instance:IsDescendantOf(Workspace) then
							ComponentAdded(Instance)
						end
					end)
					return nil
				end
				local WasSuccess, Result = pcall(function()
					task.spawn(function()
						ComponentService:RegisterComponent(Instance, ComponentToRegister)
					end)
				end)
				if not WasSuccess then
					warn("Failed to register component", ComponentToRegister, "on", Instance, Result)
				end
			end
			local Name = tostring(ComponentToRegister)
			if Name == "Component" then
				warn(`Component Name: \{{Name}\} is reserved`)
				return nil
			end
			local _exp_1 = CollectionService:GetTagged(Name)
			for _k, _v in _exp_1 do
				ComponentAdded(_v, _k - 1, _exp_1)
			end
			CollectionService:GetInstanceAddedSignal(Name):Connect(ComponentAdded)
		end
		task.delay(5, function()
			-- Go through the manifest, check if any components have not been registered yet
			local _exp_1 = ComponentService:GetAllComponents()
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#_exp_1)
			local _callback_1 = function(Component)
				return Component:GetName()
			end
			for _k, _v in _exp_1 do
				_newValue[_k] = _callback_1(_v, _k - 1, _exp_1)
			end
			-- ▲ ReadonlyArray.map ▲
			local RegisteredComponents = _newValue
			local _exp_2 = ComponentController.ComponentManifest
			-- ▼ ReadonlyArray.filter ▼
			local _newValue_1 = {}
			local _callback_2 = function(ComponentToRegister)
				-- InstanceOf check
				local ComponentName = tostring(ComponentToRegister)
				return not (table.find(RegisteredComponents, ComponentName) ~= nil)
			end
			local _length = 0
			for _k, _v in _exp_2 do
				if _callback_2(_v, _k - 1, _exp_2) == true then
					_length += 1
					_newValue_1[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			local UnregisteredComponents = _newValue_1
			if #UnregisteredComponents > 0 then
				-- ▼ ReadonlyArray.map ▼
				local _newValue_2 = table.create(#UnregisteredComponents)
				local _callback_3 = function(Component)
					return tostring(Component)
				end
				for _k, _v in UnregisteredComponents do
					_newValue_2[_k] = _callback_3(_v, _k - 1, UnregisteredComponents)
				end
				-- ▲ ReadonlyArray.map ▲
				warn("The following components have not been utilized:", table.concat(_newValue_2, ", "))
			end
		end)
	end)
	ComponentController.ComponentManifest = {}
end
local function RegisterComponent()
	return function(Component)
		local _componentManifest = ComponentController.ComponentManifest
		local _component = Component
		if table.find(_componentManifest, _component) ~= nil then
			warn("Component has already been registered:", Component)
			return nil
		end
		local _componentManifest_1 = ComponentController.ComponentManifest
		local _component_1 = Component
		table.insert(_componentManifest_1, _component_1)
	end
end
return {
	RegisterComponent = RegisterComponent,
	default = ComponentController,
}
