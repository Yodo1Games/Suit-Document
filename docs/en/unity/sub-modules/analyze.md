# Analytics Plugin

**Getting started**:

>* Download [Unity Plugin](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Analytics/Yodo1-Analytics-1.0.1.unitypackage)

## Integrate SDK

### Initialize SDK

It is recommended to call SDK initialization in the `Start` method

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
/// <param name="config">The analytics config</param>
public static void Initialize(Yodo1U3dAnalyticsConfig config);
```

* `config` is the parameter configuration required for initialization

#### Sample Code

The following example showing how to call SDK initialization in the `Start` method

```c#
void Start()
{
  Yodo1U3dAnalyticsConfig config = new Yodo1U3dAnalyticsConfig();
  config.GameKey = "<Game_Key>";
  config.TD_AppId = "<TD_App_Id>";
  Yodo1U3dAnalytics.Initialize(config);
}
```

* `GameKey` is the unique identifier of the application from Yodo1Games
* `TD_AppId` is the unique identifier of the application from Thinking SDK, it can be obtained from the project management page of TA background

## In-App events

### Tracking in-app events

The SDK lets you track user actions happening in the context of your app. These are commonly referred to as in-app events.

#### The TrackEvent method

```c#
//// <summary>
/// The TrackEvent method lets you track in-app events and send them to TD for processing.
/// </summary>
/// <param name="eventName">The In-app event name</param>
/// <param name="eventValues">The event parameters Map</param>
public static void TrackEvent(string eventName, Dictionary<string, object> eventValues);
```

* `eventName` is the In-app event name, the event name is `string` type, the name can start with a letter and contain digits, letters, and underscores (_). The name can contain a maximum of 50 characters and is case insensitive.
* `eventValues` is the event parameters `Dictionary`, Where each element represents an attribute, supports `string`、`bool`、`int`、`double` and `float`.

#### Sample Code

```c#
Dictionary<string, object> dic = new Dictionary<string, object>();
dic.Add("level", 10);
Yodo1U3dAnalytics.TrackEvent("my_test", dic);
```

## User ID

### Set user ID

The SDK instance will use a random UUID as the default guest ID for each user, which will be used as the user's identity ID when the user is not logged in. It should be noted that the guest ID will change when the user reinstalls the App and changes the device.

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

* `accountId` is the user ID defined in the game

#### Sample Code

```c#
Yodo1U3dAnalytics.Login("test_account_id");
```

### Logout ID

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

#### Sample Code

```c#
Yodo1U3dAnalytics.Logout();
```

### Get the distinct id of Thinking SDK

```c#
/// <summary>
/// Get the current distinct ID
/// </summary>
/// <returns></returns>
public static string GetDistinctId();
```

#### Sample Code

```c#
string distinct_id = Yodo1U3dAnalytics.GetDistinctId();
```

### Get the device id of Thinking SDK

```c#
/// <summary>
/// Get the TD's device ID
/// </summary>
/// <returns></returns>
public static string GetDeviceId();
```

#### Sample Code

```c#
string device_id = Yodo1U3dAnalytics.GetDeviceId();
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
