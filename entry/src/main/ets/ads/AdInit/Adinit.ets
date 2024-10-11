import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { Logger } from 'wind_common';
import Constant from '../../common/Constant';
import { ToBidAd, ToBidAdConfig } from '@tobid/adsdk';
import { BusinessError } from '@kit.BasicServicesKit';

export class ToBidSDK {
  static onWindowStageCreate(windowStage: window.WindowStage, context: common.UIAbilityContext) {
    let adConfig: ToBidAdConfig = new ToBidAdConfig({
      appId: '50400', appKey: ''
    });
    // 设置用户ID 方便后续排查用户问题
    ToBidAd.userId('your user id');
    ToBidAd.initialized(context, windowStage, adConfig).then(() => {
      Logger.debug(Constant.TAG, 'ToBidAd初始化成功')
    }).catch((err: BusinessError) => {
      Logger.debug(Constant.TAG, 'ToBidAd初始化失败' + JSON.stringify(err))
    });
  }
}