import display from '@ohos.display';
import { Logger } from 'wind_common';
import Constant from '../../common/Constant';
import { SelectorDialog } from '../dialog/SelectorDialog';
import { ModeType } from './SelectorList';


export enum ZPRowMode {
  None,
  Text,
  TextInput,
  Switch,
  Selector,
}

@Component
export struct ZPSection {
  header?: string | Resource;
  footer?: string | Resource;
  configs: ZPRowConfig[] = [];

  build() {
    Column() {
      Row() {
        Text(this.header)
          .fontSize($r('app.float.normal_text_size'))
          .fontColor($r('app.color.font_gray_color'))
          .maxLines(1)
      }
      .width(Constant.FULL_PARENT)
      .padding({
        left: $r('app.float.padding_normal'),
        right: $r('app.float.padding_normal'),
      })

      Blank().height(10)

      ForEach(this.configs, (config: ZPRowConfig) => {
        ZPRow({ config: config }).backgroundColor(Color.White)
      }, (config: ZPRowConfig, index: number) => index.toString())
      if (this.footer) {
        Row() {
          Text(this.footer)
            .fontSize($r('app.float.small_text_size'))
            .fontColor($r('app.color.font_gray_color'))
            .maxLines(2)
        }
        .width(Constant.FULL_PARENT)
        .padding({
          left: $r('app.float.padding_normal'),
          right: $r('app.float.padding_normal'),
        })
      }
    }
    .width(Constant.FULL_PARENT)
    .margin({
      top: $r('app.float.mainPage_tabTitles_margin'),
    })
  }
}

@Component
export struct ZPRow {
  @Require config: ZPRowConfig = new ZPRowConfig();
  fontColor: ResourceColor = $r('app.color.font_main_color_dark')
  @State showSelector: boolean = false // 是否展开下拉菜单
  modesDatas: ModeType[] = []
  @State currentMode: ModeType = {id: -1, name: 'none'};
  private onlyRight:boolean = true;
  private rid: string = '';
  private dialog?: CustomDialogController

  aboutToAppear() {
    if (this.config.getIcon() == undefined && this.config.getTitle() == undefined) {
      this.onlyRight = false;
    }
    if (this.config.getMode() == ZPRowMode.Selector) {
      this.modesDatas = this.config.getDatas()
      if (this.modesDatas !== null && this.modesDatas.length > 0) {
        this.currentMode = this.modesDatas[0]
      }
      if (typeof this.config.getValue() == 'number') {
        let value = this.config.getValue() as number
        if (this.modesDatas.length > value && value >= 0) {
          this.currentMode = this.modesDatas[value]
        }
      }
      let onValueChanged = this.config.getOnValueChanged()
      if (onValueChanged && this.currentMode) {
        onValueChanged(this.currentMode);
      }
    }
  }

