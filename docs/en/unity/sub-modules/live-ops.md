# Live Ops Plugin

**Getting started**:

>* Download [Unity Plugin](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Live_Ops/Yodo1-LiveOps-1.0.0.unitypackage)
>* SDK supports Unity LTS 2019 and above
>* SDK supports Android API 19 and above
>* `CocoaPods` is required for `iOS` build, you can install it by following the instructions [here](https://guides.cocoapods.org/using/getting-started.html#getting-started)
>* iOS15 requires `Xcode` 13+, please make sure you are using the latest version of Xcode

## Integrate Configuration

### `Android` Configuration

#### Support for AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) is required for `Android` build, you can enable it by selecting ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier***

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

## Integrate SDK

### Initialize SDK

It is recommended to call SDK initialization in the `Start` method

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void Initialize(string gameKey);
```

* `gameKey` is the unique identifier of the application from Yodo1Games

### Set the initialization callback events

```c#
private static System.Action _onInitializeSuccessEvent;
public static event System.Action OnInitializeSuccessEvent;
   
private static System.Action<int, string> _onInitializeFailureEvent;
public static event System.Action<int, string> OnInitializeFailureEvent;
```

#### Sample Code

The following example showing how to call SDK initialization in the `Start` method

```c#
void Start()  {

	Yodo1U3dLiveOpsSDK.OnInitializeSuccessEvent += () =>
	{
		
	};

	Yodo1U3dLiveOpsSDK.OnInitializeFailureEvent += (int code, string message) =>
	{  
		
	};
	
	Yodo1U3dLiveOpsSDK.Instance.Initialize("<Game_Key>");
}
```

## Remote configuration

### `string` type

```c#
/// <summary>
/// The StringValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static string StringValue(string key, string defaultValue);
```

* `key` is to obtain the key value corresponding to the remote configuration value
* `defaultValue` is the default value for setting value

#### Sample Code

```c#
string valueString = Yodo1U3dLiveOpsSDK.Instance.StringValue("test_string", string.Empty);
```

### `bool` type

```c#
/// <summary>
/// The BooleanValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static bool BooleanValue(string key, bool defaultValue);
```

* `key` is to obtain the key value corresponding to the remote configuration value
* `defaultValue` is the default value for setting value

#### Sample Code

```c#
bool valueBool = Yodo1U3dLiveOpsSDK.Instance.BooleanValue("test_bool", false);
```

### `int` type

```c#
/// <summary>
/// The IntValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static int IntValue(string key, int defaultValue);
```

* `key` is to obtain the key value corresponding to the remote configuration value
* `defaultValue` is the default value for setting value

#### Sample Code

```c#
int valueInt = Yodo1U3dLiveOpsSDK.Instance.IntValue("test_int", 10);
```

### `double` type

```c#
/// <summary>
/// The DoubleValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static double DoubleValue(string key, double defaultValue)
```

* `key` is to obtain the key value corresponding to the remote configuration value
* `defaultValue` is the default value for setting value

#### Sample Code

```c#
double valueDouble = Yodo1U3dLiveOpsSDK.Instance.DoubleValue("test_ double", 10.0);
```

### `float` type

```c#
/// <summary>
/// The FloatValue method lets you get the the remote config.
/// </summary>
/// <param name="key"></param>
/// <param name="defaultValue"></param>
/// <returns></returns>
public static float FloatValue(string key, float defaultValue)
```

* `key` is to obtain the key value corresponding to the remote configuration value
* `defaultValue` is the default value for setting value

#### Sample Code

```c#
float valueFloat = Yodo1U3dLiveOpsSDK.Instance.FloatValue("test_ float", 10.0);
```

## Redeem Code

### Verify the redeem code

```c#
/// <summary>
/// The VerifyActivationCode method lets you verify the activation code
/// </summary>
/// <param name="activationCode"></param>
public static void VerifyActivationCode(string activationCode);
```

* `activationCode` is the value of the redeem code

> Note
>
>* `activationCode` can't contain empty signs and punctuation marks

### The callback events of the redeem code

```c#
private static System.Action<Dictionary<string, object>> _onActivationCodeRewardEvent;
public static event System.Action<Dictionary<string, object>> OnActivationCodeRewardEvent;
   
private static System.Action<int, string> _onActivationCodeFailureEvent;
public static event System.Action<int, string> OnActivationCodeFailureEvent;
```

### Sample Code

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

## Other Methods

### Get the SDK version

```c#
/// <summary>
/// The GetSdkVersion method get sdk version.
/// </summary>
public static string GetSdkVersion();
```

### Enable the debug log

The debug log is disabled by default. Please disable it before release to App stores

```c#
/// <summary>
/// Whether to enable logging.
/// </summary>
public static void SetDebugLog(bool debugLog);
```
