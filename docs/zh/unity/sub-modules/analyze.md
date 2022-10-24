# Analytics Plugin

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Analytics/Yodo1-Analytics-1.0.1.unitypackage)

## 集成SDK

### 初始化SDK

推荐在`Start`方法中调用SDK初始化

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
/// <param name="config">The analytics config</param>
public static void Initialize(Yodo1U3dAnalyticsConfig config);
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

#### TrackEvent方法

```c#
//// <summary>
/// The TrackEvent method lets you track in-app events and send them to TD for processing.
/// </summary>
/// <param name="eventName">The In-app event name</param>
/// <param name="eventValues">The event parameters Map</param>
public static void TrackEvent(string eventName, Dictionary<string, object> eventValues);
```

* `eventName`是应用内事件名称，事件名称是`string`类型，只能以字母开头，可包含数字，字母和下划线"_"，长度最大为50个字符，对字母大小写不敏感。
* `eventValues`是事件参数`Dictionary`，其中每个元素代表一个属性，支持`string`、`bool`、`int`、`double`和`float`.

#### 示例代码

```c#
Dictionary<string, object> dic = new Dictionary<string, object>();
dic.Add("level", 10);
Yodo1U3dAnalytics.TrackEvent("my_test", dic);
```

## 用户ID

### 设置账号ID

SDK 实例会使用ID_安装次数作为每个用户的默认访客 ID，该 ID 将会作为用户在未登录状态下身份识别 ID。需要注意的是，访客 ID 在用户重新安装 App 以及更换设备时将会变更。

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

### 清除账号 ID

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
