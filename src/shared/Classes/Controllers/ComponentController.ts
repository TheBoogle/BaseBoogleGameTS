import { CollectionService, RunService, ServerScriptService, StarterPlayer, Workspace } from "@rbxts/services";

import type BaseComponent from "../Component";
import Controller from "../Controller";
import { IComponentManifest } from "../../Models/Types/IComponentManifest";
import ComponentService from "../../Services/ComponentService";

export default class ComponentController extends Controller {
	public static ComponentManifest: IComponentManifest = [];

	public static GetComponentsFolder(): Folder | undefined {
		const BasePath = RunService.IsClient()
			? StarterPlayer.FindFirstChild("StarterPlayerScripts")
			: ServerScriptService;

		return BasePath?.FindFirstChild("TS")
			?.FindFirstChild("Logic")
			?.FindFirstChild("Classes")
			?.FindFirstChild("Components") as Folder;
	}

	public override async Initialize() {
		super.Initialize();

		const ComponentsFolder = ComponentController.GetComponentsFolder();

		if (!ComponentsFolder) {
			warn("Failed to find Components folder");

			return;
		}

		ComponentsFolder.GetChildren().forEach((Component) => {
			if (Component.IsA("ModuleScript")) {
				require(Component);
			}
		});

		for (const ComponentToRegister of ComponentController.ComponentManifest) {
			const ComponentAdded = (Instance: Instance): void => {
				if (!Instance.IsDescendantOf(Workspace)) {
					Instance.AncestryChanged.Once(() => {
						if (Instance.IsDescendantOf(Workspace)) {
							ComponentAdded(Instance);
						}
					});
					return;
				}

				const [WasSuccess, Result] = pcall(() => {
					task.spawn(() => {
						ComponentService.RegisterComponent(Instance, ComponentToRegister);
					});
				});

				if (!WasSuccess) {
					warn("Failed to register component", ComponentToRegister, "on", Instance, Result);
				}
			};

			const Name = tostring(ComponentToRegister);

			if (Name === "Component") {
				warn(`Component Name: {${Name}} is reserved`);

				return;
			}

			CollectionService.GetTagged(Name).forEach(ComponentAdded);

			CollectionService.GetInstanceAddedSignal(Name).Connect(ComponentAdded);
		}

		task.delay(5, () => {
			// Go through the manifest, check if any components have not been registered yet
			const RegisteredComponents = ComponentService.GetAllComponents().map((Component) => Component.GetName());

			const UnregisteredComponents = ComponentController.ComponentManifest.filter((ComponentToRegister) => {
				// InstanceOf check
				const ComponentName = tostring(ComponentToRegister);

				return !RegisteredComponents.includes(ComponentName);
			});

			if (UnregisteredComponents.size() > 0) {
				warn(
					"The following components have not been utilized:",
					UnregisteredComponents.map((Component) => tostring(Component)).join(", "),
				);
			}
		});
	}
}

export function RegisterComponent() {
	return function <T extends typeof BaseComponent<Instance>>(Component: T) {
		if (ComponentController.ComponentManifest.includes(Component)) {
			warn("Component has already been registered:", Component);

			return;
		}

		ComponentController.ComponentManifest.push(Component);
	};
}
