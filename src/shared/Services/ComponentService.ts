import BaseComponent from "../Classes/Component";

export default class ComponentService {
	protected static Components = new Array<BaseComponent<Instance>>();

	public static RegisterComponent<T extends BaseComponent<Instance>>(
		Instance: Instance,
		ComponentToMake: typeof BaseComponent<Instance>,
	): T {
		const NewComponent = new ComponentToMake(Instance) as T;
		NewComponent.Initialize();

		this.Components.push(NewComponent);

		return NewComponent;
	}

	public static RegisterExistingComponent<T extends BaseComponent<Instance>>(ExistingComponent: T): void {
		ExistingComponent.Initialize();

		this.Components.push(ExistingComponent);
	}

	public static GetComponent<T extends BaseComponent<Instance>>(Instance: Instance): T | undefined {
		const ComponentID = Instance.GetAttribute(BaseComponent.GetAttributeName()) as string;

		return this.GetComponentByID(ComponentID) as T | undefined;
	}

	public static GetComponentByInstanceName<T extends BaseComponent<Instance>>(InstanceName: string): T | undefined {
		return this.Components.find((Component) => Component.GetInstance().Name === InstanceName) as T | undefined;
	}

	public static GetComponentByAttribute<T extends BaseComponent<Instance>>(
		AttributeName: string,
		AttributeValue: AttributeValue,
	): T | undefined {
		return this.Components.find(
			(Component) => Component.GetInstance().GetAttribute(AttributeName) === AttributeValue,
		) as T | undefined;
	}

	public static GetComponentByInstance<T extends BaseComponent<Instance>>(Instance: Instance): T | undefined {
		return this.Components.find((Component) => Component.GetInstance() === Instance) as T | undefined;
	}

	public static GetAllComponentsByType<T extends BaseComponent<Instance>>(Type: new (...args: never[]) => T): T[] {
		return this.Components.filter((Component) => Component instanceof Type) as T[];
	}

	public static GetAllComponents() {
		return this.Components;
	}

	public static GetFirstComponent<T extends BaseComponent<Instance>>(
		Type?: new (...args: never[]) => T,
	): T | undefined {
		if (Type) {
			return this.Components.find((Component) => Component instanceof Type) as T | undefined;
		}
		return this.Components[0] as T | undefined;
	}

	public static GetComponentByID<T extends BaseComponent<Instance>>(ID: string): T | undefined {
		return this.Components.find((Component) => Component.ID === ID) as T | undefined;
	}
}
