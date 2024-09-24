import { TBClickViewIdList, TBNativeAd, TBNativeAdComponent, TBNativeMediaComponent, TBType } from '@tobid/adsdk';
import DeviceInfo from '../../../common/DeviceInfo';

@Component
export struct CustomNativeDrawAdView {
  @State logoWidth: number = 20;
  @Require nativeAd: TBNativeAd | undefined;
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
  builderAdView(nativeAd: TBNativeAd) {
    Stack({ alignContent: Alignment.BottomStart }) {
      Stack() {
        if (nativeAd.getMaterialType() === TBType.MaterialType.video) {
          this.builderVideo()
        } else {
          this.builderImage()
        }
      }
      .width('100%')
      .height('100%')
      .clip(true)
      .backgroundColor(Color.Black)


      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Image(nativeAd.getAppIconUrl())
          .id(this.clickViewIds.addAdId(DeviceInfo.randomUUID()))
          .objectFit(ImageFit.Contain)
          .height('100%')
          .aspectRatio(1)
          .borderRadius(5)
          .height(35)
          .width(35)
          .backgroundColor(Color.Black)


        Text(nativeAd.getAdDescription())
          .fontSize(11)
          .textAlign(TextAlign.Start)
          .maxLines(2)
          .width("48%")
          .margin({ left: 5 })
          .textOverflow({ overflow: TextOverflow.Ellipsis })


        Button(nativeAd.getActionDescription(), {type: ButtonType.Normal})
          .fontSize(10)
          .borderRadius(5)
          .width("20%")
          .height(28)
          .padding(0)
          .margin({ top: 20, bottom: 20, left: 10, right: 10 })
          .id(this.creativeViewIds.addAdId(DeviceInfo.randomUUID()))
      }
      .height("10%")
      .width("70%")
      .backgroundColor("#95ffffff")
      .borderRadius(5)
      .margin({ bottom: 35, left: 25 })


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
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
    .onAppear(() => {
      nativeAd.registerViewForInteraction(this.clickViewIds, this.creativeViewIds)
    })
  }

  @Builder
  builderImage() {
    if (this.nativeAd?.getImageList() !== undefined) {
      Image(this.nativeAd!.getImageList()[0].imageUrl)
        .objectFit(ImageFit.Contain)
        .width('100%').height('100%')
        .backgroundColor(Color.Transparent)
    }

  }

  @Builder
  builderVideo() {
    TBNativeMediaComponent({ nativeAd: this.nativeAd })
      .width('100%').height('100%')
      .backgroundColor(Color.Black)
  }

  @Builder
  builderAd() {
    if (this.nativeAd?.getRenderType() !== TBType.RenderType.template) {
      this.builderAdView(this.nativeAd!)
    }

  }

  @Builder
  buildNativeAdView() {
    TBNativeAdComponent({
      nativeAd: this.nativeAd,
      builder: (): void => this.builderAd()
    })
      .backgroundColor(Color.Transparent)
      .width('100%').height('100%')
  }
}