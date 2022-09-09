# Analytics Plugin

**集成准备**:

>* 下载[Unity插件]()
>* SDK支持Unity LTS 版本（2019或更高版本）
>* SDK支持Android API 19+
>* `CocoaPods`是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
>* iOS14需要`Xcode` 12+，请确保你的`Xcode`是最新的。

## 集成配置

### 1. `Android`配置

#### 1.1 设置支持AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) 是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 来启用它，如下图所示：

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

## 集成SDK

### 初始化SDK

推荐在`Start`方法中调用SDK初始化

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
/// <param name="config">The analytics config</param>
public static void Initialize(Yodo1U3dAnalyticsConfig config)
```

* `config`是初始化需要使用的参数配置

#### 示例代码

下面的例子演示了如何在`Start`方法中调用SDK初始化

```c#
void Start()
{
	Yodo1U3dAnalyticsConfig config = new Yodo1U3dAnalyticsConfig();
	config.GameKey = "<Game_Key>";
	config.TD_AppId = "<TD_App_Id>";
	Yodo1U3dAnalytics.Initialize(config);
}
```

* `config`配置中第一个参数（GameKey）是游戏使用的gameKey（Yodo1 GameKey）
* `config`配置中第二个参数（TD_AppId）是ThinkingData AppId

## 应用内事件

### 记录应用程序事件

SDK允许您记录应用程序上下文中发生的用户操作。这些通常被称为应用内事件。

### trackEvent方法

```c#
//// <summary>
/// The trackEvent method lets you track in-app events and send them to TD for processing.
/// </summary>
/// <param name="eventName">The In-app event name</param>
/// <param name="eventValues">The event parameters Map</param>
public static void TrackEvent(string eventName, Dictionary<string, object> eventValues);
```

* 第一个参数(eventName)是应用内事件名称
* 第二个参数(eventValues)是事件参数`Dictionary`

#### 示例代码

```c#
Dictionary<string, object> dic = new Dictionary<string, object>();
dic.Add("test_1", "test123");
dic.Add("test_2", 123);
Yodo1U3dAnalytics.TrackEvent("my_test", dic);
```

### 设置account id

```c#
/// <summary>
///
/// The Login method lets you set the user's account id
/// 
/// The login method can be called to set the user's account ID when the user logs in.
/// The account ID will be used as the identity ID after setting the account ID, and the set account ID will be retained until the logout method is called.
/// 
/// </summary>
/// <param name="accountId">The user's account ID</param>
public static void Login(string accountId);
```

* `accountId`是游戏中定义的账号id

#### 示例代码

```c#
Yodo1U3dAnalytics.Login("test_account_id");
```

### 取消设置account id

```c#
/// <summary>
/// 
/// Clear account ID
///
/// The logout method can be called to clear the account ID after the user has logged out, and the guest ID will be used as the identity ID until the next call to Login method
/// 
/// </summary>
public static void Logout();
```

#### 示例代码

```c#
Yodo1U3dAnalytics.Logout();
```

### 获取TD的distinct id

```c#
/// <summary>
/// Get the current distinct ID
/// </summary>
/// <returns></returns>
public static string GetDistinctId();
```

#### 示例代码

```c#
string distinct_id = Yodo1U3dAnalytics.GetDistinctId();
```

### 获取TD的device id

```c#
/// <summary>
/// Get the TD's device ID
/// </summary>
/// <returns></returns>
public static string GetDeviceId();
```

#### 示例代码

```c#
string device_id = Yodo1U3dAnalytics.GetDeviceId();
```

## 其他

### 获取SDK版本信息

```c#
/// <summary>
/// The GetSdkVersion method get sdk version.
/// </summary>
public static string GetSdkVersion();
```

### 开启日志

默认是不开启日志，上架之前请先关闭日志

```c#
/// <summary>
/// Whether to enable logging.
/// </summary>
public static void SetDebugLog(bool debugLog);
```