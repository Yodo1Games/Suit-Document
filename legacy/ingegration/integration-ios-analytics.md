# iOS Analytics

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
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1Analytics', '6.1.5'
```

在`终端`中执行以下命令:</br>
```ruby
pod install --repo-update
```

### 2. `Xcode`项目配置
#### 2.1 设置`Info.plist` 参数
``` xml
<key>AnalyticsInfo</key> 
<dict>  
    	<key>ThinkingAppId</key> 
    	<string>[ThinkingData AppId]</string> 
    	<key>AppleAppId</key> 
    	<string>[Apple AppId]</string> 
    	<key>AppsFlyerDevKey</key> 
    	<string>[AppsFlyer DevKey]</string>
    	<key>GameKey</key> 
    	<string>[Yodo1 GameKey]</string>
    	<key>debugEnabled</key> 
    	<string>0</string> 
</dict>
```
![](./../../resource/ios_analytics_setting.png)
#### 2.2 设置`iOS9 App Transport Security`
在`iOS9`中, 苹果增加了`ATS`的控制功能。为了确保在所有中间网络上不间断地支持统计数据，您需要在`Info.plist`中进行以下设置:

* 添加 `NSAppTransportSecurity` 类型 `Dictionary`
* 在 `NSAppTransportSecurity`添加 `NSAllowsArbitraryLoads` , 类型`Boolean`, 值 `YES`

您也可以直接编辑plist源代码(`Open As Source Code`)来实现相同的功能，示例如下:
        
``` xml
<key>NSAppTransportSecurity</key> 
<dict> 
	<key>NSAppTransportSecurity</key> 
	<true/>
</dict>
```

### 3. 初始化SDK
#### 3.1 引入头文件`Yodo1AnalyticsManager.h `
``` obj-c
#import "Yodo1AnalyticsManager.h"
```

#### 3.2 在项目中的AppDelegate的`didFinishLaunchingWithOptions` 方法中添加以下代码

``` obj-c
AnalyticsInitConfig * config = [[AnalyticsInitConfig alloc]init];
[Yodo1AnalyticsManager.sharedInstance initializeAnalyticsWithConfig:config];
```
### 4. 数据分析api使用
#### 4.1 数据统计基础功能
``` obj-c
/**
 *  使用之前，先初始化initWithAnalytics
 *
 *  @param eventName  事件id(必须)
 *  @param eventData  事件数据(必须)
 */
- (void)eventAnalytics:(NSString*)eventName
             eventData:(NSDictionary*)eventData;

/**
 *  设置AppsFlyer和ThinkingData userId （可选）
 */
- (void)login:(NSString *)userId;

```
#### 4.2 AppsFlyer事件
``` obj-c
// AppsFlyer事件
/**
 *  使用appsflyer 自定义事件
 *  @param eventName  事件id(必须)
 *  @param eventData  事件数据(必须)
 */
- (void)eventAppsFlyerAnalyticsWithName:(NSString *)eventName 
                              eventData:(NSDictionary *)eventData;
/**
 *  AppsFlyer Apple 内付费验证和事件统计
 */
- (void)validateAndTrackInAppPurchase:(NSString*)productIdentifier
                                price:(NSString*)price
                             currency:(NSString*)currency
                        transactionId:(NSString*)transactionId;
                        
/**
 *  AppsFlyer Apple 内付费使用自定义事件上报
 */
- (void)eventAndTrackInAppPurchase:(NSString*)revenue
                          currency:(NSString*)currency
                          quantity:(NSString*)quantity
                         contentId:(NSString*)contentId
                         receiptId:(NSString*)receiptId;

```
#### 4.3 AppsFlyer Deeplink功能
AppsFlyer Deeplink集成，请参考它的[官方文档](https://dev.appsflyer.com/hc/docs/initial-setup-2#procedures-for-ios-universal-links)

在`delegate`方法openURL中添加如下代码：

``` obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"openURL:%@" ,url);

    [[Yodo1AnalyticsManager sharedInstance] handleOpenUrl:url options:options];

    return YES;
}

```
在`delegate`continueUserActivity中添加如下代码：

``` obj-c
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity
#if defined(__IPHONE_12_0) || defined(__TVOS_12_0)
    restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring> > * _Nullable restorableObjects))restorationHandler
#else
    restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
#endif
{
    NSLog(@"userActivityUrl:%@",userActivity.webpageURL.description);
    [[Yodo1AnalyticsManager sharedInstance] continueUserActivity:userActivity];
    return YES;
}

```