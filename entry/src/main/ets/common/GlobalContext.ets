import { common } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import Constant from './Constant';

export class GlobalContext {
  private constructor() {
  }

  private static instance: GlobalContext;
  private _objects = new Map<string, Object>();

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    return this._objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }

  windowStage(): window.WindowStage {
    return GlobalContext.getContext().getObject(Constant.KEY_WINDOW_STAGE) as window.WindowStage;
  }

  context(): common.UIAbilityContext {
    return GlobalContext.getContext().getObject(Constant.KEY_CONTEXT) as common.UIAbilityContext;
  }

}