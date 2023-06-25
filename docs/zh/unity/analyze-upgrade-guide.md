# 统计功能升级引导

## 升级步骤

1. 下载最新的[Suit Unity插件](./integration.md)并导入到游戏工程内。
2. 向UA团队申请Adjust的AppToken并将其配置在iOS配置中
3. 添加 yodo1\_ua\_events.xls UA事件映射文件，此文件用于管理 UA 事件名称和事件token的映射关系
   * UA团队：为所需的UA事件申请token，并填入此映射文件中后，发送这个文件给相关项目组的技术团队。
   * 技术团队：将文件放置在项目的`Assets/Yodo1/Suit/Resources`目录下，构建游戏包体进行测试。
4. 修改追踪事件的方法，`customEvent`修改为`TrackEvent`
5. 修改追踪UA事件的方法，`customEventAppsflyer`修改为`TrackUAEvent`
6. 修改追踪IAP收入的方法，`eventAndValidateInAppPurchase_Apple`, `eventAndValidateInAppPurchase_Google`, 和`validateInAppPurchase_Apple` 修改为 `TrackIAPRevenue`
7. 追踪广告收入，使用`TrackAdRevenue`来追踪广告收入

请点[这里](/zh/unity/modules/analyze)查看集成文档。

## SDK方法参考

| Suit v6.2.1                                                                                                                  | Suit v6.3.0                                                           |
|------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| customEvent(string eventName, Dictionary<string, string> properties)                                                         | TrackEvent(string eventName, Dictionary<string, string> properties)   |
| customEventAppsflyer(string eventName, Dictionary<string, string> properties)                                                | TrackUAEvent(string eventName, Dictionary<string, string> properties) |
| eventAndValidateInAppPurchase_Apple(revenue, currency, quantity, contentId, receiptId)                                       | TrackIAPRevenue(Yodo1U3dIAPRevenue iAPRevenue)                        |
| eventAndValidateInAppPurchase_Google(string publicKey, string signature, string purchaseData, string price, string currency) | TrackIAPRevenue(Yodo1U3dIAPRevenue iAPRevenue)                        |
| validateInAppPurchase_Apple(string productId, string price, string currency, string transactionId)                           | TrackIAPRevenue(Yodo1U3dIAPRevenue iAPRevenue)                        |
| -                                                                                                                            | TrackAdRevenue(Yodo1U3dAdRevenue adRevenue)                           |