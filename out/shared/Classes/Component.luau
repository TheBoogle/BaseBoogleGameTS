-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local MongoId = TS.import(script, script.Parent, "MongoId").MongoId
local BaseComponent
do
	BaseComponent = setmetatable({}, {
		__tostring = function()
			return "BaseComponent"
		end,
	})
	BaseComponent.__index = BaseComponent
	function BaseComponent.new(...)
		local self = setmetatable({}, BaseComponent)
		return self:constructor(...) or self
	end
	function BaseComponent:constructor(ComponentInstance, ID)
		self.ID = MongoId:GenerateString()
		self.Instance = ComponentInstance
		if ID ~= "" and ID then
			self.ID = ID
		end
		self.Instance:SetAttribute(BaseComponent:GetAttributeName(), self.ID)
	end
	function BaseComponent:GetAttributeName()
		local RunTimeMode = RunService:IsClient()
		return if RunTimeMode then self:GetClientAttribute() else self:GetServerAttribute()
	end
	function BaseComponent:GetServerAttribute()
		return "SERVER_COMPONENT_ID"
	end
	function BaseComponent:GetClientAttribute()
		return "CLIENT_COMPONENT_ID"
	end
	function BaseComponent:Initialize()
		self.Instance.Destroying:Connect(function()
			self:Stop()
		end)
		self:TagInstance()
	end
	function BaseComponent:GetName()
		return tostring((getmetatable(self)))
	end
	function BaseComponent:GetClassName()
		return tostring(self)
	end
	function BaseComponent:TagInstance(ForceName)
		local _condition = ForceName
		if _condition == nil then
			_condition = self:GetName()
		end
		local ComponentName = _condition
		if self.Instance:HasTag(ComponentName) then
			return nil
		end
		self.Instance:AddTag(ComponentName)
	end
	function BaseComponent:InitializeRenderStep()
		self.RenderStep = RunService.RenderStepped:Connect(function(DeltaTime)
			debug.profilebegin(`{self:GetName()} RenderStep`)
			self:RenderUpdate(DeltaTime)
			debug.profileend()
		end)
	end
	function BaseComponent:InitializeHeartbeat()
		self.Heartbeat = RunService.Heartbeat:Connect(function(DeltaTime)
			debug.profilebegin(`{self:GetName()} PhysicsStep`)
			self:PhysicsUpdate(DeltaTime)
			debug.profileend()
		end)
	end
	function BaseComponent:Stop()
		local _result = self.RenderStep
		if _result ~= nil then
			_result = _result.Connected
		end
		if _result then
			self.RenderStep:Disconnect()
		end
	end
	function BaseComponent:GetInstance()
		return self.Instance
	end
	function BaseComponent:RenderUpdate(DeltaTime)
	end
	function BaseComponent:PhysicsUpdate(DeltaTime)
	end
end
return {
	default = BaseComponent,
}
