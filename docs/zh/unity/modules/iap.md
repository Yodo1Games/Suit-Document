# 应用内购买

## 集成准备

在开始集成之前，需要准备商店密钥和IAP计费点。

### 商店密钥

在开始集成之前，您需要准备以下秘钥，并将其发送给Yodo1团队。

#### Apple商店

你可以从Apple后台获得共享密钥，`App Store Connect -> users and access -> shared key`，请点击[共享密钥](https://appstoreconnect.apple.com/access/shared-secret)。如下图所示：

<!-- markdownlint-disable -->
<figure>
    <img src="/zh/assets/images/ios_shared_key.png" width="800"/>
</figure>


#### Google商店

<font color=red>Google Pay要求: </font>[Google链接](https://developers.google.com/android-publisher/authorization?hl=en)
![image](https://user-images.githubusercontent.com/12006868/164370037-3ccd465c-b2ef-410b-9d09-118ef63a62cc.png)

#### 中国安卓商店

中国安卓商店需要相关密钥，Yodo1的运营团队将负责申请并配置到PA系统中

### 计费点

为了统一并更好的管理不同商店的IAP差异，SDK将使用excel来管理所有商品信息

**注意**

* 小米，华为，Google和Apple商店，计费点托管到他们服务器，根据渠道的商品ID，来获取商品信息，或者发起支付
* 其它商店，SDK将根据包体内的商品信息完成购买相关流程，并将详细的商品信息发送给渠道SDK/服务器，完成整体的购买流程。

#### 游戏计费点模版

你可以从这里[下载模版](/zh/assets/IapConfig_sample.xls)，商品结构如下：

<!-- markdownlint-disable -->
<figure>
    <img src="/zh/assets/images/unity_iap_product.png" width="800"/>
</figure>

| Key                | Data Type | Description                                                                  |
| ------------------ | --------- | ---------------------------------------------------------------------------- |
| ProductName        | string    | Product Name                                                                 |
| ChannelProductId   | string    | Product unique ID                                                            |
| ProductDescription | string    | Product description                                                          |
| PriceDisplay       | string    | Displayed price                                                              |
| ProductPrice       | string    | Product Price(CNY:元,USD:dollar)                                             |
| Currency           | string    | Currency type(eg:USD,CNY,JPY,EUR,HKD)                                        |
| ProductType        | string    | 1(0:not consumable, 1:consumable, 2:auto subscribe, 3:non-auto subscription) |
| PeriodUnit         | string    | Period Unit                                                                  |


#### 制作计费点文件

开发者需要添加所有游戏内的商品信息到上述excel中

* Apple或Google商店: 需要开发者将excel(表格改名为IapConfig.xls，扩展名保持不变)放置于`Yodo1/Suit/Resources/`目录下。
* 中国安卓商店: 并发送到Yodo1运营团队，运营团队将申请所有计费点，并配置在PA。

## 查询所有商品

一般在游戏实名认证结束后，或者登录成功后 进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。

``` c#
//该方法会请求所有商品信息，然后在回调中全部返回
Yodo1U3dPayment.RequestProductsInfo();
或
//该方法只会获取指定的商品的信息， 然后在回调中返回 string puoductID = "iap_few_coins";
Yodo1U3dPayment.ProductInfoWithProductId(puoductID);
    
设置回调：Yodo1U3dPayment.SetRequestProductsInfoDelegate (RequestProductsInfoDelegate);
    
void RequestProductsInfoDelegate(bool success, List<Yodo1U3dProductData> products){
     if (products != null) {
           foreach (Yodo1U3dProductData product in products) {
              Debug.Log ("productId:" + product.ProductId + ",PriceDisplay:" + product.PriceDisplay + ",PriceDisplay:" + product.PriceDisplay);
              Debug.Log ("MarketId:" + product.MarketId + ",Currency:" + product.Currency + "\n" + "Description" + product.Description + "\n");
           }
     }
}
```

## 查询已经拥有的订阅型商品

一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。备注：只适用于GooglePlay渠道，AppleStore渠道。

``` c#
Yodo1U3dPayment.SetQuerySubscriptionsDelegate(QuerySubscriptionsDelegate);
  
Yodo1U3dPayment.QuerySubsriptions();
```

## 查询已经拥有的消耗和非消耗商品

一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。备注：只适用于GooglePlay渠道。

``` c#
Yodo1U3dPayment.SetVerifyProductsInfoDelegate(VerifyPurchasesDelegate);
  
Yodo1U3dPayment.RequestGoogleCode();
```

## 恢复所有商品

一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。备注：只适用于GooglePlay渠道，AppleStore渠道。

``` c#
Yodo1U3dPayment.SetRestorePurchasesDelegate(RestorePurchasesDelegate);
  
Yodo1U3dPayment.restorePurchase();
```

## 支付

调用支付方法，对于需要用户登录才能拉起支付的时候会先自动调用登录。

``` c#
/**该方法会根据引入的渠道展示支付方式（支付宝，微信，渠道，运营商）
* productId  商品Id
* extra 透传值，可为null
* 建议方式
**/i
Yodo1U3dPayment.Purchase(string productId, string extra)
```

设置支付回调：

``` c#
Yodo1U3dPayment.SetPurchaseDelegate(PurchaseDelegate);
/**
* orderId,yodo1订单号
* channelOrderId , iOS订单号。（目前只在iOS中）
* productId，计费点文件的Id。
* extra，渠道支付返回的多余信息
* payType，支付类型
*/

void PurchaseDelegate (Yodo1U3dConstants.PayEvent status, string orderId, string productId, string extra, Yodo1U3dConstants.PayType payType) {
        Debug.Log ("status : " + status + ",productId : "+productId+", orderId : "+orderId+ ", extra : " + extra);
        if (status == Yodo1U3dConstants.PayEvent.PaySuccess) {

        }
}
```

Yodo1U3dConstants.PayEvent结构：

| Key名称         | 描述 |
| -------------- | --------- |
| PayCannel      |   取消支付  |
| PaySuccess     |   支付成功  |
| PayFail        |   支付失败  |
| PayVerifyFail  |  ops验证失败|
| PayCustomCode  |  支付账号异常|

Yodo1U3dConstants.PayType结构：

| Key名称         | 描述 |
| -------------- | ------------- |
| PayTypeWechat  |   微信         |
| PayTypeAlipay  |   支付宝       |
| PayTypeChannel | 支付渠道(ios为appstore)  |
| PayTypeSMS     |   短代               |

## 查询漏单

一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。
Yodo1U3dPayment.QueryLossOrder ();

设置回调：

``` c#
Yodo1U3dPayment.SetLossOrderIdPurchasesDelegate(LossOrderIdPurchasesDelegate);
  
void LossOrderIdPurchasesDelegate(bool success, List<Yodo1U3dProductData> products) {
    if (success && products != null) {
        foreach (Yodo1U3dProductData product in products) { Debug.Log ("productId:" + product.ProductId + ",PriceDisplay:" + product.PriceDisplay + ",PriceDisplay:" +     product.PriceDisplay); Debug.Log ("MarketId:" + product.MarketId + ",Currency:" + product.Currency + "\n" + "Description" + product.Description + "\n");
      }
   }
}
```

## 发货成功通知

购买成功后，调用发货成功通知接口。。功能是健全购买流程，作为丢单的统计依据。

``` c#
/**
 * 发送发货成功通知，可以不用在意回调处理。
 */
         Yodo1U3dPayment.sendGoods(orderId[]);
//可以不接入
  
         Yodo1U3dPayment.SetSendGoodsOverDelegate(SendGoodsOverDelegate);
```

## 发货失败通知

购买失败后，调用发货失败通知接口。。功能是健全购买流程，作为丢单的统计依据。

``` c#
/**
 * 发送发货失败通知，可以不用在意回调处理。
 */
         Yodo1U3dPayment.sendGoodsFail(orderId[]);
//可以不接入
          Yodo1U3dPayment.SetSendGoodsFailDelegate(SendGoodsFailDelegate);
```

## In-App Purchase

| ErrorCode | ErrorMessage                    |
| :-------- | :------------------------------ |
| 0         | ERROR\_CODE\_FAIELD             |
| 2         | ERROR\_CODE\_CANCEL             |
| 3         | ERROR\_CODE\_FAIELD\_VERIFY     |
| 205       | ERROR\_CODE\_USER\_ERROR        |
| 203       | ERROR\_CODE\_MISS\_ORDER        |
| 206       | ERROR\_CODE\_CREATE\_ORDER      |
| 207       | ERROR\_CODE\_NOT\_FIND\_LIBRARY |
| 209       | ERROR\_CODE\_NOT\_PERMISSSIONS  |
