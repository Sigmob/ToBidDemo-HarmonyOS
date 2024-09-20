class NavConstant {
  /** 填满空间  */
  static readonly FULL_ALL_SPACE: string = "100%"
  /** 返回图标的大小  */
  static readonly BACK_IMAGE_SIZE: number = 24
  /** 返回图标距离左侧屏幕的间距  */
  static readonly BACK_IMAGE_LEFT_MARGIN: number = 15
  /** 中间内容距离两侧的间距  */
  static readonly CONTENT_HORIZONTAL_SPACE: number = 10
  /** 右侧功能按钮的事件点击区域宽度，高度跟随内容的高度  */
  static readonly RIGHT_IMAGE_BOX_WIDTH: number = 45
  /** 右侧功能按钮距离右侧屏幕的间距  */
  static readonly RIGHT_IMAGE_ON_SCREEN_RIGHT_MARGIN: number = 8.5
  /** 内容的高度  */
  static readonly CONTENT_HEIGHT: number = 56
}


/**
 * 导航栏
 *
 * 每个页面都需要配置一个
 */
@Preview
@Component
export struct NavigationBarView {
  /** 导航栏背景颜色 */
  public naviBackgroundColor?: ResourceColor = "#FFFFFF"
  /** 标题 */
  public title?: ResourceStr
  /** 标题字体大小 */
  public titleFont?: ResourceStr | number = "20vp"
  /** 标题字体颜色 */
  public titleColor?: ResourceColor = "#000000"
  /** 标题字体粗细 */
  public titleFontWeight?: FontWeight = FontWeight.Medium
  /** 是否显示返回按钮 */
  public showBack?: boolean = true
  /** 返回图标 */
  public backImage?: ResourceStr = $r("app.media.icon_back")
  /** 返回图标的颜色 */
  public backImageColor?: ResourceColor = "#000000"
  /** 返回图标的大小 */
  public backImageSize: number = NavConstant.BACK_IMAGE_SIZE
  /** 返回图标距离左侧屏幕的间距 */
  public backImageLeftMargin: number = NavConstant.BACK_IMAGE_LEFT_MARGIN
  /** 返回按钮的标题 */
  public backTitle?: ResourceStr = ""
  /** 返回按钮的标题字体颜色 */
  public backTitleColor?: ResourceColor = "#000000"
  /** 返回按钮的标题字体大小 */
  public backTitleFont?: ResourceStr | number = "20vp"
  /** 返回按钮的标题字体粗细 */
  public backTitleFontWeight?: string | number | FontWeight = FontWeight.Medium
  /** 返回按钮标题距离返回图标的间距 */
  public backTitleLeftMargin?: Length = "16vp"
  /** 中间内容是否保持居中 */
  public contentToCenter?: boolean = true
  /** 中间内容距离两侧的间距 */
  public contentHorizontalSpace: number = NavConstant.CONTENT_HORIZONTAL_SPACE
  /** 中间内容的对齐方式，可通过该值修改contentToCenter=false下title居左显示 */
  public centerContentAlign?: Alignment = Alignment.Center
  /** 搜索框文本占位符 */
  public searchPlaceholder?: ResourceStr = "搜索..."
  /** 设置输入框类型。 */
  public searchInputType?: InputType = InputType.Normal
  /** 设置文本在输入框中的水平对齐方式。默认值：TextAlign.Start
   说明：仅支持TextAlign.Start、TextAlign.Center和TextAlign.End。 */
  public searchTextAlign?: TextAlign = TextAlign.Start
  /**   设置输入框为默认风格或内联输入风格 */
  public searchTextInputStyle?: TextInputStyle | TextContentStyle = TextInputStyle.Default
  /*设置是否开启下划线。下划线默认颜色为'#33182431'，默认粗细为1px，文本框尺寸48vp（下划线只支持InputType.Normal类型）。*/
  public searchShowUnderline?: boolean = false
  /** 搜索框文本占位符的字体颜色 */
  public searchPlaceholderFontColor?: ResourceColor = "#999999"
  /** 搜索框文本占位符的字体大小 */
  public searchPlaceholderFontSize?: ResourceStr | number = "16vp"
  /** 搜索框文本占位符的字体粗细 */
  public searchPlaceholderFontWeight?: string | number | FontWeight = FontWeight.Normal
  /** 搜索框图标 */
  public searchImage?: ResourceStr
  /** 搜索框图标的颜色 */
  public searchImageColor?: ResourceColor = "#999999"
  /** 搜索框图标的大小 */
  public searchImageSize?: Length = "15vp"
  /** 搜索框图标距离左侧的间距 */
  public searchImageLeftMargin?: Length = "15vp"
  /** 搜索框文本占位符的周边间距 */
  public searchPlaceholderMargin?: Padding | Length = { left: "0vp", right: "0vp" }
  /** 搜索框的背景颜色 */
  public searchBackgroundColor?: ResourceColor = "#F0F0F0"
  /** 搜索框的圆角，默认为内容的高度 */
  public searchBarRadius?: number = 0
  /** 从右侧屏幕往左的第一个按钮是否需要显示，默认不显示 */
  public showFirstImage?: boolean = false
  /** 从右侧屏幕往左的第一个按钮的图片 */
  public rightFirstImage?: ResourceStr
  /** 从右侧屏幕往左的第二个按钮是否需要显示，默认不显示 */
  public showSecondImage?: boolean = false
  /** 从右侧屏幕往左的第二个按钮的图片 */
  public rightSecondImage?: ResourceStr
  /** 从右侧屏幕往左的第三个按钮是否需要显示，默认不显示 */
  public showThirdImage?: boolean = false
  /** 从右侧屏幕往左的第三个按钮的图片 */
  public rightThirdImage?: ResourceStr
  /** 右侧功能按钮的图标大小，宽高都是该值 */
  public rightImageSize?: Length = "25vp"
  /** 右侧功能按钮的事件点击区域宽度，高度跟随内容的高度 */
  public rightImageBoxWidth: number = NavConstant.RIGHT_IMAGE_BOX_WIDTH
  /** 右侧功能按钮距离右侧屏幕的间距 */
  public rightImagesOnScreenRightMargin: number = NavConstant.RIGHT_IMAGE_ON_SCREEN_RIGHT_MARGIN
  /** 内容的高度 */
  public contentHeight: number = NavConstant.CONTENT_HEIGHT
  /** 内容距离底部的间距 */
  public contentBottomSpace?: Length = 0;
  /** 导航栏的总高度，该高度参考的程序为【我的华为】App */
  public navHeight?: Length = "56vp"
  /** 返回按钮的点击事件，如果存在返回标题，点击返回标题也会触发该事件 */
  public backClick?: (event?: ClickEvent) => void
  /** 搜索框的点击事件 */
  public searchClick?: (event?: ClickEvent) => void
  /** 按下输入法回车键触发该回调 */
  public onSubmit?: (enterKey?: EnterKeyType, event?: SubmitEvent) => void
  /** 输入内容发生变化时，触发该回调。 */
  public onChange?: (value: string) => void
  /** 输入状态变化时，触发该回调。有光标时为编辑态，无光标时为非编辑态。isEditing为true表示正在输入 */
  public onEditChange?: (isEditing: boolean) => void
  /** 从右侧屏幕往左的第一个按钮的点击事件 */
  public rightFirstImageClick: (event?: ClickEvent) => void = () => {
  }
  /** 从右侧屏幕往左的第二个按钮的点击事件 */
  public rightSecondImageClick: (event?: ClickEvent) => void = () => {
  }
  /** 从右侧屏幕往左的第三个按钮的点击事件 */
  public rightThirdImageClick: (event?: ClickEvent) => void = () => {
  }
  /** 替换中间的内容文本，替换后，需要自己实现【标题】或【搜索框】 */
  @BuilderParam
  public centerContent?: () => void
  /** 从右侧屏幕往左的第一个按钮的内容替换，一般可用来改为文本控件或者组合图标（双层图标），通过设置rightImageBoxWidth来拉开间距 */
  @BuilderParam
  public rightFirstImageContent?: () => void
  /** 从右侧屏幕往左的第二个按钮的内容替换，一般可用来改为文本控件或者组合图标（双层图标），通过设置rightImageBoxWidth来拉开间距 */
  @BuilderParam
  public rightSecondImageContent?: () => void
  /** 从右侧屏幕往左的第三个按钮的内容替换，一般可用来改为文本控件或者组合图标（双层图标），通过设置rightImageBoxWidth来拉开间距 */
  @BuilderParam
  public rightThirdImageContent?: () => void
  /** 右侧所有功能按钮的总长 + 按钮紧贴屏幕右侧的边距 */
  private rightImageTotalSpace: number = 0
  private controller: TextInputController = new TextInputController()

