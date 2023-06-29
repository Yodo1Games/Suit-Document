# 统计功能

>* 当从Suit 6.2.1 及以下版本升级到6.3.0及以上时，请先查看[升级引导](/zh/unity/analyze-upgrade-guide)。

## 设置账号 ID

在用户进行登录时，可调用 login 来设置用户的账号 ID，在设置完账号 ID 后，将会以账号 ID 作为身份识别 ID

``` c#
Yodo1U3dUser user = new Yodo1U3dUser();
user.playedId = "Your Player ID"
Yodo1U3dAnalytics.login(user);
```

## Thinking Data

### 发送自定义事件

在 SDK 初始化完成之后，您就可以调用 `TrackEvent` 来上传游戏自定义事件, 以用户的任务作为示例：

```c#
Dictionary<string, string> properties = new Dictionary<string, string>();
properties.Add("mission_id", "xxxx");
properties.Add("mission_name", "yyyy");
properties.Add("mission_finish", "true");

Yodo1U3dAnalytics.TrackEvent("mission", properties);
```

>* 事件的名称是`string`类型，只能以字母开头，可包含数字，字母和下划线“_”，长度最大为 50 个字符，对字母大小写不敏感。
>* 事件的属性是一个`Dictionary`对象，其中每个元素代表一个属性，Key的值为属性的名称，为`string`类型，规定只能以字母开头，包含数字，字母和下划线“_”，长度最大为 50 个字符，对字母大小写不敏感。

## UA(AppsFlyer和Adjust)

当前UA仅适用于Apple和Google商店，并在Google商店使用时，要求必须正确集成[用户隐私](/zh/unity/optional-modules/privacy/)，确保合规。

### 应用内事件

当你开始集成应用内事件时，请先下载[yodo1_ua_events.xls](/zh/assets/yodo1_ua_events.xls.zip)文件，填入你需要的事件名称和token(Token由UA团队提供)，并将其放置在`Assets/Yodo1/Suit/Resources`目录下。

#### 发送自定义事件

您可以调用 `TrackUAEvent` 来上传游戏UA相关自定义事件，以用户的任务作为示例：

```c#
Dictionary<string, string> properties = new Dictionary<string, string>();
properties.Add("mission_id", "xxxx");
properties.Add("mission_name", "yyyy");
properties.Add("mission_finish", "true");

Yodo1U3dAnalytics.TrackUAEvent("mission", properties);
```

#### 追踪IAP收入

1. 向UA团队申请IAP收入的事件Token，并填写到yodo1_ua_events文件中。
2. 当购买IAP成功后，调用`TrackIAPRevenue` 方法上报IAP收入。注意：如果你在使用Yodo1 Suit进行应用内购买，SDK将自动上报IAP收入

   ```c#
   Yodo1U3dAnalytics.TrackIAPRevenue(Yodo1U3dIAPRevenue  iAPRevenue);
   ```

   示例如下：

   ```c#
   using UnityEngine.Purchasing;

   public class GameObject : MonoBehaviour, IStoreListener
   {
     public static string kProductIDConsumable = "com.test.cons";

     void Start()
     {
         // TODO 初始化Suit SDK
     }

     public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs args)
     {
         var product = args.purchasedProduct;
         string prodID = args.purchasedProduct.definition.id
         string price = args.purchasedProduct.metadata.localizedPrice.ToString()
         string currency = args.purchasedProduct.metadata.isoCurrencyCode;

         string receipt = args.purchasedProduct.receipt;
         var recptToJSON = (Dictionary<string, object>)Yodo1JSONObject.Deserialize(product.receipt)
         var receiptPayload = (Dictionary<string, object>)Yodo1JSONObject.Deserialize((string)recptToJSON["Payload"]);
         var transactionID = product.transactionID;

         if (String.Equals(args.purchasedProduct.definition.id, kProductIDConsumable, StringComparison.Ordinal))
         {
            //TODO 追踪IAP收入
            Yodo1U3dIAPRevenue iAPRevenue = new Yodo1U3dIAPRevenue();
            iAPRevenue.ProductIdentifier = prodID;
            iAPRevenue.Revenue = price;
            iAPRevenue.Currency = currency;
   #if UNITY_IOS
            iAPRevenue.TransactionId = transactionID;
            iAPRevenue.ReceiptId = receipt;
   #elif UNITY_ANDROID
            iAPRevenue.PublicKey = <google_public_key>;
            iAPRevenue.Signature = (string)receiptPayload["signature"];.
            iAPRevenue.PurchaseData = (string)receiptPayload["json"];
   #endif
            Yodo1U3dAnalytics.TrackIAPRevenue(iAPRevenue);
         }

         return PurchaseProcessingResult.Complete;
     }
   }
   ```

#### 追踪广告收入

Suit SDK提供`TrackAdRevenue`方法来报告广告收入。

```c#
Yodo1U3dAdRevenue adRevenue = new Yodo1U3dAdRevenue();
adRevenue.Source = Yodo1U3dAdRevenue.Source_Applovin_MAX;
adRevenue.Revenue = 0.01;
adRevenue.Currency = "USD";
adRevenue.NetworkName = "admob";
adRevenue.UnitId = "";
adRevenue.PlacementId = "";
Yodo1U3dAnalytics.TrackAdRevenue(adRevenue);
```

