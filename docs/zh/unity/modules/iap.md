# 支付IAP功能

在开始集成之前，您需要准备以下`共享密钥`，并将其发送给Yodo1团队。
<font color=red>Apple Pay要求: </font>[Apple链接](https://appstoreconnect.apple.com/access/shared-secret)

![image](https://user-images.githubusercontent.com/12006868/165882664-0f81c01a-5f03-40d4-8998-01eb94965fbf.png)
<font color=red>Google Pay要求: </font>[Google链接](https://developers.google.com/android-publisher/authorization?hl=en)
![image](https://user-images.githubusercontent.com/12006868/164370037-3ccd465c-b2ef-410b-9d09-118ef63a62cc.png)

## 计费点配置和计费点托管

游戏内商品的iap 商品计费点，在项目中单独配置放置。大多数渠道包，通过打到包内的 xml 配置，获取商品最新的价格、名称、描述等信息。其中小米，华为，googlePlay等渠道，使用计费点托管到渠道服务器，根据对应的productId，来获取商品信息，或者发起支付。

这里提供一个excel模板。[点击打开IapConfig_sample.xls](./../../assets/IapConfig_sample.xls)

接入方，收集统计游戏内所有的商品信息，填入excel表格中，上传反馈到 yodo1 系统即可。需要进行托管的计费点，由运营人员编辑各个渠道所需要的格式，上传开启。游戏开发一视同仁。

Suit Unity打包中，将excel表格改名为IapConfig，扩展名保持不变。放置于Yodo1/Suit/Resources/目录下。

产品结构如下：

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
