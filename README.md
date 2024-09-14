[TOC]

# ToBid广告鸿蒙-SDK接入文档

##  SDK集成与工程配置

### 鸿蒙中心仓库接入

在oh-package.json5添加依赖

```json
"dependencies": {
  "tobidadsdk": "1.0.0"
}
```



### 手动引入har包

在oh-package.json5添加依赖

```json
"dependencies": {
  "tobidadsdk": "file:./libs/tobidad-{version}.har",
  "wind_common": "file:./libs/wind_common-{version}.har"
}
```
工程完成依赖接入后，执行 ohpm install 执行har包的安装，即可在工程中tobidadsdk了。

**注意：**
如果之前接入了har或者本次为替换har包更新版本，可先执行ohpm clean cache清除oh_modules目录，避免更新har包失败。



### 鸿蒙集成编译环境

在下述版本验证通过： 

DevEco Studio NEXT Developer Beta6

构建版本：5.0.3.402

SDK: API12



### 添加权限

1. 打开app模块的module.json5文件
2. 添加以下权限:访问网络、获取网络状态(可选)、获取广告追踪标识(oaid)(可选)、获取位置信息(可选)

```json
"requestPermissions": [
      {
        "name": "ohos.permission.INTERNET",
        "reason": "$string:permission_reason",
      },
      {
        "name": 'ohos.permission.APP_TRACKING_CONSENT',
        "reason": '$string:permission_reason',
      },
      {
        "name": 'ohos.permission.APPROXIMATELY_LOCATION',
        "reason": '$string:permission_reason',
      },
      {
        "name": 'ohos.permission.GET_WIFI_INFO',
        "reason": '$string:permission_reason',
      },
      {
        "name": 'ohos.permission.GET_NETWORK_INFO',
        "reason": '$string:permission_reason',
      }
]
```

| 权限名称                               | 说明                                                   | 必要性 |
| -------------------------------------- | ------------------------------------------------------ | ------ |
| ohos.permission.APP_TRACKING_CONSENT   | '允许应用读取开放匿名设备标识符'，SDK用于获取oaid；可选，影响转化    | 可选   |
| ohos.permission.INTERNET               | '允许使用Internet网络'，SDK用于网络请求；              | 必选   |
| ohos.permission.GET_WIFI_INFO          | '允许应用获取Wi-Fi信息'，SDK用于判断设备连接wifi状态   | 可选   |
| ohos.permission.GET_NETWORK_INFO       | '允许应用获取Network信息', SDK检查蜂窝数据业务是否启用 | 可选   |
| ohos.permission.APPROXIMATELY_LOCATION | '允许应用获取设备模糊位置信息', SDK用于获取经纬度      | 可选   |



## 隐私合规与SDK初始化

### SDK初始化

```typescript
import  { ToBidAd, ToBidAdConfig } from 'tobidadsdk';

onWindowStageCreate(windowStage: window.WindowStage): void {
	let adConfig: ToBidAdConfig = new ToBidAdConfig({
		appId: "your appId", 
		appKey: "your appKey"
	});
	ToBidAd.initialized(this.context, windowStage, adConfig).then(() => {
		console.log('ToBidAd初始化成功')
	}).catch((err: BusinessError) => {
		console.log('ToBidAd初始化失败' + JSON.stringify(err))
	});
}

// 获取SDK初始化状态
ToBidAd.initState()
```



### 隐私合规



```typescript
export abstract class TBCustomPrivacyController {
  /**
   * app在项目中配置权限。并在合适时机动态申请权限，用户授权。
   * 1：当isCanUseLocation()返回false。当sdk需要地理位置信息时，使用getLocation()返回的值。
   * 2：当isCanUseLocation()返回true。当sdk需要地理位置信息时，先去检查是否已经得到用户授权，如果是则获取系统地理位置信息，如果否则使用getLocation()返回的值。
   * @returns 是否允许SDK获取系统地理位置信息
   */
  isCanUseLocation() {
    return true;
  }

  /**
   *
   * @returns 媒体传入的地理位置信息
   */
  getLocation(): TBType.Location {
    let location: TBType.Location = {
      longitude: Device.longitude,
      latitude: Device.latitude
    }
    return location;
  }

  /**
   * app在项目中配置权限。在适当时机申请权限，然后用户授权。
   * 1：如果isCanUseAppTrackingConsent()返回false，当sdk需要oaid时，则使用getDevOaid()返回的值。
   * 2：如果isCanUseAppTrackingConsent()返回true。当sdk需要oaid时，先去检查权限是否已经得到用户授权，如果用户已经授权则获取系统oaid。如果用户未授权，则使用getDevOaid()返回的值。
   * @returns 是否允许SDK获取系统oaid
   */
  isCanUseAppTrackingConsent(): boolean {
    return true;
  }


  /**
   * isCanUseOaid=false时，开发者可以传入oaid
   *
   * @return oaid
   */
  async getDevOaid(): Promise<string> {
    return Device.getOAID();
  }


  /**
   * 是否允许SDK使用ohos.permission.GET_WIFI_INFO权限对应的信息。
   * 返回true，如果应用申请了ohos.permission.GET_WIFI_INFO权限，sdk则可以使用
   * 返回false，sdk则不可以使用。
   * @returns
   */
  isCanUseWifiState() {
    return true
  }

  /**
   * 媒体isCanUseWifiState()返回false时，SDK使用getMacAddress()的返回值作为mac地址
   * @returns
   */
  getMacAddress(): string | undefined {
    return undefined
  }
}
```







## 开屏广告

### 场景介绍

开屏广告是一种在应用启动时且在应用主界面显示之前需要被展示的广告。您需要预先为App设计一张开屏默认的Slogan图片，确保在未获得到开屏广告之前展示默认的Slogan，提供良好的用户体验。

开屏广告分为全屏开屏广告、半屏开屏广告，其中全屏开屏广告展示形式为广告铺满整个页面；半屏开屏广告展示形式会根据媒体页面自定义布局渲染广告、icon和版权信息，一般情况下建议将icon和版权信息展示在广告下方。



### 接口说明

```typescript
export class TBSplashAd extends TBBaseAd {

  constructor(request: TBType.AdRequest);

  /**
   * 获取当前广告对象的广告请求信息
   */
  get request(): TBType.AdRequest;

  /**
   * 设置广告加载监听器
   */
  set adLoadListener(listener: TBAdLoadListener);

  /**
   * 设置广告交互监听器
   */
  set adInteractionListener(listener: TBSplashAdInteractionListener);

  /**
   * 检查广告是否准备完成，处于可播放状态。
   */
  ready(): boolean;

  /**
   * 返回广告缓存池内所有信息
   * 填充后可调用, 广告关闭后清理
   * @returns
   */
  getCacheAdInfoList(): TBAdInfo[];

  /**
   * 加载广告
   */
  loadAdData(): void;

  /**
   * 播放广告
   */
  showAd(options?: TBType.AdDisplayOptions) : void;

  /**
   * 销毁资源
   */
  destroy(): void;
}
```



### 广告加载监听器

```typescript
export interface TBAdLoadListener {
  /**
   * 广告素材缓存成功，此时广告处于等待播放状态
   */
  onAdDidLoad: () => void;

  /**
   * 广告加载失败
   * @param error 错误描述信息
   */
  onAdLoadError: (error: BusinessError) => void;

}
```



### 广告交互监听器

```typescript
export interface TBSplashAdInteractionListener {
  /**
   *  广告展示
   * @param adInfo 当前渠道信息
   */
  onAdShow(adInfo: TBAdInfo): void;

  /**
   * 广告调用播放时出错
   * @param error 错误描述信息
   */
  onAdShowError(error: BusinessError<void>): void

  /**
   *  广告点击
   * @param adInfo 当前渠道信息
   */
  onAdClick(adInfo: TBAdInfo): void;

  /**
   *  广告关闭
   * @param adInfo 当前渠道信息
   */
  onAdClose(adInfo: TBAdInfo): void;


  /**
   *  用户在观看时点击了跳过
   * @param adInfo 当前渠道信息
   */
  onSkipped(adInfo: TBAdInfo): void;


  /**
   *  倒计时结束
   * @param adInfo 当前渠道信息
   */
  onCounterZero(adInfo: TBAdInfo): void;


  /**
   * 自定义开屏广告底部品牌区域
   * @param builder
   * @returns tbnode.Data中wrap和controller两个参选二选其一即可
   */
  customBottomViewWrapBuilder(parameter: TBParameter, adInfo: TBAdInfo): tbnode.Data | undefined;
}
```



### 加载开屏广告

```typescript
// 创建广告请求参数
let request: TBType.AdRequest = {
	placementId: 'your placement id',
	userId: 'your user ID',
	adWidth: number,
  adHeight: number
}
// 创建广告加载对象
let splashAd = new TBSplashAd(request);
// 设置广告监听
splashAd.adLoadListener = this;
splashAd.adInteractionListener = this;
// 加载广告
splashAd.loadAdData();
```



### 展示开屏广告

广告加载成功后即可展示开屏广告，**收到onAdDidLoad回调**代表广告加载成功，建议在广告展示前通过ready方法判断广告是否准备完成。

```typescript
// 展示广告
if (splashAd.ready()) {
	splashAd.showAd()
}
```





## 激励视频广告



### 场景介绍

激励广告是一种全屏播放的广告，用户可以在观看完整的广告后获取奖励,视频广告播放结束后会显示结束页面，引导用户进行后续动作。目前鸿蒙上激励广告的表现形式为：视频播放完展示Endcard页面，或者直接出现广告落地页。



### 接口说明

```typescript
export class TBRewardVideoAd extends TBBaseAd {

  constructor(request: TBType.AdRequest);

  /**
   * 获取当前广告对象的广告请求信息
   */
  get request(): TBType.AdRequest;

  /**
   * 设置广告加载监听器
   */
  set adLoadListener(listener: TBAdLoadListener);

  /**
   * 设置广告交互监听器
   */
  set adInteractionListener(listener: TBRewardAdInteractionListener);

  /**
   * 检查广告是否准备完成，处于可播放状态。
   */
  ready(): boolean;

  /**
   * 返回广告缓存池内所有信息
   * 填充后可调用, 广告关闭后清理
   * @returns
   */
  getCacheAdInfoList(): TBAdInfo[];

  /**
   * 加载广告
   */
  loadAdData(): void;

  /**
   * 播放广告
   */
  showAd(options?: TBType.AdDisplayOptions): void;

  /**
   * 销毁数据
   */
  destroy(): void;
}
```



### 广告加载监听器

```typescript
export interface TBAdLoadListener {
  /**
   * 广告素材缓存成功，此时广告处于等待播放状态
   */
  onAdDidLoad: () => void;

  /**
   * 广告加载失败
   * @param error 错误描述信息
   */
  onAdLoadError: (error: BusinessError) => void;
}
```



### 广告交互监听器

