# UA Plugin

**Getting started**:

>* Download [Unity Plugin](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/UA/Yodo1-UA-1.0.1.unitypackage)
>* SDK supports Unity LTS 2019 and above
>* SDK supports Android API 19 and above
>* `CocoaPods` is required for `iOS` build, you can install it by following the instructions [here](https://guides.cocoapods.org/using/getting-started.html#getting-started)
>* iOS15 requires `Xcode` 13+, please make sure you are using the latest version of Xcode

## Integrate Configuration

### 1. `Android` Configuration

#### 1.1 Support for AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) is required for `Android` build, you can enable it by selecting ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier***

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

#### 1.2 Android permission

In early 2022, Google announced a change to the behavior of Google Play Services and fetching of the Android Advertising ID. According to the [announcement](https://support.google.com/googleplay/android-developer/answer/6048248?hl=en), apps targeting Android 13 (API 33) and above must declare a Google Play services normal permission in their `AndroidManifest.xml` file in order to get access to the device’s Advertising ID.

UA SDK adds the AD_ID permission automatically.

> Note
>
>* If your app participates in the [Designed for Families]((https://support.google.com/googleplay/android-developer/topic/9877766?hl=en&ref_topic=9858052)) program, you should Revoke the AD_ID permission.
>* For apps that target API level 32 (Android 12L) or older, this permission is not needed.

##### Revoking the `AD_ID` permission

According to [Google’s Policy](https://support.google.com/googleplay/android-developer/answer/11043825?hl=en), apps that target children must not transmit the Advertising ID.

针对Android 13 (API 33)及以上的儿童应用程序必须防止权限合并到他们的应用程序，通过添加一个撤销声明到他们的Manifest:

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID"
 tools:node="remove"/>
```

For more information, see [Google Play Services documentation](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info#public-string-getid).

### 2. `iOS` Configuration

#### 2.1 Adds `use_framework`

Set the `use_framework` according to `Assets -> External Dependency Manager -> iOS Resolver -> Settings`

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>
<!-- markdownlint-restore -->

## Integrate SDK

### Privacy Policy compliance

#### COPPA

```c#
/// <summary>
/// The SetAgeRestrictedUser method set whether it is a child user.
/// </summary>
/// <param name="isChild">true/false</param>
public static void SetAgeRestrictedUser(bool isChild);
```

##### Example: COPPA

```c#
Yodo1U3dUA.SetAgeRestrictedUser("<bool>");                                     
```

#### GDPR

```c#
/// <summary>
/// The SetHasUserConsent method Set whether to agree to the user privacy agreement.
/// </summary>
/// <param name="isConsent">true/false</param>
public static void SetHasUserConsent(bool isConsent);
```

##### Example: GDPR

```c#
Yodo1U3dUA.SetHasUserConsent("<bool>");                                     
```

#### CCPA

```c#
/// <summary>
/// The SetDoNotSell method set whether to agree not to sell.
/// </summary>
/// <param name="isNotSell">true/false</param>
public static void SetDoNotSell(bool isNotSell);
```

##### Example: CCPA

```c#
Yodo1U3dUA.SetDoNotSell("<bool>");                                     
```

### Initialize SDK

It is recommended to call SDK initialization in the `Start` method

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void InitializeWithConfig(Yodo1U3dUAConfig config);
```

* `Yodo1U3dUAConfig` is the parameter configuration required for initialization

### Sample Code

The following example showing how to call SDK initialization in the `Start` method

```c#
void Start()  {
    Yodo1U3dUAConfig config = new Yodo1U3dUAConfig();
    config.AppsFlyerDevKey = "<AF_Dev_Key>";
    config.AppleId = "<Apple_Id>";
    Yodo1U3dUA.InitializeWithConfig(config);
}
```

* `AppsFlyerDevKey` is Appsflyer Dev Key. Note: This is an optional parameter and defaults to the AppsFlyer Dev Key of Yodo1
* `AppleId` is your Apple id. Note: This is required by iOS, please ignore it if you’re building Android

## In-App events

### Tracking in-app events

The SDK lets you track user actions happening in the context of your app. These are commonly referred to as in-app events.

#### The TrackEvent method

```c#
/// <summary>
/// The TrackEvent method lets you track in-app events and send them to UA for processing.
/// </summary>
/// <param name="eventName">The In-app event name</param>
/// <param name="eventValues">The event parameters Dictionary</param>
public static void TrackEvent(string eventName, Dictionary<string, object> eventValues);
```

* `eventName` is the In-app event name
* `eventValues` is the event parameters `Dictionary`

#### Sample Code

```c#
Dictionary<string, object> dic = new Dictionary<string, object>();
dic.Add("test_1", "test123");
dic.Add("test_2", 123);
Yodo1U3dUA.TrackEvent("my_test", dic);
```

### Tracking revenue

You can send revenue with in-app event. Use `Yodo1UAInAppEventType.PURCHASE` event parameter to include revenue in the in-app event. You can populate it with any numeric value, positive or negative.

The revenue value should not contain comma separators, currency signs, or text. A revenue event should be similar to 1234.56, for example.

#### Example: Purchase event with revenue

```c#
Dictionary<string, object> dic = new Dictionary<string, object>();
dic.Add(Yodo1UAInAppEventParam.CONTENT_ID, "<CONTENT_ID>");
dic.Add(Yodo1UAInAppEventParam.CONTENT_TYPE, "<CONTENT_TYPE>");
dic.Add(Yodo1UAInAppEventParam.REVENUE, "<REVENUE>");
dic.Add(Yodo1UAInAppEventParam.CURRENCY, "<CURRENCY>");
dic.Add(Yodo1UAInAppEventParam.QUANTITY, "<QUANTITY>");
dic.Add(Yodo1UAInAppEventParam.ORDER_ID, "<ORDER_ID>");

Yodo1U3dUA.TrackEvent(Yodo1UAInAppEventType.PURCHASE, dic);
```

> Note
>
>* Do not add currency symbols to the revenue value.
>* The currency code should be a 3 character ISO 4217 code.

### Validating purchases

SDK provides server verification for in-app purchases. The `ValidateAndTrackInAppPurchase` method takes care of validating and tracking the purchase event.

#### The ValidateAndTrackInAppPurchase method

```c#
/// <summary>
/// API for server verification of in-app purchases
/// </summary>
/// <param name="productDefinition"></param>
public static void ValidateAndTrackInAppPurchase(Yodo1UAProductDefinition productDefinition);
```

> Note
>
>* ValidateAndTrackInAppPurchase generates an `af_purchase` in-app event upon successful validation.

#### Example: Validate an in-app purchase

```c#
Yodo1UAProductDefinition product = new Yodo1UAProductDefinition();
product.PublicKey = "<PublicKey>";
product.Signature = "<Signature>";
product.PurchaseData = "<PurchaseData>";
product.Currency = "<Currency>";
product.Price = "<Price>";
product.ProductIdentifier = "<ProductIdentifier>";
product.TransactionId = "<TransactionId>";

Yodo1U3dUA.ValidateAndTrackInAppPurchase(product);
```

* PublicKey: License Key obtained from the Google Play Console(Only Android)
* Signature: data.INAPP_DATA_SIGNATURE from onActivityResult(Only Android)
* PurchaseData: data.INAPP_PURCHASE_DATA from onActivityResult(Only Android)
* Price: Purchase price(Both Android and iOS)
* Currency: Purchase currency(Both Android and iOS)
* ProductIdentifier: Product Identifier(Only iOS)
* TransactionId: TransactionId from proof of successful payment(Only iOS)

#### Testing purchase validation in Sandbox mode（Only iOS）

To test purchase validation using a sandboxed environment, add the following code:

```c#
/// <summary>
/// The useReceiptValidationSandbox method lets you can open sandbox test environment. Used to test payment verification.
/// It’s only work on iOS 
/// </summary>
/// <param name="isSanbox">true/false</param>
public static void UseReceiptValidationSandbox(bool isSanbox);
```

#### Example: enable the Sandbox mode

```c#
Yodo1U3dUA.UseReceiptValidationSandbox(true);                                     
```

> Note
>
>* Apply for a sandbox account at [Apple's developer](https://developer.apple.com) site
>* On your iPhone -> Settings -> App Store -> Add `SANDBOX ACCOUNT`

### Event constants

#### Predefined event names

Predefined event name constants follow a `Yodo1UAInAppEventType.PURCHASE` naming convention

| Event name       |  Unity constant name            |  
| ---------------- | ------------------------------- |
| "y_ua_purchase"  |  Yodo1UAInAppEventType.PURCHASE |

#### Predefined event parameters

Predefined event parameter constants follow a `Yodo1UAInAppEventParam` naming convention

| Event parameter name   |  Unity constant name          |   Type    |
| ---------------------- | ------------------------------- | --------- |
| "y_ua_content_id"      |  CONTENT_ID                     |   String  |
| "y_ua_content_type"    |  CONTENT_TYPE                   |   String  |
| "y_ua_revenue"         |  REVENUE                        |   String  |
| "y_ua_currency"        |  CURRENCY                       |   String  |
| "y_ua_quantity"        |  QUANTITY                       |   String  |
| "y_ua_order_id"        |  ORDER_ID                       |   String  |

## Set custom user Id

```c#
/// <summary>
/// The setCustomUserID method lets you can set your own user ID in your app to this property
/// 
/// In case you use your own user ID in your app, you can set this property to that ID.
/// Enables you to cross-reference your own unique ID with AppsFlyer’s unique ID and the other devices’ IDs
/// 
/// </summary>
/// <param name="customUserID">Your own user ID in your app</param>
public static void SetCustomUserID(string customUserID);
```

### Example: set custom user id

```c#
Yodo1U3dUA.SetCustomUserID("<String>");                                     
```

* This operation is used to obtain event information about multiple accounts of the current user, for example, multiple accounts of the same device

## Adding additional attributes

```c#
/// <summary>
/// The setAdditionalData method lets you can add custom data to events' payload. It will appear in raw-data reports.
/// </summary>
/// <param name="customData">The event parameters Dictionary</param>
public static void SetAdditionalData(Dictionary<string, object> customData);
```

### Example: Adding additional attributes

```c#
Yodo1U3dUA.SetAdditionalData("<Dictionary>");                                     
```

* Strengthen the event analysis ability, and can also do data association with other third-party statistical platforms

<!-- ## 深度链接(DeepLink) -->

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

## known issues

### Backup rules

If you add `android:fullBackupContent="true"` inside the tag in the `AndroidManifest.xml`, you might get the following error:

```xml
Manifest merger failed : Attribute application@fullBackupContent value=(true)
```

To fix this error, add `tools:replace="android:fullBackupContent"` in the `<application>` tag in the `AndroidManifest.xml` file.

If you have your own backup rules specified (`android:fullBackupContent="@xml/my_rules"`), in addition to the instructions above, please merge them with AppsFlyer rules manually by adding the following rule:

```xml
<full-backup-content>
    ...//your custom rules
    <exclude domain="sharedpref" path="appsflyer-data"/>
</full-backup-content>
```
