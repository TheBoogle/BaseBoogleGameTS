import type BaseComponent from "../Component";
import Controller from "../Controller";
import { IComponentManifest } from "../../Models/Types/IComponentManifest";
export default class ComponentController extends Controller {
    static ComponentManifest: IComponentManifest;
    static GetComponentsFolder(): Folder | undefined;
    Initialize(): Promise<void>;
}
export declare function RegisterComponent(): <T extends typeof BaseComponent<Instance>>(Component: T) => void;
