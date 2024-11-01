import { TBNativeAd } from '@tobid/adsdk';
import { RandomUtil } from 'wind_common';

export class NativeDataModel {
  uniqId: string;
  type: string = '';
  title: string = '';
  source: string = ''
  incon: string = ''
  nativeAd?: TBNativeAd;
  
  constructor() {
    this.uniqId = RandomUtil.generateRandomUUID();
  }
}