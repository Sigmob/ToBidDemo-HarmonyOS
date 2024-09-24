import Constant from '../../common/Constant';
import DeviceInfo from '../../common/DeviceInfo'

@Component
export struct PosSlider {
  @Link adWidth: number;
  @Link adHeight: number;

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center }) {
      Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
        Text('广告位宽度')
        Slider({value: this.adWidth, min: 0, max: DeviceInfo.cwidth, direction: Axis.Horizontal })
          .width('60%')
          .showTips(true)
          .onChange((data) => {
            this.adWidth = data;
          })
        Text(`${Math.floor(this.adWidth)}`)
      }
      .height(Constant.CELL_HEIGHT_NORMAL)

      Flex({ justifyContent: FlexAlign.SpaceEvenly, alignItems: ItemAlign.Center }) {
        Text('广告位高度')
        Slider({value: this.adHeight, min: 0, max: DeviceInfo.cheight, direction: Axis.Horizontal })
          .width('60%')
          .showTips(true)
          .onChange((data) => {
            this.adHeight = data;
          })
        Text(`${Math.floor(this.adHeight)}`)
      }
      .height(Constant.CELL_HEIGHT_NORMAL)
    }
    .offset({ y: 10 })
    .backgroundColor(Color.White)
  }
}