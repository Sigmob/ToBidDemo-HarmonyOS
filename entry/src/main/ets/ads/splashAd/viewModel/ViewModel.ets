import {
    TBAdInfo,
    TBAdLoadListener,
    tbnode,
    TBParameter,
    TBSplashAd,
    TBSplashAdInteractionListener,
    TBType
} from '@tobid/adsdk';
import Constant from '../../../common/Constant';
import DeviceInfo from '../../../common/DeviceInfo';
import { ListenerModel } from '../../../models/Model';
import { BusinessError } from '@ohos.base';
import { SplashBottomView } from '../views/builder';
import { Logger } from 'wind_common';
import { Toast } from '../../../common/Toast';

export class ViewModel implements TBAdLoadListener {
  readonly model: ListenerModel;
  hasLogo: boolean = true;
  splashAd?: TBSplashAd;

  constructor() {
    this.model = new ListenerModel();
  }


  loadAdData(placementId: string) {
    this.model.message = ''
    this.model.loadState = '加载中...'
    if (!this.splashAd) {
      let adHeight = DeviceInfo.cheight;
      if (this.hasLogo) {
        // 100为demo自定义品牌区的高度,开发者可根据实际情况自行处理
        adHeight = DeviceInfo.cheight - 100;
      }
      //开屏广告需要设置adWidth&adHeight，否则可能影响展示效果
      let request: TBType.AdRequest = {
        placementId: placementId,
        userId: 'Codi', //userId方便后续排查用户问题
        adWidth: DeviceInfo.cwidth,
        adHeight: adHeight
      }
      let splashAd = new TBSplashAd(request)
      splashAd.adLoadListener = this;
      splashAd.adInteractionListener = new SplashAdInteractionListener(new WeakRef(this))
      this.splashAd = splashAd;
    }
    this.splashAd.loadAdData();
  }

  playAd() {
    this.splashAd?.showAd()
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

class SplashAdInteractionListener implements TBSplashAdInteractionListener {
  private readonly viewModel: WeakRef<ViewModel>;

  constructor(viewModel: WeakRef<ViewModel>) {
    this.viewModel = viewModel;
  }

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

  onSkipped(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onSkipped[${adInfo.placementId}]`)
    Toast.show(`onSkipped - ${adInfo.placementId}`)
  }

  onCounterZero(adInfo: TBAdInfo): void {
    Logger.debug(Constant.TAG, `onCounterZero[${adInfo.placementId}]`)
    Toast.show(`onCounterZero - ${adInfo.placementId}`)
  }

  customBottomViewWrapBuilder(parameter: TBParameter, adInfo: TBAdInfo): tbnode.Data | undefined {
    if (this.viewModel.deref()?.hasLogo !== true) {
      return undefined;
    }
    let builder: WrappedBuilder<[tbnode.Params]> = wrapBuilder(SplashBottomView);
    return {
      wrap: builder,
      args: {} as tbnode.Params
    };
  }
}

