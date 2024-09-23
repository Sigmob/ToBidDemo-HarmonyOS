import { TBSplashAd, TBType } from '@tobid/adsdk';
import Constant from '../../../common/Constant';
import DeviceInfo from '../../../common/DeviceInfo';
import { ListenerModel } from './Model'

export class ViewModel {
  readonly model: ListenerModel;
  hasLogo: boolean = true;
  splashAd?: TBSplashAd;

  constructor() {
    this.model = new ListenerModel();
  }

  loadAdData() {
    this.model.loadState = '加载中...'
    if (this.splashAd) {
      this.splashAd.loadAdData();
    } else {
      let adHeight = DeviceInfo.cheight;
      if (this.hasLogo) {
        // 100为demo自定义品牌区的高度
        adHeight = DeviceInfo.cheight - 100;
      }
      let request: TBType.AdRequest = {
        placementId: Constant.AD_SLOT_SPLASH,
        userId: 'Codi',
        adWidth: DeviceInfo.cwidth,
        adHeight: adHeight
      }
      let splashAd = new TBSplashAd(request)
      splashAd.loadAdData();
      this.splashAd = splashAd;
    }
  }

  playAd() {

  }
}