  aboutToAppear() {
    // 计算右侧功能键所占的总宽度
    this.fillRightImageTotalSpace()
    // 初始化默认参数
    if (!this.searchBarRadius) {
      // 默认搜索条背景圆角处理
      this.searchBarRadius = this.contentHeight / 2
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.End }) {
      Row() {
        // 返回按钮
        if (this.showBack) {
          this.backBuilder()
        }

        // 标题及搜索
        if (((this.title || this.searchClick) && !this.backTitle) || this.centerContent) {
          Stack() {
            if (this.centerContent) {
              // 外部替换
              this.centerContent()
            } else {
              // 内部预置
              if (this.title) {
                this.titleBuilder()
              }
              if (this.searchClick) {
                this.searchBarBuilder()
              }
            }

          }
          .alignContent(this.centerContentAlign)
          .layoutWeight(1)
          .margin(this.getCenterContentMargin())
        } else {
          Blank()
        }

        // 右侧的按钮，最多只能放三个
        if (this.showFirstImage || this.showSecondImage || this.showThirdImage) {
          Row() {
            Row() {
              if (this.showFirstImage) {
                this.rightImageBuilder(this.rightFirstImage, 0)
              }
              if (this.showSecondImage) {
                this.rightImageBuilder(this.rightSecondImage, 1)
              }
              if (this.showThirdImage) {
                this.rightImageBuilder(this.rightThirdImage, 2)
              }
            }
            .margin({ right: this.rightImagesOnScreenRightMargin })
            .height(this.contentHeight)
          }
        }
      }
      .backgroundColor(Color.Orange)
      .width(NavConstant.FULL_ALL_SPACE)
      .height(this.contentHeight)
      .margin({ bottom: this.contentBottomSpace })
    }
    .backgroundColor(this.naviBackgroundColor)
    .width(NavConstant.FULL_ALL_SPACE)
    .height(this.navHeight)
  }

  /**
   * 创建返回按钮
   */
  @Builder
  private backBuilder() {
    Row() {
      Image(this.backImage)
        .width(this.backImageSize)
        .height(this.backImageSize)
        .fillColor(this.backImageColor)
        .margin({ left: this.backImageLeftMargin })
      if (this.backTitle) {
        Text(this.backTitle)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontSize(this.backTitleFont)
          .fontWeight(this.backTitleFontWeight)
          .fontColor(this.backTitleColor)
          .margin({ left: this.backTitleLeftMargin })
      }
    }
    .onClick(this.backClick)
  }

  /**
   * 创建标题
   */
  @Builder
  private titleBuilder() {
    Text(this.title)
      .fontSize(this.titleFont)
      .fontWeight(this.titleFontWeight)
      .fontColor(this.titleColor)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .maxLines(1)
      .layoutWeight(1)
  }

  /**
   * 创建搜索条
   */
  @Builder
  private searchBarBuilder() {
    Row() {
      Image(this.searchImage)
        .width(this.searchImageSize)
        .height(this.searchImageSize)
        .fillColor(this.searchImageColor)
        .margin({ left: this.searchImageLeftMargin })


      TextInput({ placeholder: this.searchPlaceholder, controller: this.controller })
        .maxLines(1)
        .fontColor(this.searchPlaceholderFontColor)
        .fontSize(this.searchPlaceholderFontSize)
        .fontWeight(this.searchPlaceholderFontWeight)
        .margin(this.searchPlaceholderMargin)
        .backgroundColor("#00ffffff")
        .type(this.searchInputType)
        .style(this.searchTextInputStyle)
        .layoutWeight(1)
        .textAlign(this.searchTextAlign)
        .showUnderline(this.searchShowUnderline)
        .onSubmit(this.onSubmit)
        .onChange(this.onChange)
        .onEditChange(this.onEditChange)
    }
    .height(this.contentHeight)
    .backgroundColor(this.searchBackgroundColor)
    .borderRadius(this.searchBarRadius)
    .onClick(this.searchClick)

  }

  /**
   * 创建右侧紧贴屏幕的按钮
   */
  @Builder
  private rightImageBuilder(image?: ResourceStr, tag?: number) {
    Column() {
      if (this.rightFirstImageContent != undefined || this.rightSecondImageContent != undefined ||
        this.rightThirdImageContent != undefined) {
        // 外部替换
        if (this.rightFirstImageContent != undefined) {
          this.rightFirstImageContent()
        } else if (this.rightSecondImageContent != undefined) {
          this.rightSecondImageContent()
        } else if (this.rightThirdImageContent != undefined) {
          this.rightThirdImageContent()
        }
      } else {
        // 内部预置
        Image(image)
          .objectFit(ImageFit.Contain)
          .width(this.rightImageSize)
          .height(this.rightImageSize)
      }

    }
    .width(this.rightImageBoxWidth)
    .height(this.contentHeight)
    .justifyContent(FlexAlign.Center)
    .onClick((event: ClickEvent) => {
      if (tag === 0) {
        this.rightFirstImageClick(event)
        return
      }
      if (tag === 1) {
        this.rightSecondImageClick(event)
        return
      }
      if (tag === 2) {
        this.rightThirdImageClick(event)
        return
      }
    })
  }

  /**
   * 计算右侧功能键所占的总宽度
   */
  private fillRightImageTotalSpace() {
    let totalSpace = 0
    if (!this.showFirstImage && !this.showSecondImage && !this.showThirdImage) {
      return
    }
    totalSpace += this.rightImagesOnScreenRightMargin
    if (this.showFirstImage) {
      totalSpace += this.rightImageBoxWidth
    }
    if (this.showSecondImage) {
      totalSpace += this.rightImageBoxWidth
    }
    if (this.showThirdImage) {
      totalSpace += this.rightImageBoxWidth
    }
    this.rightImageTotalSpace = totalSpace
  }

  /**
   * 计算中心内容的两边Margin
   * @returns
   */
  private getCenterContentMargin(): Margin {
    if (this.contentToCenter) {
      const leftSpace = this.showBack ? this.backImageSize + this.backImageLeftMargin : 0
      const rightSpace = this.rightImageTotalSpace
      if (leftSpace > rightSpace) {
        return { left: this.contentHorizontalSpace, right: leftSpace + this.contentHorizontalSpace }
      }
      return { left: (rightSpace + this.contentHorizontalSpace) - leftSpace, right: this.contentHorizontalSpace }
    }
    return { left: this.contentHorizontalSpace, right: this.contentHorizontalSpace }
  }
}

