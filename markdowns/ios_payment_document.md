# ios_payment_document

## 1.Preparation before using the payment function
Setting Yodo1ProductInfo.plist billing point
![](./../../resource/ios_payment_1.png)

## 2.Use of payment function
# #import "Yd1UCenterManager.h"

/**
 *  Get uniformProductId by channelProductId
 */
- (NSString *)uniformProductIdWithChannelProductId:(NSString *)channelProductId;

/**
 *  Create order number and order, return order number
 */
- (void)createOrderIdWithUniformProductId:(NSString *)uniformProductId
                                    extra:(NSString*)extra
                                 callback:(void (^)(bool success,NSString * orderid,NSString* error))callback;

/**
 * Buy product
 * extra is a dictionary json string @{@"channelUserid":@""}
 */
- (void)paymentWithUniformProductId:(NSString *)uniformProductId
                              extra:(NSString*)extra
                           callback:(PaymentCallback)callback;

/**
 *  Restore purchases
 */
- (void)restorePayment:(RestoreCallback)callback;

/**
 *  Query for missing orders
 */
- (void)queryLossOrder:(LossOrderCallback)callback;

/**
 *  Query subscription
 */
- (void)querySubscriptions:(BOOL)excludeOldTransactions
                  callback:(QuerySubscriptionCallback)callback;

/**
 *  Get product information
 */
- (void)productWithUniformProductId:(NSString*)uniformProductId
                           callback:(ProductsInfoCallback)callback;

/**
 *  Get all product information
 */
- (void)products:(ProductsInfoCallback)callback;

/**
 *  Get promotional order
 */
- (void)fetchStorePromotionOrder:(FetchStorePromotionOrderCallback) callback;

/**
 *  Get promotion order visibility
 */
- (void)fetchStorePromotionVisibilityForProduct:(NSString*)uniformProductId
                                       callback:(FetchStorePromotionVisibilityCallback)callback;
/**
 *  Update promotion order
 */
- (void)updateStorePromotionOrder:(NSArray<NSString *> *)uniformProductIdArray
                         callback:(UpdateStorePromotionOrderCallback)callback;

/**
 *  Update promotion visibility
 */
- (void)updateStorePromotionVisibility:(BOOL)visibility
                               product:(NSString*)uniformProductId
                              callback:(UpdateStorePromotionVisibilityCallback)callback;

/**
 *  Ready to proceed with the purchase promotion
 */
- (void)readyToContinuePurchaseFromPromot:(PaymentCallback)callback;

/**
 *  Cancel purchase
 */
- (void)cancelPromotion;

/**
 *  Get promotional products
 */
- (Product*)promotionProduct;



# #import "Yd1UCenter.h"
/**
 *  device login
 *  @param playerId is playid
 */
- (void)deviceLoginWithPlayerId:(NSString *)playerId
                       callback:(void(^)(YD1User* _Nullable user, NSError* _Nullable  error))callback;

/**
 *  Create order number
 */
- (void)generateOrderId:(void (^)(NSString* _Nullable orderId,NSError* _Nullable error))callback;

/**
 *  Create order
 */
- (void)createOrder:(NSDictionary*) parameter
           callback:(void (^)(int error_code,NSString* error))callback;

/**
 *  App Store verify IAP
 */
- (void)verifyAppStoreIAPOrder:(YD1ItemInfo *)itemInfo
                      callback:(void (^)(BOOL verifySuccess,NSString* response,NSError* error))callback;

/**
 * Query subscription
 */
- (void)querySubscriptions:(YD1ItemInfo *)itemInfo
                  callback:(void (^)(BOOL success,NSString* _Nullable response,NSError* _Nullable error))callback;

/**
 * Notification has been shipped successfully
 */
- (void)sendGoodsOver:(NSString *)orderIds
             callback:(void (^)(BOOL success,NSString* error))callback;


/**
 * Notification has been shipped failed
 */
- (void)sendGoodsOverForFault:(NSString *)orderIds
                     callback:(void (^)(BOOL success,NSString* error))callback;

/**
 *  Report order has been paid successfully interface
 */
- (void)clientCallback:(YD1ItemInfo *)itemInfo callbakc:(void (^)(BOOL success,NSString* error))callback;

/**
 *  Reporting payment failure interface
 */
- (void)reportOrderStatus:(YD1ItemInfo *)itemInfo callbakc:(void (^)(BOOL success,NSString* error))callback;

/**
 *  The client notifies the server that the unity interface has been synchronized
 */
- (void)clientNotifyForSyncUnityStatus:(NSArray *)orderIds
                              callback:(void (^)(BOOL success,NSArray* notExistOrders,NSArray* notPayOrders,NSString* error))callback;

/**
 *  Query missing orders interface (stand-alone version)
 */
- (void)offlineMissorders:(YD1ItemInfo *)itemInfo
                 callback:(void (^)(BOOL success,NSArray* missorders,NSString* error))callback;

/**
 * Activation Code/Coupon
 */
- (void)verifyActivationcode:(NSString *)code
                    callback:(void (^)(BOOL success,NSDictionary* _Nullable response,NSString* _Nullable error))callback;