```typescript

export interface TBRewardAdInteractionListener {
  /**
   *  广告展示
   * @param adInfo 当前渠道信息
   */
  onAdShow(adInfo: TBAdInfo): void;

  /**
   * 调用播放时出错
   * @param error 错误描述信息
   */
  onAdShowError(error: BusinessError<void>): void;

  /**
   * 广告点击
   * @param adInfo  当前渠道信息
   */
  onAdClick(adInfo: TBAdInfo): void;

  /**
   * 广告关闭
   * @param adInfo 当前渠道信息
   */
  onAdClose(adInfo: TBAdInfo): void;

  /**
   * 奖励发放
   * @param reward 奖励信息
   * @param adInfo 当前渠道信息
   */
  onRewardArrived(adInfo: TBAdInfo, reward: TBReward): void;

  /**
   * 广告素材播放完成，例如视频未跳过，完整的播放了
   * @param adInfo 当前渠道信息
   */
  onVideoComplete(adInfo: TBAdInfo): void;

  /**
   * 用户在观看时点击了跳过
   * @param adInfo 当前渠道信息
   */
  onSkipped(adInfo: TBAdInfo): void;

  /**
   * 广告展示时出错
   * @param error 错误描述信息
   * @param adInfo 当前渠道信息
   */
  onVideoError(error: BusinessError, adInfo: TBAdInfo): void ;
}
```

### 服务端回调说明

- **服务器回调模式不是必须的**，只是增加了一次第三方服务器的验证判断。具体的奖励发放由客户端完成。
- 服务端回调逻辑：ToBid根据“**奖励发放条件“，**先通过“ToBid服务端”访问“开发者服务端”向开发者确认是否进行奖励发放，再依据“开发者服务端”返回的true/false，在客户端给出是/否发放奖励的回调。
- ToBid服务端只是透传验证请求，不会在中间过程添加校验逻辑。为了保障开发者利益和用户体验，开发者可以在验证环节增加自己的校验逻辑。

### Reward接口说明

```typescript
export class TBReward {

  /**
   * 第三方交易ID
   */
  transId?: string;

  /**
   * 奖励是否有效
   */
  isRewardValid: boolean = false;

  /**
   * 奖励名称
   */
  rewardName?: string;

  /**
   * 奖励数量
   */
  rewardAmount: number = 0;

  /**
   * 奖励类型
   */
  rewardType?: string;
}
```



### 加载激励视频广告

```typescript
// 创建广告请求参数
let request: TBType.AdRequest = {
	placementId: 'your placement id',
	userId: 'your user ID',
  // options在开通服务端奖励回调时会透传给三方服务器
  options: {
    'custom_info': 'xxx',
    'age': '32'
  }
}
// 创建广告加载对象
let rewardVideoAd = new TBRewardVideoAd(request);
// 设置广告监听
rewardVideoAd.adLoadListener = this;
rewardVideoAd.adInteractionListener = this;
// 加载广告
rewardVideoAd.loadAdData();
```



### 展示激励视频广告

广告加载成功后即可展示开屏广告，**收到onAdDidLoad回调**代表广告加载成功，建议在广告展示前通过ready方法判断广告是否准备完成。

```typescript
// 展示广告
if (rewardVideoAd.ready()) {
	rewardVideoAd.showAd()
}
```





## 插屏广告

### 场景介绍

插屏广告是一种在应用开启、暂停或退出时以全屏或半屏的形式弹出的广告形式，展示时机巧妙避开用户对应用的正常体验，尺寸大，曝光效果好。



### 接口说明

```typescript
export class TBInterstitialAd extends TBBaseAd {

  constructor(request: TBType.AdRequest);

  /**
   * 获取当前广告对象的广告请求信息
   */
  get request(): TBType.AdRequest;

  /**
   * 设置广告加载监听器
   */
  set adLoadListener(listener: TBAdLoadListener);

  /**
   * 设置广告交互监听器
   */
  set adInteractionListener(listener: TBInterstitialAdInteractionListener);

  /**
   * 检查广告是否准备完成，处于可播放状态。
   */
  ready(): boolean;

  /**
   * 返回广告缓存池内所有信息
   * 填充后可调用, 广告关闭后清理
   * @returns
   */
  getCacheAdInfoList(): TBAdInfo[];

  /**
   * 加载广告
   */
  loadAdData(): vodi;

  /**
   * 播放广告
   */
  showAd(options?: TBType.AdDisplayOptions): vodi;

  /**
   * 销毁数据
   */
  destroy(): void;
}
```



### 广告加载监听器

```typescript
export interface TBAdLoadListener {
  /**
   * 广告素材缓存成功，此时广告处于等待播放状态
   */
  onAdDidLoad: () => void;

  /**
   * 广告加载失败
   * @param error 错误描述信息
   */
  onAdLoadError: (error: BusinessError) => void;
}
```



### 广告交互监听器

```typescript
export interface TBInterstitialAdInteractionListener {
  /**
   *  广告展示
   * @param adInfo 当前渠道信息
   */
  onAdShow(adInfo: TBAdInfo): void;

  /**
   * 调用广告播放时出错
   * @param error 错误描述信息
   */
  onAdShowError(error: BusinessError<void>): void;

  /**
   *  广告点击
   * @param adInfo 当前渠道信息
   */
  onAdClick(adInfo: TBAdInfo): void;

  /**
   *  广告关闭
   * @param adInfo 当前渠道信息
   */
  onAdClose( adInfo: TBAdInfo): void;

  /**
   *  广告素材播放完成，例如视频未跳过，完整的播放了
   * @param adInfo 当前渠道信息
   */
  onVideoComplete(adInfo: TBAdInfo): void;

  /**
   *  用户在观看时点击了跳过
   * @param adInfo 当前渠道信息
   */
  onSkipped(adInfo: TBAdInfo): void;

  /**
   *  广告展示时出错
   * @param error 错误描述信息
   * @param adInfo 当前渠道信息
   */
  onVideoError(error: BusinessError, adInfo: TBAdInfo): void ;
}
```



### 加载插屏广告

```typescript
// 创建广告请求参数
let request: TBType.AdRequest = {
	placementId: 'your placement id',
	userId: 'your user ID',
}
// 创建广告加载对象
let interstitialAd = new TBInterstitialAd(request);
// 设置广告监听
interstitialAd.adLoadListener = this;
interstitialAd.adInteractionListener = this;
// 加载广告
interstitialAd.loadAdData();
```



### 广告展示

广告加载成功后即可展示开屏广告，**收到onAdDidLoad回调**代表广告加载成功，建议在广告展示前通过ready方法判断广告是否准备完成。

```typescript
// 展示广告
if (interstitialAd.ready()) {
	interstitialAd.showAd()
}
```







## 信息流广告

### 场景介绍

原生广告是与应用内容融于一体的广告，通过“和谐”的内容呈现广告信息，在不破坏用户体验的前提下，为用户提供有价值的信息，展示形式包含图片和视频，支持您自由定制界面。



信息流广告分为自渲染广告和模板广告，但是模板广告只有当三方SDK支持时才会返回模板广告。

- 自渲染广告：聚合SDK返回物料，由开发者在TBNativeAdComponent组件上进行子视图的自行渲染和展示。
- 模版渲染广告：聚合SDK直接返回渲染好的广告组件TBNativeAdComponent，开发者直接展示即可。



### 广告加载类TBNativeAdLoader

在SDK里只需要使用 TBNativeAdLoader 就可以获取信息流广告。TBNativeAdLoader支持多广告加载，可以一次加载返回多个广告。

> **注意：adHeight高度为0时，广告的实际高度由模版广告自行渲染决定**



```typescript
export class TBNativeAdLoader {
  /**
   * 广告请求信息
   */  
  readonly request: TBType.AdRequest;

  /**
   * 构造函数
   */  
  constructor(request: TBType.AdRequest);

  /**
   * 设置广告加载监听器
   */
  set adLoadListener(listener: TBNativeAdLoaderListener);

  /**
   * 返回广告缓存池内所有信息
   * 填充后可调用, 广告关闭后清理
   * @returns
   */
  getCacheAdInfoList(): TBAdInfo[];

  /**
   * 加载广告
   */
  loadAdData();

  /**
   * 销毁广告加载资源
   */
  destroy(): void;

}
```



### 广告模型类TBNativeAd

在广告加载成功回调中获取相关广告信息，将广告信息传入广告组件TBNativeAdComponent进行信息流广告的展示。

```typescript
export class TBNativeAd {
  /**
   * 广告交互监听器
   */
  interactListener: TBNativeAdInteractListener | null = null;
  
  /**
   * 视频交互监听器
   */
  videoListener: TBAdVideoListener | null = null;
  /**
   * 广告dislike弹窗监听
   */
  dislikeListener: TBDislikeListener | null = null;
  /**
   * 渠道ID
   */
  readonly channelId: TBType.Channel;
  /**
   * 普通点击组件Id集合
   */
  readonly clickViewIds: TBClickViewIdList<string> = new TBClickViewIdList();
  /**
   * 创意点击ID集合
   */
  readonly creativeViewIds: TBClickViewIdList<string> = new TBClickViewIdList();
  /**
   * 扩展参数
   */
  readonly extra: Record<string, Object> = {};


  /**
   * 释放资源
   */
  destroy(): void;

  /**
   * 广告唯一标识
   */
  getUniqueId(): string;

  /**
   * 素材类型
   * 【模版渲染为空】
   */
  getMaterialType(): TBType.MaterialType;

  /**
   * 渲染类型 模版渲染 or 自渲染
   */
  getRenderType(): TBType.RenderType;

  /**
   * 信息流广告类型 信息流 or DrawVideo
   */
  getNativeType(): TBType.NativeType;

  /**
   * 广告交互类型
   * 【模版渲染时为空】
   */
  getInteractionType(): TBType.AdInteractionType;

  /**
   * 广告标题
   * 【模版渲染时为空】
   */
  getAdTitle(): string;

  /**
   * 广告描述
   * 【模版渲染时为空】
   */
  getAdDescription(): string;

  /**
   * 广告来源，可能为空
   * 【模版渲染时为空】
   */
  getAdSource(): string;

  /**
   * 获取广告⻆标的logo
   * 当返回string类型时，可能为标准url，(csj)adx广告场景时可能文字描述
   * 【模版渲染时为空】
   */
  getAdLogo(): string | Resource | undefined ;

  /**
   * 广告图片集合，单图和组图类型广告素材有返回，视频类素材返回为空
   * 【模版渲染时为空】
   */
  getImageList(): TBAdImage[];

  /**
   * 广告Icon链接
   * 【模版渲染时为空】
   */
  getAppIconUrl(): string | undefined;

  /**
   * 应用下载相关合规信息
   * 【模版渲染时为空】
   */
  getComplianceInfo(): TBComplianceInfo | undefined;

  /**
   * 应用下载次数文案，非下载返回为空 eg:1000W此下载
   * 【模版渲染时为空】
   */
  getAppDownloadCountDes(): string | undefined;

  /**
   * 广告app评论数
   * 【模版渲染时为0】
   */
  getAppCommentNum(): number;


  /**
   * 应用下载评分，取值0~5.0; 非下载返回为0
   * 【模版渲染时为空】
   */
  getAppScore(): number;

  /**
   * 视频封面url
   * [支持渠道：快手]
   * 【模版渲染时为空】
   */
  getCoverUrl(): TBAdImage | undefined;

  /**
   * 视频url
   * 【模版渲染时为空】
   */
  getVideoUrl(): string | undefined;

  /**
   * 视频时⻓
   * 【模版渲染时为空】
   */
  getVideoDuration(): number;

  /**
   * CTA按钮文案
   * 【模版渲染时为空】
   */
  getActionDescription(): string;


	/**
   * 注册原生自渲染广告点击组件ID
   * @param rootAdComponentId 广告布局根节点Id
   * @param uiContext 当前组件的上下文
   * @param clickViewIds 普通点击Id集合,点击之后，会跳转到落地页，然后再进行后续广告转化
   * @param creativeViewIds： 创意点击Id集合，点击之后，会直接进行转化
   */
  registerViewForInteraction(clickViewIds: TBClickViewIdList<string>, creativeViewIds: TBClickViewIdList<string>);
}
```



