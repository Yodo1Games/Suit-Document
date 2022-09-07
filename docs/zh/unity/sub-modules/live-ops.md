# Live Ops Plugin

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

#### 1.2 Android权限

在2022年初，谷歌宣布改变谷歌Play Services的行为，并获取Android广告ID。根据声明，针对Android 13 (API 33)及以上的应用程序必须在其`AndroidManifest.xml`文件中声明谷歌Play服务正常权限，以获得设备的广告ID。

UA SDK会自动添加AD_ID权限。

> 注意
>
>* 如果你的应用程序参与了为[家庭设计](https://support.google.com/googleplay/android-developer/topic/9877766?hl=en&ref_topic=9858052)的项目，你应该取消AD_ID权限
>* 对于目标API级别32 (Android 12L)或更老的应用程序，不需要此权限。

#### 取消`AD_ID`权限

根据[谷歌的政策](https://support.google.com/googleplay/android-developer/answer/11043825?hl=en)，针对儿童的应用程序不能传输广告ID。

针对Android 13 (API 33)及以上的儿童应用程序必须防止权限合并到他们的应用程序，通过添加一个撤销声明到他们的Manifest:

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID"
 tools:node="remove"/>
```

有关更多信息，请参见[谷歌Play Services文档](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info#public-string-getid)。

## 集成SDK

### 初始化SDK

推荐在`Start`方法中调用SDK初始化

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void Initialize(string gameKey);
```

* `gameKey`是初始化需要使用的`Yodo1 GameKey`

### 初始化回调

```c#
// 初始化成功
private static System.Action _onInitializeSuccessEvent;
public static event System.Action OnInitializeSuccessEvent;

// 初始化失败    
private static System.Action<int, string> _onInitializeFailureEvent;
public static event System.Action<int, string> OnInitializeFailureEvent;
```

#### 示例代码

下面的例子演示了如何在`Start`方法中调用SDK初始化

```c#
void Start()  {

	Yodo1U3dLiveOpsSDK.OnInitializeSuccessEvent += () =>
	{
		//初始化成功回调
	};

	Yodo1U3dLiveOpsSDK.OnInitializeFailureEvent += (int code, string message) =>
	{  
		//初始化失败回调
	};
	//初始化
	Yodo1U3dLiveOpsSDK.Instance.Initialize("<Game_Key>");
}
```

## 在线参数

### string类型

```c#
/// <summary>
/// The StringValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static string StringValue(string key, string defaultValue);
```

* 第一个参数(key)是获取在线参数value所对应的key值
* 第二个参数(defaultValue)是设置value的默认值

#### 示例代码

```c#
string valueString = Yodo1U3dLiveOpsSDK.Instance.StringValue("test_string", string.Empty);
```

### bool类型

```c#
/// <summary>
/// The BooleanValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static bool BooleanValue(string key, bool defaultValue);
```

* 第一个参数(key)是获取在线参数value所对应的key值
* 第二个参数(defaultValue)是设置value的默认值

#### 示例代码

```c#
bool valueBool = Yodo1U3dLiveOpsSDK.Instance.BooleanValue("test_bool", false);
```

### int类型

```c#
/// <summary>
/// The IntValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static int IntValue(string key, int defaultValue);
```

* 第一个参数(key)是获取在线参数value所对应的key值
* 第二个参数(defaultValue)是设置value的默认值

#### 示例代码

```c#
int valueInt = Yodo1U3dLiveOpsSDK.Instance.IntValue("test_int", 10);
```

### double类型

```c#
/// <summary>
/// The DoubleValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static double DoubleValue(string key, double defaultValue)
```

* 第一个参数(key)是获取在线参数value所对应的key值
* 第二个参数(defaultValue)是设置value的默认值

#### 示例代码

```c#
double valueDouble = Yodo1U3dLiveOpsSDK.Instance.DoubleValue("test_ double", 10.0);
```

### float类型

```c#
/// <summary>
/// The FloatValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static float FloatValue(string key, float defaultValue)
```

* 第一个参数(key)是获取在线参数value所对应的key值
* 第二个参数(defaultValue)是设置value的默认值

#### 示例代码

```c#
float valueFloat = Yodo1U3dLiveOpsSDK.Instance.FloatValue("test_ float", 10.0);
```

## 激活码

### 激活码校验

```c#
/// <summary>
/// The VerifyActivationCode method lets you verify the activation code
/// </summary>
/// <param name="activationCode"></param>
public static void VerifyActivationCode(string activationCode);
```

* `activationCode`是激活码（string）

> 注意
>
>* `activationCode`不能包含空号和标点符号

### 激活码回调

```c#
// 激活码兑换成功
private static System.Action<Dictionary<string, object>> _onActivationCodeRewardEvent;
public static event System.Action<Dictionary<string, object>> OnActivationCodeRewardEvent;

// 激活码兑换失败    
private static System.Action<int, string> _onActivationCodeFailureEvent;
public static event System.Action<int, string> OnActivationCodeFailureEvent;
```

#### 激活码兑换示例代码

```c#
Yodo1U3dLiveOpsSDK.OnActivationCodeRewardEvent += (Dictionary<string, object> reward) =>
{
	// 激活码兑换成功
};

Yodo1U3dLiveOpsSDK.OnActivationCodeFailureEvent += (int code, string message) =>
{
	// 激活码兑换失败
};

// 激活码兑换
string activationCode = "ABC123";
Yodo1U3dLiveOpsSDK.Instance.VerifyActivationCode(activationCode);
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
