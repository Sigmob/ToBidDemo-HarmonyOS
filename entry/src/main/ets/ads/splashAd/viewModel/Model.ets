@ObservedV2
export class ListenerModel {
  /**
   * 广告加载状态
   */
  @Trace loadState: string = '未加载';

  @Trace message: string = '';
}