import {
    TBAdInfo,
  TBAdVideoListener,
  TBDislikeListener,
  TBNativeAd,
  TBNativeAdInteractListener,
  TBNativeAdLoader,
    TBNativeAdLoaderListener,
    TBReward,
    TBRewardAdInteractionListener, TBType
} from '@tobid/adsdk';
import Constant from '../../../common/Constant';
import { ListenerModel } from '../../../models/Model';
import { BusinessError } from '@ohos.base';
import { Logger } from 'wind_common';
import { TestPosId } from '../../../common/TestPosId';
import { Toast } from '../../../common/Toast';

export class ViewModel implements TBNativeAdLoaderListener {
  readonly pageStack: NavPathStack = new NavPathStack();
  readonly model: ListenerModel;
  adLoader?: TBNativeAdLoader;
  ads: TBNativeAd[] = [];

  constructor() {
    this.model = new ListenerModel();
  }

  loadAdData(adWidth: number, adHeight?: number) {
    this.model.message = ''
    this.model.loadState = '加载中...'
    if (!this.adLoader) {
      let request: TBType.AdRequest = {
        placementId: TestPosId.POS_ID_NATIVE,
        adWidth: adWidth,
        adHeight: adHeight, // adHeight=0时，模版自适应高度
        userId: 'Codi', //userId方便后续排查用户问题
        adCount: 1, // 一次加载广告的数量，1～3条，默认为1
      }
      let adLoader = new TBNativeAdLoader(request)
      adLoader.adLoadListener = this;
      this.adLoader = adLoader;
    }
    this.adLoader.loadAdData();
  }

  destroy() {
    this.ads.forEach((data) => data.destroy())
    this.ads = []
  }

  /**
   * 广告加载成功回调
   */
  onAdLoadSuccessed(ads: TBNativeAd[]): void {
    this.model.loadState = '加载成功...'
    Logger.debug(Constant.TAG, 'onAdDidLoad')
    Toast.show('onAdDidLoad')
    this.ads = ads;
    ads.forEach((data) => {
      let nativeAd = new WeakRef(data);
      data.videoListener = new INativeAdVideoListener(nativeAd);
      data.interactListener = new INativeAdInteractListener(nativeAd);
      data.dislikeListener = new ISGDislikeListener(new WeakRef(this));
    });
  }

  /**
   * 广告加载失败
   * @param error
   */
  onAdLoadFailed(error: BusinessError<void>): void {
    this.model.loadState = `加载失败[${error.code}]...`
    this.model.message = JSON.stringify(error);
    Logger.error(Constant.TAG, `onAdLoadError[${JSON.stringify(error)}]`)
    Toast.show(`${JSON.stringify(error)}`)
  };
}


export class INativeAdVideoListener implements TBAdVideoListener {
  private readonly nativeAd: WeakRef<TBNativeAd>;

  constructor(nativeAd: WeakRef<TBNativeAd>) {
    this.nativeAd = nativeAd;
  }

  onVideoPlayStart(): void {
    Logger.debug(Constant.TAG, `onVideoPlayStart - ${this.nativeAd.deref()?.getUniqueId()}`)
    Toast.show('onVideoPlayStart')
  }

  onVideoPlayComplete(): void {
    Logger.debug(Constant.TAG, `onVideoPlayComplete - ${this.nativeAd.deref()?.getUniqueId()}`)
    Toast.show('onVideoPlayComplete')
  }

  onVideoPlayError(): void {
    Logger.debug(Constant.TAG, `onVideoPlayError - ${this.nativeAd.deref()?.getUniqueId()}`)
    Toast.show('onVideoPlayError')
  }
}

export class INativeAdInteractListener implements TBNativeAdInteractListener {
  private readonly nativeAd: WeakRef<TBNativeAd>;

  constructor(nativeAd: WeakRef<TBNativeAd>) {
    this.nativeAd = nativeAd;
  }

  onRenderSuccess(adInfo: TBAdInfo, width: number, height: number): void {
    Logger.debug(Constant.TAG, `onRenderSuccess: ${width} * ${height}`)
  }

  onRenderFail(adInfo: TBAdInfo, error: BusinessError<void>): void {
    Logger.error(Constant.TAG, `onRenderFail: ${JSON.stringify(error)}`)
  }

  onAdShow(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG,
      `onAdShow: ${this.nativeAd.deref()?.getUniqueId()} ,adInfo: ${JSON.stringify(adInfo)}`)
    Toast.show('onAdShow')
  }

  onAdClick(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onAdClick - ${this.nativeAd.deref()?.getUniqueId()}`)
    Toast.show('onAdClick')
  }

  onAdClose(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onAdClose - ${this.nativeAd.deref()?.getUniqueId()}`)
    Toast.show('onAdClose')
  }
}

class ISGDislikeListener implements TBDislikeListener {
  readonly viewModel: WeakRef<ViewModel>;
  constructor(viewModel: WeakRef<ViewModel>) {
    this.viewModel = viewModel;
  }

  onShow(): void {
    Logger.debug(Constant.TAG, 'dislike.show')
    Toast.show('dislike.show')
  }

  onSelected(position: number, value: string, enforce: boolean): void {
    Logger.debug(Constant.TAG, `dislike.selected: ${position} - ${value} - ${enforce}`)
    Toast.show(`dislike.selected: ${position} - ${value} - ${enforce}`)
    // 需要在dislike回调中处理广告关闭，否则广告点击关闭后无反应
    let viewModel = this.viewModel.deref()
    viewModel?.pageStack?.pop(true);
  }

  onCancel(): void {
    Logger.debug(Constant.TAG, 'dislike.cancel')
    Toast.show('dislike.cancel')
  }
}

