# Android Integration

> Suit supports Android version 4.4.+ (Android API level: 19+) and above

## The Integration Steps

### 1. Open the project-level `build.gradle` and add the below code

```groovy
maven { url "https://nexus.yodo1.com/repository/maven-public/" }
```

### 2. Open the app-level `build.gradle` and add the below code
#### 2.1 Add the below Gradle dependencies

```groovy
//core
implementation 'com.yodo1.suit.pay:core:6.2.0.2'
implementation 'com.yodo1.suit.pay:core_bridge:6.1.15'
//GooglePlay Store
implementation 'com.yodo1.suit.pay:google:5.1.0.1'
//AF analytics
implementation 'com.yodo1.suit.analytics:appsflyer:6.10.1.1'
```

#### 2.2 Add `compileOptions` property to the `Android` section
```groovy
android {
	compileOptions {
		sourceCompatibility = 1.8
		targetCompatibility = 1.8
	} 
}
```

### 3. Add `MultiDex` property to the `defaultConfig` section

```groovy
defaultConfig {
    ...
    multiDexEnabled true
    ...
}
```

### 4. Support AndroidX

Add the following content to the `gradle.properties` file

```ruby
android.useAndroidX=true
android.enableJetifier=true
```

### 5. Add `SplashActivity` to `AndroidManifest.xml` as default LAUNCHER activity

```xml
<application >
    <activity
        android:name="com.yodo1.android.sdk.view.SplashActivity"
        android:configChanges="keyboardHidden|orientation|screenSize"
        android:exported="true"
        android:screenOrientation="portrait"
        android:theme="@style/Theme.AppCompat.Light.NoActionBar">
        <intent-filter>
            <action android:name="android.intent.action.MAIN" />
            <category android:name="android.intent.category.LAUNCHER" />
        </intent-filter>
    </activity>
</application>
```
**Note**: You need to change `android:screenOrientation` with respect to your app's or game's settings 

### 6. Implement the `Yodo1Application` lifecycle methods

There are two ways to implement lifecycle methods of `Yodo1Application`

* Change the `android:name` of the application in `AndroidManifest.xml` as below

	```xml
	<application
	        android:name="com.yodo1.android.sdk.Yodo1Application">
	```

* Or, this can be done in code as below

	```java
	import com.yodo1.android.sdk.Yodo1Application;
	
	public class AppApplication extends Yodo1Application {
	}
	```

### 7. Implement the `Yodo1Activity` lifecycle methods

App MainActivity should be an extension of Yodo1Activity. There are two ways to implement lifecycle methods of `Yodo1Activity`

* Inherit `Yodo1Activity` as below code

	```java
	import com.yodo1.android.sdk.Yodo1Activity;
	
	public class MainActivity extends Yodo1Activity {
	
	}
	```
* Or, implement lifecycle methods in your main activity

	```java
	@Override
	protected void onCreate(Bundle savedInstanceState) {
	    super.onCreate(savedInstanceState);
	    Yodo1BridgeUtils.gamesdk().onActivityCreate(this);
	    Yodo1BridgeUtils.onActivityCreated(this, savedInstanceState);
	}
	
	@Override
	protected void onStart() {
	    super.onStart();
	    Yodo1BridgeUtils.gamesdk().onActivityStart(this);
	    Yodo1BridgeUtils.onActivityStarted(this);
	}
	
	@Override
	protected void onResume() {
	    super.onResume();
	    Yodo1BridgeUtils.gamesdk().onActivityResume(this);
	    Yodo1BridgeUtils.onActivityResumed(this);
	}
	
	@Override
	protected void onRestart() {
	    super.onRestart();
	    Yodo1BridgeUtils.gamesdk().onActivityRestart(this);
	    Yodo1BridgeUtils.onActivityRestart(this);
	}
	
	@Override
	public void onConfigurationChanged(Configuration newConfig) {
	    super.onConfigurationChanged(newConfig);
	    Yodo1BridgeUtils.gamesdk().onConfigurationChanged(this, newConfig);
	    Yodo1BridgeUtils.onActivityConfigurationChanged(this, newConfig);
	}
	
	@Override
	protected void onPause() {
	    super.onPause();
	    Yodo1BridgeUtils.gamesdk().onActivityPause(this);
	    Yodo1BridgeUtils.onActivityPause(this);
	}
	
	@Override
	protected void onStop() {
	    super.onStop();
	    Yodo1BridgeUtils.gamesdk().onActivityStop(this);
	    Yodo1BridgeUtils.onActivityStopped(this);
	}
	
	@Override
	protected void onDestroy() {
	    super.onDestroy();
	    Yodo1BridgeUtils.gamesdk().onActivityDestroy(this);
	    Yodo1BridgeUtils.onActivityDestroyed(this);
	}
	
	@Override
	protected void onNewIntent(Intent intent) {
	    super.onNewIntent(intent);
	    Yodo1BridgeUtils.gamesdk().onActivityNewIntent(this, intent);
	    Yodo1BridgeUtils.onActivityNewIntent(this, intent);
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	    super.onActivityResult(requestCode, resultCode, data);
	    Yodo1BridgeUtils.gamesdk().onActivityResult(this, requestCode, resultCode, data);
	    Yodo1BridgeUtils.onActivityResult(this, requestCode, resultCode, data);
	}
	
	@Override
	public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
	    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
	    Yodo1BridgeUtils.gamesdk().onActivityRequestPermissionsResult(this, requestCode, permissions, grantResults);
	    Yodo1BridgeUtils.onActivityRequestPermissionsResult(this, requestCode, permissions, grantResults);
	}
	
	@Override
	public void onSaveInstanceState(Bundle outState, PersistableBundle outPersistentState) {
	    super.onSaveInstanceState(outState, outPersistentState);
	    Yodo1BridgeUtils.gamesdk().onSaveInstanceState(this, outState, outPersistentState);
	    Yodo1BridgeUtils.onActivitySaveInstanceState(this, outState);
	}
	
	@Override
	public void onBackPressed() {
	    super.onBackPressed();
	    Yodo1BridgeUtils.gamesdk().onBackPressed(this);
	    Yodo1BridgeUtils.onActivityBackPress(this);
	}
	```

