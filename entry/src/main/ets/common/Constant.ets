export default class Constant {
  /**
   * log tag
   */
  static readonly TAG = '[entry]';
  static readonly _CONTAINER_ = '__container__';

  /**
   * 开屏测试ID
   */
  static readonly POS_ID_SPLASH = 'splash_placement_ids.json';
  /**
   * 激励视频测试ID
   */
  static readonly POS_ID_REWARD = 'reward_video_placement_ids.json';
  /**
   * 插屏测试ID
   */
  static readonly POS_ID_INTERSTITIAL = 'interstitial_placement_ids.json'
  /**
   * 原生广告测试ID
   */
  static readonly POS_ID_NATIVE = 'native_placement_ids.json'
  /**
   * 横幅广告测试ID
   */
  static readonly POS_ID_BANNER = 'banner_placement_ids.json'


  /**
   * 宽或者高100%
   */
  static readonly FULL_PARENT = '100%';
  /**
   * 统一间距
   */
  static readonly COMMON_SPACE = 12;
  /**
   * 单元格行高
   */
  static readonly CELL_HEIGHT_NORMAL = 44;
  /**
   * 下拉选择框行高
   */
  static readonly SELECTOR_CELL_HEIGHT = 35;
  /**
   * 线条高度
   */
  static readonly LINE_HEIGHT_NORMAL = 1;
  /**
   * 窗口管理器
   */
  static readonly KEY_WINDOW_STAGE = 'KEY_WINDOW_STAGE'
  /**
   * 上下文
   */
  static readonly KEY_CONTEXT = 'KEY_CONTEXT'
}