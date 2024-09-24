import { BasicDataSource } from './BasicDataSource';

export class RefreshDataSource extends BasicDataSource {
  private dataArray: Object[] = [];

  // 获得数据总数
  totalCount(): number {
    return this.dataArray.length;
  }

  initData(datas: Object[]) {
    this.dataArray = datas;
    this.notifyDataReload();
  }

  // 获取索引值对应的数据
  getData(index: number): Object {
    return this.dataArray[index];
  }

  public addData(index: number, data: Object): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Object): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(data: Object): void {
    let index = this.dataArray.indexOf(data);
    if (index != -1) {
      this.dataArray.splice(index, 1);
      this.notifyDataDelete(index);
    }
  }

  public pushDataArray(datas: Object[]): void {
    this.dataArray = this.dataArray.concat(datas);
    this.notifyDataReload();
  }
}