import { NativeDataModel } from '../models/NativeDataMode';
import StringUtil from './StringUtil';
import { GlobalContext } from '../common/GlobalContext';
import { SlotId } from '../models/Model';

export class DatasUtil {

  static get_placement_ids(name: string): SlotId[] {
    let ctx = GlobalContext.getContext().context();
    let dataBuffer = ctx.resourceManager.getRawFileContentSync(name);
    let context = StringUtil.uint8ArrayToString(dataBuffer);
    let datas = JSON.parse(context) as SlotId[];
    return datas;
  }

  static fakeDatas(): NativeDataModel[] {
    let ctx = GlobalContext.getContext().context();
    let dataBuffer = ctx.resourceManager.getRawFileContentSync('feedInfo.json');
    let context = StringUtil.uint8ArrayToString(dataBuffer);
    let datas = JSON.parse(context) as Record<string, string>[];
    let resluts: NativeDataModel[] = [];
    datas.forEach((data) => {
      let model = new NativeDataModel();
      if (data['title']) {
        model.title = data['title'];
      }
      if (data['type']) {
        model.type = data['type'];
      }
      if (data['source']) {
        model.source = data['source'];
      }
      if (data['incon']) {
        model.incon = data['incon'];
      }
      resluts.push(model);
    })
    return resluts;
  }
}