#### TBComplianceInfo说明

TBComplianceInfo提供应用下载相关合规信息，仅在返回广告位下载类广告时生效。

```typescript
export class TBComplianceInfo extends TBMediaComplianceInfo {

  /**
   * 获取App Name
   * @returns
   */
  getAppName(): string;

  /**
   * 获取应用版本
   * @returns
   */
  getAppVersion(): string;

  /**
   * 获取开发者名称
   * @returns
   */
  getDeveloperName(): string;

  /**
   * 获取隐私协议
   * @returns
   */
  getPrivacyUrl(): string;

  /**
   * 获取权限名称及权限描述列表
   * @returns
   */
  getPermissionsMap(): Map<string, string>;

  /**
   * 获取权限列表url
   * @returns
   */
  getPermissionUrl(): string;

  /**
   * 获取产品功能url
   * @returns
   */
  getIntroductionInfoUrl(): string;
}
```



### 广告组件TBNativeAdComponent

本组件提供了信息流广告的渲染

TBNativeAdComponent({nativeAd: TBNativeAd, builder: () => void})

展示信息流广告广告

| 参数名   | 类型       | 必填 | 说明                   |
| -------- | ---------- | ---- | ---------------------- |
| nativeAd | TBNativeAd | 是   | 广告对象               |
| builder  | () => void | 否   | 应用自渲染广告子组件。 |



### 视频组件TBNativeMediaComponent

本组件提供了信息流广告视频的渲染（仅在开发者自渲染时渲染）

TBNativeMediaComponent({nativeAd: TBBaseNativeAd})

展示信息流广告视频组件

| 参数名   | 类型           | 必填 | 说明                         |
| -------- | -------------- | ---- | ---------------------------- |
| nativeAd | TBBaseNativeAd | 是   | 广告加载成功后返回的广告对象 |



### 广告加载监听器

```typescript

export interface TBNativeAdLoaderListener {
  /**
   * 广告加载成功
   * @param loader 广告加载对象
   * @param ads 广告对象数据
   */
  onAdLoadSuccessed(ads: TBNativeAd[]): void;

  /**
   * 广告加载失败
   * @param loader 广告加载对象
   * @param error
   */
  onAdLoadFailed(error: BusinessError): void;
}
```



### 广告交互监听器

```typescript
export interface TBNativeAdInteractListener {

  /**
   * 广告渲染成功【仅模版渲染广告】
   * @param adInfo 渠道信息
   * @param width 广告组件宽度
   * @param height 广告组件高度
   */
  onRenderSuccess(adInfo: TBAdInfo, width: number, height: number): void;


  /**
   * 广告渲染失败【仅模版渲染广告】
   * @param adInfo 渠道信息
   * @param error 错误描述信息
   */
  onRenderFail(adInfo: TBAdInfo, error: BusinessError<void>): void;

  /**
   * 广告曝光
   * @param adInfo 渠道信息
   */
  onAdShow(adInfo: TBAdInfo): void;

  /**
   * 广告点击
   * @param adInfo  渠道信息
   */
  onAdClick(adInfo: TBAdInfo): void;

  /**
   * 广告点击关闭
   * @param adInfo  渠道信息
   * @warning 仅在模版渲染时触发，自渲染由开发者自行渲染关闭按钮。
   */
  onAdClose(adInfo: TBAdInfo): void;

}
```



### 广告视频交互监听器

```typescript
export interface TBAdVideoListener {
  /**
   * 视频开始播放
   */
  onVideoPlayStart(adInfo: TBAdInfo): void;

  /**
   * 视频播放结束
   */
  onVideoPlayComplete(adInfo: TBAdInfo): void;

  /**
   * 视频播放失败
   */
  onVideoPlayError(adInfo: TBAdInfo, error: BusinessError): void;
}
```



### 广告Dislike交互监听器

```typescript
export interface TBDislikeListener {
  /**
   * dislike 弹窗show
   */
  onShow(): void;

  /**
   * Dislike 条目被选中
   * @param position  条目的index
   * @param value 条目的内容
   * @param enforce 是否强制关闭广告
   */
  onSelected(position: number, value: string, enforce: boolean): void;


  /**
   * Dislike 弹窗取消
   */
  onCancel(): void;

}
```



### 加载信息流广告

```typescript
// 创建广告请求参数
let request: TBType.AdRequest = {
	placementId: 'your placement id',
	userId: 'your user ID',
  adCount: 1, // 加载广告数量，一次建议1～3条
	adWidth: number, // 广告宽度（单位vp）
  adHeight: number， //当高度不设置时，则模版自适应高度（以宽度自适应高度）
}
// 创建广告加载对象
let loader = new TBNativeAdLoader(request);
// 设置广告监听
loader.adLoadListener = this;
// 加载广告
loader.loadAdData();
```



### 注册原生自渲染广告计费事件

**注意：仅针对自渲染生效**

通过registerViewForInteraction方法注册原生自渲染广告计费事件和交互事件，方法说明如下，其中`TBClickViewIdList`类为SDK提供的集合容器继承自ArrayList；该容器主要作用是收集注册点击事件的UI组件Id；

**注意：UI组件id在应用中必须保持唯一（华为鸿蒙官方要求）**

```typescript
/**
   * 注册原生自渲染广告点击组件ID
   * @param rootAdComponentId 广告布局根节点Id
   * @param uiContext 当前组件的上下文
   * @param clickViewIds 普通点击Id集合,点击之后，会跳转到落地页，然后再进行后续广告转化
   * @param creativeViewIds： 创意点击Id集合，点击之后，会直接进行转化
   */
  registerViewForInteraction(clickViewIds: TBClickViewIdList<string>, creativeViewIds: TBClickViewIdList<string>);
```

**注意：这里clickViewIds和creativeViewIds的区别，注册在clickViewIds的组件，点击后会跳转到落地页，然后再进行后续的广告转化，注册在creativeViewIds的组件，点击后，会直接进行转化**



注册案例：

```typescript
@Builder
  builderAdView(nativeAd: TBNativeAd) {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(nativeAd.getAppIconUrl())
          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
          .objectFit(ImageFit.Contain)
          .height('100%')
          .aspectRatio(1)
          .borderRadius(5)
          .constraintSize({
            minWidth: 50, minHeight: 50
          })
          .backgroundColor(Color.Black)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
          Text(nativeAd.getAdTitle())
          	.id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
          Text(nativeAd.getAdDescription())
	          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
        }
        .height('100%')
        .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .margin({ top: 10 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
        Row({ space: 3 }) {
          if (nativeAd.getAdLogo()) {
            Image(nativeAd.getAdLogo())
              .objectFit(ImageFit.Cover)
              .onComplete((data) => {
                if (data?.loadingStatus === 1) {
                  this.logoWidth = data.width / data.height * 20;
                }
              })
              .width(this.logoWidth).height(20)
          } else {
            Text(nativeAd!.getAdSource())
              .fontColor(Color.Red)
              .fontSize(10)
          }
        }

        Button(nativeAd.getActionDescription())
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .controlSize(ControlSize.SMALL)
          .fontColor(Color.Blue)
          .borderWidth(0.5)
          .borderColor(Color.Blue)
          .backgroundColor(Color.White)
          .id(this.creativeViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.Transparent)
    .onAppear(() => {
      nativeAd.registerViewForInteraction(this.clickViewIds, this.creativeViewIds)
    })
  }
```



### 展示信息流广告

信息流广告分为自渲染和模版渲染，渲染类型可通过native.getRenderType()判断

#### 展示自渲染信息流广告

```typescript
TBNativeAdComponent({
	nativeAd: this.nativeAd,
	builder: (): void => this.builderAd()
})
```

其中builderAd中为渲染自渲染的布局，由开发者自定布局样式。

**注意：自渲染需通过registerViewForInteraction方法注册原生自渲染广告计费事件和交互事件，否则会影响计费**

```typescript
@Builder
builderAd(nativeAd: TBNativeAd) {
    Column() {
      Stack() {
        if (nativeAd.getMaterialType() === TBType.MaterialType.video) {
          this.builderVideo()
        } else {
          this.builderImage()
        }
      }
      .width('100%')
      .aspectRatio(1.7778)
      .borderRadius(10)
      .clip(true)
      .backgroundColor(Color.Black)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(nativeAd.getAppIconUrl())
          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
          .objectFit(ImageFit.Contain)
          .height('100%')
          .aspectRatio(1)
          .borderRadius(5)
          .constraintSize({
            minWidth: 50, minHeight: 50
          })
          .backgroundColor(Color.Black)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
          Text(nativeAd.getAdTitle())
          	.id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
          Text(nativeAd.getAdDescription())
	          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
        }
        .height('100%')
        .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .margin({ top: 10 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
        Row({ space: 3 }) {
          if (nativeAd.getAdLogo()) {
            Image(nativeAd.getAdLogo())
              .objectFit(ImageFit.Cover)
              .onComplete((data) => {
                if (data?.loadingStatus === 1) {
                  this.logoWidth = data.width / data.height * 20;
                }
              })
              .width(this.logoWidth).height(20)
          } else {
            Text(nativeAd!.getAdSource())
              .fontColor(Color.Red)
              .fontSize(10)
          }
        }

        Button(nativeAd.getActionDescription())
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .controlSize(ControlSize.SMALL)
          .fontColor(Color.Blue)
          .borderWidth(0.5)
          .borderColor(Color.Blue)
          .backgroundColor(Color.White)
          .id(this.creativeViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.Transparent)
    .onAppear(() => {
      nativeAd.registerViewForInteraction(this.clickViewIds, this.creativeViewIds)
    })
  }

  @Builder
  builderImage() {
    if (this.nativeAd?.getImageList() !== undefined) {
      Image(this.nativeAd!.getImageList()[0].imageUrl)
        .objectFit(ImageFit.Contain)
        .width('100%').height('100%')
        .backgroundColor(Color.Transparent)
    }

  }

  @Builder
  builderVideo() {
    TBNativeMediaComponent({ nativeAd: this.nativeAd })
      .width('100%')
      .width('100%').height('100%')
      .backgroundColor(Color.Black)
  }
```



#### 展示模版渲染信息流广告

```typescript
TBNativeAdComponent({
	nativeAd: this.nativeAd
})
```



## Banner广告

### 场景介绍

Banner广告是在应用程序顶部、中部或底部占据一个位置的矩形图片，广告内容每隔一段时间会自动刷新。



Banner广告分为自渲染广告和模板广告，但是自渲染广告只有当三方SDK支持时才会返回。

- 自渲染广告：聚合SDK返回物料，由开发者在TBBannerAdComponent组件上进行子视图的自行渲染和展示。
- 模版渲染广告：聚合SDK直接返回渲染好的广告组件TBBannerAdComponent，开发者直接展示即可。



### 广告加载类TBBannerAdLoader

