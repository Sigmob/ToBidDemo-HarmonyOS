import { window } from '@kit.ArkUI';
import { common } from '@kit.AbilityKit';
import { cjax, Logger } from 'wind_common';
import Constant from '../../common/Constant';
import { ToBidAd, ToBidAdConfig } from '@tobid/adsdk';
import { TestPosId } from '../../common/TestPosId';
import { BusinessError } from '@kit.BasicServicesKit';

export class ToBidSDK {
  static onWindowStageCreate(windowStage: window.WindowStage, context: common.UIAbilityContext) {
    ToBidSDK.mockUrl();
    let adConfig: ToBidAdConfig = new ToBidAdConfig({
      appId: TestPosId.APP_ID, appKey: TestPosId.APP_KEY
    });
    // 设置用户ID 方便后续排查用户问题
    ToBidAd.userId('your user id');
    ToBidAd.initialized(context, windowStage, adConfig).then(() => {
      Logger.debug(Constant.TAG, 'ToBidAd初始化成功')
    }).catch((err: BusinessError) => {
      Logger.debug(Constant.TAG, 'ToBidAd初始化失败' + JSON.stringify(err))
    });
  }


  private static async mockUrl() {
    cjax.interceptors.request.use((config: cjax.RequestConfig) => {
      if (config.flag === 2) {
        config.url = 'http://39.105.1.99:8080/ssp/v3/tobid/config';
      }
      Logger.debug(Constant.TAG, `request.url = ${config.url}`);
      return config;
    });
  }
}