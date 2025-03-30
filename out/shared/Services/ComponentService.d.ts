import BaseComponent from "../Classes/Component";
export default class ComponentService {
    protected static Components: BaseComponent<Instance>[];
    static RegisterComponent<T extends BaseComponent<Instance>>(Instance: Instance, ComponentToMake: typeof BaseComponent<Instance>): T;
    static RegisterExistingComponent<T extends BaseComponent<Instance>>(ExistingComponent: T): void;
    static GetComponent<T extends BaseComponent<Instance>>(Instance: Instance): T | undefined;
    static GetComponentByInstanceName<T extends BaseComponent<Instance>>(InstanceName: string): T | undefined;
    static GetComponentByAttribute<T extends BaseComponent<Instance>>(AttributeName: string, AttributeValue: AttributeValue): T | undefined;
    static GetComponentByInstance<T extends BaseComponent<Instance>>(Instance: Instance): T | undefined;
    static GetAllComponentsByType<T extends BaseComponent<Instance>>(Type: new (...args: never[]) => T): T[];
    static GetAllComponents(): BaseComponent<Instance>[];
    static GetFirstComponent<T extends BaseComponent<Instance>>(Type?: new (...args: never[]) => T): T | undefined;
    static GetComponentByID<T extends BaseComponent<Instance>>(ID: string): T | undefined;
}
