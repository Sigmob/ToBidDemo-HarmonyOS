import { ListenerModel } from './Model'

export class ViewModel {

  readonly model: ListenerModel;

  constructor() {
    this.model = new ListenerModel();
  }

  loadAdData() {
    this.model.loadState = '加载中...'
  }

  playAd() {

  }
}