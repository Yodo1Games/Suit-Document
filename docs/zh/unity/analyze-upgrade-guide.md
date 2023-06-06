# 统计功能升级引导

## 主要变化

1. 新增 EventConfig.xls UA事件映射文件，用于管理 UA 事件名称和事件token的映射关系
   * UA团队：为所需的UA事件申请token，并填入此映射文件中后，发送这个文件给相关项目组的技术团队。
   * 技术团队：将文件放置在项目的`Assets/Yodo1/Suit/Resources`目录下，构建游戏包体进行测试。
2. 新增方法`TrackAdRevenue`，追踪广告收入。

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