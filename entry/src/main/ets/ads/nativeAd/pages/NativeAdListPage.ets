import { NavigationBarView } from '../../../components/navigation/NavigationBarView';
import { NavigationView } from '../../../components/navigation/NavigationView';
import { ListViewModel } from '../viewModel/ListViewModel'
import { router } from '@kit.ArkUI';
import { TBNativeAd } from '@tobid/adsdk';
import { CustomNativeAdView } from '../views/CustomNativeAdView';
import { NativeFakeView } from '../views/NativeFakeView';
import { NativeDataModel } from '../../../models/NativeDataMode';
import { ListView } from '@abner/refresh';

@Entry
@Component
struct NativeAdListPage {
  private viewModel = new ListViewModel();

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, Object>;
    this.viewModel.placementId = params['placementId'] as string;
    this.viewModel.onRefresh();
  }
  aboutToDisappear(): void {
    this.viewModel.destroy();
  }

  build() {
    Stack() {
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
    .width('100%').height('100%')
    .backgroundColor(Color.White)
  }

  @Builder
  navigationBuilder() {
    NavigationBarView({
      title: '原生广告ListView',
      showBack: true,
      naviBackgroundColor: $r('app.color.main_color'),
      backClick: () => router.back()
    })
  }

  @Builder
  nativeAdViewBuilder(nativeAd: TBNativeAd) {
    Stack({ alignContent: Alignment.Center }) {
      CustomNativeAdView({ nativeAd: nativeAd })
        .clip(true)
        .width('100%')
    }
    .width('100%')
    .backgroundColor(Color.Transparent)
  }

  @Builder
  itemLayout(item: Object, index: number): void {
    if (item instanceof NativeDataModel) {
      NativeFakeView({ item: item })
    } else if (item instanceof TBNativeAd) {
      this.nativeAdViewBuilder(item)
    }
  }

  @Builder
  contentBuilder() {
    ListView({
      isLazyData: false,
      isKeyGeneratorIndex: true,
      listAttribute: (attr) => {
        attr.divider = {
          color: $r('app.color.gray'),
          strokeWidth: 0.5,
          startMargin: 10,
          endMargin: 10
        }
      },
      lazyDataSource: this.viewModel.dataSource,
      itemLayout: (item, index) => this.itemLayout(item, index),
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.onRefresh(),
      onLoadMore: () => this.viewModel.onLoadMore()
    })
      .width('100%').height('100%')
  }

  @Builder
  _contentBuilder() {
    ListView({
      isLazyData: true,
      isKeyGeneratorIndex: true,
      listAttribute: (attr) => {
        attr.divider = {
          color: $r('app.color.gray'),
          strokeWidth: 0.5,
          startMargin: 10,
          endMargin: 10
        }
      },
      lazyDataSource: this.viewModel.dataSource,
      itemLayout: (item, index) => this.itemLayout(item, index),
      controller: this.viewModel.controller,
      onRefresh: () => this.viewModel.onRefresh(),
      onLoadMore: () => this.viewModel.onLoadMore()
    })
      .width('100%').height('100%')
  }


}