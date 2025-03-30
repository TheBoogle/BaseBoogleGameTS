-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local BaseComponent = TS.import(script, script.Parent.Parent, "Classes", "Component").default
local ComponentService
do
	ComponentService = setmetatable({}, {
		__tostring = function()
			return "ComponentService"
		end,
	})
	ComponentService.__index = ComponentService
	function ComponentService.new(...)
		local self = setmetatable({}, ComponentService)
		return self:constructor(...) or self
	end
	function ComponentService:constructor()
	end
	function ComponentService:RegisterComponent(Instance, ComponentToMake)
		local NewComponent = ComponentToMake.new(Instance)
		NewComponent:Initialize()
		local _exp = self.Components
		table.insert(_exp, NewComponent)
		return NewComponent
	end
	function ComponentService:RegisterExistingComponent(ExistingComponent)
		ExistingComponent:Initialize()
		local _components = self.Components
		local _existingComponent = ExistingComponent
		table.insert(_components, _existingComponent)
	end
	function ComponentService:GetComponent(Instance)
		local ComponentID = Instance:GetAttribute(BaseComponent:GetAttributeName())
		return self:GetComponentByID(ComponentID)
	end
	function ComponentService:GetComponentByInstanceName(InstanceName)
		local _exp = self.Components
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(Component)
			return Component:GetInstance().Name == InstanceName
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		return _result
	end
	function ComponentService:GetComponentByAttribute(AttributeName, AttributeValue)
		local _exp = self.Components
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(Component)
			return Component:GetInstance():GetAttribute(AttributeName) == AttributeValue
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		return _result
	end
	function ComponentService:GetComponentByInstance(Instance)
		local _exp = self.Components
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(Component)
			return Component:GetInstance() == Instance
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		return _result
	end
	function ComponentService:GetAllComponentsByType(Type)
		local _exp = self.Components
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _callback = function(Component)
			return TS.instanceof(Component, Type)
		end
		local _length = 0
		for _k, _v in _exp do
			if _callback(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		return _newValue
	end
	function ComponentService:GetAllComponents()
		return self.Components
	end
	function ComponentService:GetFirstComponent(Type)
		if Type then
			local _exp = self.Components
			-- ▼ ReadonlyArray.find ▼
			local _callback = function(Component)
				return TS.instanceof(Component, Type)
			end
			local _result
			for _i, _v in _exp do
				if _callback(_v, _i - 1, _exp) == true then
					_result = _v
					break
				end
			end
			-- ▲ ReadonlyArray.find ▲
			return _result
		end
		return self.Components[1]
	end
	function ComponentService:GetComponentByID(ID)
		local _exp = self.Components
		-- ▼ ReadonlyArray.find ▼
		local _callback = function(Component)
			return Component.ID == ID
		end
		local _result
		for _i, _v in _exp do
			if _callback(_v, _i - 1, _exp) == true then
				_result = _v
				break
			end
		end
		-- ▲ ReadonlyArray.find ▲
		return _result
	end
	ComponentService.Components = {}
end
return {
	default = ComponentService,
}