在SDK里只需要使用 TBBannerAdLoader 就可以获取信息流广告。TBBannerAdLoader支持多广告加载，可以一次加载返回多个广告。

> **注意：adHeight高度为0时，广告的实际高度由模版广告自行渲染决定**



```typescript
export class TBBannerAdLoader {
  /**
   * 广告请求信息
   */  
  readonly request: TBType.AdRequest;

  /**
   * 构造函数
   */  
  constructor(request: TBType.AdRequest);

  /**
   * 设置广告加载监听器
   */
  set adLoadListener(listener: TBBannerAdLoaderListener);

  /**
   * 返回广告缓存池内所有信息
   * 填充后可调用, 广告关闭后清理
   * @returns
   */
  getCacheAdInfoList(): TBAdInfo[];

  /**
   * 加载广告
   */
  loadAdData();

  /**
   * 销毁广告加载资源
   */
  destroy(): void;

}
```



### 广告模型类TBBannerAd

在广告加载成功回调中获取相关广告信息，将广告信息传入广告组件TBBannerAdComponent进行广告的展示。

```typescript
export class TBBannerAd {
  /**
   * 广告交互监听器
   */
  interactListener: TBBannerAdInteractListener | null = null;
  
  /**
   * 视频交互监听器
   */
  videoListener: TBAdVideoListener | null = null;
  /**
   * 广告dislike弹窗监听
   */
  dislikeListener: TBDislikeListener | null = null;
  /**
   * 渠道ID
   */
  readonly channelId: TBType.Channel;
  /**
   * 普通点击组件Id集合
   */
  readonly clickViewIds: TBClickViewIdList<string> = new TBClickViewIdList();
  /**
   * 创意点击ID集合
   */
  readonly creativeViewIds: TBClickViewIdList<string> = new TBClickViewIdList();
  /**
   * 扩展参数
   */
  readonly extra: Record<string, Object> = {};


  /**
   * 释放资源
   */
  destroy(): void;

  /**
   * 广告唯一标识
   */
  getUniqueId(): string;

  /**
   * 素材类型
   * 【模版渲染为空】
   */
  getMaterialType(): TBType.MaterialType;

  /**
   * 渲染类型 模版渲染 or 自渲染
   */
  getRenderType(): TBType.RenderType;

  /**
   * 广告交互类型
   * 【模版渲染时为空】
   */
  getInteractionType(): TBType.AdInteractionType;

  /**
   * 广告标题
   * 【模版渲染时为空】
   */
  getAdTitle(): string;

  /**
   * 广告描述
   * 【模版渲染时为空】
   */
  getAdDescription(): string;

  /**
   * 广告来源，可能为空
   * 【模版渲染时为空】
   */
  getAdSource(): string;

  /**
   * 获取广告⻆标的logo
   * 当返回string类型时，可能为标准url，(csj)adx广告场景时可能文字描述
   * 【模版渲染时为空】
   */
  getAdLogo(): string | Resource | undefined ;

  /**
   * 广告图片集合，单图和组图类型广告素材有返回，视频类素材返回为空
   * 【模版渲染时为空】
   */
  getImageList(): TBAdImage[];

  /**
   * 广告Icon链接
   * 【模版渲染时为空】
   */
  getAppIconUrl(): string | undefined;

  /**
   * 应用下载相关合规信息
   * 【模版渲染时为空】
   */
  getComplianceInfo(): TBComplianceInfo | undefined;

  /**
   * 应用下载次数文案，非下载返回为空 eg:1000W此下载
   * 【模版渲染时为空】
   */
  getAppDownloadCountDes(): string | undefined;

  /**
   * 广告app评论数
   * 【模版渲染时为0】
   */
  getAppCommentNum(): number;


  /**
   * 应用下载评分，取值0~5.0; 非下载返回为0
   * 【模版渲染时为空】
   */
  getAppScore(): number;

  /**
   * 视频封面url
   * [支持渠道：快手]
   * 【模版渲染时为空】
   */
  getCoverUrl(): TBAdImage | undefined;

  /**
   * 视频url
   * 【模版渲染时为空】
   */
  getVideoUrl(): string | undefined;

  /**
   * 视频时⻓
   * 【模版渲染时为空】
   */
  getVideoDuration(): number;

  /**
   * CTA按钮文案
   * 【模版渲染时为空】
   */
  getActionDescription(): string;


	/**
   * 注册原生自渲染广告点击组件ID
   * @param rootAdComponentId 广告布局根节点Id
   * @param uiContext 当前组件的上下文
   * @param clickViewIds 普通点击Id集合,点击之后，会跳转到落地页，然后再进行后续广告转化
   * @param creativeViewIds： 创意点击Id集合，点击之后，会直接进行转化
   */
  registerViewForInteraction(clickViewIds: TBClickViewIdList<string>, creativeViewIds: TBClickViewIdList<string>);
}
```



#### TBComplianceInfo说明

TBComplianceInfo提供应用下载相关合规信息，仅在返回广告位下载类广告时生效。

```typescript
export class TBComplianceInfo extends TBMediaComplianceInfo {

  /**
   * 获取App Name
   * @returns
   */
  getAppName(): string;

  /**
   * 获取应用版本
   * @returns
   */
  getAppVersion(): string;

  /**
   * 获取开发者名称
   * @returns
   */
  getDeveloperName(): string;

  /**
   * 获取隐私协议
   * @returns
   */
  getPrivacyUrl(): string;

  /**
   * 获取权限名称及权限描述列表
   * @returns
   */
  getPermissionsMap(): Map<string, string>;

  /**
   * 获取权限列表url
   * @returns
   */
  getPermissionUrl(): string;

  /**
   * 获取产品功能url
   * @returns
   */
  getIntroductionInfoUrl(): string;
}
```



### 广告组件TBBannerAdComponent

本组件提供了Banner广告的渲染

TBBannerAdComponent({nativeAd: TBNativeAd, builder: () => void})

展示信息流广告广告

| 参数名   | 类型       | 必填 | 说明                   |
| -------- | ---------- | ---- | ---------------------- |
| bannerAd | TBBannerAd | 是   | 广告对象               |
| builder  | () => void | 否   | 应用自渲染广告子组件。 |



### 视频组件TBNativeMediaComponent

本组件提供了信息流/Banner广告视频的渲染（仅在开发者自渲染时渲染）

TBNativeMediaComponent({nativeAd: TBBaseNativeAd})

展示信息流广告视频组件

| 参数名   | 类型           | 必填 | 说明                         |
| -------- | -------------- | ---- | ---------------------------- |
| nativeAd | TBBaseNativeAd | 是   | 广告加载成功后返回的广告对象 |



### 广告加载监听器

```typescript
export interface TBBannerAdLoaderListener {
  /**
   * 广告加载成功
   * @param ads 广告对象数据
   */
  onAdLoadSuccessed(ads: TBBannerAd[]): void;

  /**
   * 广告加载失败
   * @param loader 广告加载对象
   * @param error
   */
  onAdLoadFailed(error: BusinessError): void;
}
```



### 广告交互监听器

```typescript
export interface TBBannerAdInteractListener {

  /**
   * 广告渲染成功【仅模版渲染广告】
   * @param adInfo 渠道信息
   * @param width 广告组件宽度
   * @param height 广告组件高度
   */
  onRenderSuccess(adInfo: TBAdInfo, width: number, height: number): void;


  /**
   * 广告渲染失败【仅模版渲染广告】
   * @param adInfo 渠道信息
   * @param error 错误描述信息
   */
  onRenderFail(adInfo: TBAdInfo, error: BusinessError<void>): void;

  /**
   * 广告曝光
   * @param adInfo 渠道信息
   */
  onAdShow(adInfo: TBAdInfo): void;

  /**
   * 广告点击
   * @param adInfo  渠道信息
   */
  onAdClick(adInfo: TBAdInfo): void;

  /**
   * 广告点击关闭
   * @param adInfo  渠道信息
   * @warning 仅在模版渲染时触发，自渲染由开发者自行渲染关闭按钮。
   */
  onAdClose(adInfo: TBAdInfo): void;

}
```



### 广告视频交互监听器

```typescript
export interface TBAdVideoListener {
  /**
   * 视频开始播放
   */
  onVideoPlayStart(adInfo: TBAdInfo): void;

  /**
   * 视频播放结束
   */
  onVideoPlayComplete(adInfo: TBAdInfo): void;

  /**
   * 视频播放失败
   */
  onVideoPlayError(adInfo: TBAdInfo, error: BusinessError): void;
}
```



### 广告Dislike交互监听器

```typescript
export interface TBDislikeListener {
  /**
   * dislike 弹窗show
   */
  onShow(): void;

  /**
   * Dislike 条目被选中
   * @param position  条目的index
   * @param value 条目的内容
   * @param enforce 是否强制关闭广告
   */
  onSelected(position: number, value: string, enforce: boolean): void;


  /**
   * Dislike 弹窗取消
   */
  onCancel(): void;

}
```



### 加载Banner广告

```typescript
// 创建广告请求参数
let request: TBType.AdRequest = {
	placementId: 'your placement id',
	userId: 'your user ID',
  adCount: 1, // 加载广告数量，一次建议1～3条
	adWidth: number, // 广告宽度（单位vp）
  adHeight: number， //当高度不设置时，则模版自适应高度（以宽度自适应高度）
}
// 创建广告加载对象
let loader = new TBBannerAdLoader(request);
// 设置广告监听
loader.adLoadListener = this;
// 加载广告
loader.loadAdData();
```



### 注册Banner自渲染广告计费事件

**注意：仅针对自渲染生效**

通过registerViewForInteraction方法注册原生自渲染广告计费事件和交互事件，方法说明如下，其中`TBClickViewIdList`类为SDK提供的集合容器继承自ArrayList；该容器主要作用是收集注册点击事件的UI组件Id；

**注意：UI组件id在应用中必须保持唯一（华为鸿蒙官方要求）**

```typescript
/**
   * 注册原生自渲染广告点击组件ID
   * @param rootAdComponentId 广告布局根节点Id
   * @param uiContext 当前组件的上下文
   * @param clickViewIds 普通点击Id集合,点击之后，会跳转到落地页，然后再进行后续广告转化
   * @param creativeViewIds： 创意点击Id集合，点击之后，会直接进行转化
   */
  registerViewForInteraction(clickViewIds: TBClickViewIdList<string>, creativeViewIds: TBClickViewIdList<string>);
```

**注意：这里clickViewIds和creativeViewIds的区别，注册在clickViewIds的组件，点击后会跳转到落地页，然后再进行后续的广告转化，注册在creativeViewIds的组件，点击后，会直接进行转化**



注册案例：

```typescript
@Builder
  builderAdView(nativeAd: TBBannerAd) {
    Column() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(nativeAd.getAppIconUrl())
          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
          .objectFit(ImageFit.Contain)
          .height('100%')
          .aspectRatio(1)
          .borderRadius(5)
          .constraintSize({
            minWidth: 50, minHeight: 50
          })
          .backgroundColor(Color.Black)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
          Text(nativeAd.getAdTitle())
          	.id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
          Text(nativeAd.getAdDescription())
	          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
        }
        .height('100%')
        .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .margin({ top: 10 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
        Row({ space: 3 }) {
          if (nativeAd.getAdLogo()) {
            Image(nativeAd.getAdLogo())
              .objectFit(ImageFit.Cover)
              .onComplete((data) => {
                if (data?.loadingStatus === 1) {
                  this.logoWidth = data.width / data.height * 20;
                }
              })
              .width(this.logoWidth).height(20)
          } else {
            Text(nativeAd!.getAdSource())
              .fontColor(Color.Red)
              .fontSize(10)
          }
        }

        Button(nativeAd.getActionDescription())
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .controlSize(ControlSize.SMALL)
          .fontColor(Color.Blue)
          .borderWidth(0.5)
          .borderColor(Color.Blue)
          .backgroundColor(Color.White)
          .id(this.creativeViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.Transparent)
    .onAppear(() => {
      nativeAd.registerViewForInteraction(this.clickViewIds, this.creativeViewIds)
    })
  }
```



