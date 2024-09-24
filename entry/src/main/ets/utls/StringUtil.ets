import util from '@ohos.util';

export default class StringUtil {
  static base64 = new util.Base64Helper();

  /**
   * 判断字符串是否为空
   * @param value
   * @returns
   */
  static isEmpty(value: string): boolean {
    if (value == null || value == undefined) return true
    if (typeof value !== "string") {
      return true
    }
    return !(value.trim().length > 0);
  }

  static isNotBlank(value: string): boolean {
    return !StringUtil.isEmpty(value);
  }

  /**
   * 通过输入参数编码后输出对应文本。
   * @param src {Uint8Array}
   * @returns 加密后的string
   */
  static encodeToStringFromUint8ArraySync(src: Uint8Array): string {
    return StringUtil.base64.encodeToStringSync(src)
  }

  /**
   * 通过输入参数编码后输出对应文本。
   * @param src {string}
   * @returns 加密后的string
   */
  static encodeToStringSync(src: string): string {
    return StringUtil.base64.encodeToStringSync(StringUtil.stringToUint8Array(src))
  }

  /**
   * 通过输入参数解码后输出对应文本。
   * @param src 输入参数
   * @returns 解码后的Uint8Array数据
   */
  static decodeSync(src: Uint8Array | string): Uint8Array {
    return StringUtil.base64.decodeSync(src)
  }

  /**
   * 通过输入参数解码后输出对应文本。
   * @param src 输入参数
   * @returns 解码后的string数据
   */
  static decodeToStringSync(src: Uint8Array | string): string {
    return StringUtil.uint8ArrayToString(StringUtil.decodeSync(src))
  }

  /**
   * string转Uint8Array
   * @param str
   * @returns
   */
  static stringToUint8Array(str: string): Uint8Array {
    let arr: number[] = [];
    for (let i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }
    return new Uint8Array(arr);
  }

  /**
   * 字节流以16进制输出
   * @param uint8Array
   * @returns
   */
  static uint8ArrayToHexString(uint8Array: Uint8Array): string {
    let result: string[] = [];
    for (let i = 0; i < uint8Array.length; i++) {
      result.push(('0' + uint8Array[i].toString(16)).slice(-2));
    }
    return result.join('');
  }

  /**
   * uint8Array转成string
   * @param array
   * @returns
   */
  static uint8ArrayToString(array: Uint8Array): string {
    let arrayString = '';
    for (let i = 0; i < array.length; i++) {
      arrayString += String.fromCharCode(array[i]);
    }
    return arrayString;
  }
}