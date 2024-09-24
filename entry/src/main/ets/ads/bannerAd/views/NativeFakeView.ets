import { NativeDataModel } from '../../../models/NativeDataMode';
import StringUtil from '../../../utls/StringUtil';

@Component
@Reusable
export struct NativeFakeView {
  @Require @State item: NativeDataModel = new NativeDataModel();

  aboutToReuse(params: Record<string, Object>): void {
    this.item = params.item as NativeDataModel;
  }

  build() {
    Column({ space: 10 }) {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
        Text(this.item.title)
          .maxLines(3)
          .textOverflow({
            overflow: TextOverflow.Ellipsis
          })
        if (this.item.type === 'titleImg') {
          Stack().width('35%').aspectRatio(1.77).backgroundColor($r('app.color.gray'))
        }
      }

      if (this.item.type === 'bigImg') {
       // Stack().width('100%').aspectRatio(1.77).backgroundColor($r('app.color.gray'))
      } else if (this.item.type === 'threeImgs') {
        Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween }) {
          Stack().width('30%').aspectRatio(1.77).backgroundColor($r('app.color.gray'))
          Stack().width('30%').aspectRatio(1.77).backgroundColor($r('app.color.gray'))
          Stack().width('30%').aspectRatio(1.77).backgroundColor($r('app.color.gray'))
        }
      }
      Row({ space: 10 }) {
        if (!StringUtil.isEmpty(this.item.incon)) {
          Text(this.item.incon)
            .backgroundColor(Color.Transparent)
            .borderRadius(3)
            .borderWidth(0.5)
            .fontSize(13)
            .padding(3)
            .borderColor(Color.Red)
            .fontColor(Color.Red)
        }
        Text(this.item.source)
          .fontSize(13)
          .fontColor(Color.Grey)
      }
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .padding(10)
    .alignItems(HorizontalAlign.Start)
  }
}