### 展示Banner广告

信息流广告分为自渲染和模版渲染，渲染类型可通过native.getRenderType()判断

#### 展示自渲染Banner广告

```typescript
TBBannerAdComponent({
	nativeAd: this.nativeAd,
	builder: (): void => this.builderAd()
})
```

其中builderAd中为渲染自渲染的布局，由开发者自定布局样式。

**注意：自渲染需通过registerViewForInteraction方法注册原生自渲染广告计费事件和交互事件，否则会影响计费**

```typescript
@Builder
builderAd(nativeAd: TBNativeAd) {
    Column() {
      Stack() {
        if (nativeAd.getMaterialType() === TBType.MaterialType.video) {
          this.builderVideo()
        } else {
          this.builderImage()
        }
      }
      .width('100%')
      .aspectRatio(1.7778)
      .borderRadius(10)
      .clip(true)
      .backgroundColor(Color.Black)

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Image(nativeAd.getAppIconUrl())
          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
          .objectFit(ImageFit.Contain)
          .height('100%')
          .aspectRatio(1)
          .borderRadius(5)
          .constraintSize({
            minWidth: 50, minHeight: 50
          })
          .backgroundColor(Color.Black)
        Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Start }) {
          Text(nativeAd.getAdTitle())
          	.id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
          Text(nativeAd.getAdDescription())
	          .id(this.clickViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
            .maxLines(1)
            .textOverflow({
              overflow: TextOverflow.Ellipsis
            })
        }
        .height('100%')
        .margin({ left: 10 })
      }
      .width('100%')
      .height(50)
      .margin({ top: 10 })

      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.End }) {
        Row({ space: 3 }) {
          if (nativeAd.getAdLogo()) {
            Image(nativeAd.getAdLogo())
              .objectFit(ImageFit.Cover)
              .onComplete((data) => {
                if (data?.loadingStatus === 1) {
                  this.logoWidth = data.width / data.height * 20;
                }
              })
              .width(this.logoWidth).height(20)
          } else {
            Text(nativeAd!.getAdSource())
              .fontColor(Color.Red)
              .fontSize(10)
          }
        }

        Button(nativeAd.getActionDescription())
          .buttonStyle(ButtonStyleMode.TEXTUAL)
          .controlSize(ControlSize.SMALL)
          .fontColor(Color.Blue)
          .borderWidth(0.5)
          .borderColor(Color.Blue)
          .backgroundColor(Color.White)
          .id(this.creativeViewIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.Transparent)
    .onAppear(() => {
      nativeAd.registerViewForInteraction(this.clickViewIds, this.creativeViewIds)
    })
  }

  @Builder
  builderImage() {
    if (this.nativeAd?.getImageList() !== undefined) {
      Image(this.nativeAd!.getImageList()[0].imageUrl)
        .objectFit(ImageFit.Contain)
        .width('100%').height('100%')
        .backgroundColor(Color.Transparent)
    }

  }

  @Builder
  builderVideo() {
    TBNativeMediaComponent({ nativeAd: this.nativeAd })
      .width('100%')
      .width('100%').height('100%')
      .backgroundColor(Color.Black)
  }
```



#### 展示模版渲染Banner广告

```typescript
TBBannerAdComponent({
	nativeAd: this.nativeAd
})
```



## 高级功能

### 前置初始化

- 每个平台TBSDKConfigure传入参数必须跟ToBid后台该平台配置的AppID和AppKey一致，否则将导致该平台所有广告加载失败
- SDK将优先使用缓存在本地的策略参数（开发者后台配置的AppID、AppKey等）初始化广告平台，本地没有广告平台的策略参数时，将以开发者传入的TBSDKConfigure初始化广告平台

```typescript
export interface TBSDKConfigure {
  /// 渠道ID  [Required]
  adnId: number;
  /// 渠道初始化所需的AppId [Required]
  appId: string;
  /// 渠道初始化所需的AppKey [Optional]
  appKey?: string;
  /// 渠道名称 [Optional]
  name?: string;
}
```



**代码示例**

```typescript
let adConfig: ToBidAdConfig = new ToBidAdConfig({
	appId: 'your appId', appKey: 'you appKey'
});
let configure: TBSDKConfigure = {
	adnId: TBType.Channel.sigmob,
	appId: '1234',
	name: 'sigmob'
}
let configures: TBSDKConfigure[] = [];
adConfig.setSDKConfigures(configures);
```



### 隐私设置

#### 个性化推荐

```typescript
export function personalizedAdvertising(state: TBType.PersonalizedAdvertising): void;
```

```typescript
/**
	* 个性化状态
  */
export enum PersonalizedAdvertising {
    on = 0, // 开启
    off = 1, // 关闭
}
```



#### 未成年设置

```typescript
export function ageState(state: TBType.Age): void;
```

```typescript
/**
   * 年龄状态
   */
  export enum Age {
    adult = 0, // 成年人
    child = 1, // 儿童
  }
```



#### 用户年龄

```typescript
export function userAge(age: number): void;
```

### 自定义流量分组

#### App全局自定义规则

```typescript
let appGroup = new AppGroupFilter();
appGroup
  .equalTo('user_source', 'huawei') // 流量安装来源，开发者自己传
	.equalTo('channel', 'toutiao') // 买量渠道：穿山甲、快手、sigmob等
	.equalTo('sub_channel', 'toutiao') // 买量子渠道：穿山甲、快手、sigmob等

adConfig.addFilter(appGroup);
```



**AppGroupFilter接口说明**

```typescript
export class AppGroupFilter extends Filter {
 
  equalTo(field: string, value: string): AppGroupFilter;
  /**
   * 获取传入的自定义分组信息
   * @returns 
   */
  group(): Record<string, string>;

  toString(): string;
}
```



#### 广告位级自定义规则设置

```typescript
let placementGroup = new PlacementGroupFilter('your tobid placementId');
placementGroup
  .equalTo('user_source', 'huawei') // 流量安装来源，开发者自己传
	.equalTo('channel', 'toutiao') // 买量渠道：穿山甲、快手、sigmob等
	.equalTo('sub_channel', 'toutiao') // 买量子渠道：穿山甲、快手、sigmob等
adConfig.addFilter(placementGroup);
```



**PlacementGroupFilter接口说明**

```typescript
export class PlacementGroupFilter extends Filter {
 
  equalTo(field: string, value: string): PlacementGroupFilter;
  /**
   * 获取传入的自定义分组信息
   * @returns 
   */
  group(): Record<string, string>;

  toString(): string;
}
```



### 过滤器

**WaterfallFilter接口说明**

```typescript
export class WaterfallFilter extends TBFilter<filterType.WaterfallFilterKey, ValueType> {
  
  // 匹配数据表的field列中值为value的字段。
  equalTo(field: filterType.WaterfallFilterKey, value: V): TBFilter<K, V>;

  // 匹配数据表的field列中值在给定范围内的字段。
  in(field: K, value: V[]): TBFilter<K, V>;

  // 添加和条件
  and(): TBFilter<K, V>;

  // 将或条件添加到谓词中。
  or(): TBFilter<K, V>;

  // 匹配数据表的field列中值大于value的字段。
  greaterThan(field: K, value: V): TBFilter<K, V>;
  
  // 匹配数据表的field列中值小于于value的字段。
  lessThan(field: K, value: V): TBFilter<K, V>;
  
  // 匹配数据表的field列中值大于等于value的字段。
  greaterThanOrEqualTo(field: K, value: V): TBFilter<K, V>;
  
  // 匹配数据表的field列中值小于等于value的字段。
  lessThanOrEqualTo(field: K, value: V): TBFilter<K, V>;

  /**
   * 数据过滤
   * @param data 原始数据源【这里已Object通用类型表示，也可以使用泛型】
   * @returns
   */
  abstract doFilter(data: filterType.WaterfallFilterData): FilterResult;

  /**
   * 条件组输出字符串
   * @param condition 条件组
   * @returns
   */
  abstract toString(result: FilterResult): string; 
}
```



#### 示例1

```typescript
// 针对聚合广告位id:123456，过滤穿山甲渠道 100<ecpm<200的请求
let filter = new WaterfallFilter('123456');
filter
	.equalTo(filterType.WaterfallFilterKey.channelId, TBType.Channel.csj)
	.greaterThan(filterType.WaterfallFilterKey.ecpm, 100)
	.lessThan(filterType.WaterfallFilterKey.ecpm, 200)    
adConfig.addFilter(filter)
```



#### 示例2

```typescript
// 针对聚合广告位id:123456，过滤穿山甲渠道广告位ID为666666的广告位
let filter = new WaterfallFilter('123456');
filter
	.equalTo(filterType.WaterfallFilterKey.channelId, TBType.Channel.csj)
	.equalTo(filterType.WaterfallFilterKey.adnId, '666666')
adConfig.addFilter(filter)
```



#### 示例3

```typescript
// 针对聚合广告位id:123456，过滤穿山甲渠道的客户端竞价广告位出价小于等于200的
let filter = new WaterfallFilter('123456');
filter
	.equalTo(filterType.WaterfallFilterKey.channelId, TBType.Channel.csj)
	.greaterThan(filterType.WaterfallFilterKey.bidType, TBType.BidType.c2s)
	.lessThanOrEqualTo(filterType.WaterfallFilterKey.ecpm, 200)

adConfig.addFilter(filter)
```





## 接口说明

### AdRequest

广告请求参数。

| 名称        | 类型                   | 必填 | 说明                                                         |
| ----------- | ---------------------- | ---- | ------------------------------------------------------------ |
| placementId | string                 | 是   | 广告位ID                                                     |
| userId      | string                 | 否   | 用户ID                                                       |
| options     | Record<string, string> | 否   | 自定义参数，主要用于激励服务端回调回传信息使用               |
| adCount     | number                 | 否   | 请求的广告数量，出原生广告外，其它广告类型均为1， 原生广告范围在[1, 5] |
| adWidth     | number                 | 否   | 请求广告时期望的创意宽度，单位vp（仅原生、横幅）             |
| adHeight    | number                 | 否   | 请求广告时期望的创意高度，单位vp（仅原生、横幅）             |



### AdDisplayOptions

广告展示参数。

| 名称      | 类型                   | 必填 | 说明                 |
| --------- | ---------------------- | ---- | -------------------- |
| sceneId   | string                 | 否   | 广告播放场景id       |
| sceneDesc | string                 | 否   | 广告播放场景描述信息 |
| options   | Record<string, string> | 否   | 自定义参数           |

### InitState

初始化状态

```typescript
export enum InitState {
    none = 0, //未初始化
    initializing = 1, //初始化中
    complete = 2, //初始化完成
    failure = 3, // 初始化失败
}
```



