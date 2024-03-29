# Live Ops集成

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Live_Ops/Yodo1-LiveOps-1.0.0.unitypackage)

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

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

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

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

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

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

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

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

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

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

#### 示例代码

```c#
float valueFloat = Yodo1U3dLiveOpsSDK.Instance.FloatValue("test_ float", 10.0);
```

## 兑换码

### 校验兑换码

```c#
/// <summary>
/// The VerifyActivationCode method lets you verify the activation code
/// </summary>
/// <param name="activationCode"></param>
public static void VerifyActivationCode(string activationCode);
```

* `activationCode`是兑换码（string）

> 注意
>
>* `activationCode`不能包含空号和标点符号

### 兑换码回调事件

```c#
private static System.Action<Dictionary<string, object>> _onActivationCodeRewardEvent;
public static event System.Action<Dictionary<string, object>> OnActivationCodeRewardEvent;
   
private static System.Action<int, string> _onActivationCodeFailureEvent;
public static event System.Action<int, string> OnActivationCodeFailureEvent;
```

#### 兑换码ErrorCode

| code   | 描述           |
| -------| ------------- |
| 0      | 成功           |
| 1      | 无效的兑换码    |
| 2      | 兑换码已使用    |
| 3      | 活动未开始      |
| 4      | 活动已结束      |
| 5      | 同类兑换码不可重复领取|

#### 兑换码示例代码

```c#
Yodo1U3dLiveOpsSDK.OnActivationCodeRewardEvent += (Dictionary<string, object> reward) =>
{
	
};

Yodo1U3dLiveOpsSDK.OnActivationCodeFailureEvent += (int code, string message) =>
{
	
};


string activationCode = "<Your_Activation_Code>";
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
