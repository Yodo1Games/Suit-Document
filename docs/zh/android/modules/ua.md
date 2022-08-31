# UA功能

**集成准备**:

>* SDK要求API最小版本是19
>* 你可以通过`Gradle`下载SDK作为依赖项。
>* 你需要[Android Studio](https://developer.android.com/studio)，请查看这些指南。

## 安装SDK

### 1. 添加`Gradle`依赖

将以下代码添加到你的应用级`build.gradlefile`中:

```groovy
repositories {
 google()
 mavenCentral()
    ⋮
}

dependencies {
 implementation 'com.yodo1.ua:core:1.0.0'
 implementation 'com.yodo1.ua:appsflyer:6.8.0.0'
    ⋮
}
```

### 2. Android权限

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

### 3. 设置`Java 8`编译选项

如果你的项目没有使用Java 8+，在build.gradle中设置Java版本为8:

```groovy
android {
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}
```

## 集成SDK

### 初始化SDK

建议在全局的`Application`类/子类中初始化SDK。这是为了确保SDK可以在任何场景中启动(例如，深度链接)。

#### 1. 引入`Yodo1UA`

```java
import com.yodo1.ua.Yodo1UA;
```

#### 2. 初始化SDK

在全局应用程序onCreate中，使用以下参数调用`initialize`方法

```java
Yodo1UA.UAInitConfig initConfig = new Yodo1UA.UAInitConfig();
initConfig.appsFlyerDevKey = "<AF_DEV_KEY>";
Yodo1UA.initialize(this, initConfig);
```

* 第一个参数是Application Context.
* 第二个参数是初始化配置，注意：如果使用Yodo1默认Appsflyer Dev Key，可忽略该参数，SDK中已经集成它

### 示例代码

下面的例子演示了如何从Application类初始化和启动SDK。

```java
import android.app.Application;
import com.yodo1.ua.Yodo1UA;

public class Yodo1UAApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        // ...
        Yodo1UA.UAInitConfig initConfig = new Yodo1UA.UAInitConfig();
        initConfig.appsFlyerDevKey = "<AF_DEV_KEY>";
        Yodo1UA.initialize(this);
        // ...
    }
}
```

## 应用内事件

### 记录应用程序事件

SDK允许您记录应用程序上下文中发生的用户操作。这些通常被称为应用内事件。

#### trackEvent方法

logEvent方法允许您追踪应用程序内的事件，要访问`trackEvent`方法，导入`Yodo1UA`

```java
import com.yodo1.ua.Yodo1UA;
```

trackEvent 有3个参数

```java
void trackEvent(Context context, String eventName, Map<String, Object> eventValues)
```

* 第一个参数(context)是应用`Application/Activity`上下文
* 第二个参数(eventName)是应用内事件名称
* 第三个参数(eventValues)是事件参数`Map`

### 记录收入

你可以通过应用内部事件发送收益。使用`Yodo1UAInAppEventParam.REVENUE`事件参数，将收益包含在应用内部事件中。您可以用任何数值(正的或负的)填充它。收入值不应该包含逗号、分隔符、货币符号或文本。例如，收入事件应该类似于1234.56。

#### 示例:带有收益的购买事件

```java
Map<String, Object> eventValues = new HashMap<String, Object>();
eventValues.put(Yodo1UAInAppEventParam.CONTENT_ID, < ITEM_SKU >);
eventValues.put(Yodo1UAInAppEventParam.CONTENT_TYPE, < ITEM_TYPE >);
eventValues.put(Yodo1UAInAppEventParam.CURRENCY, "USD");
eventValues.put(Yodo1UAInAppEventParam.REVENUE, 200);
eventValues.put(Yodo1UAInAppEventParam.QUANTITY, 1);

Yodo1UA.trackEvent(this, Yodo1UAInAppEventType.PURCHASE, eventValues);
```

> 注意
>
>* 不要在收益值中添加货币符号
>* 货币代码应该是3个字符的ISO 4217代码

### 验证购买

SDK为应用内部购买提供服务器验证。`validateAndTrackInAppPurchase`方法负责验证和记录购买事件。

#### validateAndTrackInAppPurchase方法

validateAndTrackInAppPurchase 有6个参数

```java
validateAndTrackInAppPurchase(Context context, 
                               String publicKey, 
                               String signature, 
                               String purchaseData, 
                               String price, 
                               String currency)
```

* context: Application / Activity context
* publicKey: License Key obtained from the Google Play Console
* signature: data.INAPP_DATA_SIGNATURE from onActivityResult
* purchaseData: data.INAPP_PURCHASE_DATA from onActivityResult
* price: Purchase price, should be derived from skuDetails.getStringArrayList("DETAILS_LIST")
* currency: Purchase currency, should be derived from skuDetails.getStringArrayList("DETAILS_LIST")

> 注意
>
>* 验证成功后，`validateAndTrackInAppPurchase`将在AppsFlyer后台生成一个`af_purchase`应用内事件，自己发送此事件将导致重复事件报告。

#### 示例:验证应用内购买

```java
// Purchase object is returned by Google API in onPurchasesUpdated() callback
private void handlePurchase(Purchase purchase) {
    Log.d(LOG_TAG, "Purchase successful!");
    Yodo1UA.validateAndTrackInAppPurchase(getApplicationContext(),
                                         PUBLIC_KEY,
                                         purchase.getSignature(),
                                         purchase.getOriginalJson(),
                                         "10",
                                         "USD");
}
```

### 事件的常量

#### 预定义的事件名称

要使用以下常量，导入`Yodo1UAInAppEventType`:

```java
import com.yodo1.ua.constants.Yodo1UAInAppEventType;
```

预定义的事件名称常量遵循`Yodo1UAInAppEventType.EVENT_NAME`命名约定

| Event name       |  Android constant name          |  
| ---------------- | ------------------------------- |
| "y_ua_purchase"  |  Yodo1UAInAppEventType.PURCHASE |

#### 预定义的事件参数

要使用以下常量，导入`Yodo1UAInAppEventParam`

```java
import com.yodo1.ua.constants.Yodo1UAInAppEventParam;
```

预定义的事件参数常量遵循`Yodo1UAInAppEventParam.PARAMETER_NAME`命名约定

| Event parameter name   |  Android constant name          |   Type    ｜
| ---------------------- | ------------------------------- | --------- ｜
| "y_ua_content_id"      |  CONTENT_ID                     |   String  ｜
| "y_ua_content_type"    |  CONTENT_TYPE                   |   String  ｜
| "y_ua_revenue"         |  REVENUE                        |   float   ｜
| "y_ua_currency"        |  CURRENCY                       |   String  ｜
| "y_ua_quantity"        |  QUANTITY                       |   int     ｜
| "y_ua_order_id"        |  ORDER_ID                       |   String  ｜

## 深度链接(DeepLink)
