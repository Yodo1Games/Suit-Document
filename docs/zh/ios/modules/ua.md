# UA 集成

**开始前**:

>* ' iOS14 '要求' Xcode '版本为' 12+ '，请确保升级你的' Xcode '版本为' 12+ '。
>* ' SDK '要求' iOS '的最低版本为' iOS10.0 '
>*最简单的方法是使用' CocoaPods '(请使用' 1.10 '及以上)，如果你是' CocoaPods '的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using -cocoapods)，学习如何创建和使用' Podfile '

## 集成SDK

### 添加`iOS SDK`到项目中

#### 创建 `Podfile` 文件</br>

在项目的根目录中创建`Podfile`文件

```ruby
touch Podfile
```

#### 引入iOS SDK到项目中</br>

请打开项目中的`Podfile`文件并且将下面的代码添加到文件中:

```ruby
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1UA', '1.0.0'
```

在`终端`中执行以下命令:</br>

```ruby
pod install --repo-update
```

## 集成步骤

### 初始化

#### 引入头文件`Yodo1UA.h`

``` obj-c
#import "Yodo1UA.h"
```

#### 初始化方式有两种（任选其一）

##### 初始化方式①

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

##### 初始化方式②

``` obj-c
UAInitConfig *config = [[UAInitConfig alloc]init];
config.appsflyer_dev_key = @"<AppsFlyer_Dev_Key>";
config.apple_id = @"<Apple_Id>";
[Yodo1UA.sharedInstance initWithConfig:config];
```

## 应用内事件

### 记录应用程序事件

SDK允许您记录应用程序上下文中发生的用户操作。这些通常被称为应用内事件。

#### TrackEvent方法

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

#### 示例代码

``` obj-c
[[Yodo1UA sharedInstance] trackEvent:@"EventName_Test"
						  withValues:@{@"data1":@"dataContent1",
					  				   @"data2":@"dataContent2"}];
```

### 记录收入

你可以通过应用内部事件发送收益。确定支付成功后，将收益包含在应用内部事件中。您可以用任何数值(正的或负的)填充它。收入值不应该包含逗号、分隔符、货币符号或文本。例如，收入事件应该类似于1234.56。

#### 示例:带有收益的购买事件

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

> 注意
>
>* 不要在收益值中添加货币符号
>* 货币代码应该是3个字符的ISO 4217代码

### 验证购买

SDK为应用内部购买提供服务器验证。`validateAndTrackInAppPurchase`方法负责验证和记录购买事件。

#### validateAndTrackInAppPurchase方法

``` obj-c
/**
 *  验证购买，SDK 为应用内购买提供验证。 validateAndTrackInAppPurchase 方法负责验证和记录购买事件。
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
```

#### 示例:验证应用内购买

``` obj-c
[[Yodo1UA sharedInstance] validateAndTrackInAppPurchase:@"com.productId"
						  price:@"0.99"
						  currency:@"USA"
						  transactionId:@""];
```

**Note**: Calling `validateAndTrackInAppPurchase` generates an `af_purchase` in-app event upon successful validation. Sending this event yourself creates duplicate event reporting.

#### 开启沙箱测试环境

开启沙箱测试环境是为了方便测试`validateAndTrackInAppPurchase`

``` obj-                   
/**
 *  开启沙箱测试环境（默认是关闭状态，提审上架之前必须处于关闭状态）
 */                        
- (void)useReceiptValidationSandbox:(BOOL)isConsent;
```

> 注意
>
>* 在[苹果开发者](https://developer.apple.com)网站申请沙盒账户
>* 在苹果手机上 -> 设置 -> App Store 添加`沙盒账户`

## 设置CustomId

``` obj-c
/**
 *  @param userId 自定义用户id（NSString）
 */
- (void)setCustomUserId:(nonnull NSString *)userId;
```

### 示例:设置CustomId

``` obj-c
[[Yodo1UA sharedInstance] setCustomUserId:@"<Custom_Id>"];
```

* 针对于需要获取当前用户下多个账号的事件信息，例如：同一台设备下有多个账号

## 增加额外属性

``` obj-c
/**
 *  @param customData 额外数据（NSDictionary）
 */
- (void)setAdditionalData:(nullable NSDictionary *)customData;
```

### 示例:增加额外属性配置

``` obj-c
// 与ThinkingData数据平台中的ta_distinct_id做数据关联
[Yodo1UA.sharedInstance setAdditionalData:@{@"ta_distinct_id":ThinkingAnalyticsSDK.sharedInstance.getDistinctId}];
```

## 向AppsFlyer发送SKAN回传备份（iOS 15+适用）

请参考它的[官方文档](https://support.appsflyer.com/hc/zh-cn/articles/4402320969617)

>* 将`NSAdvertisingAttributionReportEndpoint`键添加到应用程序的`info.plist`中。
>* 将键的值设置为`https://appsflyer-skadnetwork.com/`。

## 深度链接（Deeplink）

AppsFlyer Deeplink集成，请参考它的[官方文档](https://dev.appsflyer.com/hc/docs/initial-setup-2#procedures-for-ios-universal-links)

### 设置Deeplink代理，添加`Yodo1UADeeplinkDelegate`

``` obj-c
#import "Yodo1UA.h"

@interface xxxView ()<Yodo1UADeeplinkDelegate>

@end
```

### 实现代理方法

``` obj-c
Yodo1UA.sharedInstance.delegate = self;

// 实现代理方法
- (void)getDeeplinkResult:(NSDictionary *)result {
    NSLog(@"%@", result);
}
```

### 实现生命周期方法`handleOpenUrl`

在生命周期`openURL`方法中实现如下代码：

``` obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"openURL:%@" ,url);
    [[Yodo1UA sharedInstance] handleOpenUrl:url options:options];
    return YES;
}
```

### 实现生命周期方法`continueUserActivity`

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

## 关于隐私合规政策

### 儿童用户

``` obj-c
/**
 *  是否开启用户的年龄限制
 */
- (void)setAgeRestrictedUser:(BOOL)consent;
``` 

### 隐私协议

``` obj-c
- /**
 *  用户是否同意“用户隐私协议”
 */
- (void)setHasUserConsent:(BOOL)consent;
```

### 禁止出售用户信息

``` obj-c
- /**
 *  是否出售用户信息
 */ 
- (void)setDoNotSell:(BOOL)consent;
```

## 其他

### 获取SDK版本信息

``` obj-c
/**
 *  获取SDK版本
 */
- (NSString *)getSdkVersion;
```

### 开启日志

默认是不开启日志，上架之前请先关闭日志

``` obj-c
/**
 *  开启日志（默认是NO，不开启）
 */
- (void)setDebugLog:(BOOL)debugLog;
```
