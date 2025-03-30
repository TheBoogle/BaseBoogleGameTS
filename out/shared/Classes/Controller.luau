-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local Controller
do
	Controller = {}
	function Controller:constructor()
		self.IsInitialized = false
	end
	function Controller:Initialize()
		if self.IsInitialized then
			warn("Controller already initialized", debug.traceback())
			return nil
		end
		print(`[{if RunService:IsServer() then "Server" else "Client"}] Initializing {self:GetName()}`)
		self:InitializeSteps()
		self.IsInitialized = true
	end
	function Controller:GetName()
		return tostring((getmetatable(self)))
	end
	function Controller:RenderStep(DeltaTime)
	end
	function Controller:PhysicsStep(DeltaTime)
	end
	function Controller:InitializeSteps()
		if RunService:IsClient() then
			self.RenderSignal = RunService.RenderStepped:Connect(function(DT)
				debug.profilebegin(`{self:GetName()} RenderStep`)
				self:RenderStep(DT)
				debug.profileend()
			end)
		end
		self.HeartbeatSignal = RunService.Heartbeat:Connect(function(DT)
			debug.profilebegin(`{self:GetName()} PhysicsStep`)
			self:PhysicsStep(DT)
			debug.profileend()
		end)
	end
end
return {
	default = Controller,
}
