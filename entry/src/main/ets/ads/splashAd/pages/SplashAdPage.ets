import { NavigationBarView } from '../../../components/navigation/NavigationBarView';
import { NavigationView } from '../../../components/navigation/NavigationView';
import { router } from '@kit.ArkUI';
import Constant from '../../../common/Constant';
import { TitleComponent } from '../../../components/views/TitleComponent';
import { RowType } from '../../../common/Types';
import { ViewModel } from '../viewModel/ViewModel';

@Entry
@Component
struct SplashAdPage {
  private title: string = ''
  private viewModel = new ViewModel();

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, Object>;
    this.title = params['title'] as string;
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
    }.width('100%').height('100%')
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
      .onClick(() => this.viewModel.loadAdData())
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
      .onClick(() => this.viewModel.playAd())
      ListItem() {
        TitleComponent({
          title: '开启底部品牌区域',
          rowType: RowType.switch,
          value: true
        })
      }
      .margin({
        top: $r('app.float.padding_normal'),
        bottom: $r('app.float.padding_normal')
      })
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