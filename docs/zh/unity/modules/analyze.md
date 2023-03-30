# 统计功能

## 设置账号 ID

在用户进行登录时，可调用 login 来设置用户的账号 ID，在设置完账号 ID 后，将会以账号 ID 作为身份识别 ID

``` c#
Yodo1U3dUser user = new Yodo1U3dUser();
user.playedId = "Your Player ID"
Yodo1U3dAnalytics.login(user);
```

## 发送自定义事件

在 SDK 初始化完成之后，您就可以调用 `customEvent` 来上传游戏自定义事件, 以用户购买某商品作为范例：

```c#
Dictionary<string, string> properties = new Dictionary<string, string>();
properties.Add("product_name", "商品名");

Yodo1U3dAnalytics.customEvent("product_buy", properties);
```

>* 事件的名称是`string`类型，只能以字母开头，可包含数字，字母和下划线“_”，长度最大为 50 个字符，对字母大小写不敏感。
>* 事件的属性是一个`Dictionary`对象，其中每个元素代表一个属性，Key的值为属性的名称，为`string`类型，规定只能以字母开头，包含数字，字母和下划线“_”，长度最大为 50 个字符，对字母大小写不敏感。

## UA(AppsFlyer)统计

在GooglePlay渠道，要求必须正确接入[Privacy](https://yodo1-suit.web.app/zh/unity/optional-modules/privacy/)，确保统计合规。

### IAP收入

有收入的购买事件，示例如下

```c#
string contentId = "Your SKU Item";
string revenue = "200";
string currency = "USD";
string quantity = "";
string receiptId = "";

Yodo1U3dAnalytics.eventAndValidateInAppPurchase_Apple(revenue, currency, quantity, contentId, receiptId);
```

## 发送UA自定义事件

您可以调用 `customEventAppsflyer` 来上传游戏UA相关自定义事件, 以用户的任务作为示例：

```c#
Dictionary<string, string> properties = new Dictionary<string, string>();
properties.Add("mission_id", "xxxx");
properties.Add("mission_name", "yyyy");
properties.Add("mission_finish", "true");

Yodo1U3dAnalytics.customEventAppsflyer("mission", properties);
```


<!-- //Google Play支付校验。如果使用sdk内GooglePlay支付，则不需要手动调用。
Yodo1U3dAnalytics.validateInAppPurchase_GooglePlay(String publicKey, String signature, String purchaseData, String price, String currency);
//AppleStore支付校验
Yodo1U3dAnalytics.validateInAppPurchase_Apple(string productId, string price, string currency, string transactionId); -->

## 设置UA-Deeplink功能

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

## 设置UA-User invite attribution功能

您可以在editor编辑面板添加domain，domain必须与deeplink一致。（注意：域前面必须添加"applink:"前缀）

生成分享url

```c#
public static void generateInviteUrlWithLinkGenerator(Yodo1U3dAnalyticsUserGenerate generate);
```

>* 注意
>*  在获取到的url后面拼接`&af_force_deeplink=true`可以唤起手机上已经安装好的应用（Facebook分享中url被拦截，链接只会跳转到AppStore，拼接了`&af_force_deeplink=true`可以唤起应用）

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