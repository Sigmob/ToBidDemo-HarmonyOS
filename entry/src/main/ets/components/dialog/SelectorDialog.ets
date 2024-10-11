import { ModeType, SelectorList } from '../from/SelectorList'

@CustomDialog
export struct SelectorDialog {
  @Link currentMode: ModeType
  @Require selectOptions: ModeType[] = [];
  controller: CustomDialogController;
  cwidth: number = 0;
  cheight: number = 0;
  cx: number = 0;
  cy: number = 0;
  onSelected?: (mode: ModeType) => void

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Start }) {
      SelectorList({
        currentMode: this.currentMode,
        modesData: this.selectOptions,
        onSelected: () => {
          this.controller.close()
          if (this.onSelected && this.currentMode) {
            this.onSelected(this.currentMode)
          }
        }
      })
        .width(this.cwidth)
        .height(this.cheight)
        .position({
          x: this.cx,
          y: this.cy
        })
    }
    .onClick(() => {
      this.controller.close()
    })
    .width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }
}