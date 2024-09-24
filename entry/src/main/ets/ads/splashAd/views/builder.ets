import { tbnode } from '@tobid/adsdk'

@Builder
export function SplashBottomView(args: tbnode.Params) {
  Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
    Image($r('app.media.app_icon')).width(50).height(50)
    Text($r('app.string.app_name'))
  }
  .height(100)
  .width('100%')
  .backgroundColor(Color.Yellow)
}