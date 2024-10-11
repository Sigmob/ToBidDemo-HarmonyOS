@ObservedV2
export class ListenerModel {
  /**
   * 广告加载状态
   */
  @Trace loadState: string = '未加载';

  @Trace message: string = '';
}


export interface SlotId {
  adSlotId: string; // 聚合广告位ID
  adType: number; // 广告类型
  name: string; // 名称
}