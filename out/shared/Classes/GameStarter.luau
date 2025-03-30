-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
local GameStarter
do
	GameStarter = setmetatable({}, {
		__tostring = function()
			return "GameStarter"
		end,
	})
	GameStarter.__index = GameStarter
	function GameStarter.new(...)
		local self = setmetatable({}, GameStarter)
		return self:constructor(...) or self
	end
	function GameStarter:constructor()
	end
	function GameStarter:GetRunContext()
		return if RunService:IsServer() then Enum.RunContext.Server else Enum.RunContext.Client
	end
	function GameStarter:Start()
		print(`[{GameStarter:GetRunContext().Name}] Starting {GameStarter.GameName} {GameStarter.GameVersion}`)
	end
	GameStarter.GameName = "GameName"
	GameStarter.GameVersion = "0.1.0.0"
end
return {
	default = GameStarter,
}
