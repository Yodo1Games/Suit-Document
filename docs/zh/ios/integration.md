# 集成 SDK

**集成准备**:

>* `iOS14`要求`Xcode`版本为`12+`，请确保升级你的`Xcode`版本为`12+`。
>* SDK要求`iOS`的最低版本为`10.0`
>* 最简单的方法是使用`CocoaPods`(请使用`1.10`及以上)，如果你是`CocoaPods`的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using-cocoapods)，学习如何创建和使用`Podfile`

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
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'

pod 'Yodo1Suit', '6.1.2'
```

在`终端`中执行以下命令:</br>

```ruby
pod install --repo-update
```

### 2. `Xcode`项目配置

#### 2.1 设置`Info.plist` 参数

```xml
<key>AnalyticsInfo</key> 
<dict>
<!-- markdownlint-disable -->
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

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/ios_analytics_setting.png" width="300">
</figure>

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
#### 3.1 引入头文件`Yodo1Manager.h`
``` obj-c
#import "Yodo1Manager.h"
```

#### 3.2 在项目中的AppDelegate的`didFinishLaunchingWithOptions` 方法中添加以下代码
初始化方式一：

``` obj-c
[Yodo1Manager initWithAppKey:@"Your Yodo1's App Key"];
```
初始化方式二：

``` obj-c
SDKConfig *config = [[SDKConfig alloc]init];
config.appKey = @"Your Yodo1's App Key";
[Yodo1Manager initSDKWithConfig:config];
```

### 4. 基础功能api使用
``` obj-c
// 获取SDK版本信息
+ (NSString *)sdkVersion;
// 获取DeviceId 
+ (NSString *)getDeviceId;
// 获取国家编码
+ (NSString *)GetCountryCode;

// 在线参数功能
+ (NSString *)stringParamsConfigWithKey:(NSString *)key defaultValue:(NSString *)value;
+ (BOOL)boolParamsConfigWithKey:(NSString *)key defaultValue:(bool)value;

```
#### 5. Privacy模块
#### 5.1 引入头文件`Yodo1Manager.h`
``` obj-c
#import "Yodo1Manager.h"
```
#### 5.2 Privacy Api使用
``` obj-c
+ (void)setUserConsent:(BOOL)consent;

+ (BOOL)isUserConsent;

+ (BOOL)isTagForUnderAgeOfConsent;

+ (void)setDoNotSell:(BOOL)doNotSell;

+ (BOOL)isDoNotSell;

```
#### 6. GameCenter模块
#### 6.1 引入头文件`Yodo1GameCenter.h`
``` obj-c
#import "Yodo1GameCenter.h"
```
#### 6.2 GameCenter Api使用
``` obj-c
// GameCenter初始化，登录
- (void)initGameCenter;

// 判断是否登录
- (BOOL)gameCenterIsLogin;

// 解锁成就
- (void)achievementsUnlock:(NSString *)identifier;

// 提交分数
- (void)UpdateScore:(int)score leaderboard:(NSString *)identifier;

// 打开挑战榜
- (void)ShowGameCenter;

// 打开排行榜
- (void)LeaderboardsOpen;

// 打开成就榜
- (void)AchievementsOpen;

// 获取指定identifier的成就完成百分比
- (double)ProgressForAchievement:(NSString *)identifier;

// 获取指定identifier排行榜的最高分
- (int)highScoreForLeaderboard:(NSString *)identifier;
```
在`delegate`continueUserActivity中添加如下代码：

### 7. iCloud（云存储）模块
#### 7.1 引入头文件`Yodo1iCloud.h`
``` obj-c
#import "Yodo1iCloud.h"
```
#### 7.2 iCloud Api使用
``` obj-c
/**
 *  存储信息到云端
 *
 *  @param saveName   存储名
 *  @param saveValsue 存储值
 */
- (void)saveToCloud:(NSString* __nullable)saveName
          saveValue:(NSString* __nullable)saveValsue;

/**
 *  从云端读取数据
 *
 *  @param recordName          存储名
 *  @param completionHandler 回调block
 */
- (void)loadToCloud:(NSString* __nullable)recordName
  completionHandler:(void (^__nullable)(NSString * __nullable results, NSError * __nullable error))completionHandler;

/**
 *  从云端删除数据
 *
 *  @param recordName 存储记录id
 */
- (void)removeRecordWithRecordName:(NSString *__nullable)recordName;
```
### 8. iRate（App评价）模块
#### 8.1 引入头文件`iRate.h`
``` obj-c
#import "iRate.h"
```
#### 8.2 iRate Api使用
``` obj-c
// 在AppStore打开评价界面
- (void)openRatingsPageInAppStore;
```
### 9. Notification（本地推送通知）模块
#### 9.1 引入头文件`Yodo1LocalNotification.h`
``` obj-c
#import "Yodo1LocalNotification.h"
```
#### 9.2 Notification Api使用
``` obj-c
/**
 *  注册本地推送通知
 *
 *  @param notificationKey 通知的Key
 *  @param notificationId  通知的Id
 *  @param alertTime       通知时间
 *  @param title           通知对话框标题
 *  @param msg             通知描述
 */
+ (void)registerLocalNotification:(NSString* __nullable)notificationKey
                   notificationId:(NSInteger)notificationId
                        alertTime:(NSInteger)alertTime
                            title:(NSString* __nullable)title
                              msg:(NSString* __nullable)msg;
/**
 *  取消本地推送通知
 *
 *  @param key            通知的Key
 *  @param notificationId 通知的Id
 */
+ (void)cancelLocalNotificationWithKey:(NSString* __nullable)key
                        notificationId:(NSInteger)notificationId;
```
### 10. Replay（屏幕录制）模块
#### 10.1 引入头文件`Yodo1Replay.h`
``` obj-c
#import "Yodo1Replay.h"
```
#### 10.2 Replay Api使用
``` obj-c
// 是否支持回放
- (BOOL)bSupportReplay;
// 开始录制
- (void)startScreenRecorder;
// 结束录制
- (void)stopScreenRecorder;
// 展示录制
- (void)showRecorder:(UIViewController* __nullable)viewcontroller;
```