  build() {
    Column() {
      Row() {
        if (this.onlyRight) {
          Row({ space: Constant.COMMON_SPACE }) {
            if (this.config.getIcon()) {
              Image(this.config.getIcon())
                .width($r('app.float.image_cell_size'))
                .height($r('app.float.image_cell_size'))
            }
            Text(this.config.getTitle())
              .fontSize($r('app.float.normal_text_size'))
              .fontColor(this.fontColor)
              .fontWeight(FontWeight.Medium)
              .maxLines(1)
          }
          .constraintSize({
            maxWidth: '50%'
          })
        }
        Row() {
          this.right_build()
        }
        .constraintSize({
          maxWidth: this.onlyRight ? '60%' : '100%'
        })
        .justifyContent(this.onlyRight ? FlexAlign.End : FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
      }
      .constraintSize({
        minHeight: Constant.CELL_HEIGHT_NORMAL
      })
      .backgroundColor(Color.Transparent)
      .justifyContent(FlexAlign.SpaceBetween)
      .width(Constant.FULL_PARENT)
      .padding({
        left: $r('app.float.padding_normal'),
        right: $r('app.float.padding_normal')
      })

      Divider()
    }
    .onClick(this.config.getOnClick())
  }

  @Builder
  right_build() {
    if (this.config.getMode() == ZPRowMode.None) {
      this.arrow_right_build()
    } else if (this.config.getMode() == ZPRowMode.Text) {
      this.text_right_build()
    } else if (this.config.getMode() == ZPRowMode.Switch) {
      this.switch_right_build()
    } else if (this.config.getMode() == ZPRowMode.TextInput) {
      this.textInput_right_build()
    } else if (this.config.getMode() == ZPRowMode.Selector) {
      this.selector_right_build()
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
    if (typeof (this.config.getValue()) === 'string' || typeof (this.config.getValue()) === 'object') {
      Text(this.config.getValue() as string | Resource).titleTextStyle()
    }
    if (typeof (this.config.getValue()) === 'boolean' || typeof (this.config.getValue()) === 'number') {
      Text(`${this.config.getValue()}`).titleTextStyle()
    }
  }

  @Builder
  switch_right_build() {
    if (typeof (this.config.getValue()) === 'boolean') {
      Toggle({ type: ToggleType.Switch, isOn: this.config.getValue() as boolean })
        .selectedColor($r('app.color.main_color'))
        .switchPointColor('#FFFFFF')
        .onChange((isOn: boolean) => {
          let changeHandler = this.config.getOnValueChanged();
          if (changeHandler) {
            changeHandler(isOn)
          }
        })
    }
  }

  @Builder
  textInput_right_build() {
    TextInput({
      text: this.config.getValue() == undefined ? '' : `${this.config.getValue()}`,
      placeholder: this.config.getPlaceholder()
    })
      .type(InputType.Normal)
      .style(TextInputStyle.Default)
      .backgroundColor(Color.Transparent)
      .textAlign(this.onlyRight ? TextAlign.End : TextAlign.Start)
      .caretColor($r('app.color.main_color'))
      .onChange((value: string) => {
        let changeHandler = this.config.getOnValueChanged();
        if (changeHandler) {
          changeHandler(value)
        }
      })
      .onEditChange((isEditing: boolean) => {
        if (isEditing) {
          this.fontColor = $r('app.color.main_color')
        } else {
          this.fontColor = $r('app.color.font_main_color_dark')
        }
      })
  }

  @Builder
  selector_right_build() {
    RelativeContainer(){
      Text(this.currentMode ? this.currentMode.name : 'none')
        .fontSize($r('app.float.small_text_size'))
        .fontColor($r('app.color.font_main_color_dark'))
        .id(this.rid)
        .margin({
          right: 22
        })
        .id('name')
        .alignRules({
          center: {anchor: '__container__', align: VerticalAlign.Center},
          middle: {anchor: '__container__', align: HorizontalAlign.Center},
        })

      Image(this.showSelector ? $r('app.media.icon_arrow_top') : $r('app.media.icon_arrow_bottom'))
        .height($r('app.float.arrow_jump_height'))
        .width($r('app.float.arrow_jump_height'))
        .margin({ right: $r('app.float.padding_small') })
        .id('img')
        .alignRules({
          right: {anchor: '__container__', align: HorizontalAlign.End},
          center: {anchor: '__container__', align: VerticalAlign.Center},
        })
    }
    .onClick((event: ClickEvent) => {
      Logger.debug(Constant.TAG, JSON.stringify(event))
      let deviceInfo = display.getDefaultDisplaySync();
      let screenHeight = px2vp(deviceInfo.height)
      let cheight: number = (this.config.getDatas().length > 5 ? 5 : this.config.getDatas()
        .length) * Constant.SELECTOR_CELL_HEIGHT
      let cx = event.windowX - event.x
      let cy = event.windowY - event.y + Constant.SELECTOR_CELL_HEIGHT
      if (cy + cheight > screenHeight * 0.9) {
        cy = cy - cheight - Constant.SELECTOR_CELL_HEIGHT
      }
      this.dialog = new CustomDialogController({
        customStyle: true,
        builder: SelectorDialog({
          controller: this.dialog,
          selectOptions: this.config.getDatas(),
          currentMode: this.currentMode,
          onSelected: this.config.getOnValueChanged(),
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
    .width('50%')
    .margin($r('app.float.padding_small'))
  }
}

export class ZPSessionConfig {
  header?: string;
  footer?: string;
  configs: ZPRowConfig[] = []
}

export class ZPRowConfig {
  private _icon?: Resource;
  private _title?: string | Resource;
  private _placeholder: string = ''
  private _mode: ZPRowMode = ZPRowMode.None;
  private _value?: string | boolean | number | Resource;
  private _onClick?: (event?: ClickEvent) => void;
  private _onValueChanged?: (value: ModeType|boolean|string) => void;
  private _datas: ModeType[] = [] //下拉选择框数据源
  private _tag: number = 0;
  name: string = '';

  getTag(): number {
    return this._tag
  }
  tag(val: number): ZPRowConfig {
    this._tag = val
    return this
  }

  getPlaceholder(): string {
    return this._placeholder;
  }

  placeholder(value: string): ZPRowConfig {
    this._placeholder = value;
    return this;
  }

  datas(value: ModeType[]): ZPRowConfig {
    this._datas = value
    return this
  }

  getDatas(): ModeType[] {
    return this._datas
  }

  icon(value: Resource): ZPRowConfig {
    this._icon = value;
    return this;
  }

  getIcon(): Resource | undefined{
    return this._icon
  }

  title(value: string | Resource): ZPRowConfig {
    this._title = value;
    return this;
  }

  getTitle(): string | Resource | undefined {
    return this._title
  }

  mode(value: ZPRowMode): ZPRowConfig {
    this._mode = value;
    return this;
  }

  getMode(): ZPRowMode {
    return this._mode
  }

  value(value: string | number | boolean | Resource): ZPRowConfig {
    this._value = value;
    return this;
  }

  getValue(): string | number | boolean | Resource | undefined{
    return this._value
  }

  onClick(event: (event?: ClickEvent) => void): ZPRowConfig {
    this._onClick = event;
    return this;
  }

  getOnClick(): ((event?: ClickEvent) => void) | undefined{
    return this._onClick
  }

  onValueChanged(event?: (value: ModeType|boolean|string) => void): ZPRowConfig {
    this._onValueChanged = event
    return this
  }

  getOnValueChanged():( (value: ModeType|boolean|string) => void) | undefined {
    return this._onValueChanged
  }
}

@Extend(Text) function titleTextStyle() {
  .fontSize($r('app.float.small_text_size'))
  .fontColor($r('app.color.font_gray_color'))
  .maxLines(3)
}