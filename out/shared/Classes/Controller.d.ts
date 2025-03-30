export default abstract class Controller {
    protected RenderSignal: RBXScriptConnection | undefined;
    protected HeartbeatSignal: RBXScriptConnection | undefined;
    private IsInitialized;
    constructor();
    Initialize(): void;
    GetName(): string;
    protected RenderStep(DeltaTime: number): void;
    protected PhysicsStep(DeltaTime: number): void;
    protected InitializeSteps(): void;
}
