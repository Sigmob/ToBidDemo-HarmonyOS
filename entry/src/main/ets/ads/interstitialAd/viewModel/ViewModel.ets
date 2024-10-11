import {
    TBAdInfo,
    TBAdLoadListener,
    TBInterstitialAd,
    TBInterstitialAdInteractionListener, TBType
} from '@tobid/adsdk';
import Constant from '../../../common/Constant';
import { ListenerModel } from '../../../models/Model';
import { BusinessError } from '@ohos.base';
import { Logger } from 'wind_common';
import { Toast } from '../../../common/Toast';

export class ViewModel implements TBAdLoadListener {
  readonly model: ListenerModel;
  interstitialAd?: TBInterstitialAd;

  constructor() {
    this.model = new ListenerModel();
  }


  loadAdData(placementId: string) {
    this.model.message = ''
    this.model.loadState = '加载中...'
    if (!this.interstitialAd) {
      let request: TBType.AdRequest = {
        placementId: placementId,
        userId: 'Codi', //userId方便后续排查用户问题
      }
      let interstitialAd = new TBInterstitialAd(request)
      interstitialAd.adLoadListener = this;
      interstitialAd.adInteractionListener = new IInterstitialAdInteractionListener();
      this.interstitialAd = interstitialAd;
    }
    this.interstitialAd.loadAdData();
  }

  playAd() {
    this.interstitialAd?.showAd()
  }

  /**
   * 广告加载成功回调
   */
  onAdDidLoad() {
    this.model.loadState = '加载成功...'
    Logger.debug(Constant.TAG, 'onAdDidLoad')
    Toast.show('onAdDidLoad')
  }

  /**
   * 广告加载失败
   * @param error
   */
  onAdLoadError(error: BusinessError<void>) {
    this.model.loadState = `加载失败[${error.code}]...`
    this.model.message = JSON.stringify(error);
    Logger.error(Constant.TAG, `onAdLoadError[${JSON.stringify(error)}]`)
    Toast.show(`${JSON.stringify(error)}`)
  };
}

class IInterstitialAdInteractionListener implements TBInterstitialAdInteractionListener {
  onAdShow(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onAdShow[adInfo: ${JSON.stringify(adInfo)}]`)
    Toast.show(`onAdShow - ${adInfo.placementId}`)
  }

  onAdShowError(error: BusinessError<void>): void {
    Logger.debug(Constant.TAG, `onAdShowError[${JSON.stringify(error)}]`)
    Toast.show(`onAdShowError - ${JSON.stringify(error)}`)
  }

  onAdClick(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onAdClick[${adInfo.placementId}]`)
    Toast.show(`onAdClick - ${adInfo.placementId}`)
  }

  onAdClose(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onAdClose[${adInfo.placementId}]`)
    Toast.show(`onAdClose - ${adInfo.placementId}`)
  }

  onVideoPlayComplete(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onVideoComplete[${adInfo.placementId}]`)
    Toast.show(`onVideoComplete - ${adInfo.placementId}`)
  }

  onSkipped(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onSkipped[${adInfo.placementId}]`)
    Toast.show(`onSkipped - ${adInfo.placementId}`)
  }

  onVideoPlayError(err: BusinessError<void>, adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onVideoError[${JSON.stringify(err)}`)
    Toast.show(`onVideoError - ${JSON.stringify(err)}`)
  }
}

