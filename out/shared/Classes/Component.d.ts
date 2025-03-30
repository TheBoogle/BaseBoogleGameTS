export default class BaseComponent<T extends Instance> {
    protected Instance: T;
    readonly ID: string;
    protected RenderStep: RBXScriptConnection | undefined;
    protected Heartbeat: RBXScriptConnection | undefined;
    constructor(ComponentInstance: T, ID?: string);
    static GetAttributeName(): string;
    static GetServerAttribute(): string;
    static GetClientAttribute(): string;
    Initialize(): void;
    GetName(): string;
    static GetClassName(): string;
    protected TagInstance(ForceName?: string): void;
    protected InitializeRenderStep(): void;
    protected InitializeHeartbeat(): void;
    Stop(): void;
    GetInstance(): T;
    protected RenderUpdate(DeltaTime: number): void;
    protected PhysicsUpdate(DeltaTime: number): void;
}
