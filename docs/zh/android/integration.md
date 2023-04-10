# Suit SDK

## 安装SDK

### 1. gradle配置

请在项目顶层build.gradle加入以下依赖：

```groovy
allprojects {
    repositories {
        //yodo1 maven repo
        maven { url "https://nexus.yodo1.com/repository/maven-public/" }
    }
}
```

请在顶层gradle.properties增加或者修改一下内容（如果确定用户项目不是Androidx结构可以不加入）：

```properties
android.useAndroidX=true
android.enableJetifier=true
```

### 2. build.gradle配置

请在应用module内build.gradle添加以下依赖：

```groovy
api 'com.yodo1.suit.pay:core:6.1.16.0'
api 'com.yodo1.suit.bridge:pay:6.1.15'
```

### 3. AndroidManifest.xml配置

#### 配置增加应用module下AndroidManifest.xml有一下内容

```xml
<!--请确认application节点name类为Yodo1Application。或者继承自Yodo1Application类。-->
<application
        android:name="com.yodo1.android.sdk.Yodo1Application">

<!--请确认应用使用SplashActivity启动。请修改确认screenOrientation和游戏应用对应，例如sensorLandscape或者sensorPortrait等-->
        <activity
            android:name="com.yodo1.android.sdk.view.SplashActivity"
            android:configChanges="keyboardHidden|orientation|screenSize"
            android:exported="true"
            android:screenOrientation="portrait"
            android:theme="@style/GameTheme">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
```

#### 主Activity修改

在下图配置mainClassName的类，需要继承 com.yodo1.android.sdk.Yodo1Activity。如果游戏应用主Activity不方便直接替换，可以根据以下代码，写到各个Activity生命周期中。

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

### 2. 资源配置

应用module下src/main/res/raw下，新建yodo1_games_config.properties文件。至少包含以下内容，并根据游戏应用实际情况修改可修改配置：

```properties
#！！！请修改到游戏应用主Activity包路径,eg:com.yodo1.demo.MainActivity
mainClassName=your app MainActivity
#闪屏界面是否显示logo
isshow_yodo1_logo=true

#修改单机游戏offline，或网络游戏online
yodo1_sdk_mode=offline
#修改游戏是横屏还是竖屏。portrait或者landscape,二选一。
thisProjectOrient=portrait
Yodo1SDKType=yodo1_global
Yodo1SDKVersion=6.1.16
CHANNEL_CODE_PUBLISH=GooglePlay
CHANNEL_CODE=GooglePlay
sdk_code=GooglePlay
```

添加计费点文件，如果不接入支付功能可忽略。新建或者修改文件src/main/assets/[yodo1_payinfo.xml](../assets/yodo1_payinfo.xml)文件。

```xml
<?xml version="1.0" encoding="UTF-8"?>
<products>
    <!--coin对应游戏币，currency货币类型，fidGooglePlay谷歌支付SKU计费点，productDesc道具描述，productId道具id，productName道具名称，productPrice道具价格(元)，isRepeated:1可重复购买商品;0不可重复购买商品;2订阅商品。-->
    <product coin="3000" currency="CNY" fidGooglePlay="com.yodo1.stampede.offer1" fidHW="test" fidLENOVO="133064" fidXIAOMI="com.yodo1.rodeo.opendoor" isRepeated="1" priceDisplay="$1.99"
productDesc="LuxuryTourSale" productId="iap_few_coins" productName="LuxuryTourSale" productPrice="0.01" />
<!--更多计费点继续添加到这里。(开发者可通过excel转csv,再通过文本工具批量修改)-->
</products>
```

这里提供一个excel模板。[点击打开IapConfig_sample.xls](../assets/IapConfig_sample.xls)

## 集成DK

### 1,初始化

开发者调用接口完成初始化。

```java
//regionCode can be null.
Yodo1Game.initSDK(this, "Yodo1GameKey", "Yodo1ReginCode");

//推荐使用的初始化方法
JSONObject jso = new JSONObject();
try {
    jso.put("appKey",Config.APP_KEY);
    jso.put("regionCode",Config.REGION_CODE);
    jso.put("appsflyerCustomUserID", YDeviceUtils.getDeviceId(this));
} catch (JSONException e) {
    e.printStackTrace();
}
Yodo1Game.initWithConfig(this,jso.toString());
```

