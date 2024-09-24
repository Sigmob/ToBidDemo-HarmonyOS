import { TBNativeAd, TBType } from '@tobid/adsdk';
import { ViewModel } from '../viewModel/ViewModel';
import { CustomNativeAdView } from './CustomNativeAdView';
import { CustomNativeDrawAdView } from './CustomNativeDrawAdView';

@Component
export struct NativeAdView {
  @Consume('NavPathStack') pageStack: NavPathStack;
  nativeAd?: TBNativeAd

  aboutToAppear(): void {
    let params = this.pageStack.getParamByName('TBNativeAdComponent') as ViewModel[]
    let viewModel = params[0];
    let ads = viewModel.ads;
    if (ads.length > 0) {
      this.nativeAd = ads[0];
    }
  }

  aboutToDisappear(): void {
  }

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