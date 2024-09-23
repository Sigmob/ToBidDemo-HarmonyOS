import { display } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';

export class DeviceInfo {
  /**
   * 显示设备的宽度，单位为像素。
   */
  readonly width: number = display.getDefaultDisplaySync().width;
  /**
   * 显示设备的高度，单位为像素。
   */
  readonly height: number = display.getDefaultDisplaySync().height;

  /**
   * 生成全局唯一的UUID
   * @returns
   */
  randomUUID(): string {
    return util.generateRandomUUID(true);
  }

  /**
   * 显示设备的宽度，单位为vp。
   */
  get cwidth(): number {
    return Math.trunc(px2vp(this.width));
  }

  /**
   * 显示设备的高度，单位为vp。
   */
  get cheight(): number {
    return Math.trunc(px2vp(this.height));
  }
}

export default new DeviceInfo();