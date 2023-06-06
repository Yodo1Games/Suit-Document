# 统计功能

>* 当从Suit 6.2.1 及以下版本升级到6.3.0时，请先查看[升级引导](/zh/unity/analyze-upgrade-guide)。

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

当你开始集成应用内事件时，请先下载[EventConfig.xls](/zh/assets/EventConfig.xls)文件，填入你需要的事件名称和token(Token由UA团队提供)，并将其放置在`Assets/Yodo1/Suit/Resources`目录下。

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

1. 向UA团队申请IAP收入的事件Token，并填写到EventConfig文件中。
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
            if(isSandbox)
            {
               iAPRevenue.Sandbox(true);
            }
            iAPRevenue.TransactionId = transactionID;
   #elif UNITY_ANDROID
            iAPRevenue.PublicKey = <google_public_key>;
            iAPRevenue.Signature = signature;
            iAPRevenue.PurchaseData = purchaseData;
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

当前无法从MAS SDK的标准集成方式中获取广告收入，所以需要使用[MAS广告收入组件](https://github.com/Yodo1Games/Yodo1-MAS-ROAS-Collection/tree/master/ROAS-Collection-Unity)获取广告收入，示例代码如下

```c#
using UnityEngine.Purchasing;

public class GameObject : MonoBehaviou
{
   void Start()
   {
      Yodo1ROASCollection.SetAdRevenueDelegate((string adPlatform, string adSource, string adFormat, string adUnitName, double revenue, string currency) => {
         Debug.LogFormat("{0} adPlatform:{1} adSource:{2} adFormat:{3} adUnitName:{4} revenue:{5} currency:{6}", Yodo1ROASCollection.TAG, adPlatform, adSource, adFormat, adUnitName, revenue, currency);
         // TODO You can track the data yourselves here. 
         Yodo1U3dAdRevenue adRevenue = new Yodo1U3dAdRevenue();
         if (adPlatform.Contains("applovin")) {
         adRevenue.Source = Yodo1U3dAdRevenue.Source_Applovin_MAX;
         } else if (adPlatform.Contains("admob")) {
         adRevenue.Source = Yodo1U3dAdRevenue.Source_AdMob;
         } else if (adPlatform.Contains("ironsource")) {
         adRevenue.Source = Yodo1U3dAdRevenue.Source_IronSource;
         }
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