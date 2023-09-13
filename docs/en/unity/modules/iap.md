# In-App Purchases

## Integration preparation

Before starting the integration, it is necessary to prepare the store key and IAP billing point.

### Store Key

Before starting the integration, you need to prepare the following key and send it to the Yodo1 team.

#### Apple Store

You can obtain a shared key from the Apple backend，`App Store Connect -> users and access -> shared key`，Click[ShareSecret](https://appstoreconnect.apple.com/access/shared-secret)。如下图所示：

<!-- markdownlint-disable -->
<figure>
    <img src="/zh/assets/images/ios_shared_key.png" width="800"/>
</figure>


#### Google Store

<font color=red>Google Pay Require: </font>[Google Link](https://developers.google.com/android-publisher/authorization?hl=en)
![image](https://user-images.githubusercontent.com/12006868/164370037-3ccd465c-b2ef-410b-9d09-118ef63a62cc.png)

#### China Android Store

The Chinese Android store requires relevant keys, and the Yodo1 operation team will be responsible for applying and configuring them into the PA system

### Billing point

In order to unify and better manage the IAP differences among different stores, the SDK will use Excel to manage all product information

**Notice**

* Xiaomi, Huawei, Google, Apple stores and so on host billing points to their servers to obtain product information or initiate payments based on the channel's product ID。
* For other stores, the SDK will complete the purchase process based on the product information inside the package, and send detailed product information to the channel SDK/server to complete the overall purchase process.

#### Game billing point template

Click[TemplateDownload](/zh/assets/IapConfig_sample.xls.zip)，The product structure is as follows：

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


#### Create billing point files

Developers need to add all in-game product information to the above Excel

* Apple or Google Store: Developers need to place Excel (table renamed IapConfig.xls, extension unchanged) in the 'Yodo1/Suit/Resources/' directory.
* Chinese Android store: and send it to the Yodo1 operation team, which will apply for all billing points and configure them in PA.

Functionality is sufficient

## Query all products

It is usually done after the real name authentication of the game is completed, or after successful login, or it can be requested to obtain product information in the game hall or before requesting it.

``` c#
//This method will request all product information and then return it all in the callback
Yodo1U3dPayment.RequestProductsInfo();
or
//This method only retrieves information about the specified product and returns it in the callback string puoductID = "iap_few_coins";
Yodo1U3dPayment.ProductInfoWithProductId(puoductID);
    
Set Callback：Yodo1U3dPayment.SetRequestProductsInfoDelegate (RequestProductsInfoDelegate);
    
void RequestProductsInfoDelegate(bool success, List<Yodo1U3dProductData> products){
     if (products != null) {
           foreach (Yodo1U3dProductData product in products) {
              Debug.Log ("productId:" + product.ProductId + ",PriceDisplay:" + product.PriceDisplay + ",PriceDisplay:" + product.PriceDisplay);
              Debug.Log ("MarketId:" + product.MarketId + ",Currency:" + product.Currency + "\n" + "Description" + product.Description + "\n");
           }
     }
}
```

## Query subscription products that you already have

Usually, it is done after the game's real name authentication is completed or the login is successful. It can also be requested to obtain product information in the game hall or before requesting it. Note: Only applicable to Google Play channels and Apple Store channels.

``` c#
Yodo1U3dPayment.SetQuerySubscriptionsDelegate(QuerySubscriptionsDelegate);
  
Yodo1U3dPayment.QuerySubsriptions();
```

## Query the already owned consumption and non consumption products

Usually, it is done after the game's real name authentication is completed or the login is successful. It can also be requested to obtain product information in the game hall or before requesting it. Note: Only applicable to Google Play channels.

``` c#
Yodo1U3dPayment.SetVerifyProductsInfoDelegate(VerifyPurchasesDelegate);
  
Yodo1U3dPayment.RequestGoogleCode();
```

## Restore all products

Usually, it is done after the game's real name authentication is completed or the login is successful. It can also be requested to obtain product information in the game hall or before requesting it. Note: Only applicable to Google Play channels and Apple Store channels.

``` c#
Yodo1U3dPayment.SetRestorePurchasesDelegate(RestorePurchasesDelegate);
  
Yodo1U3dPayment.restorePurchase();
```

## Purchase

Calling the payment method will automatically call the login when the user needs to log in to initiate payment.

``` c#
/**This method will display the payment method according to the introduced channel (Alipay, WeChat, channel, operator)
* productId  ProductId
* extra PassValue,Nullable
* Suggested approach
**/i
Yodo1U3dPayment.Purchase(string productId, string extra)
```

Set purchase callback：

``` c#
Yodo1U3dPayment.SetPurchaseDelegate(PurchaseDelegate);
/**
* orderId,yodo1 OrderId
* channelOrderId , iOS OrderId。（Only in iOS）
* productId，channel Product Id。
* extra，Excess information returned by channel payment
* payType，payType
*/

void PurchaseDelegate (Yodo1U3dConstants.PayEvent status, string orderId, string productId, string extra, Yodo1U3dConstants.PayType payType) {
        Debug.Log ("status : " + status + ",productId : "+productId+", orderId : "+orderId+ ", extra : " + extra);
        if (status == Yodo1U3dConstants.PayEvent.PaySuccess) {

        }
}
```

Yodo1U3dConstants.PayEvent Structure：

| KeyName       | Description           |
|---------------|-----------------------|
| PayCannel     | Pay Cancel            |
| PaySuccess    | Pay Success           |
| PayFail       | Pay Failure           |
| PayVerifyFail | Ops Verify Fail       |
| PayCustomCode | Pay Account Exception |

Yodo1U3dConstants.PayType Structure：

| KeyName        | Description                 |
|----------------|-----------------------------|
| PayTypeWechat  | Wechat                      |
| PayTypeAlipay  | Alipay                      |
| PayTypeChannel | PayChannel(ios is appstore) |
| PayTypeSMS     | PayBySms                    |

## Query missing orders

Usually, it is done after the game's real name authentication is completed or the login is successful. It can also be requested to obtain product information in the game hall or before requesting it.
Yodo1U3dPayment.QueryLossOrder ();

Set Callback：

``` c#
Yodo1U3dPayment.SetLossOrderIdPurchasesDelegate(LossOrderIdPurchasesDelegate);
  
void LossOrderIdPurchasesDelegate(bool success, List<Yodo1U3dProductData> products) {
    if (success && products != null) {
        foreach (Yodo1U3dProductData product in products) { Debug.Log ("productId:" + product.ProductId + ",PriceDisplay:" + product.PriceDisplay + ",PriceDisplay:" +     product.PriceDisplay); Debug.Log ("MarketId:" + product.MarketId + ",Currency:" + product.Currency + "\n" + "Description" + product.Description + "\n");
      }
   }
}
```

## Notification of successful shipment

Notification of successful shipment

``` c#
/**
 * After the purchase is successful, call the delivery success notification interface.. The function is to improve the purchasing process and serve as a statistical basis for lost orders.
 */
         Yodo1U3dPayment.sendGoods(orderId[]);
         
//Can be disconnected
         Yodo1U3dPayment.SetSendGoodsOverDelegate(SendGoodsOverDelegate);
```

## Delivery Failure Notification

After the purchase fails, call the delivery failure notification interface.. The function is to improve the purchasing process and serve as a statistical basis for lost orders.

``` c#
/**
 * Sending a delivery failure notification eliminates the need for callback processing.
 */
         Yodo1U3dPayment.sendGoodsFail(orderId[]);
//Can be disconnected
          Yodo1U3dPayment.SetSendGoodsFailDelegate(SendGoodsFailDelegate);
```

## ErrorCode

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
