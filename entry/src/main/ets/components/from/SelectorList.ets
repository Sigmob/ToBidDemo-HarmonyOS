import Constant from "../../common/Constant";

export interface ModeType {
  id: number;
  name: string;
  value: string;
}

@Component
struct ModeItem {
  mode?: ModeType;
  currentMode?: ModeType

  @Builder
  renderModeItem(fontColor: ResourceColor, bgColor: ResourceColor, value: string) {
    Stack({ alignContent: Alignment.Center }) {
      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Start }) {
        Text(value).fontSize($r('app.float.normal_text_size')).fontColor(fontColor).align(Alignment.Start)
          .padding({ left: $r('app.float.padding_normal') })
      }
      .width(Constant.FULL_PARENT)

      Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.End }) {
        Divider().height(Constant.LINE_HEIGHT_NORMAL)
          .align(Alignment.BottomEnd)
      }
    }
    .height(Constant.SELECTOR_CELL_HEIGHT)
    .width('100%')
    .backgroundColor(bgColor)
  }

  build() {
    if (this.mode) {
      if (this.currentMode == undefined ||  this.mode.id !== this.currentMode.id) {
        this.renderModeItem('rgba(0,0,0,0.9)', '', this.mode.name)
      } else {
        this.renderModeItem('#0A59F7', '#E6EEFF', this.mode.name)
      }
    }
  }
}


@Component
export struct SelectorList {
  onSelected?: (mode: ModeType) => void
  @Require @Prop modesData: ModeType[]
  @Link currentMode: ModeType

  onSelector(item: ModeType) {
    if (this.currentMode == null || item.id !== this.currentMode.id) {
      this.currentMode = item;
    }
    if (this.onSelected) {
      this.onSelected(this.currentMode)
    }
  }

  build() {
    List() {
      ForEach(this.modesData, (item: ModeType) => {
        ListItem() {
          ModeItem({ mode: item })
        }
        .onClick(() => this.onSelector(item))
      }, (item: ModeType) => item.id.toString())
    }
    .height(Constant.FULL_PARENT)
    .width(Constant.FULL_PARENT)
    .backgroundColor('#ffffff')
    .shadow({
      radius: 50,
      color: 'rgba(0,0,30,0.15)'
    })
  }
}