### 8. Setting up the game configuration

Create a `yodo1_games_config.properties` file in `src/main/res/raw` folder, and then set up your game configuration as below

```properties
# The main Activity of the game, e.g. com.yodo1.demo.MainActivity
mainClassName=Your MainActivity

# The screenOrientation of the game, portrait or landscape
thisProjectOrient=portrait

# Whether the Yodo1 logo in the splash screen needs to be enabled
isshow_yodo1_logo=false

# offline or online
yodo1_sdk_mode=offline
Yodo1SDKType=yodo1_global
Yodo1SDKVersion=1.5.0
CHANNEL_CODE_PUBLISH=GooglePlay
CHANNEL_CODE=GooglePlay
sdk_code=GooglePlay

#=========================== Analytics related KEYs ===========================
# Thinking Data
dmp_key_thinkingdata_appId=Your_TD_AppId

# AppsFlyer
appsflyer_dev_key=Your_AF_DevKey
```

### 9. Initialize the SDK
Initialize the SDK in the `onCreate` method of `Activity`

```java
protected void onCreate() {
  super.onCreate();
  
  /**
  *	Initialize SDK with config
  * @param Activity Context
  * @param String JsonMaps
  *	@{"appKey","Yodo1AppId"}  :  String Yodo1AppId
  *	@{"appsflyerCustomUserID","uniqueId"} : must if no login call.
  */
	JSONObject initConfig = new JSONObject();
	try {
	    initConfig.put("appKey", "Your_AppId");
	    initConfig.put("appsflyerCustomUserID", YDeviceUtils.getDeviceId(this));
	} catch (JSONException e) {
	    e.printStackTrace();
	}
	Yodo1Game.initWithConfig(this, initConfig.toString());
}
```

### 10. ProGuard
If you're using ProGuard with the Suit SDK, add the following code to your ProGuard file (Android Studio: `proguard-rules.pro` or Eclipse: `proguard-project.txt`).

```
-ignorewarnings
-keeppackagenames com.yodo1.**
-keep class com.yodo1.** { *; }
```

## Account Integration(Optional)

### 1. Set up your Play Games Services app id

Add the below content to your AndroidManifest.xml file and set up your app id of Play Games Services

```xml
<meta-data
      android:name="com.google.android.gms.games.APP_ID"
      android:value="Your Google App Id" />
```

### 2. Set up the listener of account
```java
Yodo1UserCenter.setListener(new Yodo1AccountListener() {
    @Override
    public void onLogin(LoginType type, Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
        YLog.e(TAG + "onLogin, result = " + resultCode + ", errorCode = " + errorCode + ", type = " + type);
        if (resultCode == Yodo1ResultCallback.ResultCode.Success) {
            Toast.makeText(mContext, "Login Success", Toast.LENGTH_SHORT).show();
        } else if (resultCode == Yodo1ResultCallback.ResultCode.Failed) {
            Toast.makeText(mContext, "Login Failed", Toast.LENGTH_LONG).show();
        } else if (resultCode == Yodo1ResultCallback.ResultCode.Cancel) {
            Toast.makeText(mContext, "Login Canceled", Toast.LENGTH_LONG).show();
        }
    }

    @Override
    public void onSwitchAccount(LoginType type, Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
        YLog.i(TAG + "onSwitchAccount, result = " + resultCode + ", errorCode = " + errorCode + ", type = " + type);
    }

    @Override
    public void onLogout(Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
        YLog.i(TAG + "onLogout, result = " + resultCode + ", errorCode = " + errorCode);
        Toast.makeText(mContext, "logout Success", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onRegist(Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
        YLog.i(TAG + "onRegist, result = " + resultCode + ", errorCode = " + errorCode);
    }
});
```

