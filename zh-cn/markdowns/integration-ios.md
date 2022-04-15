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

pod 'Yodo1Ads/OpenSuit_AnalyticsAppsFlyer'
pod 'Yodo1Ads/OpenSuit_AnalyticsUmeng'
pod 'Yodo1Ads/Yodo1_iCloud'
pod 'Yodo1Ads/Yodo1_UCenter'
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

### 4. 初始化SDK
#### 4.1 导入头文件`Yodo1Mas.h`
``` obj-c
#import "Yodo1Ads.h"
```

#### 4.2 在 didFinishLaunchingWithOptions 中进行初始化 
``` obj-c
[Yodo1Ads initWithAppKey:@"Your AppKey"];
```

## 数据分析(可选)
### 1. 导入头文件`Yodo1AnalyticsManager.h`

### 2. 上报自定义事件

``` obj-c
/**
 *  @param eventName  事件id(必须)
 *  @param eventData  事件数据(可选)
 */
- (void)eventAnalytics:(NSString*)eventName
             eventData:(NSDictionary*)eventData;
```

### 3. AppsFlyer相关事件

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

## In App Purchase

### 1. 准备计费点
![](./../../resource/ios_payment_1.png)

#### 2 导入头文件`Yd1UCenterManager.h`
``` obj-c
#import "Yd1UCenterManager.h"
```

### 2. 购买产品
``` obj-c
/**
 * 购买产品
 * extra 是字典json字符串 @{@"channelUserid":@""}
 */
- (void)paymentWithUniformProductId:(NSString *)uniformProductId
                              extra:(NSString*)extra
                           callback:(PaymentCallback)callback;
```

### 3. 恢复购买
```obj-c
/**
 *  恢复购买
 */
- (void)restorePayment:(RestoreCallback)callback;
```

### 4. 查询漏单

```obj-c
/**
 *  查询漏单
 */
- (void)queryLossOrder:(LossOrderCallback)callback;
```

### 5. 查询订阅

```obj-c
/**
 *  查询订阅
 */
- (void)querySubscriptions:(BOOL)excludeOldTransactions
                  callback:(QuerySubscriptionCallback)callback;
```
​    
