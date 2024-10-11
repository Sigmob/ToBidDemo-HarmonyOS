import { ModeType } from './SelectorList';
import display from '@ohos.display';
import { SelectorDialog } from '../dialog/SelectorDialog';
import { util } from '@kit.ArkTS';
import Constant from '../../common/Constant';

@Component
export struct ZPSelect {

  @State selectOptions: ModeType[] = [];
  @State currentMode: ModeType = {id: -1, name: 'none'};
  private dialog?: CustomDialogController;
  onValueChanged?: (item: ModeType) => void;


  @State showSelector: boolean = false;

  build() {
    this.selector_right_build()
  }

  @Builder
  selector_right_build() {
    RelativeContainer(){
      Text(this.currentMode ? this.currentMode.name : 'none')
        .fontSize($r('app.float.small_text_size'))
        .fontColor($r('app.color.font_main_color_dark'))
        .id(util.generateRandomUUID(true))
        .margin({
          right: 10
        })
        .alignRules({
          center: {anchor: '__container__', align: VerticalAlign.Center},
          middle: {anchor: '__container__', align: HorizontalAlign.Center},
        })

      Image(this.showSelector ? $r('app.media.icon_arrow_top') : $r('app.media.icon_arrow_bottom'))
        .height($r('app.float.arrow_jump_height'))
        .width($r('app.float.arrow_jump_height'))
        .margin({ right: $r('app.float.padding_small') })
        .id(util.generateRandomUUID(true))
        .alignRules({
          right: {anchor: '__container__', align: HorizontalAlign.End},
          center: {anchor: '__container__', align: VerticalAlign.Center},
        })
    }
    .onClick((event: ClickEvent) => {
      let deviceInfo = display.getDefaultDisplaySync();
      let screenHeight = px2vp(deviceInfo.height)
      let cheight: number = (this.selectOptions.length > 5 ? 5 : this.selectOptions.length) * Constant.SELECTOR_CELL_HEIGHT
      let cx = event.windowX - event.x
      let cy = event.windowY - event.y + Constant.SELECTOR_CELL_HEIGHT
      if (cy + cheight > screenHeight * 0.9) {
        cy = cy - cheight - Constant.SELECTOR_CELL_HEIGHT
      }
      this.dialog = new CustomDialogController({
        customStyle: true,
        builder: SelectorDialog({
          controller: this.dialog,
          currentMode:this.currentMode,
          selectOptions: this.selectOptions,
          onSelected: this.onValueChanged,
          cwidth: event.target.area.width as number,
          cheight: cheight,
          cy: cy,
          cx: cx,
        }),
        autoCancel: true,
        alignment: DialogAlignment.Top, // 可设置dialog的对齐方式，设定显示在底部或中间等，默认为底部显示
      })
      this.dialog.open()
    })
    .borderWidth(1)
    .borderColor($r('app.color.font_gray_color'))
    .backgroundColor(Color.Transparent)
    .height(Constant.SELECTOR_CELL_HEIGHT)
    .margin($r('app.float.padding_small'))
  }

}