### 3. Login to user center

```java
/**
 * The login method of user center
 *
 * @param activity Activity
 */
Yodo1UserCenter.login(activity);
```

**Note**: Please make sure you're using the same keystore as when you publish the Play store when you need to test it.

### 4. Check the login status
```java
/**
 * Whether the user logged in to the user center.
 *
 * @return true, If the user logged in the user center, false otherwise.
 */
boolean isLogin = Yodo1UserCenter.isLogin()
```

### 5. Logout user center

```java
/**
 * The logout method of user center
 *
 * @param activity Activity
 */
Yodo1UserCenter.logout(activity);
```

## In-App Purchase Integration

**Note**: Please skip this step if in-app purchases integration is not needed.

### Requirements

You need to prepare the below KEYs before you start integration In-App purchase integration

* google_publish_key - You can find out it like this
![image](https://user-images.githubusercontent.com/12006868/164370037-3ccd465c-b2ef-410b-9d09-118ef63a62cc.png)

* Relevant KEYs required by the service (clientID, clientSecret, refreshToken), you can get these KEYs follow up [here](https://developers.google.com/android-publisher/authorization?hl=en), and send these KEYs to Yodo1 Team.

## 1. Create a `yodo1_games_config.properties` file in `src/main/res/raw` folder, and then set up your game configuration as below

```properties
#=========================== Google Play related KEYs ===========================
# Google Play Licensing, Base64-encoded RSA public key to include in your app binary. Remove any spaces.
google_publish_key=Your_Google_Licensing
```

### 2. Set up the SKUs of game

* Create a `yodo1_payinfo.xml` file in `src/main/assets/` folder, and then add your in-app purchase SKU items to the file

```xml
<?xml version="1.0" encoding="UTF-8"?>
<products>
	<product coin="3000" currency="CNY" fidGooglePlay="com.yodo1.stampede.offer1" isRepeated="1" priceDisplay="$1.99" productDesc="LuxuryTourSale" productId="iap_few_coins" productName="LuxuryTourSale" productPrice="0.01" />

</products>
```

The product structure is as follows

| Key           | Data Type | Description                                                                     |
| :------------ | :-------- | :------------------------------------------------------------------------------ |
| productId     | STRING    | Product unique ID                                                               |
| productName   | STRING    | Product Name                                                                    |
| productDesc   | STRING    | Product description                                                             |
| productPrice  | STRING    | Product Price(CNY:元,USD:dollar)                                                |
| currency      | STRING    | Currency type(eg:USD,CNY,JPY,EUR,HKD)                                           |
| priceDisplay  | STRING    | Displayed currency price                                                        |
| isRepeated    | STRING    | Product type.(SKU type, "1": Consumable, "0":non-Consumable, "2": Subscription) |
| coin          | STRING    | Equivalent game currency                                                        |
| fidGooglePlay | STRING    | SKU code of Google play store                                                   |

### 3. Set the listener method

```java
Yodo1Purchase.init(new Yodo1PurchaseListener() {
    @Override
    public void purchased(int code, String orderId, ProductData productData, PayType payType) {
        String msg = "purchased, code = " + code + ", orderId = " + orderId;

        if (code == Yodo1PurchaseListener.ERROR_CODE_SUCCESS) {
            Log.d(TAG, "Purchase successfully and will send goods");
            Yodo1Purchase.sendGoods(new String[]{orderId});
        } else if (code == Yodo1PurchaseListener.ERROR_CODE_FAIELD) {
            Log.d(TAG, "Purchase failed");
        } else if (code == Yodo1PurchaseListener.ERROR_CODE_MISS_ORDER) {
            Log.d(TAG, "Purchase order missed");
        } else if (code == Yodo1PurchaseListener.ERROR_CODE_CANCEL) {
            Log.d(TAG, "Purchase canceled");
        }
    }

    @Override
    public void queryProductInfo(int code, List<ProductData> products) {
        int size = products == null ? 0 : products.size();
        String msg = "queryProductInfo, code = " + code + ", products.size = " + size + ", list:" + products;
        YLog.e(TAG + msg);
        if (products != null) {
            for (int i = 0; i < products.size(); i++) {
                ProductData product = products.get(i);
                YLog.i(TAG + "queryProductInfo, index: " + i + ", product info: [" + product.toString() + "]");
            }
        }
    }

    @Override
    public void queryMissOrder(int code, List<ProductData> products) {
        int size = products == null ? 0 : products.size();
        String msg = "queryMissOrder, code = " + code + ", products.size = " + size;
        YLog.e(TAG + msg);
        if (products != null) {
            for (int i = 0; i < products.size(); i++) {
                ProductData product = products.get(i);
                YLog.e(TAG + "queryMissOrder, index: " + i + ", product info: [" + product.toString() + "]");
            }
        }
    }

    @Override
    public void restorePurchased(int code, List<ProductData> products) {
        int size = products == null ? 0 : products.size();
        String msg = "restorePurchased, code = " + code + ", products.size = " + size;
        YLog.e(TAG + msg);
        if (products != null) {
            for (int i = 0; i < products.size(); i++) {
                ProductData product = products.get(i);
                YLog.i(TAG + "restorePurchased, index: " + i + ", product info: [" + product.toString() + "]");
            }
        }
    }

    @Override
    public void inAppVerifyPurchased(int code, List<ProductData> products) {

    }

    @Override
    public void querySubscriptions(int code, long serverTime, List<ProductData> subscriptions) {

    }

    @Override
    public void sendGoods(int code, String message) {
    	 Log.d(TAG, "sendGoods code:" + code + " message:" + message);
    }

    @Override
    public void sendGoodsFail(int code, String message) {
    	 Log.d(TAG, "sendGoods code:" + code + " message:" + message);
        YToastUtils.showToast(mContext, "sendGoodsFail  Code:" + code + " message:" + message);
    }
});      
```

### 4. Purchase product

Launch the cashier for payment; the purchased result can be accessed using the method `purchased ` of listener `Yodo1PurchaseListener`.

```java
/**
* Purchase product with product id
*
* @param activity  Activity
* @param productId The product id of will be purchased
*/
Yodo1Purchase.pay(activity, productid);
```

### 5. Restore purchased products


```java
/**
 * Restore purchased non-consumable products
 * Note: this method works in the Google store only
 *
 * @param activity Activity
 */
Yodo1Purchase.restoreProduct(activity);
```

### 6. Query products information

The products information can be retrieved using the method `queryProductInfo ` of listener `Yodo1PurchaseListener`.In order to update the latest product information such as ProductName, price description etc by channel config of yodo1_payinfo.xml.

```java
/**
 * Query all products information
 *
 * @param activity Activity
 */
Yodo1Purchase.queryProducts(activity);
```

### 7. Query order information of missed orders

The game may lose orders due to various reasons, and call this method to replenish orders. The missing orders can be listened using the method `queryMissOrder` of listener `Yodo1PurchaseListener`.

```java
/**
 * Query all orders information of missed
 *
 * @param activity Activity
 */
Yodo1Purchase.queryMissOrder(activity);
```

### 8. Query subscribed items information

The method is to get the subscribed items information and to update the latest time and terms of the subscribed items. The information can be accessed using the method `querySubscriptions` of listener `Yodo1PurchaseListener`.

```java
/**
 * Query subscription products information
 * Note: this method works in the Google store only
 *
 * @param activity Activity
 */
Yodo1Purchase.querySubscriptions(activity);
```

### 9. Send goods successfully

Send notification of purchase success to payment server of Yodo1, this method will be called when the item has been purchased and distributed to the player successfully.

```java
/**
 * This method will be called when the item has been purchased and distributed to the player successfully.
 * This method must be called to notify the Yodo1-OPS to change the order status
 *
 * @param orders Purchased orders
 */
Yodo1Purchase.sendGoods(orders);
```

### 10. Send goods failed

Send notification of purchase failed to payment server of Yodo1, this method will be called when the item purchased has been failed.

```java
/**
 * This method will be called when the item has been purchased and distributed to the player successfully.
 * This method must be called to notify the Yodo1-OPS to change the order status
 *
 * @param orders Purchased orders
 */
Yodo1Purchase.sendGoods(orders);
```

## Analytics Integration

### 1. Report event

`Yodo1Analytics.onCustomEvent` can be used to report events. The name of the event should be of type `String` and can only begin with a letter. It can contain numbers, letters and an underscore "_". The maximum length is 50 characters and is not sensitive to letter case.

```java
Yodo1Analytics.onCustomEvent(context, eventName);
```

```java
String eventName = "test";
Map<String,Object> eventParams = new HashMap();
Yodo1Analytics.onCustomEvent(eventName,eventParams);
```

```java
Map<String,Object> eventParams = new HashMap();
Yodo1Analytics.onCustomEventAppsflyer("eventName",eventParams);
```