import { promptAction } from '@kit.ArkUI'

export class Toast {
  static show(msg: string, duration = 2000) {
    promptAction.showToast({
      message: msg,
      duration
    })
  }
}