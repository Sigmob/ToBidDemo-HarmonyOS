import Constant from "../../common/Constant";
import { SlotId } from "../../models/Model";
import { ModeType } from "../from/SelectorList";
import { ZPRowConfig, ZPRowMode } from "../from/ZPForm";
import { ZPSection } from "../from/ZPForm";
import { SlotSelector } from "../SlotSelector/SlotSelector";

@Component
export struct ZAdView {
  @Link curSlotId: string;
  @Link slotIds: SlotId[];
  bidToken: string = '';
  uses2s: boolean = false;
  onAdLoad?: () => void;
  onAdLoadByToken?: (token?: string) => void;
  onSendWinNotice?: () => void;
  onSendLossNotice?: () => void;
  onAdPlay?: () => void;

  aboutToAppear(): void {

  }
  aboutToDisappear(): void {

  }

  build() {
    List() {
      this.buildAdSlot()
      this.buildAdLoadPlay()
    }
    .width(Constant.FULL_PARENT)
    .backgroundColor($r('app.color.mainPage_backgroundColor'))
  }


  @Builder
  buildAdSlot() {
    ListItem() {
      SlotSelector({
        header: '选择广告位',
        title: '请选择广告位',
        slotIds: $slotIds,
        valueChanged: (item: string | boolean | ModeType) => {
          this.curSlotId = (item as ModeType).value;
        }
      })
    }
  }

  @Builder
  buildAdLoadPlay() {
    ListItem() {
      ZPSection({
        header: '广告加载和播放',
        configs: [
          new ZPRowConfig()
            .title('加载广告')
            .mode(ZPRowMode.Text)
            .icon($r('app.media.icon_load'))
            .onClick(() => {
              if (this.onAdLoad) {
                this.onAdLoad();
              }
            }),
          new ZPRowConfig()
            .title('播放广告')
            .mode(ZPRowMode.Text)
            .icon($r('app.media.icon_play'))
            .onClick(() => {
              if (this.onAdPlay) {
                this.onAdPlay();
              }
            })
        ]
      })
    }
  }
}
