# Analytics 集成

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

pod 'Yodo1Analytics', '1.0.0'
```

在`终端`中执行以下命令:</br>

```ruby
pod install --repo-update
```

## 集成步骤

### 初始化SDK

#### 引入头文件`Yodo1Analytics.h`

推荐在`didFinishLaunchingWithOptions`生命周期方法中进行初始化

``` obj-c
#import "Yodo1Analytics.h"
```

#### 初始化

``` obj-c
AnalyticsInitConfig *config = [[AnalyticsInitConfig alloc]init];
config.game_key = @"<Game_Key>";
config.td_app_id = @"<TD_App_Id>";
[Yodo1Analytics.sharedInstance initWithConfig:config];
```

* 第一个参数（game_key）是当前工程中使用的Yodo1 Game Key
* 第二个参数（td_app_id）是当前工程中使用的ThinkingData AppId

## 应用内事件

### 记录应用程序事件

SDK允许您记录应用程序上下文中发生的用户操作。这些通常被称为应用内事件。

#### TrackEvent方法

``` obj-c
/**
 *  Tracking in-app events, the SDK lets you log user actions happening in the context of your app.
 *
 *  @param eventName  The event name(Necessary)
 *  @param eventData  The event data(Optional)
 */
- (void)trackEvent:(nonnull NSString *)eventName withValues:(nullable NSDictionary *)eventData;
```

* `eventName`是应用内事件名称，事件名称是`NSString`类型，只能以字母开头，可包含数字，字母和下划线"_"，长度最大为50个字符，对字母大小写不敏感。
* `eventData `是事件参数`Dictionary`，其中每个元素代表一个属性，支持`NSString`、`BOOL`、`int`、`double`和`float`.

#### 示例代码

``` obj-c
[[Yodo1Analytics sharedInstance] trackEvent:@"<Event_Name>" withValues:@{@"level":10}];
```

## 用户ID

### 设置账号ID

SDK 实例会使用ID_安装次数作为每个用户的默认访客 ID，该 ID 将会作为用户在未登录状态下身份识别 ID。需要注意的是，访客 ID 在用户重新安装 App 以及更换设备时将会变更。

```obj-c
/**
 *  ThinkingData  set  account id
 */
- (void)login:(nonnull NSString *)accountId;
```

* `accountId`是游戏中定义的账号id

#### 示例代码

```obj-c
[[Yodo1Analytics sharedInstance] login:@"<Account_Id>"];
```

### 清除账号 ID

```obj-c
/**
 *  ThinkingData logout
 */
- (void)logout;
```

#### 示例代码

```obj-c
[[Yodo1Analytics sharedInstance] logout];
```

### 获取TD的distinct id

```obj-c
/**
 *  get  ThinkingData distinctId
 */
- (nonnull NSString *)getDistinctId;
```

#### 示例代码

```obj-c
NSString *distinct_id = [[Yodo1Analytics sharedInstance] getDistinctId];
```

### 获取TD的device id

```obj-c
/**
 *  get ThinkingData DeviceId
 */
- (nonnull NSString *)getDeviceId;
```

#### 示例代码

```obj-c
NSString *device_id = [[Yodo1Analytics sharedInstance] getDeviceId];
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
