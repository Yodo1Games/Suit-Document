# UA集成

**开始前**:
>* ' iOS14 '要求' Xcode '版本为' 12+ '，请确保升级你的' Xcode '版本为' 12+ '。
>* ' SDK '要求' iOS '的最低版本为' iOS10.0 '
>*最简单的方法是使用' CocoaPods '(请使用' 1.10 '及以上)，如果你是' CocoaPods '的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using -cocoapods)，学习如何创建和使用' Podfile '

## 集成步骤
### 1. 添加`iOS SDK`到项目中
#### 1.1 创建 `Podfile` 文件</br>
在项目的根目录中创建`Podfile`文件

```ruby
touch Podfile
```

#### 1.2 引入iOS SDK到项目中</br>
请打开项目中的`Podfile`文件并且将下面的代码添加到文件中:

```ruby
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec-Dev.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1UA', '1.0.0'
```

在`终端`中执行以下命令:</br>
```ruby
pod install --repo-update
```

### 2. 初始化SDK
#### 2.1 引入头文件`Yodo1UA.h`

``` obj-c
#import "Yodo1UA.h"
```
#### 2.2 初始化方式有两种（任选其一）
#### 2.2.1 初始化方式①

在`Info.plist` 文件中设置`AppleAppId`（必选）和`AppsFlyerDevKey`（可选，未配置则使用默认AppsFlyerDevKey）

``` xml
<key>AnalyticsInfo</key> 
<dict>  
    	<key>AppleAppId</key> 
    	<string>[Apple AppId]</string> 
    	<key>AppsFlyerDevKey</key> 
    	<string>[AppsFlyer DevKey]</string>
</dict>
```

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/ios_ua_setting.png" width="300">
</figure>

``` obj-c
[Yodo1UA.sharedInstance initWithInfoPlist];
```

#### 2.2.2 初始化方式②
``` obj-c
UAInitConfig *config = [[UAInitConfig alloc]init];
config.appsflyerDevKey = @"AppsFlyer DevKey";
config.appleId = @"Apple Id";
[Yodo1UA.sharedInstance initWithConfig:config];
```

### 3. 遵循隐私合规政策
#### 3.1 在UA初始化之前调用
``` obj-c
/**
 *  是否开启用户的年龄限制
 */
- (void)setAgeRestrictedUser:(BOOL)consent;
 
- /**
 *  用户是否同意“用户隐私协议”
 */
- (void)setHasUserConsent:(BOOL)consent;

- /**
 *  是否出售用户信息
 */ 
- (void)setDoNotSell:(BOOL)consent;
```
### 4. UA数据统计
#### 4.1 In-App 事件
#### 4.1.1 基础事件
``` obj-c
/**
 *  使用之前，先进行SDK初始化
 *
 *  @param eventName  事件id(必须)
 *  @param eventData  事件数据(可选)
 */
- (void)trackEvent:(nonnull NSString *)eventName 
		withValues:(nullable NSDictionary *)eventData;
```
示例代码：

``` obj-c
[[Yodo1UA sharedInstance] trackEvent:@"EventName_Test"
						  withValues:@{@"data1":@"dataContent1",
					  				   @"data2":@"dataContent2"}];
```

#### 4.1.2 记录收入

确定支付成功后，(不使用验证)可以直接使用trackEvent事件上报，示例代码：

``` obj-c
/**
 *  Y_UA_PURCHASE: 固定的事件名称
 *  Y_UA_CURRENCY: 货币
 *  Y_UA_QUANTITY: 数量
 *  Y_UA_CONTENT_ID: 产品id
 *  Y_UA_REVENUE: 价格
 */
[Yodo1UA.sharedInstance trackEvent:Y_UA_PURCHASE 
						withValues:@{Y_UA_CURRENCY:@"USD", 
									 Y_UA_QUANTITY:@"1", 
								   Y_UA_CONTENT_ID:@"12345", 
									  Y_UA_REVENUE:@"0.01"}];
```


#### 4.1.3 验证购买

``` obj-c
/**
 *  验证购买，SDK 为应用内购买提供验证。 validateAndLogInAppPurchase 方法负责验证和记录购买事件。
 *  
 *  @param productIdentifier The product identifier
 *  @param price The product price
 *  @param currency The product currency
 *  @param transactionId The purchase transaction Id
 */
- (void)validateAndTrackInAppPurchase:(nonnull NSString*)productIdentifier
                                price:(nonnull NSString*)price
                             currency:(nonnull NSString*)currency
                        transactionId:(nonnull NSString*)transactionId;
                      

/**
 *  开启沙箱测试环境（默认是关闭状态，提审上架之前必须处于关闭状态）
 */                        
- (void)useReceiptValidationSandbox:(BOOL)consent;

```

示例代码：

``` obj-c
[[Yodo1UA sharedInstance] validateAndTrackInAppPurchase:@"com.productId"
						  price:@"0.99"
						  currency:@"USA"
						  transactionId:@""];
```

**Note**: Calling `validateAndTrackInAppPurchase` generates an `af_purchase` in-app event upon successful validation. Sending this event yourself creates duplicate event reporting.

#### 4.2 设置额外数据

``` obj-c
/**
 *  @param customData 额外数据（NSDictionary）
 */
- (void)setAdditionalData:(nullable NSDictionary *)customData;
```

示例代码：

``` obj-c
// 与ThinkingData数据平台中的ta_distinct_id做数据关联
[Yodo1UA.sharedInstance setAdditionalData:@{@"ta_distinct_id":ThinkingAnalyticsSDK.sharedInstance.getDistinctId}];
```

#### 4.3 设置`CustomUserId`
``` obj-c
/**
 *  @param userId 自定义用户id（NSString）
 */
- (void)setCustomUserId:(nonnull NSString *)userId;
```

#### 4.4 Deeplink功能
#### 4.4.1 Deeplink集成
AppsFlyer Deeplink集成，请参考它的[官方文档](https://dev.appsflyer.com/hc/docs/initial-setup-2#procedures-for-ios-universal-links)
#### 4.4.2 设置Deeplink代理，添加`Yodo1UADeeplinkDelegate`
``` obj-c
#import "Yodo1UA.h"

@interface xxxView ()<Yodo1UADeeplinkDelegate>

@end
```

``` obj-c
Yodo1UA.sharedInstance.delegate = self;

// 实现代理方法
- (void)getDeeplinkResult:(NSDictionary *)result {
    NSLog(@"%@", result);
}
```

#### 4.4.3 生命周期方法中调用`handleOpenUrl`和`continueUserActivity`

在生命周期`openURL`方法中实现如下代码：

``` obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"openURL:%@" ,url);
    [[Yodo1UA sharedInstance] handleOpenUrl:url options:options];
    return YES;
}
```

在生命周期`continueUserActivity`方法中实现如下代码：

``` obj-c
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
#if defined(__IPHONE_12_0) || defined(__TVOS_12_0)
    restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring> > * _Nullable restorableObjects))restorationHandler
#else
    restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
#endif
{
    NSLog(@"userActivityUrl:%@",userActivity.webpageURL.description);
    [[Yodo1UA sharedInstance] continueUserActivity:userActivity];
    return YES;
}
```

### 5. 其他功能
``` obj-c
/**
 *  获取SDK版本
 */
- (NSString *)getSdkVersion;

/**
 *  开启日志（默认是0，不开启）
 */
- (void)logLevel:(int)level;
```