# 统计功能

## 发送自定义事件

注意，很多特定统计是空实现，使用需要咨询。可尽可能使用自定义统计接口。

``` java
/**
 * 自定义事件上报,eg: [Guide_Frist_Jump, {"default":"1"}]
 *
 * @param event
 * @param jsonData eventParameters
 */
Yodo1U3dAnalytics.customEvent()
```

## 用户相关-特定事件

``` obj-c
//统计平台的用户登录。游戏自定义玩家属性值，来配置填充到统计sdk上。eg.accountId(clientId,user,playId)
Yodo1U3dAnalytics.login(Yodo1U3dUser user);

//Google Play支付校验。如果使用sdk内GooglePlay支付，则不需要手动调用。
Yodo1U3dAnalytics.validateInAppPurchase_GooglePlay(String publicKey, String signature, String purchaseData, String price, String currency);
//AppleStore支付校验
Yodo1U3dAnalytics.validateInAppPurchase_Apple(string productId, string price, string currency, string transactionId);
//以自定义事件进行支付上报
Yodo1U3dAnalytics.eventAndValidateInAppPurchase_Apple(string revenue, string currency, string quantity, string contentId, string receiptId);
```

## 特定渠道事件统计

说明：当游戏应用不执行suit内置登录时，请使用initWithConfig进行初始化，并设置appsflyerCustomUserID值为用户或者设备唯一id。（可以获取使用deviceId）

``` java
Yodo1U3dAnalytics.customEventAppsflyer();
```