# UA Plugin

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/UA/Yodo1-UA-1.0.1.unitypackage)
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

##### 取消`AD_ID`权限

根据[谷歌的政策](https://support.google.com/googleplay/android-developer/answer/11043825?hl=en)，针对儿童的应用程序不能传输广告ID。

针对Android 13 (API 33)及以上的儿童应用程序必须防止权限合并到他们的应用程序，通过添加一个撤销声明到他们的Manifest:

```xml
<uses-permission android:name="com.google.android.gms.permission.AD_ID"
 tools:node="remove"/>
```

有关更多信息，请参见[谷歌Play Services文档](https://developers.google.com/android/reference/com/google/android/gms/ads/identifier/AdvertisingIdClient.Info#public-string-getid)。

### 2. `iOS`配置
#### 2.1 添加 `use_framework`
设置路径：Assets -> External Dependency Manager -> iOS Resolver -> Settings（如图所示）
<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>
<!-- markdownlint-restore -->

## 集成SDK

### 关于隐私合规政策

#### 儿童用户

```c#
/// <summary>
/// The SetAgeRestrictedUser method set whether it is a child user.
/// </summary>
/// <param name="isChild">true/false</param>
public static void SetAgeRestrictedUser(bool isChild);
```

##### 示例:设置是否为儿童用户

```c#
Yodo1U3dUA.SetAgeRestrictedUser("<bool>");                                     
```

#### 隐私协议

```c#
/// <summary>
/// The SetHasUserConsent method Set whether to agree to the user privacy agreement.
/// </summary>
/// <param name="isConsent">true/false</param>
public static void SetHasUserConsent(bool isConsent);
```

##### 示例:设置是否同意隐私协议

```c#
Yodo1U3dUA.SetHasUserConsent("<bool>");                                     
```

#### 禁止出售用户信息

```c#
/// <summary>
/// The SetDoNotSell method set whether to agree not to sell.
/// </summary>
/// <param name="isNotSell">true/false</param>
public static void SetDoNotSell(bool isNotSell);
```

##### 示例:设置是否禁止出售用户信息

```c#
Yodo1U3dUA.SetDoNotSell("<bool>");                                     
```

### 初始化SDK

推荐在`Start`方法中调用SDK初始化

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void InitializeWithConfig(Yodo1U3dUAConfig config);
```

* `Yodo1U3dUAConfig`是初始化参数配置

### 示例代码

下面的例子演示了如何在`Start`方法中调用SDK初始化

```c#
void Start()  {
    Yodo1U3dUAConfig config = new Yodo1U3dUAConfig();
    config.AppsFlyerDevKey = "<AF_Dev_Key>";
    config.AppleId = "<Apple_Id>";
    Yodo1U3dUA.InitializeWithConfig(config);
}
```

* `AppsFlyerDevKey`是Appsflyer Dev Key，注意：如果使用Yodo1默认Appsflyer Dev Key，可忽略该参数，SDK中已经集成它
* `AppleId`是苹果的Apple Id，注意：如果是iOS平台，该参数是必选项，如果是Andriod平台，该参数可以忽略

## 应用内事件

### 记录应用程序事件

SDK允许您记录应用程序上下文中发生的用户操作。这些通常被称为应用内事件。

#### TrackEvent方法

```c#
/// <summary>
/// The TrackEvent method lets you track in-app events and send them to UA for processing.
/// </summary>
/// <param name="eventName">The In-app event name</param>
/// <param name="eventValues">The event parameters Dictionary</param>
public static void TrackEvent(string eventName, Dictionary<string, object> eventValues);
```

* `eventName`是应用内事件名称
* `eventValues`是事件参数`Dictionary`

#### 示例代码

```c#
Dictionary<string, object> dic = new Dictionary<string, object>();
dic.Add("test_1", "test123");
dic.Add("test_2", 123);
Yodo1U3dUA.TrackEvent("my_test", dic);
```

### 记录收入

你可以通过应用内部事件发送收益。使用`Yodo1UAInAppEventType.PURCHASE`事件参数，将收益包含在应用内部事件中。您可以用任何数值(正的或负的)填充它。收入值不应该包含逗号、分隔符、货币符号或文本。例如，收入事件应该类似于1234.56。

#### 示例:带有收益的购买事件

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

> 注意
>
>* 不要在收益值中添加货币符号
>* 货币代码应该是3个字符的ISO 4217代码

### 验证购买

SDK为应用内部购买提供服务器验证。`ValidateAndTrackInAppPurchase`方法负责验证和记录购买事件。

#### ValidateAndTrackInAppPurchase方法

```c#
/// <summary>
/// API for server verification of in-app purchases
/// </summary>
/// <param name="productDefinition"></param>
public static void ValidateAndTrackInAppPurchase(Yodo1UAProductDefinition productDefinition);
```

> 注意
>
>* 验证成功后，`validateAndTrackInAppPurchase`将在AppsFlyer后台生成一个`af_purchase`应用内事件，自己发送此事件将导致重复事件报告。

#### 示例:验证应用内购买

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

#### 开启沙箱测试环境（Only iOS）

开启沙箱测试环境是为了方便测试`ValidateAndTrackInAppPurchase`（iOS平台）

```c#
/// <summary>
/// The useReceiptValidationSandbox method lets you can open sandbox test environment. Used to test payment verification.
/// It’s only work on iOS 
/// </summary>
/// <param name="isSanbox">true/false</param>
public static void UseReceiptValidationSandbox(bool isSanbox);
```

#### 示例:开启沙箱测试

```c#
Yodo1U3dUA.UseReceiptValidationSandbox(YES);                                     
```

> 注意
>
>* 在[苹果开发者](https://developer.apple.com)网站申请沙盒账户
>* 在苹果手机上 -> 设置 -> App Store 添加`沙盒账户`

### 事件的常量

#### 预定义的事件名称

预定义的事件名称常量遵循`Yodo1UAInAppEventType.PURCHASE`命名约定

| Event name       |  Unity constant name            |  
| ---------------- | ------------------------------- |
| "y_ua_purchase"  |  Yodo1UAInAppEventType.PURCHASE |

#### 预定义的事件参数

预定义的事件参数常量遵循`Yodo1UAInAppEventParam`命名约定

| Event parameter name   |  Unity constant name          |   Type    |
| ---------------------- | ------------------------------- | --------- |
| "y_ua_content_id"      |  CONTENT_ID                     |   String  |
| "y_ua_content_type"    |  CONTENT_TYPE                   |   String  |
| "y_ua_revenue"         |  REVENUE                        |   String  |
| "y_ua_currency"        |  CURRENCY                       |   String  |
| "y_ua_quantity"        |  QUANTITY                       |   String  |
| "y_ua_order_id"        |  ORDER_ID                       |   String  |

## 设置CustomId

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

### 示例:设置CustomId

```c#
Yodo1U3dUA.SetCustomUserID("<String>");                                     
```

* 针对于需要获取当前用户下多个账号的事件信息，例如：同一台设备下有多个账号

## 增加额外属性

```c#
/// <summary>
/// The setAdditionalData method lets you can add custom data to events' payload. It will appear in raw-data reports.
/// </summary>
/// <param name="customData">The event parameters Dictionary</param>
public static void SetAdditionalData(Dictionary<string, object> customData);
```

### 示例:增加额外属性配置

```c#
Yodo1U3dUA.SetAdditionalData("<Dictionary>");                                     
```

* 加强事件分析能力，同时也可以与其他第三方统计平台做数据关联

<!-- ## 深度链接(DeepLink) -->

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

## 已知问题

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
