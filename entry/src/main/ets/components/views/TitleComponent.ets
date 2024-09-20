import Constant from '../../common/Constant';
import { RowType } from '../../common/Types';

@Component
export struct TitleComponent {
  @Require title: ResourceStr = ''
  @Require icon: ResourceStr | undefined = undefined;
  fontColor: ResourceColor = $r('app.color.font_main_color_dark')
  rowType: RowType = RowType.arrow;
  value: Object | undefined = undefined;

  @Builder
  buildRow() {
    Row({ space: Constant.COMMON_SPACE }) {
      if (this.icon) {
        Image(this.icon)
          .width($r('app.float.image_cell_size'))
          .height($r('app.float.image_cell_size'))
      }
      Text(this.title)
        .fontSize($r('app.float.normal_text_size'))
        .fontColor(this.fontColor)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
      Blank()
      Row() {
        this.build_right()
      }
      // .width(Constant.FULL_PARENT)
      .justifyContent(FlexAlign.End)
      .alignItems(VerticalAlign.Center)
    }
    .height(Constant.CELL_HEIGHT_NORMAL)
    .width(Constant.FULL_PARENT)
    .backgroundColor(Color.White)
    .padding({
      left: $r('app.float.padding_normal'),
      right: $r('app.float.padding_normal')
    })
  }

  @Builder
  build_right() {
    if (this.rowType == RowType.arrow) {
      this.arrow_right_build()
    }else if (this.rowType == RowType.text) {
      this.text_right_build()
    }
  }


  @Builder
  arrow_right_build() {
    Image($r('app.media.icon_arrow_right'))
      .width($r('app.float.arrow_jump_width'))
      .height($r('app.float.arrow_jump_height'))
  }

  @Builder
  text_right_build() {
    if (typeof (this.value) === 'boolean' || typeof (this.value) === 'number' || typeof (this.value) === 'string') {
      Text(`${this.value}`).titleTextStyle()
    }
  }

  build() {
    Column() {
      this.buildRow()
      Divider()
    }
  }
}


@Extend(Text) function titleTextStyle() {
  .fontSize($r('app.float.small_text_size'))
  .fontColor($r('app.color.font_gray_color'))
  .maxLines(3)
}