### 2,渠道功能

在使用渠道功能前，需要在应用module添加渠道依赖，如下：

```groovy
//Google渠道添加
api 'com.yodo1.suit.pay:google:5.1.0.1'

//!!GP 同时yodo1_games_config.properties文件加入一下两个配置：
google_app_id=yourAppId on GooglePlay
google_publish_key=YourPublishKey on GooglePlay
```

#### 1. 用户相关Api

登录：

```java
    /**
    * 1,登录。
    */
Yodo1UserCenter.login(mContext);
    /**
    * 2,指定登录类型。LoginType:Channel,Device.
    */
String extString = "";
Yodo1UserCenter.login(mContext, LoginType.Channel, extString);
```

设置登录回调：

```java
    private Yodo1AccountListener listener = new Yodo1AccountListener() {
        @Override
        public void onLogin(LoginType type, Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
            YLog.e(TAG + "onLogin, result = " + resultCode + ", errorCode = " + errorCode + ", type = " + type);
            if (resultCode == Yodo1ResultCallback.ResultCode.Success) {
                Toast.makeText(mContext, "Login Success", Toast.LENGTH_SHORT).show();
                submitUser();
            } else if (resultCode == Yodo1ResultCallback.ResultCode.Failed) {
                Toast.makeText(mContext, "Login Failed", Toast.LENGTH_LONG).show();
            } else if (resultCode == Yodo1ResultCallback.ResultCode.Cancel) {
                Toast.makeText(mContext, "Login Canceled", Toast.LENGTH_LONG).show();
            }
        }

        @Override
        public void onSwitchAccount(LoginType type, Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
            YLog.i(TAG, "onSwitchAccount, result = " + resultCode + ", errorCode = " + errorCode + ", type = " + type);
        }

        @Override
        public void onLogout(Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
            YLog.i(TAG, "onLogout, result = " + resultCode + ", errorCode = " + errorCode);
        }

        @Override
        public void onRegist(Yodo1ResultCallback.ResultCode resultCode, int errorCode) {
            YLog.i(TAG, "onRegist, result = " + resultCode + ", errorCode = " + errorCode);
        }
    };
Yodo1UserCenter.setListener(listener);
```

登出

```java
YLog.e("isLogin" + Yodo1UserCenter.isLogin());
if (Yodo1UserCenter.isLogin()) {
    Yodo1UserCenter.logout(mContext);
}
//登出回调使用上面配置。onLogout()将会被调用。
```

#### 2. 支付相关Api

1，支付回调设置：

```java

    private Yodo1PurchaseListener payListener = new Yodo1PurchaseListener() {
        @Override
        public void purchased(int code, String orderId, ProductData productData, PayType payType) {
            String msg = "purchased, code = " + code + ", orderId = " + orderId;
            YLog.e(TAG + msg);

            if (code == Yodo1PurchaseListener.ERROR_CODE_SUCCESS) {
                Toast.makeText(mContext, "Pay Success,send Goods", Toast.LENGTH_SHORT).show();
                lastSuccessOrderId = orderId;
                Yodo1Purchase.sendGoods(new String[]{orderId});
            } else if (code == Yodo1PurchaseListener.ERROR_CODE_FAIELD) {
                Toast.makeText(mContext, "Pay Failed", Toast.LENGTH_LONG).show();
            } else if (code == Yodo1PurchaseListener.ERROR_CODE_MISS_ORDER) {
                Toast.makeText(mContext, "Pay Miss Order", Toast.LENGTH_LONG).show();
            } else if (code == Yodo1PurchaseListener.ERROR_CODE_CANCEL) {
                Toast.makeText(mContext, "Pay Canceled", Toast.LENGTH_LONG).show();
            } else {
                Toast.makeText(mContext, "Code:" + code + " orderId:" + orderId, Toast.LENGTH_LONG).show();
            }
        }

        @Override
        public void queryProductInfo(int code, List<ProductData> products) {
            int size = products == null ? 0 : products.size();
            String msg = "queryProductInfo, code = " + code + ", products.size = " + size + ", list:" + products;
            YLog.e(TAG + msg);
            Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
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
            Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
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
            Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
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
            YToastUtils.showToast(mContext, "sendGoods  Code:" + code + " message:" + message);
        }

        @Override
        public void sendGoodsFail(int code, String message) {
            YToastUtils.showToast(mContext, "sendGoodsFail  Code:" + code + " message:" + message);
        }
    };
//com.yodo1.android.sdk.open.Yodo1Purchase
Yodo1Purchase.init(payListener);
```

