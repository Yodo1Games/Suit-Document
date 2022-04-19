# iOS Integrated Document

**Before the start**:
>* `iOS14` requires `Xcode` version to be `12+`, please be sure to upgrade your `Xcode` version to `12+`.
>*  `SDK` requires the minimum version of `iOS` to be `iOS10.0`
>*  The easiest way is to use `CocoaPods` (please use `1.10` and above), if you are new to `CocoaPods`, please refer to its [official documentation](https://guides.cocoapods.org/using/using -cocoapods), learn how to create and use a `Podfile`

## Integration steps
### 1. Add `iOS SDK` to the project
#### 1.1 Create `Podfile` file</br>
Create a `Podfile` file in the project root directory
```ruby
touch Podfile
```

#### 1.2 Import the iOS SDK into the project</br>
Please open the project's `Podfile` file and add the following code to the application's target:

```ruby
source 'https://github.com/Yodo1Games/Yodo1Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1Suit/Yodo1_ConfigKey', '1.5.1.1'
pod 'Yodo1Suit/OpenSuit_AnalyticsAppsFlyer', '1.5.1.1'
pod 'Yodo1Suit/OpenSuit_AnalyticsUmeng', '1.5.1.1'
pod 'Yodo1Suit/Yodo1_UCenter', '1.5.1.1'

```

Execute the following command in `Terminal`:</br>
```ruby
pod install --repo-update
```

### 2. `Xcode` project configuration
#### 2.1 Set `Yodo1KeyInfo.plist` parameter
``` xml
<key>KeyConfig</key> 
<dict>  
    	<key>AppsFlyer_domain</key> 
    	<string>[AppsFlyer domain]</string> 
    	<key>ThinkingAppId</key> 
    	<string>[ThinkingData AppId]</string> 
    	<key>AppsFlyer_Schemes</key> 
    	<string>[AppsFlyer Schemes]</string> 
    	<key>ThinkingServerUrl</key> 
    	<string>[Thinking ServerUrl]</string> 
    	<key>AppsFlyer_Identifier</key> 
    	<string>[[AppsFlyer Identifier]</string> 
    	<key>SdkVersion</key> 
    	<string>1.5.1.1</string> 
    	<key>GameKey</key> 
    	<string>[Yodo1 GameKey]</string> 
    	<key>debugEnabled</key> 
    	<string>0</string> 
    	<key>RegionCode</key> 
    	<string>[Yodo1 RegionCode]</string> 
    	<key>UmengAnalytics</key> 
    	<string>[Umeng AppId]</string> 
    	<key>AppleAppId</key> 
    	<string>[Apple AppId]</string> 
    	<key>AppsFlyerDevKey</key> 
    	<string>[AppsFlyer DevKey]</string> 
</dict>
```
![](./../resource/ios_init_appkey.png)
#### 2.2 Set `iOS9 App Transport Security`
In `iOS9`, Apple added controls on `ATS`. To ensure uninterrupted support of statistics on all intermediary networks, you need to make the following settings in the `Info.plist` file:

* Add `NSAppTransportSecurity` of type `Dictionary`
* Add `NSAllowsArbitraryLoads` in `NSAppTransportSecurity`, type `Boolean`, value `YES`

You can also directly edit the plist source code (`Open As Source Code`) to achieve the same function, the example is as follows:
        
``` xml
<key>NSAppTransportSecurity</key> 
<dict> 
	<key>NSAppTransportSecurity</key> 
	<true/>
</dict>
```

#### 2.3 Disable `BitCode`
To ensure that all intermediary networks work properly, disable bitcode as shown in the image below:

<img src="./../resource/ios_bitcode.png" style="zoom:50%;" />

### 3. Compliance with the necessary legal framework (Privacy)
Please follow all legal frameworks that apply to your game and its users.

<font color=red>Important:</font> Failure to adhere to these frameworks may result in your game being rejected by the Apple Store and negatively impact your game monetization.
#### 3.1 Import header file `Yodo1Suit.h` `YD1AgePrivacyManager.h`
``` obj-c
#import "YodoSuit.h"
#import "YD1AgePrivacyManager.h"
```
#### 3.2 Set Privacy
``` obj-c
//CCPA Publishers may choose to display a "Do Not Sell My Personal Information" link.
//YES is age < limitAge.
[Yodo1Suit setDoNotSell:NO];

//COPPA To ensure COPPA, GDPR, and AppStore policy compliance, you should indicate whether a user is a child.
//YES, If the user is known to be in an age-restricted category (i.e., under the age of 13), false otherwise.
[Yodo1Suit setTagForUnderAgeOfConsent:NO];

//GDPR YES, If the user has consented, NO otherwise.
//YES is age >= limitAge
[Yodo1Suit setUserConsent:NO];
```

``` obj-c
/**
 *  If no other solution provides the protocol flag, the protocol flag is obtained by displaying the interaction through the SDK protocol.
 */
[YD1AgePrivacyManager dialogShowUserConsentWithGameAppKey:@"Your AppKey" channelCode:@"appstore" viewController:self block:^(BOOL accept, BOOL child, int age) {

 }];
```
### 4. Initialize SDK
#### 4.1 Import the header file `Yodo1Suit.h`
``` obj-c
#import "YodoSuit.h"
```

#### 4.2 Initialize in didFinishLaunchingWithOptions
``` obj-c
[YodoSuit initWithAppKey:@"Your AppKey"];
```

### 5. Data analysis (optional)
#### 5.1 Import the header file `Yodo1AnalyticsManager.h`
``` obj-c
#import "Yodo1AnalyticsManager.h"
```
#### 5.2 Report a custom event
``` obj-c
/**
 *  @param eventName  event id (required)
 *  @param eventData  event data (optional)
 */
- (void)eventAnalytics:(NSString*)eventName
             eventData:(NSDictionary*)eventData;
```

#### 5.3 AppsFlyer related events

``` obj-c
/**
 *  Custom events with appsflyer
 *  @param eventName  event id (required)
 *  @param eventData  event data (optional)
 */
- (void)eventAdAnalyticsWithName:(NSString *)eventName 
                       eventData:(NSDictionary *)eventData;
```

``` obj-c
/**
 *  AppsFlyer In-Apple Payment Verification and Event Statistics
 */
- (void)validateAndTrackInAppPurchase:(NSString*)productIdentifier
                                price:(NSString*)price
                             currency:(NSString*)currency
                        transactionId:(NSString*)transactionId;
```

``` obj-c
/**
 *  Subscribe to openURL(AppsFlyer-Deeplink])
 *
 *  @param application  	application in life cycle
 *  @param url				openurl in life cycle
 *  @param options			options in the life cycle
 */
- (void)SubApplication:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
```

``` obj-c
/**
 *  Subscribe to continueUserActivity(AppsFlyer-Deeplink])
 *
 *  @param application			application in life cycle
 *  @param userActivity			userActivity in the lifecycle
 *  @param restorationHandler	RestorationHandler in the life cycle
 */
- (void)SubApplication:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler;
```

### 6. In-App Purchase

#### 6.1 Prepare billing point `Yodo1ProductInfo.plist`
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
    	<key>ProductType(0:not consumable, 1:consumable, 2:auto subscribe, 3:non-auto subscription)</key> 
    	<string>product type()</string> 
    	<key>PeriodUnit</key> 
    	<string>Period Unit</string> 
</dict>
```
![](./../resource/ios_purchase_point.png)

#### 6.2 Import the header file `Yd1UCenterManager.h`
``` obj-c
#import "Yd1UCenterManager.h"
```
#### 6.3 Buy product
``` obj-c
/**
 * Buy product
 * extra is a dictionary json string @{@"channelUserid":@""} (optional)
 */
- (void)paymentWithUniformProductId:(NSString *)uniformProductId
                              extra:(NSString*)extra
                           callback:(PaymentCallback)callback;
```
#### 6.4 Restore purchases
```obj-c
/**
 *  Restore purchases
 */
- (void)restorePayment:(RestoreCallback)callback;
```
#### 6.5 Query missing orders

```obj-c
/**
 *  Query missing orders
 */
- (void)queryLossOrder:(LossOrderCallback)callback;
```
#### 6.6 Query subscription

```obj-c
/**
 *  Query subscription
 */
- (void)querySubscriptions:(BOOL)excludeOldTransactions
                  callback:(QuerySubscriptionCallback)callback;
```
#### 6.7 Get product information

```obj-c
/**
 *  Get information about a product
 */
- (void)productWithUniformProductId:(NSString*)uniformProductId
                           callback:(ProductsInfoCallback)callback;
``` 
```obj-c                        
/**
 *  Get information on all products
 */
- (void)products:(ProductsInfoCallback)callback;
```
### 7. In-App Purchase Send Goods Notifications
#### 7.1 Import the header file `Yd1UCenter.h`
``` obj-c
#import "Yd1UCenter.h"
```
#### 7.2 Send Goods
```obj-c
/**
 *  Send Goods Success
 */
- (void)sendGoodsOver:(NSString *)orderIds
             callback:(void (^)(BOOL success,NSString* error))callback;
```
```obj-c
/**
 *  Send Goods Failed
 */
- (void)sendGoodsOverForFault:(NSString *)orderIds
                     callback:(void (^)(BOOL success,NSString* error))callback;
```



