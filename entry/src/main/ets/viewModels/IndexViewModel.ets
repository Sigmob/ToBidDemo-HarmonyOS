import { ToBidAd } from '@tobid/adsdk';
import { RowType } from '../common/Types';

export interface IndexData {
  title: string;
  url?: string;
  icon: Resource;
  rowType: RowType;
  value?: Object;
}


export class IndexViewModel {
  datas(): IndexData[] {
    return [
      {
        title: '开屏广告',
        icon: $r('app.media.icon_ad'),
        rowType: RowType.arrow,
        url: "ads/splashAd/pages/SplashAdPage"
      },
      {
        title: '激励视频广告',
        icon: $r('app.media.icon_ad'),
        rowType: RowType.arrow,
        url: "ads/rewardVideoAd/pages/RewardVideoAdPage"
      },
      {
        title: '插屏广告',
        icon: $r('app.media.icon_ad'),
        rowType: RowType.arrow,
        url: "ads/interstitialAd/pages/InterstitialAdPage"
      },
      {
        title: '原生广告',
        icon: $r('app.media.icon_ad'),
        rowType: RowType.arrow,
        url: "ads/nativeAd/pages/NativeAdPage"
      },
      {
        title: 'Banner广告',
        icon: $r('app.media.icon_ad'),
        rowType: RowType.arrow,
        url: "ads/bannerAd/pages/BannerAdPage"
      },
      {
        title: 'SDK版本',
        icon: $r('app.media.icon_sdk'),
        rowType: RowType.text,
        value: ToBidAd.sdkVersion()
      },
    ]
  }
}