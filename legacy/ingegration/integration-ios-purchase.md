# iOS Purchase

**开始前**:
>* ' iOS14 '要求' Xcode '版本为' 12+ '，请确保升级你的' Xcode '版本为' 12+ '。
>* ' SDK '要求' iOS '的最低版本为' iOS10.0 '
>* 最简单的方法是使用' CocoaPods '(请使用' 1.10 '及以上)，如果你是' CocoaPods '的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using -cocoapods)，学习如何创建和使用' Podfile '
>* 集成Purchase之前需要优先集成Analytics，请参考[Analytics集成文档](./yodo1-analytics-ios.md)

## 集成步骤
### 1. 添加`iOS SDK`到项目中
#### 1.1 <font color=red>要求: </font>
在开始集成之前，您需要准备以下`共享密钥`，并将其发送给Yodo1团队。链接https://appstoreconnect.apple.com/access/shared-secret

![image](https://user-images.githubusercontent.com/12006868/165882664-0f81c01a-5f03-40d4-8998-01eb94965fbf.png)


#### 1.2 创建 `Podfile` 文件</br>
在项目的根目录中创建`Podfile`文件

```ruby
touch Podfile
```

#### 1.3 引入iOS SDK到项目中</br>
请打开项目中的`Podfile`文件并且将下面的代码添加到文件中:

```ruby
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1Purchase', '6.1.3'
```

在`终端`中执行以下命令:</br>
```ruby
pod install --repo-update
```

### 2. `Xcode`工程配置

#### 2.1 准备计费点`Yodo1ProductInfo.plist`
``` xml
<key>custom name</key> 
<dict> 
    	<key>ProductName</key> 
    	<string>product name</string> 
    	<key>ChannelProductId</key> 
    	<string>product id</string> 
    	<key>ProductDescription</key> 
    	<string>product description</string> 
    	<key>PriceDisplay</key> 
    	<string>displayed price</string> 
    	<key>ProductPrice</key> 
    	<string>product price</string> 
    	<key>Currency</key> 
    	<string>currency</string> 
    	<key>ProductType</key> 
    	<string>1(0:not consumable, 1:consumable, 2:auto subscribe, 3:non-auto subscription)</string> 
    	<key>PeriodUnit</key> 
    	<string>Period Unit</string> 
</dict>
```
![](./../../resource/ios_purchase_point.png)

产品结构如下：
	
| Key                 | Data Type | Description |
| ------------------- | --------- | ----------- |
| ProductName         |   string  | Product Name|
| ChannelProductId    |   string  | Product unique ID |
| ProductDescription  |   string  | Product description |
| PriceDisplay        |   string  | Displayed price |
| ProductPrice        |   string  | Product Price(CNY:元,USD:dollar) |
| Currency            |   string  | Currency type(eg:USD,CNY,JPY,EUR,HKD) |
| ProductType         |   string  | 1(0:not consumable, 1:consumable, 2:auto subscribe, 3:non-auto subscription) |
| PeriodUnit          |   string  | Period Unit |

### 3. Purchase功能
#### 3.1 引入头文件`Yodo1PurchaseManager.h `
``` obj-c
#import "Yodo1PurchaseManager.h"
```
#### 3.2 api使用
``` obj-c
/**
 * 购买产品
 * extra 是字典json字符串 @{@"channelUserid":@""}
 */
- (void)paymentWithUniformProductId:(NSString *)uniformProductId
                              extra:(NSString*)extra
                           callback:(PaymentCallback)callback;

/**
 *  恢复购买
 */
- (void)restorePayment:(RestoreCallback)callback;

/**
 *  查询漏单
 */
- (void)queryLossOrder:(LossOrderCallback)callback;

/**
 *  查询订阅
 */
- (void)querySubscriptions:(BOOL)excludeOldTransactions
                  callback:(QuerySubscriptionCallback)callback;

/**
 *  获取产品信息
 */
- (void)productWithUniformProductId:(NSString*)uniformProductId
                           callback:(ProductsInfoCallback)callback;

/**
 *  获取所有产品信息
 */
- (void)products:(ProductsInfoCallback)callback;

/**
 *  获取促销订单
 */
- (void)fetchStorePromotionOrder:(FetchStorePromotionOrderCallback) callback;

/**
 *  获取促销活动订单可见性
 */
- (void)fetchStorePromotionVisibilityForProduct:(NSString*)uniformProductId
                                       callback:(FetchStorePromotionVisibilityCallback)callback;
/**
 *  更新促销活动订单
 */
- (void)updateStorePromotionOrder:(NSArray<NSString *> *)uniformProductIdArray
                         callback:(UpdateStorePromotionOrderCallback)callback;

/**
 *  更新促销活动可见性
 */
- (void)updateStorePromotionVisibility:(BOOL)visibility
                               product:(NSString*)uniformProductId
                              callback:(UpdateStorePromotionVisibilityCallback)callback;

/**
 *  准备继续购买促销
 */
- (void)readyToContinuePurchaseFromPromot:(PaymentCallback)callback;

/**
 *  取消促销产品购买
 */
- (void)cancelPromotion;

/**
 *  获取促销产品
 */
- (Product*)promotionProduct;

/**
 * 通知已发货成功
 */
- (void)sendGoodsOver:(NSString *)orderIds
             callback:(void (^)(BOOL success,NSString* error))callback;


/**
 * 通知已发货失败
 */
- (void)sendGoodsOverForFail:(NSString *)orderIds
                     callback:(void (^)(BOOL success,NSString* error))callback;

/**
 * 激活码/优惠券
 */
- (void)verifyActivationcode:(NSString *)code
                    callback:(void (^)(BOOL success,NSDictionary* _Nullable response,NSString* _Nullable error))callback;
```
## Error Codes

### Account 

| ErrorCode | ErrorMessage                    |
| :-------- | :----------------------------   |
| 0         | ACCOUNT\_ERROR\_FAILED          |
| 1         | ACCOUNT\_CANCEL                 |
| 2         | ACCOUNT\_ERROR\_ACCOUNT\_ERROR  |
| 3         | ACCOUNT\_ERROR\_PLUGIN\_ERROR   |
| 4         | ACCOUNT\_ERROR\_NETWORK\_ERROR  |
| 11        | ACCOUNT\_ERROR\_OPS\_ERROR      |
| 12        | ACCOUNT\_ERROR\_NO\_LOGIN       |
| 13        | ACCOUNT\_ERROR\_NO\_PERMISSIONS |

### In-App Purchase

| ErrorCode | ErrorMessage                    |
| :-------- | :-------------------------------|
| 0         | ERROR\_CODE\_FAIELD             |
| 2         | ERROR\_CODE\_CANCEL             |
| 3         | ERROR\_CODE\_FAIELD\_VERIFY     |
| 205       | ERROR\_CODE\_USER\_ERROR        |
| 203       | ERROR\_CODE\_MISS\_ORDER        |
| 206       | ERROR\_CODE\_CREATE\_ORDER      |
| 207       | ERROR\_CODE\_NOT\_FIND\_LIBRARY |
| 209       | ERROR\_CODE\_NOT\_PERMISSSIONS  |