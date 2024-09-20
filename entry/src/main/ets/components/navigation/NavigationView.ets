import Constant from '../../common/Constant'

@Component
export struct NavigationView {
  @BuilderParam
  @Require public navigationBuilder: () => void

  @BuilderParam
  @Require public contentBuilder: () => void

  build() {
    RelativeContainer() {
      Stack(){
        this.navigationBuilder()
      }.backgroundColor(Color.Transparent)
      .id('navigationBuilder')
      .alignRules({
        top: {align: VerticalAlign.Top, anchor: Constant._CONTAINER_},
      }).zIndex(200)

      Stack({alignContent: Alignment.TopStart}){
        this.contentBuilder()
      }
      .zIndex(100)
      .clip(true)
      .backgroundColor($r('app.color.mainPage_backgroundColor'))
      .id('contentBuilder')
      .alignRules({
        top: {align: VerticalAlign.Bottom, anchor: 'navigationBuilder'},
        bottom: {align: VerticalAlign.Bottom, anchor: Constant._CONTAINER_},
        left: {align: HorizontalAlign.Start, anchor: Constant._CONTAINER_},
        right: {align: HorizontalAlign.End, anchor: Constant._CONTAINER_},
      })
    }
  }
}