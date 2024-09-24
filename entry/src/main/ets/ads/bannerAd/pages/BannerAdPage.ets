import { NavigationBarView } from '../../../components/navigation/NavigationBarView';
import { NavigationView } from '../../../components/navigation/NavigationView';
import router from '@ohos.router';
import Constant from '../../../common/Constant';
import { PosSlider } from '../../../components/views/PosSlider';
import { TitleComponent } from '../../../components/views/TitleComponent';
import { RowType } from '../../../common/Types';
import { BannerAdView } from '../views/BannerAdView';
import { ViewModel } from '../viewModel/ViewModel';
import DeviceInfo from '../../../common/DeviceInfo';

@Entry
@Component
struct BannerAdPage {

  @State adWidth: number = DeviceInfo.cwidth;
  @State adHeight?: number = undefined;
  private title: string = ''
  private viewModel = new ViewModel();

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, Object>;
    this.title = params['title'] as string;
  }

  playAd() {
    this.viewModel.pageStack.pushPathByName('TBNativeAdComponent', this.viewModel, true)
  }

  @Builder
  PagesMap(name: string) {
    if (name == 'TBNativeAdComponent') {
      if (this.viewModel.ads.length > 0) {
        BannerAdView({
          bannerAd: this.viewModel.ads[0]
        })
      }
    }
  }

  build() {
    Navigation(this.viewModel.pageStack) {
      NavigationView({
        navigationBuilder: () => {
          this.navigationBuilder()
        },
        contentBuilder: () => {
          this.contentBuilder()
        }
      })
        .width('100%').height('100%')
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.PagesMap)
    .width('100%')
    .height('100%')
    .hideTitleBar(true)
  }

  @Builder
  navigationBuilder() {
    NavigationBarView({
      title: this.title,
      showBack: true,
      naviBackgroundColor: $r('app.color.main_color'),
      backClick: () => router.back(),
    })
  }

  @Builder
  contentBuilder() {
    List() {
      ListItem() {
        TitleComponent({
          title: '加载广告',
          icon: $r('app.media.icon_load'),
          rowType: RowType.none,
        })
      }
      .onClick(() => this.viewModel.loadAdData(this.adWidth, this.adHeight))
      .margin({
        top: $r('app.float.padding_normal'),
      })

      ListItem() {
        TitleComponent({
          title: '播放广告',
          icon: $r('app.media.icon_play'),
          rowType: RowType.none,
        })
      }
      .onClick(() => this.playAd())

      ListItem() {
        PosSlider({
          adWidth: this.adWidth,
          adHeight: this.adHeight
        })
      }

      ListItem() {
        Text(`广告加载状态：${this.viewModel.model.loadState}`)
          .textAlign(TextAlign.Center)
          .fontSize(20)
          .width(Constant.FULL_PARENT)
          .height(Constant.CELL_HEIGHT_NORMAL)
      }
      .margin({
        top: $r('app.float.padding_normal'),
        bottom: $r('app.float.padding_normal')
      })

      if (this.viewModel.model.message.length > 0) {
        ListItem() {
          Text(this.viewModel.model.message)
            .textAlign(TextAlign.Center)
            .width(Constant.FULL_PARENT)
        }
      }
    }
    .width(Constant.FULL_PARENT)
    .height(Constant.FULL_PARENT)
  }
}