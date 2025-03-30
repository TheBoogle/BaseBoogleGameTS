import { RunService } from "@rbxts/services";

export default abstract class Controller {
	protected RenderSignal: RBXScriptConnection | undefined;
	protected HeartbeatSignal: RBXScriptConnection | undefined;

	private IsInitialized = false;

	constructor() {}

	public Initialize() {
		if (this.IsInitialized) {
			warn("Controller already initialized", debug.traceback());
			return;
		}

		print(`[${RunService.IsServer() ? "Server" : "Client"}] Initializing ${this.GetName()}`);

		this.InitializeSteps();

		this.IsInitialized = true;
	}

	public GetName() {
		return tostring(getmetatable(this));
	}

	protected RenderStep(DeltaTime: number): void {}

	protected PhysicsStep(DeltaTime: number): void {}

	protected InitializeSteps() {
		if (RunService.IsClient()) {
			this.RenderSignal = RunService.RenderStepped.Connect((DT) => {
				debug.profilebegin(`${this.GetName()} RenderStep`);
				this.RenderStep(DT);
				debug.profileend();
			});
		}

		this.HeartbeatSignal = RunService.Heartbeat.Connect((DT) => {
			debug.profilebegin(`${this.GetName()} PhysicsStep`);
			this.PhysicsStep(DT);
			debug.profileend();
		});
	}
}