### Location

地理位置信息

```typescript
export interface Location {
    /**
     * 纬度
     */
    latitude?: number;

    /**
     * 经度
     */
    longitude?: number;

}
```



### PersonalizedAdvertising

个性化状态

```typescript
  export enum PersonalizedAdvertising {
    on = 0, // 开启
    off = 1, // 关闭
  }
```

### Age

年龄状态

```typescript
  export enum Age {
    adult = 0, // 成年人
    child = 1, // 儿童
  }
```



### AdSlotType

广告位类型

```typescript
export enum AdSlotType {
    none = 0,
    rewardVideoAd = 1, // 激励视频
    splashAd = 2, // 开屏广告
    intersititial = 4, // 插屏
    nativeAd = 5, // 原生广告
    bannerAd = 7. // 横幅广告
}
```



### LoadingParam

加载参数

```typescript
export enum LoadingParam {
    loadId = 'load_id', // 聚合请求ID
    adnId = 'adn_id', // 渠道广告位ID
    slotId = 'slot_id', // 聚合广告位ID
    price = 'price', // AND广告ECPM，单位分
    currency = 'currency', //AND广告ECPM对应的货币类型，目前支持CNY、USD
    adnRequest = 'request', // ADN广告的加载标识
}
```

### Currency

货币类型

```typescript
	export enum Currency {
    CNY = 'CNY', // 人民币 CNY("CNY")
    USD = 'USD', // 美元 USD("USD"),
    EUR = 'EUR', // 欧元 EUR("EUR")
  }
```



### Channel

渠道ID

```typescript
export enum Channel {
    sigmob = 9, // sigmob
    csj = 13, // 穿山甲
    gdt = 16, // 腾讯优量汇
    kuaishou = 19, // 快手
    baidu = 21, //  百度联盟
    gromore = 22, // Gromore聚合
    huawei = 25, // 华为
    tobidAdx = 999, // tobid adx
}
```



### MaterialType

素材类型

```typescript
export enum MaterialType {
    unknow = 0, // 未知，模版渲染时，素材类型未知
    video = 1, // 视频
    largeImage = 2, // 小图
    smallImage = 3, // 大图
    groupImage = 4, // 三张小图
}
```



### RenderType

渲染类型

```typescript
  export enum RenderType {
    template = 1, // 模版渲染
    native = 2, // 自渲染
  }
```



### NativeType

信息类类型

```typescript
  export enum NativeType {
    feed = 1, // feed ads
    drawVideo = 2, // vertical (immersive) video ads
  }
```



### AdInteractionType

广告交互类型

```typescript
export enum AdInteractionType {
    unknow = 0,
    download = 1,
    h5 = 2
}
```



### TBInitializedConfig  

```typescript
export class TBInitializedConfig {
  readonly context: common.UIAbilityContext; // 应用上下文，聚合初始化时由开发者传入
  readonly windowStage: window.WindowStage; // 窗口管理器，聚合初始化时由开发者传入
  appId: string; // 应用ID (自定义渠道请从extra中获取)
  appKey: string; // 应用key (自定义渠道请从extra中获取)
  adnId: number; // 渠道唯一ID
  isCustom: boolean; // 是否自定义渠道
  extra: Record<string, Object>; // 自定义参数
}
```



### TBParameter

```typescript
export interface TBParameter {

  /**
   * 窗口管理器
   */
  readonly windowStage: window.WindowStage;

  transId: string;

  /**
   * 设备oaid
   */
  getOaid: () => Promise<string>;

  /**
   * 渠道广告位信息
   */
  element: tobid.ElementOptions;
  /**
   * 是否为竞价广告源
   */
  readonly isHeaderBidding: boolean;


  /**
   * 广告加载数量 默认1条
   */
  readonly adCount: number;

  /**
   * 竞价类型
   * 0: s2s; 1: c2s
   */
  readonly bidType: number;

  /**
   * 初始化传入的上下文信息
   */
  readonly context: common.UIAbilityContext;

  /**
   * 服务端竞价响应信息
   * 【自定义渠道不支持】
   */
  readonly hbResponse?: tobid.HBResponse;

  /**
   * 广告的期望尺寸，单位vp
   */
  readonly adSize: TBType.Size;
}
```

### TBAdInfo

```typescript
export class TBAdInfo {

  /**
   * 聚合广告位ID
   */
  readonly placementId: string;

  /**
   * 渠道id
   */
  readonly networkId: TBType.Channel;
  /**
   * 渠道名称
   */
  readonly networkName: string;
  /**
   * 渠道的广告位ID
   */
  readonly networkPlacementId: string;
  /**
   * 三方代码位广告类型
   */
  readonly networkAdtype: TBType.AdSlotType;
  /**
   * 瀑布流id / 策略分组ID
   */
  readonly groupId: string;
  /**
   * 定向包ID
   */
  readonly ruleId: string;
  /**
   * ab分组
   */
  readonly abFlag: number;
  /**
   * 加载优先级
   */
  readonly loadPriority: number;
  /**
   * 加载优先级
   */
  readonly playPriority: number;
  /**
   * 单位分
   */
  readonly eCPM: number;
  /**
   * 货币单位
   */
  readonly currency: string;
  /**
   * 是否hb广告源
   */
  readonly isHeaderBidding: boolean;
  /**
   * 每次加载广告时生成的独立ID，可用于排查问题
   */
  readonly loadId: string;
  /**
   * app自己的用户体系的id，开发者传入
   */
  readonly userId: string;
  /**
   * ToBid 平台定义广告源id，开发者可用于排序
   */
  readonly aggrWaterfallId: string;
  /**
   * 当前广告类型
   */
  readonly adType: TBType.AdSlotType;
  /**
   * 广告场景id，由开发者传入
   */
  readonly scene: string;
  /**
   * 开发者在request中传入的options
   */
  readonly options?: Record<string, string>;
  /**
   * 三方渠道数据信息
   */
  readonly networkOptions?: Record<string, Object>;
}
```

### TBReward

```
export class TBReward {

  /**
   * 第三方交易ID
   */
  transId?: string;

  /**
   * 奖励是否有效
   */
  isRewardValid: boolean = false;

  /**
   * 奖励名称
   */
  rewardName?: string;

  /**
   * 奖励数量
   */
  rewardAmount: number = 0;

  /**
   * 奖励类型
   */
  rewardType?: string;
}
```



### tbnode.Data

在广告展示或者开屏自定义品牌区域时，需要开发者实现对应方法的同时并返回tbnode.Data，里面包3个参数

wrap：全局@Builder作为wrapBuilder的参数返回WrappedBuilder对象，实现全局@Builder可以进行赋值和传递。

args：全局@Builder函数参数

controller：NodeController用于实现自定义节点的创建、显示、更新等操作的管理，并负责将自定义节点挂载到NodeContainer上。

**注意：controller和wrap二选一即可，若两者同时传递，SDK优先使用NodeContainer方式**

```typescript
namespace tbnode {
  export type Params = Record<string, Object | undefined>;

  export interface Data {
    wrap?: WrappedBuilder<[Params]>;
    args?: Params;
    controller?: NodeController;
  }
}
```



## 三方广告网络配置说明

ToBid做为聚合SDK支持热插拔模式。我们为每个广告网络提供了一个.har文件的适配器.

> ToBid采用动态import方式加载个适配器，在编译态无法解析出其内容，也就无法加入编译。为了将这部分模块加入编译，还需要额外增加一个runtimeOnly的buildOption配置，用于配置动态import的变量实际的模块名。



### 快手

在oh-package.json5添加依赖

```json
"dependencies": {
	"KSAdSDK": "file:../libs/KSAdSDK-{version}.har",
  "tobid_kuaishou_adapter": "file:./libs/tobid_kuaishou_adapter-{version}.har"
}
```



在build-profile.json5添加runtimeOnly配置

```json
"buildOption": {
  "arkOptions": {
    "runtimeOnly": {
      "packages": [ "tobid_kuaishou_adapter" ]  // 要求与dependencies中配置的名字一致。
    }
  }
}
```



### 华为

在oh-package.json5添加依赖

```json
"dependencies": {
  "tobid_huawei_adapter": "file:./libs/tobid_hauwei_adapter-{version}.har"
}
```



在build-profile.json5添加runtimeOnly配置

```json
"buildOption": {
  "arkOptions": {
    "runtimeOnly": {
      "packages": [ "tobid_huawei_adapter" ]  // 要求与dependencies中配置的名字一致。
    }
  }
}
```



### 穿山甲

在oh-package.json5添加依赖

```json
"dependencies": {
	"@csj/openadsdk": "file:../libs/openadsdk-{version}.har",
  "tobid_csj_adapter": "file:./libs/tobid_csj_adapter-{version}.har"
}
```



在build-profile.json5添加runtimeOnly配置

```json
"buildOption": {
  "arkOptions": {
    "runtimeOnly": {
      "packages": [ "tobid_csj_adapter" ]  // 要求与dependencies中配置的名字一致。
    }
  }
}
```



### Gromore

> Gromore和穿山甲为融合包，@csj/openadsdk仅导入一份即可

在oh-package.json5添加依赖

```json
"dependencies": {
	"@csj/openadsdk": "file:../libs/openadsdk-{version}.har",
  "tobid_gromore_adapter": "file:./libs/tobid_gromore_adapter-{version}.har"
}
```



在build-profile.json5添加runtimeOnly配置

```json
"buildOption": {
  "arkOptions": {
    "runtimeOnly": {
      "packages": [ "tobid_gromore_adapter" ]  // 要求与dependencies中配置的名字一致。
    }
  }
}
```





## 自定义广告网络

ToBid支持**自定义广告平台**功能，您可以通过本功能，添加ToBid暂未聚合的**广告平台**。

本章节将引导您实现HarmonyOS端的自定义广告平台(Adapter)。



### 支持广告类型

目前支持的广告类型如下；

- 原生广告(Native)
- 开屏广告(Splash)
- 激励视频广告(RewardedVideo)
- 插屏广告(Interstitial)
- 横幅广告(Banner)



### 核心实现流程

- ToBid后台添加自定义广告平台以及配置自定义平台所支持的广告类型的适配器类名；
- 在工程中创建对应自定义平台的适配器类
- 自定义适配器类遵循对应广告类型的协议



###  常见问题

1. 自定义Adapter需要按照示例中相应方法含义调用，否则会影响收益。
2. 自定义Adapter时，需要在对应模块的build-profile.json5正确添加runtimeOnly配置，否则可能导致加载Adapter错误。
3. 自定义Adapter广告load之前需要确保开发者实现了对应广告类型的协议并初始化network成功。
4. 所有调用自定义adapter的方法均在主线程，请勿进行耗时操作。
6. 自定义Adapter不支持Service bidding，支持Client bidding。
7. 自定义Adapter广告对象的show、click等回调需要在load广告回调之后。



### 初始化配置

由于ToBid通过动态import导入自定义适配器类，需要在build-profile.json5正确添加runtimeOnly配置packages，否则可能导致加载Adapter错误。

#### 协议内容

自定义Adapter必须要有配置类，在配置类中完成Adapter及对应network的信息采集，对应协议为TBCustomConfigAdapter，接口实现如下所示：

