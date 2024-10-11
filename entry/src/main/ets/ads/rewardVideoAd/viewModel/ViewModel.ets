import {
  TBAdInfo,
  TBAdLoadListener,
  TBReward,
  TBRewardAdInteractionListener,
  TBRewardVideoAd,
  TBType
} from '@tobid/adsdk';
import Constant from '../../../common/Constant';
import { ListenerModel } from '../../../models/Model';
import { BusinessError } from '@ohos.base';
import { Logger } from 'wind_common';
import { Toast } from '../../../common/Toast';

export class ViewModel implements TBAdLoadListener {
  readonly model: ListenerModel;
  rewardVideoAd?: TBRewardVideoAd;

  constructor() {
    this.model = new ListenerModel();
  }


  loadAdData(placementId: string) {
    this.model.message = ''
    this.model.loadState = '加载中...'
    if (!this.rewardVideoAd) {
      let request: TBType.AdRequest = {
        placementId: placementId,
        userId: 'Codi', //userId方便后续排查用户问题
        options: {
          // options参数在开启服务端激励回调时会透传给开发者的callback服务
          'key_1': 'xxx1',
          'key_2': 'xxx2'
        }
      }
      let rewardVideoAd = new TBRewardVideoAd(request)
      rewardVideoAd.adLoadListener = this;
      rewardVideoAd.adInteractionListener = new RewardAdInteractionListener();
      this.rewardVideoAd = rewardVideoAd;
    }
    this.rewardVideoAd.loadAdData();
  }

  playAd() {
    this.rewardVideoAd?.showAd()
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

class RewardAdInteractionListener implements TBRewardAdInteractionListener {
  onAdShow(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onAdShow[adInfo: ${JSON.stringify(adInfo)}]`)
    Toast.show(`onAdShow - ${adInfo.placementId}`)
  }

  onAdShowError(error: BusinessError<void>): void {
    Logger.debug(Constant.TAG, `onAdShow[${JSON.stringify(error)}]`)
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

  onRewardArrived(adInfo: TBAdInfo, reward: TBReward): void {
    Logger.debug(Constant.TAG, `onRewardArrived[${adInfo.placementId}]`)
    Toast.show(`onRewardArrived: [${reward.isRewardValid}] - ${adInfo.placementId}`)
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
    Logger.debug(Constant.TAG, `onVideoError[${adInfo.placementId}] - ${JSON.stringify(err)}`)
    Toast.show(`onVideoError - ${JSON.stringify(err)}`)
  }
}

