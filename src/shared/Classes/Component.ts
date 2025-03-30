import { RunService } from "@rbxts/services";
import { MongoId } from "./MongoId";

export default class BaseComponent<T extends Instance> {
	protected Instance: T;
	public readonly ID = MongoId.GenerateString();

	protected RenderStep: RBXScriptConnection | undefined;
	protected Heartbeat: RBXScriptConnection | undefined;

	constructor(ComponentInstance: T, ID?: string) {
		this.Instance = ComponentInstance;

		if (ID) {
			this.ID = ID;
		}

		this.Instance.SetAttribute(BaseComponent.GetAttributeName(), this.ID);
	}

	public static GetAttributeName() {
		const RunTimeMode = RunService.IsClient();

		return RunTimeMode ? this.GetClientAttribute() : this.GetServerAttribute();
	}

	public static GetServerAttribute() {
		return "SERVER_COMPONENT_ID";
	}

	public static GetClientAttribute() {
		return "CLIENT_COMPONENT_ID";
	}

	public Initialize(): void {
		this.Instance.Destroying.Connect(() => {
			this.Stop();
		});

		this.TagInstance();
	}

	public GetName() {
		return tostring(getmetatable(this));
	}

	public static GetClassName() {
		return tostring(this);
	}

	protected TagInstance(ForceName?: string): void {
		const ComponentName = ForceName ?? this.GetName();

		if (this.Instance.HasTag(ComponentName)) {
			return;
		}

		this.Instance.AddTag(ComponentName);
	}

	protected InitializeRenderStep(): void {
		this.RenderStep = RunService.RenderStepped.Connect((DeltaTime: number) => {
			debug.profilebegin(`${this.GetName()} RenderStep`);
			this.RenderUpdate(DeltaTime);
			debug.profileend();
		});
	}

	protected InitializeHeartbeat(): void {
		this.Heartbeat = RunService.Heartbeat.Connect((DeltaTime: number) => {
			debug.profilebegin(`${this.GetName()} PhysicsStep`);
			this.PhysicsUpdate(DeltaTime);
			debug.profileend();
		});
	}

	public Stop(): void {
		if (this.RenderStep?.Connected) {
			this.RenderStep.Disconnect();
		}
	}

	public GetInstance(): T {
		return this.Instance;
	}

	protected RenderUpdate(DeltaTime: number): void {}

	protected PhysicsUpdate(DeltaTime: number): void {}
}