当前无法从MAS SDK的标准集成方式中获取广告收入，所以需要使用[MAS广告收入组件](https://github.com/Yodo1Games/Yodo1-MAS-Ad-Revenue/blob/master/MAS-Ad-Revenue-Unity/README.md)获取广告收入，示例代码如下

```c#
using UnityEngine.Purchasing;

public class GameObject : MonoBehaviou
{
   void Start()
   {
      Yodo1MasAdRevenue.SetAdRevenueDelegate((string adPlatform, string adSource, string adFormat, string adUnitName, double revenue, string currency) => {
         Debug.LogFormat("{0} adPlatform:{1} adSource:{2} adFormat:{3} adUnitName:{4} revenue:{5} currency:{6}", Yodo1MasAdRevenue.TAG, adPlatform, adSource, adFormat, adUnitName, revenue, currency);
         // TODO You can track the data yourselves here. 

         Yodo1U3dAdRevenue adRevenue = new Yodo1U3dAdRevenue();
         adRevenue.Source = adPlatform.ToLower();
         adRevenue.Revenue = revenue;
         adRevenue.Currency = currency;
         adRevenue.NetworkName = adSource;
         adRevenue.UnitId = adUnitName;
         Yodo1U3dAnalytics.TrackAdRevenue(adRevenue);
      });
   }
}
```

### 深度链接

您可以在editor编辑面板添加deeplink的domain.（注意：域前面必须添加"applink:"前缀）

获取deeplink数据

```c#
public static string GetNativeRuntime(string key);
```

>* key = "appsflyer_deeplink"，获取deeplink数据
>* key = "appsflyer_id"，获取AF的用户id

重置deeplink数据

```c#
public static void SaveToNativeRuntime(string key, string valuepairs);
```

### 用户邀请

您可以在editor编辑面板添加domain，domain必须与deeplink一致。（注意：域前面必须添加"applink:"前缀）

生成分享url

```c#
public static void generateInviteUrlWithLinkGenerator(Yodo1U3dAnalyticsUserGenerate generate);
```

>* 注意
>* 在获取到的url后面拼接`&af_force_deeplink=true`可以唤起手机上已经安装好的应用（Facebook分享中url被拦截，链接只会跳转到AppStore，拼接了`&af_force_deeplink=true`可以唤起应用）

Yodo1U3dAnalyticsUserGenerate结构

```c#
private string targetView; //目标试图名称
private string promoCode; //促销代码
private string referrerId; //介绍人id
private string campaign; //活动名称
private string channel; //渠道
private string url; //分享的domain
```

上报”用户归因分享Link“事件

```c#
public static void logInviteAppsFlyerWithEventData(Dictionary<string, string> value = null);
```

<!-- ## UA测试流程 -->

## Adjust测试流程及数据查看⽅法

### SDK log 输出要求

⾸次 sdk 接⼊完成后，请选择sandbox并开启debug mode，方便集成检查测试

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/sandbox_and_debug_mode.png" width="700">
</figure>

检查没有问题后换成 production mode 上线

### 测试数据查看⽅法

#### 测试控制台查看⽅法

测试控制台是「实时」查询接⼝，可使⽤⼴告id进⾏查询当前安装信息，或清除安装记录

>* 注：Sandbox mode/Production mode数据均可使⽤测试控制台查询

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_1.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_2.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_3.png" width="700">
</figure>

* 安卓使⽤：gps_adid / oaid / adid 
* iOS使⽤：idfa / idfv / adid

>* 注：adid是adjust为每个设备⽣成的唯⼀id，只有在adjust sdk成功初始化上报adjust服务器才会返回该值
gps_adid（即google advertising id 也简称为gaid）和idfa是设备上唯⼀的⼴告id
>* adid格式示例： 12b3e453f674b51a9db517ba0f140612
>* gps_adid/oaid/idfa/idfv格式示例：12f34b56-32dc-4f8f-8725-499e8627df34

你可以通过 adjust insights 获取，示例如下

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/adjust_insights.png" width="700">
</figure>

查看测试结果

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_4.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_5.png" width="700">
</figure>

Adjust永久排重，即该设备记录到安装之后，⽆论是否卸载重装，我们将不会重新记录安装，也不会重新归因，因此同⼀个测试设备可以通过「清除设备」的⽅式重复测试。

>* 注：先在设备上卸载应⽤，再点击「清除设备」

#### 数据后台查看⽅法

打开「Sandbox模式」

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/data_background_1.png" width="700">
</figure>

点击编辑按钮，查看⾃定义事件

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/data_background_2.png" width="700">
</figure>

选择KPI进行可视化

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/data_background_3.png" width="700">
</figure>

⾃定义事件查询⽅法：选择「可交付数据KPI」选择「事件」，在event中搜索添加⽬标事件，点击「选择指标」，点击「确认」

### 渠道归因数据测试⽅法

跟踪链接测试⽅法：创建跟踪链接 — 拼接参数 — 点击跟踪链接 — 激活应⽤ — 查看测试控制台

已为ARBS，RODEO，TEW创建了测试归因渠道(Yodo1-Test-Channel)，其它游戏进行归因测试前，请按照如下步骤创建测试归因渠道(Yodo1-Test-Channel)。
<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/attribution_1.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/attribution_2.png" width="700">
</figure>

得到点击跟踪链接：https://app.adjust.com/l5tuaz

在点击跟踪链接前请拼接⼴告id：

* 假设安卓gps_adid为：12f34b56-32dc-4f8f-8725-499e8627df34
* 假设苹果idfa为：45f34b56-32dc-4f8f-8725-499e8627df67

得到安卓点击跟踪链接：https://app.adjust.com/l5tuaz?gps_adid=12f34b56-32dc-4f8f-8725-499e8627df34

得到苹果点击跟踪链接：https://app.adjust.com/l5tuaz?idfa=45f34b56-32dc-4f8f-8725-499e8627df67

在浏览器触发跟踪链接之后，本地安装产品⾄⼿机，打开应⽤，在测试控制台查询归因结果

>* 注：⼀些媒体⽆法在跟踪链接上加设备id，只要跳转google play，Adjust仍能通过referrer进⾏准确归因；