# iOS集成

**开始之前**:
>* `iOS14`要求`Xcode`版本为`12+`，请务必升级您的`Xcode`版本到`12+`。
>*  `SDK`要求`iOS`的最低版本为`iOS10.0`
>*  最简便的方法就是使用`CocoaPods`(请使用`1.10`及以上版本), 如果您刚开始接触`CocoaPods`，请参阅其[官方文档](https://guides.cocoapods.org/using/using-cocoapods)，了解如何创建和使用`Podfile`

## 集成步骤
### 1. 将`iOS SDK`添加到项目中
#### 1.1 创建`Podfile`文件</br>
在项目根目录下创建`Podfile`文件
```ruby
touch Podfile
```

#### 1.2 将iOS SDK导入项目</br>
请打开项目的 `Podfile` 文件并将下面代码添加到应用的目标中：

```ruby
source 'https://github.com/Yodo1Games/Yodo1Spec.git'
source 'https://github.com/Yodo1Sdk/Yodo1Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1Suit/OpenSuit_AnalyticsAppsFlyer', '1.5.1.1'
pod 'Yodo1Suit/OpenSuit_AnalyticsUmeng', '1.5.1.1'
pod 'Yodo1Suit/Yodo1_UCenter', '1.5.1.1'

```

在`终端`中执行如下命令：</br>
```ruby
pod install --repo-update
```

### 2. `Xcode`工程配置
#### 2.1 设置Yodo1KeyInfo.plist参数
![](./../../resource/ios_init_1.png)

#### 2.2 `iOS9 App Transport Security`设置
在`iOS9`中，苹果增加了关于`ATS`的控制。为了确保在所有中介网络上不间断地支持MAS广告，需要您在`Info.plist`文件中进行以下设置：

* 添加`NSAppTransportSecurity`，类型为`Dictionary`
* 在`NSAppTransportSecurity`中添加`NSAllowsArbitraryLoads`，类型为`Boolean`，值为`YES`

你也可以直接编辑plist源码(`Open As Source Code`)实现同样的功能，示例如下：
        
``` xml
<key>NSAppTransportSecurity</key> 
<dict> 
    <key>NSAllowsArbitraryLoads</key> 
    <true/> 
</dict>
```

#### 2.3 禁用`BitCode`
为确保所有中介网络正常工作，请禁用bitcode，如下图所示:

<img src="./../../resource/ios_init_2.png" style="zoom:50%;" />

### 3. 遵守必要的法律框架(Privacy)
请遵守适用于您的游戏及其用户的所有法律框架。您可以通过这些链接找到相关的法规信息:

* [GDPR](privacy-gdpr.md)
* [COPPA](privacy-coppa.md)
* [CCPA](privacy-ccpa.md)

<font color=red>重要：</font>不遵守这些框架可能会导致苹果商店或谷歌应用商店拒绝你的游戏，并对你的游戏盈利产生负面影响。
#### 3.1 导入头文件`Yodo1Suit.h``YD1AgePrivacyManager.h`
``` obj-c
#import "YodoSuit.h"
#import "YD1AgePrivacyManager.h"
```
#### 3.2 Privacy设置
``` obj-c
/**
 *  Privacy设置
 */
[Yodo1Suit setTagForUnderAgeOfConsent:NO];
[Yodo1Suit setUserConsent:YES];
```
#### 3.3 展示Privacy年龄选择框
``` obj-c
/**
 *  展示Privacy年龄选择框
 */
[YD1AgePrivacyManager dialogShowUserConsentWithGameAppKey:@"Your AppKey" channelCode:@"appstore" viewController:self block:^(BOOL accept, BOOL child, int age) {

 }];
```
### 4. 初始化SDK
#### 4.1 导入头文件`Yodo1Suit.h`
``` obj-c
#import "YodoSuit.h"
```

#### 4.2 在 didFinishLaunchingWithOptions 中进行初始化 
``` obj-c
[YodoSuit initWithAppKey:@"Your AppKey"];
```

### 5. 数据分析(可选)
#### 5.1 导入头文件`Yodo1AnalyticsManager.h`
``` obj-c
#import "Yodo1AnalyticsManager.h"
```
#### 5.2 上报自定义事件
``` obj-c
/**
 *  @param eventName  事件id(必须)
 *  @param eventData  事件数据(可选)
 */
- (void)eventAnalytics:(NSString*)eventName
             eventData:(NSDictionary*)eventData;
```

#### 5.3 AppsFlyer相关事件

``` obj-c
/**
 *  使用appsflyer 自定义事件
 *  @param eventName  事件id(必须)
 *  @param eventData  事件数据(可选)
 */
- (void)eventAdAnalyticsWithName:(NSString *)eventName 
                       eventData:(NSDictionary *)eventData;
```

``` obj-c
/**
 *  AppsFlyer Apple 内付费验证和事件统计
 */
- (void)validateAndTrackInAppPurchase:(NSString*)productIdentifier
                                price:(NSString*)price
                             currency:(NSString*)currency
                        transactionId:(NSString*)transactionId;
```

``` obj-c
/**
 *  订阅openURL(AppsFlyer-Deeplink])
 *
 *  @param application  生命周期中的application
 *  @param url                    生命周期中的openurl
 *  @param options           生命周期中的options
 */
- (void)SubApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
```

``` obj-c
/**
 *  订阅continueUserActivity(AppsFlyer-Deeplink])
 *
 *  @param application                      生命周期中的application
 *  @param userActivity                    生命周期中的userActivity
 *  @param restorationHandler       生命周期中的restorationHandler
 */
- (void)SubApplication:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;
```

### 6. 应用程序内购

#### 6.1 准备计费点
![](./../../resource/ios_payment_1.png)

#### 6.2 导入头文件`Yd1UCenterManager.h`
``` obj-c
#import "Yd1UCenterManager.h"
```
#### 6.3 购买产品
``` obj-c
/**
 * 购买产品
 * extra 是字典json字符串 @{@"channelUserid":@""}(非必须)
 */
- (void)paymentWithUniformProductId:(NSString *)uniformProductId
                              extra:(NSString*)extra
                           callback:(PaymentCallback)callback;
```
#### 6.4 恢复购买
```obj-c
/**
 *  恢复购买
 */
- (void)restorePayment:(RestoreCallback)callback;
```
#### 6.5 查询漏单

```obj-c
/**
 *  查询漏单
 */
- (void)queryLossOrder:(LossOrderCallback)callback;
```
#### 6.6 查询订阅

```obj-c
/**
 *  查询订阅
 */
- (void)querySubscriptions:(BOOL)excludeOldTransactions
                  callback:(QuerySubscriptionCallback)callback;
```
#### 6.7 获取产品信息

```obj-c
/**
 *  获取某个产品信息
 */
- (void)productWithUniformProductId:(NSString*)uniformProductId
                           callback:(ProductsInfoCallback)callback;
``` 
```obj-c                        
/**
 *  获取所有产品信息
 */
- (void)products:(ProductsInfoCallback)callback;
```
#### 6.8 促销产品相关

```obj-c
/**
 *  获取促销订单
 */
- (void)fetchStorePromotionOrder:(FetchStorePromotionOrderCallback) callback;
```
```obj-c
/**
 *  获取促销活动订单可见性
 */
- (void)fetchStorePromotionVisibilityForProduct:(NSString*)uniformProductId
                                       callback:(FetchStorePromotionVisibilityCallback)callback;
```
```obj-c
/**
 *  更新促销活动订单
 */
- (void)updateStorePromotionOrder:(NSArray<NSString *> *)uniformProductIdArray
                         callback:(UpdateStorePromotionOrderCallback)callback;
```
```obj-c
/**
 *  更新促销活动可见性
 */
- (void)updateStorePromotionVisibility:(BOOL)visibility
                               product:(NSString*)uniformProductId
                              callback:(UpdateStorePromotionVisibilityCallback)callback;
```
```obj-c
/**
 *  准备继续购买促销
 */
- (void)readyToContinuePurchaseFromPromot:(PaymentCallback)callback;
```
```obj-c
/**
 *  获取促销产品
 */
- (Product*)promotionProduct;
```
#### 6.9 取消购买
```obj-c
/**
 *  取消购买
 */
- (Product*)promotionProduct;
```

### 7. 应用程序内购-事件上报
#### 7.1 导入头文件`Yd1UCenter.h`
``` obj-c
#import "Yd1UCenter.h"
```
#### 7.2 YD1ItemInfo相关
``` obj-c
@interface YD1ItemInfo : NSObject
/// 产品ID
@property (nonatomic,strong)NSString *productId;
/// payment订单号
@property (nonatomic,strong)NSString *orderId;
/// 订单号(苹果transaction_id)
@property (nonatomic,strong)NSString *channelOrderid;
/// 不传默认0 商品类型,0-不可消耗;1-可消耗;2-自动订阅;3-非自动订阅
@property (nonatomic,assign)int product_type;
/// 是否获得所有数据
@property (nonatomic,strong)NSString *exclude_old_transactions;
/// 道具代码(同IAP代码)
@property (nonatomic,strong)NSString *item_code;
/// playerid
@property (nonatomic,strong)NSString *playerid;
/// 用户id
@property (nonatomic,strong)NSString *uid;
/// yid
@property (nonatomic,strong)NSString *yid;
/// 登录时，返回的ucuid（登陆uc的情况使用）
@property (nonatomic,strong)NSString *ucuid;
/// 例如idfa等设备id
@property (nonatomic,strong)NSString *deviceid;
/// 苹果验证收据
@property (nonatomic,strong)NSString *trx_receipt;
/// true为连接沙盒环境，不传或其他为正式环境
@property (nonatomic,strong)NSString *is_sandbox;
/// 附加信息
@property (nonatomic,strong)NSString *extra;
/// 渠道号 - AppStore
@property (nonatomic,strong)NSString *channelCode;
/// 失败订单的三方返回code
@property (nonatomic,strong)NSString *statusCode;
/// 三方返回的msg，可空
@property (nonatomic,strong)NSString *statusMsg;

@end
```
#### 7.3 登录上报
```obj-c
/**
 *  设备登录
 *  playerId 是玩家id（非必选，@""）
 */
- (void)deviceLoginWithPlayerId:(NSString *)playerId
                       callback:(void(^)(YD1User* _Nullable user, NSError* _Nullable  error))callback;
```
#### 7.4 App Store verify IAP上报
```obj-c
/**
 *  App Store verify IAP
 */
- (void)verifyAppStoreIAPOrder:(YD1ItemInfo *)itemInfo
                      callback:(void (^)(BOOL verifySuccess,NSString* response,NSError* error))callback;
```
#### 7.5 查询订阅上报
```obj-c
/**
 *  查询订阅
 */
- (void)querySubscriptions:(YD1ItemInfo *)itemInfo
                  callback:(void (^)(BOOL success,NSString* _Nullable response,NSError* _Nullable error))callback;
```
#### 7.6 发货上报
```obj-c
/**
 *  通知已发货成功
 */
- (void)sendGoodsOver:(NSString *)orderIds
             callback:(void (^)(BOOL success,NSString* error))callback;
```
```obj-c
/**
 *  通知已发货失败
 */
- (void)sendGoodsOverForFault:(NSString *)orderIds
                     callback:(void (^)(BOOL success,NSString* error))callback;
```
#### 7.7 支付上报
```obj-c
/**
 *  上报订单已支付成功接口
 */
- (void)clientCallback:(YD1ItemInfo *)itemInfo callbakc:(void (^)(BOOL success,NSString* error))callback;
```
```obj-c
/**
 *  上报支付失败接口
 */
- (void)reportOrderStatus:(YD1ItemInfo *)itemInfo callbakc:(void (^)(BOOL success,NSString* error))callback;
```
#### 7.8 客户端通知服务端上报
```obj-c
/**
 *  客户端通知服务端已同步unity接口
 */
- (void)clientNotifyForSyncUnityStatus:(NSArray *)orderIds
                              callback:(void (^)(BOOL success,NSArray* notExistOrders,NSArray* notPayOrders,NSString* error))callback;
```
#### 7.9 查询漏单接口（单机版）
```obj-c
/**
 *  查询漏单接口（单机版）
 */
- (void)offlineMissorders:(YD1ItemInfo *)itemInfo
                 callback:(void (^)(BOOL success,NSArray* missorders,NSString* error))callback;
```
#### 7.10 激活码/优惠券
```obj-c
/**
 *  激活码/优惠券
 *  @param code 激活码
 */
- (void)verifyActivationcode:(NSString *)code
                    callback:(void (^)(BOOL success,NSDictionary* _Nullable response,NSString* _Nullable error))callback;
```


