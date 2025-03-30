import { RunService } from "@rbxts/services";

export default class GameStarter {
	public static GameName = "GameName";
	public static GameVersion = "0.1.0.0";

	public static GetRunContext() {
		return RunService.IsServer() ? Enum.RunContext.Server : Enum.RunContext.Client;
	}

	public static Start() {
		print(`[${GameStarter.GetRunContext().Name}] Starting ${GameStarter.GameName} ${GameStarter.GameVersion}`);
	}
}
