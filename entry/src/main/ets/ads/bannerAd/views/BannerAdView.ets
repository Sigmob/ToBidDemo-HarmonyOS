import { TBBannerAd } from '@tobid/adsdk';
import { CustomBannerAdView } from './CustomBannerAdView';

@Component
export struct BannerAdView {
  @Require bannerAd?: TBBannerAd

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        CustomBannerAdView({ bannerAd: this.bannerAd })
          .backgroundColor(Color.White)
          .borderRadius(10)
          .clip(true)
      }
      .height("100%").width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.5)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}