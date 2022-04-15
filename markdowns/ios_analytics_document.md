# ios_analytics_document

## Use of statistical functions
# #import "Yodo1AnalyticsManager.h"

/**
 *  @param eventName  event id (required)
 *  @param eventData  event data (required)
 */
- (void)eventAnalytics:(NSString*)eventName
             eventData:(NSDictionary*)eventData;

/**
 *  use appsflyer custom event
 *  @param eventName  event id (required)
 *  @param eventData  event data (required)
 */
- (void)eventAdAnalyticsWithName:(NSString *)eventName 
                       eventData:(NSDictionary *)eventData;
/**
 *  Enter a level/mission
 *
 *  @param level level/mission
 */
- (void)startLevelAnalytics:(NSString*)level;

/**
 *  Complete levels/mission
 *
 *  @param level levels/mission
 */
- (void)finishLevelAnalytics:(NSString*)level;

/**
 *  Failed the level
 *
 *  @param level levels/mission
 *  @param cause reason for failure
 */
- (void)failLevelAnalytics:(NSString*)level failedCause:(NSString*)cause;

/**
 *  Set player level
 *
 *  @param level level
 */
- (void)userLevelIdAnalytics:(int)level;

/**
 *  Spend RMB to buy virtual currency request
 *
 *  @param orderId                  type:NSString
 *  @param iapId                    type:NSString
 *  @param currencyAmount           type:double
 *  @param currencyType             type:NSString  Reference Example: RMB CNY; U.S. dollar USD; Euro EUR, etc.
 *  @param virtualCurrencyAmount    type:double
 *  @param paymentType              type:NSString  Example: "Alipay" "Apple Official" "XX Payment SDK"
 */
- (void)chargeRequstAnalytics:(NSString*)orderId
                        iapId:(NSString*)iapId
               currencyAmount:(double)currencyAmount
                 currencyType:(NSString *)currencyType
        virtualCurrencyAmount:(double)virtualCurrencyAmount
                  paymentType:(NSString *)paymentType;

/**
 *  Spend RMB to buy virtual currency successfully
 *
 *  @param orderId    type:NSString
 *  @param source  payment channel   An integer from 1 to 99, where 1..20 are predefined meanings, and the rest 21-99 need to be set on the website
 Number    meaning
 1        App Store
 */
- (void)chargeSuccessAnalytics:(NSString *)orderId source:(int)source;

/**
 *  Get virtual coins in the game
 *
 *  @param virtualCurrencyAmount Amount of virtual currency         type:double
 *  @param reason                Reasons for giving away virtual coins    type:NSString
 *  @param source                reward channel    The value is between 1 and 10. "1" has been pre-defined as "system reward", 2~10 need to set the meaning on the website          type：int
 */
- (void)rewardAnalytics:(double)virtualCurrencyAmount reason:(NSString *)reason source:(int)source;

/**
 *  Virtual item purchase / use virtual currency to purchase props
 *
 *  @param item   props                  type:NSString
 *  @param number number of props        type:int
 *  @param price  Unit price of props    type:double
 */
- (void)purchaseAnalytics:(NSString *)item itemNumber:(int)number priceInVirtualCurrency:(double)price;

/**
 *   Virtual item consumption / Players use virtual currency to buy props
 *
 *  @param item   props name
 *  @param amount number of props
 *  @param price  Unit price of props
 */
- (void)useAnalytics:(NSString *)item amount:(int)amount price:(double)price;

/**
*
*  pragma mark- Umeng timing event
*
*/
- (void)beginEvent:(NSString *)eventId;
- (void)endEvent:(NSString *)eventId;

/**
*  pragma mark- DplusMobClick api
*/

/** Dplus add event
*  param eventName
*/
- (void)track:(NSString *)eventName;

/** Dplus add event
 @param eventName
 @param propertyKey
 @param propertyValue
 */
- (void)saveTrackWithEventName:(NSString *)eventName
                   propertyKey:(NSString *)propertyKey
                 propertyValue:(NSString *)propertyValue;

/** Dplus add event (overload)
 @param eventName 
 @param propertyKey 
 @param propertyValue 
 */
- (void)saveTrackWithEventName:(NSString *)eventName
                   propertyKey:(NSString *)propertyKey
              propertyIntValue:(int)propertyValue;

/** Dplus add event (overload)
 @param eventName 
 @param propertyKey 
 @param propertyValue
 */
- (void)saveTrackWithEventName:(NSString *)eventName
                   propertyKey:(NSString *)propertyKey
            propertyFloatValue:(float)propertyValue;

/** Dplus add event (overload)
 @param eventName 
 @param propertyKey 
 @param propertyValue
 */
- (void)saveTrackWithEventName:(NSString *)eventName
                   propertyKey:(NSString *)propertyKey
           propertyDoubleValue:(double)propertyValue;

/** Dplus add event:Save and add event attributes before submitting (one-time submission)
 @param eventName
 */
- (void)submitTrackWithEventName:(NSString *)eventName;

/**
 * Setting a property key-value pair will overwrite the key with the same name
 * Write the key-value specified by this function into the dplus special file; when the APP starts, it will automatically read all the key-values of the file, and automatically use the key-value as an attribute of all subsequent track events.
 */
- (void)registerSuperProperty:(NSDictionary *)property;

/**
 *
 * Delete the specified key-value from the dplus special file
 @param propertyName
 */
- (void)unregisterSuperProperty:(NSString *)propertyName;

/**
 *
 * Returns the value corresponding to the key in the dplus special file; if it does not exist, it returns null
 @param propertyName 
 @return NSString
 */
- (NSString *)getSuperProperty:(NSString *)propertyName;

/**
 * Returns the value corresponding to the key in the dplus special file; if it does not exist, it returns null
 */
- (NSDictionary *)getSuperProperties;

/**
 *Empty all key-values in the Dplus special file
 */
- (void)clearSuperProperties;

/**
 *  <AppsFlyer> In-app payment verification and event statistics
 */
- (void)validateAndTrackInAppPurchase:(NSString*)productIdentifier
                                price:(NSString*)price
                             currency:(NSString*)currency
                        transactionId:(NSString*)transactionId;

/**
 *   subscription openURL(AppsFlyer-Deeplink])
 *
 *  @param application      <in life cycle> application
 *  @param url              <in life cycle> openurl
 *  @param options          <in life cycle> options
 */
- (void)SubApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

/**
 *  subscription continueUserActivity(AppsFlyer-Deeplink])
 *
 *  @param application              <in life cycle>application
 *  @param userActivity             <in life cycle>userActivity
 *  @param restorationHandler       <in life cycle>restorationHandler
 */
- (void)SubApplication:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;
