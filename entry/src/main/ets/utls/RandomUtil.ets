import { util } from '@kit.ArkTS';

/**
 * 随机工具类
 */
export class RandomUtil {

  private constructor() {}


  /**
   * 生成随机数number值
   * @return 随机数
   */
  static randomInt(): number {
    return Math.floor(Math.random() * Number.MAX_SAFE_INTEGER);
  }


  /**
   * 生成指定范围内的随机数 [0,limit)
   * @param limit 限制随机数的范围，不包括这个数
   * @return 随机数
   */
  static randomLimit(limit: number): number {
    return Math.floor(Math.random() * limit);
  }


  /**
   * 生成指定范围内的随机数
   * @param min 最小数（包含）
   * @param max 最大数（不包含）
   * @return 随机数
   */
  static randomNumber(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min) + min);
  }


  /**
   * 生成随机Boolean值
   * @return true or false
   */
  static randomBoolean(): boolean {
    return Math.random() < 0.5;
  }


  /**
   * 生成随机颜色，十六进制
   * @returns color
   */
  static randomColor(): string {
    const color = Math.floor(Math.random() * 16777215).toString(16)
    return `#${color}`
  }


  /**
   * 使用加密安全随机数生成器生成随机的RFC 4122版本4的string类型UUID。
   * @param entropyCache 是否使用已缓存的UUID， 默认true。
   * @returns
   */
  static generateRandomUUID(entropyCache: boolean = true): string {
    let uuid = util.generateRandomUUID(entropyCache);
    return uuid;
  }

}
