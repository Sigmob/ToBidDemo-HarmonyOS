import { NavigationBarView } from '../../../components/navigation/NavigationBarView';
import { NavigationView } from '../../../components/navigation/NavigationView';
import router from '@ohos.router';
import Constant from '../../../common/Constant';
import { ViewModel } from '../viewModel/ViewModel';
import { ZAdView } from '../../../components/views/AdView';
import { SlotId } from '../../../models/Model';
import { DatasUtil } from '../../../utls/DatasUtil';
import { TitleComponent } from '../../../components/views/TitleComponent';
import { RowType } from '../../../common/Types';

@Entry
@Component
struct SplashAdPage {
  @State slotIds: SlotId[] = [];
  @State curSlotId: string = '';
  private title: string = ''
  private viewModel = new ViewModel();

  aboutToAppear(): void {
    let params = router.getParams() as Record<string, Object>;
    this.title = params['title'] as string;
    let slotIds = DatasUtil.get_placement_ids(Constant.POS_ID_SPLASH);
    this.slotIds.push(...slotIds);
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
        ZAdView({
          slotIds: $slotIds,
          curSlotId: $curSlotId,
          uses2s: true,
          onAdLoad: (): void => this.viewModel.loadAdData(this.curSlotId),
          onAdPlay: (): void => this.viewModel.playAd(),
        })
          .backgroundColor($r('app.color.mainPage_backgroundColor'))
      }
      ListItem() {
        TitleComponent({
          title: '开启底部品牌区域',
          rowType: RowType.switch,
          value: true,
          onValueChanged: (data) => {
            this.viewModel.hasLogo = data as boolean
          }
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