```typescript

export abstract class TBCustomConfigAdapter {
  /**
   * 适配器初始化
   * @param config 初始化渠道信息
   * @param bridge 回传信息使用TBCustomConfigAdapterBridge
   */
  abstract initializedAdapter(config: TBInitializedConfig, bridge: TBCustomConfigAdapterBridge): void;

  /**
   * 适配器版本号
   * @returns
   */
	abstract adapterVersion(): string;

  /**
   * 渠道SDK版本号
   * @returns
   */
  abstract networkSdkVersion(): string;

  /**
   * 隐私更新，用户更新隐私配置时触发，初始化方法调用前一定会触发一次
   */
  abstract adPrivacyUpdate(privacy: TBPrivacyConfig): void;
}
```



#### 回调协议

渠道初始化结果通过TBCustomConfigAdapterBridge通知给ToBid

```typescript
export interface TBCustomConfigAdapterBridge {
  /**
   * 渠道SDK初始化成功
   * @param adapter
   */
  initializeSuccessed(adapter: TBCustomConfigAdapter): void;

  /**
   * 渠道SDK初始化失败
   * @param adapter
   * @param error
   */
  initializeFailed(adapter: TBCustomConfigAdapter, error: BusinessError): void;
}
```



### 自定义开屏广告



#### 协议内容

自定义广告网络实现开屏广告时必须要有配置类，且配置类需要继承TBCustomSplashAdAdapter，接口实现如下所示：

```typescript
export abstract class TBCustomSplashAdAdapter extends TBCustomAdapter {

  /**
   * 广告是否处于可播放状态
   * @returns
   */
  abstract isReady(): boolean;

  /**
   * 加载广告
   * @param parameter 广告参数
   */
  abstract loadAdData(parameter: TBParameter): void;

  /**
   * 播放广告
   * @param parameter 广告参数
   */
  showAd(parameter: TBParameter): void;

  /**
   * 广告组件
   * @param parameter
   * @returns 
   */
  registerWrapBuilder(parameter: TBParameter): tbnode.Data | undefined;

}
```

**tbnode.Data参考接口说明**





#### 回调协议

开屏的各回调结果通过TBCustomSplashAdAdapterBridge通知给ToBid

```typescript

export abstract class TBCustomSplashAdAdapterBridge extends TBCustomAdapterBridge {
  /**
   * 广告数据返回，此时广告只是返回还未预加载完成
   * @param adapter
   */
  abstract onAdLoad(adapter: TBCustomSplashAdAdapter, params: ReportParameter): void;

  /**
   * 广告缓存成功
   * @param adapter
   */
  abstract onAdDidLoad(adapter: TBCustomSplashAdAdapter): void;

  /**
   * 广告加载失败
   * @param adapter
   * @param error
   */
  abstract onAdDidLoadError(adapter: TBCustomSplashAdAdapter, error: BusinessError): void;

  /**
   * 广告开始播放
   * @param adapter
   */
  abstract onAdShow(adapter: TBCustomSplashAdAdapter): void;

  /**
   * 广告播放失败
   * @param adapter
   */
  abstract onAdShowError(adapter: TBCustomSplashAdAdapter, error: BusinessError): void;


  /**
   * 广告曝光成功
   * @param adapter
   */
  abstract onAdImpression(adapter: TBCustomSplashAdAdapter): void;

  /**
   * 广告点击
   * @param adapter
   */
  abstract onAdClick(adapter: TBCustomSplashAdAdapter): void;


  /**
   * 广告跳过
   * @param adapter
   */
  abstract onAdSkip(adapter: TBCustomSplashAdAdapter): void;

  /**
   * 广告关闭
   * @param adapter
   */
  abstract onAdClose(adapter: TBCustomSplashAdAdapter): void;

  /**
   * 广告倒计时结束
   * @param adapter
   */
  abstract onAdCounterZero(adapter: TBCustomSplashAdAdapter): void;
}
```



### 自定义激励视频广告

#### 协议内容

自定义广告网络实现激励视频广告时必须要有配置类，且配置类需要继承TBCustomRewardVideoAdAdapter，接口实现如下所示：

```typescript

export abstract class TBCustomRewardVideoAdAdapter extends TBCustomAdapter {

  /**
   * 广告是否处于可播放状态
   * @returns
   */
  abstract isReady(): boolean;

  /**
   * 加载广告
   * @param parameter 广告参数
   */
  abstract loadAdData(parameter: TBParameter): void;

  /**
   * 播放广告
   * @param parameter 广告参数
   */
  abstract showAd(parameter: TBParameter): void;

  /**
   * 销毁资源
   */
  abstract destroy(): void;
}
```



#### 回调协议

激励视频广告的各回调结果通过TBCustomRewardVideoAdAdapterBridge通知给ToBid

```typescript
export abstract class TBCustomRewardVideoAdAdapterBridge extends TBCustomAdapterBridge {
  /**
   * 广告数据返回，此时广告只是返回还未预加载完成
   * @param adapter
   */
  abstract onAdRequstSuccess(adapter: TBCustomRewardVideoAdAdapter, params: ReportParameter): void;

  /**
   * 广告缓存成功
   * @param adapter
   */
  abstract onAdDidLoad(adapter: TBCustomRewardVideoAdAdapter): void;

  /**
   * 广告加载失败
   * @param adapter
   * @param error
   */
  abstract onAdDidLoadError(adapter: TBCustomRewardVideoAdAdapter, error: BusinessError, extra?: Record<string, Object>): void;

  /**
   * 激励视频广告达到奖励条件触发激励回调
   * @param adapter
   * @param reward
   */
  abstract onRewardArrived(adapter: TBCustomRewardVideoAdAdapter, reward: TBReward): void;

  /**
   * 广告开始播放
   * @param adapter
   */
  abstract onAdShow(adapter: TBCustomRewardVideoAdAdapter): void;

  /**
   * 广告播放失败
   * @param adapter
   */
  abstract onAdShowError(adapter: TBCustomRewardVideoAdAdapter, error: BusinessError): void;


  /**
   * 广告曝光成功
   * @param adapter
   */
  abstract onAdImpression(adapter: TBCustomRewardVideoAdAdapter): void;

  /**
   * 广告点击
   * @param adapter
   */
  abstract onAdClick(adapter: TBCustomRewardVideoAdAdapter): void;


  /**
   * 广告跳过
   * @param adapter
   */
  abstract onAdSkip(adapter: TBCustomRewardVideoAdAdapter): void;

  /**
   * 广告关闭
   * @param adapter
   */
  abstract onAdClose(adapter: TBCustomRewardVideoAdAdapter): void;

  /**
   * 广告视频播放完成
   * @param adapter
   */
  abstract onAdVideoComplete(adapter: TBCustomRewardVideoAdAdapter): void;

  /**
   * 广告视频播放出错
   * @param adapter
   * @param error
   */
  abstract onAdVideoError(adapter: TBCustomRewardVideoAdAdapter, error: BusinessError): void;
}
```



### 自定义插屏广告

#### 协议内容

自定义广告网络实现激励视频广告时必须要有配置类，且配置类需要继承TBCustomInterstitialAdAdapter，接口实现如下所示：

```typescript
export abstract class TBCustomInterstitialAdAdapter extends TBCustomAdapter {

  /**
   * 广告是否处于可播放状态
   * @returns
   */
  abstract isReady(): boolean;

  /**
   * 加载广告
   * @param parameter 广告参数
   */
  abstract loadAdData(parameter: TBParameter): void;

  /**
   * 播放广告
   * @param parameter 广告参数
   */
  showAd(parameter: TBParameter): void;

  /**
   * 播放组件
   */
  registerWrapBuilder(parameter: TBParameter): tbnode.Data | undefined;

}
```

**tbnode.Data参考接口说明**



#### 回调协议

插屏广告的各回调结果通过TBCustomInterstitialAdAdapterBridge通知给ToBid

```typescript
export abstract class TBCustomInterstitialAdAdapterBridge extends TBCustomAdapterBridge {
  /**
   * 广告数据返回，此时广告只是返回还未预加载完成
   * @param adapter
   */
  abstract onAdRequstSuccess(adapter: TBCustomInterstitialAdAdapter, params: ReportParameter): void;

  /**
   * 广告缓存成功
   * @param adapter
   */
  abstract onAdDidLoad(adapter: TBCustomInterstitialAdAdapter): void;

  /**
   * 广告加载失败
   * @param adapter
   * @param error
   */
  abstract onAdDidLoadError(adapter: TBCustomInterstitialAdAdapter, error: BusinessError, extra?: Record<string, Object>): void;

  /**
   * 广告开始播放
   * @param adapter
   */
  abstract onAdShow(adapter: TBCustomInterstitialAdAdapter): void;

  /**
   * 广告播放失败
   * @param adapter
   */
  abstract onAdShowError(adapter: TBCustomInterstitialAdAdapter, error: BusinessError): void;


  /**
   * 广告曝光成功
   * @param adapter
   */
  abstract onAdImpression(adapter: TBCustomInterstitialAdAdapter): void;

  /**
   * 广告点击
   * @param adapter
   */
  abstract onAdClick(adapter: TBCustomInterstitialAdAdapter): void;


  /**
   * 广告跳过
   * @param adapter
   */
  abstract onAdSkip(adapter: TBCustomInterstitialAdAdapter): void;

  /**
   * 广告关闭
   * @param adapter
   */
  abstract onAdClose(adapter: TBCustomInterstitialAdAdapter): void;

  /**
   * 广告视频播放完成
   * @param adapter
   */
  abstract onAdVideoComplete(adapter: TBCustomInterstitialAdAdapter): void;

  /**
   * 广告视频播放出错
   * @param adapter
   * @param error
   */
  abstract onAdVideoError(adapter: TBCustomInterstitialAdAdapter, error: BusinessError): void;
}
```



### 自定义原生广告

#### 协议内容

```typescript
export abstract class TBCustomNativeAdAdapter extends TBCustomAdapter {

  /**
   * 加载广告
   * @param parameter 广告参数
   */
  abstract loadAdData(parameter: TBParameter): void;

}
```

#### 回调协议

```typescript
export abstract class TBCustomNativeAdAdapterBridge extends TBCustomAdapterBridge {

  /**
   * 广告数据返回，此时广告只是返回还未预加载完成
   * @param adapter
   */
  abstract onAdRequstSuccess(adapter: TBCustomNativeAdAdapter, params: ReportParameter): void;

  /**
   * 广告缓存成功
   * @param adapter
   */
  abstract onAdDidLoad(adapter: TBCustomNativeAdAdapter, datas: TBMediaNativeAd[]): void;

  /**
   * 广告加载失败
   * @param adapter
   * @param error
   */
  abstract onAdDidLoadError(adapter: TBCustomNativeAdAdapter, error: BusinessError, extra?: Record<string, Object>): void;

  /**
   * 广告开始播放
   * @param adapter
   * @param orign 渠道广告数据对象
   */
  abstract onAdShow(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 广告曝光成功
   * @param adapter
   */
  abstract onAdImpression(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 广告点击
   * @param adapter
   * @param orign 渠道广告数据对象
   */
  abstract onAdClick(adapter: TBCustomNativeAdAdapter, origin: Object): void;


  /**
   * 广告关闭
   * @param adapter
   * @param orign 渠道广告数据对象
   */
  abstract onAdClose(adapter: TBCustomNativeAdAdapter, origin: Object): void;



  /**
   * 模板渲染成功
   * @param adapter
   * @param orign 渠道广告数据对象
   * @param width  返回view的宽 单位 vp
   * @param height 返回view的高 单位 vp
   */
  onRenderSuccess(adapter: TBCustomNativeAdAdapter, origin: Object, width: number, height: number);

  /**
   * 模板渲染失败
   * @param adapter
   * @param orign 渠道广告数据对象
   * @param error 错误描述信息
   */
  onRenderFail(adapter: TBCustomNativeAdAdapter, origin: Object, error: BusinessError);


  /**
   * 视频开始播放
   */
  onVideoPlayStart(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 视频播放结束
   */
  onVideoPlayComplete(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 视频播放失败
   */
  onVideoPlayError(adapter: TBCustomNativeAdAdapter, origin: Object, error: BusinessError): void;

  /**
   * dislike 弹窗show
   */
  onDislikeShow(adapter: TBCustomNativeAdAdapter, origin: Object): void;
  /**
   * dislike 弹窗取消
   */
  onDislikeCancel(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * dislike 弹窗条目被选中
   */
  onDislikeSelected(adapter: TBCustomNativeAdAdapter, origin: Object, dislike: TBDislikeInfo): void;
}
```