2,获取所有商品道具
开发者可以根据计费点文件，获取到道具商品列表，更新游戏内道具商品的名字价格描述等信息。通过回调queryProductInfo方法返回结果。

```java
Yodo1Purchase.queryProducts(mContext);
```

3,补单接口

游戏由于各种原因可能导致丢单，调用补单接口进行补单。通过回调queryMissOrder方法返回结果。

```java
Yodo1Purchase.queryMissOrder(mContext);
```

4，查询订阅商品

接口返回订阅商品，同时更新订阅商品的最新订阅时间和期限。通过回调querySubscriptions方法返回结果。

```java
Yodo1Purchase.querySubscriptions(mContext);
```

5，支付

道具支付接口，发起收银台进行支付。通过回调purchased方法返回购买结果。

```java
String productid = "";//道具productId
Yodo1Purchase.pay(mContext, productid);
```

6，发送支付成功通知
发送支付成功通知。在支付成功后调用，可以不用处理回调数据。传入支付成功返回的orderId。

```java
Yodo1Purchase.sendGoods(new String[]{lastSuccessOrderId});
```

7，发送支付失败通知。
是发送支付成功通知的逆过程。在支付失败后调用，可以不用处理回调数据。

```java
Yodo1Purchase.sendGoodsFail(new String[]{lastSuccessOrderId});
```

8，恢复购买接口
目前在googlePlay渠道支持。恢复之前购买过的道具。包含非消耗商品和没有消耗的消耗型商品。

```java
Yodo1Purchase.restoreProduct(mContext);
```

#### 3. 其他渠道Api

打开排行榜功能

```java
Yodo1UserCenter.openLeaderboards(mContext);
```

打开成就排行榜：

```java
Yodo1UserCenter.achievementsOpen(mContext);
```

更多游戏

```java
Yodo1Game.moreGame(mContext);
Yodo1Game.hasMoreGame();
```

### 统计功能

增加统计功能

```groovy
//AppsFlyer统计渠道
api 'com.yodo1.suit.analytics:appsflyer:6.10.1.1'

//!!AF 同时yodo1_games_config.properties文件加入一下两个配置：
appsflyer_dev_key=YourAF_DevKey
```

#### 1. 普通事件上报

```java
//上报事件名。
Yodo1Analytics.onCustomEvent(mContext,ets);
//上报事件名，并附属参数。
Map<String,Object> eventParams = new HashMap();
Yodo1Analytics.onCustomEvent(ets,eventParams);
```

#### 2. 特定事件上报

用户特定事件上传：

```java
//玩家动作相关
Yodo1Analytics.onMissionBegion(missionId);
Yodo1Analytics.onMissionCompleted(missionid);
Yodo1Analytics.onMissionFailed(missionid,cause);
Yodo1Analytics.onReward(gamecoin,trigger,reason);
Yodo1Analytics.onUseItem(itemid,useNum,gamecoin);
```

#### 3. 特定渠道事件上报

```java
Map<String,Object> eventParams = new HashMap();
Yodo1Analytics.onCustomEventAppsflyer("eventName",eventParams);
```

### 其他功能

#### 1. 用户隐私协议展示

在googlePlay等海外发行渠道中，必须要遵守隐私协议政策法案。当游戏开发者通过其他sdk提供的机制获取到协议标记可以通过set***接口设置到suit sdk中，不再需要调用展示选择界面。

```java
//CCPA.Publishers may choose to display a "Do Not Sell My Personal Information" link.
//true is age < limitAge.
Yodo1Game.setDoNotSell(false);
//COPPA To ensure COPPA, GDPR, and Google Play policy compliance, you should indicate whether a user is a child.
//true, If the user is known to be in an age-restricted category (i.e., under the age of 13), false otherwise.
Yodo1Game.setAgeRestrictedUser(false);
//GDPR.true, If the user has consented, false otherwise.
//true is age >= limitAge
Yodo1Game.setHasUserConsent(false);
```

