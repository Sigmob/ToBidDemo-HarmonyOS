import {
    TBBannerAd,
    TBBannerAdComponent,
    TBClickViewIdList, TBNativeMediaComponent, TBType
} from '@tobid/adsdk';
import DeviceInfo from '../../../common/DeviceInfo';

@Component
export struct CustomBannerAdView {
  @State logoWidth: number = 20;
  @Require bannerAd: TBBannerAd | undefined;
  private clickViewIds = new TBClickViewIdList<string>();
  private creativeViewIds = new TBClickViewIdList<string>();

  aboutToAppear(): void {

  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Stack() {
        this.buildNativeAdView()
      }
      .backgroundColor(Color.Transparent)
    }
    .backgroundColor(Color.Transparent)
  }

  @Builder
  builderAdView(nativeAd: TBBannerAd) {
    Column() {
      Stack() {
        if (nativeAd.getMaterialType() === TBType.MaterialType.video) {
          this.builderVideo()
        } else {
          this.builderImage()
        }
      }
      .width('100%')
      .aspectRatio(1.7778)
      .borderRadius(10)
      .clip(true)
      .backgroundColor(Color.Black)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(nativeAd.getAppIconUrl())
          .id(this.clickViewIds.addAdId(DeviceInfo.randomUUID()))
          .objectFit(ImageFit.Contain)
          .height('100%')
          .aspectRatio(1)
          .borderRadius(5)
          .constraintSize({
            minWidth: 50, minHeight: 50
          })
          .backgroundColor(Color.Black)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
          Text(nativeAd.getAdTitle()).maxLines(1)
          Text(nativeAd.getAdDescription())
            .maxLines(1)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
        }
        .height('100%')
        .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .margin({ top: 10 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
        Row({ space: 3 }) {
          if (nativeAd.getAdLogo()) {
            Image(nativeAd.getAdLogo())
              .objectFit(ImageFit.Cover)
              .onComplete((data) => {
                if (data?.loadingStatus === 1) {
                  this.logoWidth = data.width / data.height * 20;
                }
              })
              .width(this.logoWidth).height(20)
          } else {
            Text(nativeAd!.getAdSource())
              .fontColor(Color.Red)
              .fontSize(10)
          }
        }

        Button(nativeAd.getActionDescription())
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .controlSize(ControlSize.SMALL)
          .fontColor(Color.Blue)
          .borderWidth(0.5)
          .borderColor(Color.Blue)
          .backgroundColor(Color.White)
          .id(this.creativeViewIds.addAdId(DeviceInfo.randomUUID()))
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.Transparent)
    .onAppear(() => {
      nativeAd.registerViewForInteraction(this.clickViewIds, this.creativeViewIds)
    })
  }

  @Builder
  builderImage() {
    if (this.bannerAd?.getImageList() !== undefined) {
      Image(this.bannerAd!.getImageList()[0].imageUrl)
        .objectFit(ImageFit.Contain)
        .width('100%').height('100%')
        .backgroundColor(Color.Transparent)
    }

  }

  @Builder
  builderVideo() {
    TBNativeMediaComponent({ nativeAd: this.bannerAd })
      .width('100%')
      .width('100%').height('100%')
      .backgroundColor(Color.Black)
  }

  @Builder
  builderAd() {
    if (this.bannerAd?.getRenderType() !== TBType.RenderType.template) {
      this.builderAdView(this.bannerAd!)
    }

  }

  @Builder
  buildNativeAdView() {
    TBBannerAdComponent({
      bannerAd: this.bannerAd,
      builder: (): void => this.builderAd()
    })
      .backgroundColor(Color.Transparent)
  }
}