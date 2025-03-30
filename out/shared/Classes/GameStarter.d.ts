export default class GameStarter {
    static GameName: string;
    static GameVersion: string;
    static GetRunContext(): Enum.RunContext.Server | Enum.RunContext.Client;
    static Start(): void;
}