如果没有其他方案提供协议标记，则通过sdk sdk协议展示交互来获取到协议标记。

```java
 Yodo1Game.showUserConsent(new Yodo1UserContentCallback() {
                    @Override
                    public void onResult(boolean open_switch, int age, int limitAge, String term, String term_version, String privacy, String privacy_version) {
                        YLog.e("showUserConsent onResult", "" + open_switch + age + limitAge + term);
                    }
                });
```

开发者可以通过showUserConsent接口回调来来获取标记值，也可以在有回调之后通过接口获取到标记值作为其他用途。

```java
Yodo1Game.getDoNotSell();
Yodo1Game.getUserConsent();
Yodo1Game.getTagForUnderAgeOfConsent();
```

#### 2. 优惠码/激活码验证

优惠码/激活码验证可以通过Yodo1后台批量生成激活码。玩家通过激活码验证，验证是否成功，返回游戏对应的奖励。

```java
Yodo1Game.verifyActivationcode(activiCode.getText().toString(), new Yodo1VerifyCodeCallback() {
            @Override
            public void onResult(Yodo1ResultCallback.ResultCode resultCode, int errorCode, String errorMsg, JSONObject reward, String rewardDes) {
                if (resultCode == Yodo1ResultCallback.ResultCode.Success) {
                    YLog.e("verifyActivationCode Success", errorCode + errorMsg + reward + rewardDes);
                } else {
                    YLog.e("verifyActivationCode No Success", errorCode + errorMsg + reward + rewardDes);
                }
            }
        });
```

#### 3. 获取在线参数

在线参数功能可以让游戏应用配置可以后台统一配置，灵活配置开关游戏等功能。

```java
//getValue by key. "" if noExist.
String key = "";
String value = YOnlineConfigUtils.getYodo1OnlineConfigParams(key);
        YOnlineConfigUtils.getConfigData("key",default);
//getValue by key. default if noExist.
T defalut = <>;
T value = YOnlineConfigUtils.getConfigData("key",default);
```

#### 4. 分享

```java
String path = "";
ChannelShareInfo info = new ChannelShareInfo();
info.setImgPath(path);
info.setIconName("sharelogo.png");
info.setQrShareLogo("sharelogo.png");
info.setQrText("长按二维码");
info.setNeedCompositeImg(true);//分享的图片是否需要合成图
info.setShareUrl("https://docs.yodo1.com/#/");
info.setIsSharePic(true);//分享的内容是否为单张图片
//snsType会通过位并运算，确定是否平台为true
/**
* Yodo1SNSTypeNone(-1),
* Yodo1SNSTypeTencentQQ(1 << 0), //朋友圈
* Yodo1SNSTypeWeixinMoments(1 << 1), //朋友圈
* Yodo1SNSTypeWeixinContacts(1 << 2),//聊天界面
* Yodo1SNSTypeSinaWeibo(1 << 3), //新浪微博
* Yodo1SNSTypeFacebook(1 << 4), //Facebook
* Yodo1SNSTypeTwitter(1 << 5), //Twitter
* Yodo1SNSTypeInstagram(1 << 6), //Instagram
* Yodo1SNSTypeAll(1 << 7); //所有平台分享
*/
info.setSnsType(snsType);
Yodo1Game.share(mContext, info, new Yodo1ShareCallback() {
    @Override
    public void onResult(int status, String msg, Yodo1SNSType type) {
        YLog.e("share onResult", status + msg);
    }
});
```

#### 5. 其他接口

```java
//应用内打开WebView Page.
HashMap<String, String> maps = new HashMap<>();
//maps.put("hideActionBar", "true");
//maps.put("isCloseTouchOutSide","true");
//maps.put("isDialog", "true");
Yodo1GameUtils.openWebPage("www.baidu.com", new JSONObject(maps).toString());

//获取隐私协议和用户协议
String terms = Yodo1GameUtils.getTermsLink();
String policy = Yodo1GameUtils.getPolicyLink();

//获取SDK版本
Yodo1Game.getSDKVersion();
//获取应用版本名称
Yodo1GameUtils.getVersionName();
//获取suit的设备唯一id
Yodo1GameUtils.getDeviceId(mContext)
```
