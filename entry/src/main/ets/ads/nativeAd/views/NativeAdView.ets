import { TBNativeAd, TBType } from '@tobid/adsdk';
import { CustomNativeAdView } from './CustomNativeAdView';
import { CustomNativeDrawAdView } from './CustomNativeDrawAdView';

@Component
export struct NativeAdView {
  @Require nativeAd?: TBNativeAd

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.Center }) {
        if (this.nativeAd?.getNativeType() == TBType.NativeType.feedAd) {
          CustomNativeAdView({ nativeAd: this.nativeAd })
            .backgroundColor(Color.White)
            .borderRadius(10)
            .clip(true)
        } else if (this.nativeAd?.getNativeType() == TBType.NativeType.drawAd) {
          CustomNativeDrawAdView({ nativeAd: this.nativeAd })
            .backgroundColor(Color.White)
            .clip(true)
        }
      }
      .height("100%").width('100%')
    }
    .backgroundColor('rgba(0,0,0,0.5)')
    .hideTitleBar(true)
    .mode(NavDestinationMode.DIALOG)
  }
}