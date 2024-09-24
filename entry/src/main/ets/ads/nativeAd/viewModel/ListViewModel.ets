import { RefreshController, RefreshDataSource } from '@abner/refresh';
import { TBDislikeListener, TBNativeAd, TBNativeAdLoader, TBNativeAdLoaderListener } from '@tobid/adsdk';
import { TBType } from '@tobid/adsdk';
import { TestPosId } from '../../../common/TestPosId';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'wind_common';
import Constant from '../../../common/Constant';
import { Toast } from '../../../common/Toast';
import { INativeAdVideoListener } from './ViewModel';
import { INativeAdInteractListener } from './ViewModel';
import { DatasUtil } from '../../../utls/DatasUtil';
import { RandomUtil } from '../../../utls/RandomUtil';
import DeviceInfo from '../../../common/DeviceInfo';

export class ListViewModel implements TBNativeAdLoaderListener {
  private adLoader?: TBNativeAdLoader;
  private isOnLoadMore: boolean = false;
  private isOnRefresh: boolean = false;
  readonly controller: RefreshController = new RefreshController() //刷新控制器，声明全局变量
  readonly dataSource: RefreshDataSource = new RefreshDataSource() //数据懒加载操作对象，执行数据增删改查

  onRefresh() {
    this.isOnRefresh = true;
    this.isOnLoadMore = false;
    this.dataSource.initData(DatasUtil.fakeDatas())
    this.loadAdData();
  }

  onLoadMore() {
    this.isOnLoadMore = true;
    this.isOnRefresh = false;
    this.loadAdData();
  }



  private loadAdData() {
    if (!this.adLoader) {
      let request: TBType.AdRequest = {
        placementId: TestPosId.POS_ID_NATIVE,
        adWidth: DeviceInfo.cwidth,
        userId: 'Codi', //userId方便后续排查用户问题
        adCount: 1, // 一次加载广告的数量，1～3条，默认为1
      }
      let adLoader = new TBNativeAdLoader(request)
      adLoader.adLoadListener = this;
      this.adLoader = adLoader;
    }
    this.adLoader.loadAdData();
  }


  destroy() {

  }

  /**
   * 广告加载成功回调
   */
  onAdLoadSuccessed(ads: TBNativeAd[]): void {
    Logger.debug(Constant.TAG, 'onAdDidLoad')
    Toast.show('onAdDidLoad')
    ads.forEach((data) => {
      let nativeAd = new WeakRef(data);
      data.videoListener = new INativeAdVideoListener(nativeAd);
      data.interactListener = new INativeAdInteractListener(nativeAd);
      data.dislikeListener = new ISGDislikeListener(new WeakRef(this));
    });
    if (this.isOnLoadMore) {
      let fakeDatas = DatasUtil.fakeDatas() as Object[];
      let fakeDatasCount = fakeDatas.length;
      ads.forEach((data) => {
        let index = RandomUtil.randomNumber(0, fakeDatasCount);
        fakeDatas.splice(index, 0, data);
      })
      this.dataSource.pushDataArray(fakeDatas);
      this.controller.finishLoadMore();
      this.isOnLoadMore = false;
    } else if (this.isOnRefresh) {
      let totalCount = this.dataSource.totalCount();
      ads.forEach((data) => {
        let index = RandomUtil.randomNumber(0, totalCount);
        this.dataSource.pushDataPosition(index, data);
      })
      this.controller.finishRefresh();
      this.isOnRefresh = false;
    }
  }

  /**
   * 广告加载失败
   * @param error
   */
  onAdLoadFailed(error: BusinessError<void>): void {
    Logger.error(Constant.TAG, `onAdLoadError[${JSON.stringify(error)}]`)
    Toast.show(`${JSON.stringify(error)}`)
    if (this.isOnLoadMore) {
      this.controller.finishLoadMore();
      this.isOnLoadMore = false;
    } else if (this.isOnRefresh) {
      this.controller.finishRefresh();
      this.isOnRefresh = false;
    }
  };
}

class ISGDislikeListener implements TBDislikeListener {
  readonly viewModel: WeakRef<ListViewModel>;

  constructor(viewModel: WeakRef<ListViewModel>) {
    this.viewModel = viewModel;
  }

  onShow(): void {
    Logger.debug(Constant.TAG, 'dislike.show')
    Toast.show('dislike.show')
  }

  onSelected(position: number, value: string, enforce: boolean): void {
    Logger.debug(Constant.TAG, `dislike.selected: ${position} - ${value} - ${enforce}`)
    Toast.show(`dislike.selected: ${position} - ${value} - ${enforce}`)
    // 需要在dislike回调中处理广告关闭，否则广告点击关闭后无反应
    let viewModel = this.viewModel.deref()
  }

  onCancel(): void {
    Logger.debug(Constant.TAG, 'dislike.cancel')
    Toast.show('dislike.cancel')
  }
}