#### TBMediaNativeAd

在原生广告加载成功时，需通过回调协议中abstract onAdDidLoad(adapter: TBCustomNativeAdAdapter, datas: TBMediaNativeAd[]): void;方法通知聚合广告加载成功，其中TBMediaNativeAd定义了自渲染和模版渲染所所要的全部信息。

```typescript
export abstract class TBMediaNativeAd {
  /**
   * 渲染类型 模版渲染 or 自渲染
   */
  abstract getRenderType(): TBType.RenderType;

  /**
   * 信息流广告类型 信息流 or DrawVideo
   */
  abstract getNativeType(): TBType.NativeType;

  /**
   * 原始渠道返回的数据对象
   */
  abstract getOriginAd(): Object;

  /**
   * 组件渲染管理器
   * @returns
   */
  abstract viewCreator(): TBMediaViewCreator | undefined;


  /**
   * 素材类型
   * 【模版渲染为空】
   */
  getMaterialType(): TBType.MaterialType {
    return TBType.MaterialType.unknow;
  }

  /**
   * 广告交互类型
   * 【模版渲染时为空】
   */
  getInteractionType(): TBType.AdInteractionType {
    return TBType.AdInteractionType.unknow;
  }

  /**
   * CTA按钮文案
   * 【模版渲染时为空】
   */
  getActionDescription(): string {
    if (this.getInteractionType() === TBType.AdInteractionType.download) {
      return '立即下载';
    } else {
      return '查看详情';
    }
  }

  /**
   * 应用下载相关合规信息
   * @returns
   */
  getComplianceInfo(): TBMediaComplianceInfo | undefined {
    return undefined;
  }

  /**
   * 广告标题
   * 【模版渲染时为空】
   */
  getAdTitle(): string {
    return '';
  }

  /**
   * 广告描述
   * 【模版渲染时为空】
   */
  getAdDescription(): string {
    return '';
  }

  /**
   * 广告来源，可能为空
   * 【模版渲染时为空】
   */
  getAdSource(): string {
    return '';
  }

  /**
   * 获取广告⻆标的logo
   * 当返回string类型时，可能为标准url，(csj)adx广告场景时可能文字描述
   * 【模版渲染时为空】
   */
  getAdLogo(): string | Resource | undefined {
    return undefined
  }

  /**
   * 广告图片集合，单图和组图类型广告素材有返回，视频类素材返回为空
   * 【模版渲染时为空】
   */
  getImageList(): TBAdImage[] {
    return [];
  }

  /**
   * 广告Icon链接
   * 【模版渲染时为空】
   */
  getAppIconUrl(): string | undefined {
    return undefined
  }

  /**
   * 应用下载次数文案，非下载返回为空 eg:1000W此下载
   * 【模版渲染时为空】
   */
  getAppDownloadCountDes(): string | undefined {
    return undefined
  }

  /**
   * 应用评论数
   * @returns
   */
  getAppCommentNum(): number {
    return 0;
  }

  /**
   * 应用下载评分，取值0~5.0; 非下载返回为0
   * 【模版渲染时为空】
   */
  getAppScore(): number {
    return 0;
  }

  /**
   * 视频封面url
   * [支持渠道：快手]
   * 【模版渲染时为空】
   */
  getCoverUrl(): TBAdImage | undefined {
    return undefined;
  }

  /**
   * 视频url
   * 【模版渲染时为空】
   */
  getVideoUrl(): string | undefined {
    return undefined
  }

  /**
   * 视频时⻓
   * 【模版渲染时为空】
   */
  getVideoDuration(): number {
    return 0;
  }


  /**
   * 可⻅区域监听数组
   * @returns
   */
  getVisibleAreaRatios(): number[] {
    return [0, 1];
  }

  /**
   * 可⻅区域监听方法，用于三方SDK内部判断⻚面展示比例，处理广告曝光&视频播放等
   * @param isVisible
   * @param currentRatio
   * @returns true: 三方SDK处理组件展示逻辑；false: 三方SDK不处理
   */
  getVisibleAreaChangeListener(isVisible: boolean, currentRatio: number): boolean {
    return false;
  }

  /**
   * 执行广告点击逻辑【仅快手】
   * @param context
   * @param event
   */
  clickAd(context: common.UIAbilityContext, event: ClickEvent);

  /**
   * 注册原生自渲染广告点击组件ID
   * @param rootAdComponentId 广告布局根节点Id
   * @param uiContext 当前组件的上下文
   * @param clickViewIds 普通点击Id集合,点击之后，会跳转到落地页，然后再进行后续广告转化
   * @param creativeViewIds： 创意点击Id集合，点击之后，会直接进行转化
   */
  registerViewForInteraction(rootAdComponentId: string, uiContext: UIContext, clickViewIds: TBClickViewIdList<string>,
    creativeViewIds: TBClickViewIdList<string>);

  /**
   * 渲染模板广告
   * @param context
   */
  render(context: UIContext): void;
  
    /**
   * 释放资源
   */
  destroy(): void;
}
```



#### TBMediaViewCreator

```typescript
export abstract class TBMediaViewCreator {
  /**
   * 自渲染的视频组件
   */
  getMediaWrapBuilder(): tbnode.Data | undefined {
    return undefined;
  }


  /**
   * 模版渲染组件
   */
  getViewWrapBuilder(): tbnode.Data | undefined {
    return undefined;
  }
}
```



#### TBMediaComplianceInfo

应用下载类合规信息

```typescript

   * 获取App Name
   * @returns
   */
  abstract getAppName(): string;

  /**
   * 获取应用版本
   * @returns
   */
  abstract getAppVersion(): string;

  /**
   * 获取开发者名称
   * @returns
   */
  abstract getDeveloperName(): string;

  /**
   * 获取隐私协议
   * @returns
   */
  abstract getPrivacyUrl(): string;

  /**
   * 获取权限名称及权限描述列表
   * @returns
   */
  abstract getPermissionsMap(): Map<string, string>;

  /**
   * 获取权限列表url
   * @returns
   */
  abstract getPermissionUrl(): string;

  /**
   * 获取产品功能url
   * @returns
   */
  abstract getIntroductionInfoUrl(): string;
}
```



### 自定义横幅广告

#### 协议内容

```typescript
export abstract class TBCustomBannerAdAdapter extends TBCustomAdapter {

  /**
   * 加载广告
   * @param parameter 广告参数
   */
  abstract loadAdData(parameter: TBParameter): void;

}
```

#### 回调协议

```typescript
export abstract class TBCustomBannerAdAdapterBridge extends TBCustomAdapterBridge {

  /**
   * 广告数据返回，此时广告只是返回还未预加载完成
   * @param adapter
   */
  abstract onAdRequstSuccess(adapter: TBCustomNativeAdAdapter, params: ReportParameter): void;

  /**
   * 广告缓存成功
   * @param adapter
   */
  abstract onAdDidLoad(adapter: TBCustomNativeAdAdapter, datas: TBMediaNativeAd[]): void;

  /**
   * 广告加载失败
   * @param adapter
   * @param error
   */
  abstract onAdDidLoadError(adapter: TBCustomNativeAdAdapter, error: BusinessError, extra?: Record<string, Object>): void;

  /**
   * 广告开始播放
   * @param adapter
   * @param orign 渠道广告数据对象
   */
  abstract onAdShow(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 广告曝光成功
   * @param adapter
   */
  abstract onAdImpression(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 广告点击
   * @param adapter
   * @param orign 渠道广告数据对象
   */
  abstract onAdClick(adapter: TBCustomNativeAdAdapter, origin: Object): void;


  /**
   * 广告关闭
   * @param adapter
   * @param orign 渠道广告数据对象
   */
  abstract onAdClose(adapter: TBCustomNativeAdAdapter, origin: Object): void;



  /**
   * 模板渲染成功
   * @param adapter
   * @param orign 渠道广告数据对象
   * @param width  返回view的宽 单位 vp
   * @param height 返回view的高 单位 vp
   */
  onRenderSuccess(adapter: TBCustomNativeAdAdapter, origin: Object, width: number, height: number);

  /**
   * 模板渲染失败
   * @param adapter
   * @param orign 渠道广告数据对象
   * @param error 错误描述信息
   */
  onRenderFail(adapter: TBCustomNativeAdAdapter, origin: Object, error: BusinessError);


  /**
   * 视频开始播放
   */
  onVideoPlayStart(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 视频播放结束
   */
  onVideoPlayComplete(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * 视频播放失败
   */
  onVideoPlayError(adapter: TBCustomNativeAdAdapter, origin: Object, error: BusinessError): void;

  /**
   * dislike 弹窗show
   */
  onDislikeShow(adapter: TBCustomNativeAdAdapter, origin: Object): void;
  /**
   * dislike 弹窗取消
   */
  onDislikeCancel(adapter: TBCustomNativeAdAdapter, origin: Object): void;

  /**
   * dislike 弹窗条目被选中
   */
  onDislikeSelected(adapter: TBCustomNativeAdAdapter, origin: Object, dislike: TBDislikeInfo): void;
}
```

**其它同自定义信息流相同**



### 自定义广告配置客户端竞价

本章节主要介绍如何自定义Adapter实现Client Bidding



在收到广告加载完成时，通过回调协议中的onAdRequstSuccess方法，通知聚合SDK广告出价成功，该方法会携带一个ReportParameter参数，开发者可以该参数中配置价格price和货币类型currency



**注意：尽量在可以获取到价格的最早时机通过onAdRequstSuccess告知聚合SDK广告出价成功，否则可能影响整体的出价时间**



以穿山甲激励视频为例：

```typescript
// 广告基础信息加载完成
  onAdLoaded(rewardAd: CSJRewardAd) {
    if (this.parameter?.isHeaderBidding) {
      let mediaExtraInfo = rewardAd.getMediaExtraInfo();
      let price =  mediaExtraInfo.get('price');
      let request_id = mediaExtraInfo.get('request_id');
      let extra: ReportParameter = {
        transId: `${request_id}`
      };
      if (price != undefined) {
        extra.price = `${price}`
      }
      this.bridge.onAdRequstSuccess(this, extra);
    }
  }
```

