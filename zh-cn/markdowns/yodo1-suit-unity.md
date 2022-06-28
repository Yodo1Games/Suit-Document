# Unity OpenSuit

**介绍**:
>* OpenSuit SDK是为了解决游戏发行中，和渠道、商务层面的各种问题而制作，集成了用户、支付、统计、分享、隐私协议、激活码等功能。OpenSuit源于yodo1内部在使用的Suit作为基础，制作的游戏侧可单独打包运行上架的工具。借助yodo1平台便捷实现游戏发行和收益的工具。
>* 中国国内联运渠道很多，各个厂商定义的接口内容和数量不一(例如登录支付防沉迷统计退出等)，yodo1 suit sdk对各个厂商的sdk尽可能做了兼容适配和包装。各个厂商对必须接入的接口要求不一，同样意义的接口返回值类型可能也不同，本文档在特殊之处会重点说明。请开发者重点理解。同时游戏接入厂，为了尽可能兼容更多的处理类型，建议采用尽量宽泛的交互处理。
>* 必接功能，为游戏必须接入，并且处理完毕整个流程的功能。没有标注必接的功能，为非必接功能，或者是 根据特定厂商 选择接入，或者根据厂商的合作类型 选择接入。原则上，只接入必接功能，就能保证上线没有问题。建议游戏开发者根据游戏内功能，尽量多地接入功能。重点说明，有些功能是简单的包装桥接，具体的实现要看三方厂商是否已经支持。开发中也建议尽量宽泛地处理调用后的处理。
>* 重点说明，中国大陆发行所有游戏，无论类型和来源，必须接入防沉迷系统。第二，所有游戏必须合法合规，完善游戏的隐私文档和用户协议文档，yodo1 sdk制定了通用宽泛的协议内容，如果游戏有特殊的权限数据获取等操作，请在隐私文档中说明清楚，严格自律。

[unitypackage插件下载](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Yodo1Sdk_OpenSuit/Yodo1SDK(Suit)-6.1.1.unitypackage)

## 集成步骤
### 1. 集成配置
### 1.1 进行Android配置
<center class="half">
    <img src="./../../resource/unity_setting_0.png" width="200"/>
    <img src="./../../resource/unity_setting_1.jpg" width="200"/>
    <img src="./../../resource/unity_setting_2.jpg" width="200"/>
</center>

>* 已经保存的配置存放在Yodo1/Suit/Resources/下，注意别被覆盖
>* use_framework必须添加
>* 不使用suit登录和支付功能，Channel不需要勾选和配置。使用登录或者支付功能，Channel勾选一个并进行配置
>* AppsFlyer附加了deeplink功能，不使用可以不配置
>* Debug Mode为日志打开和测试模式开启，上线时请关闭

### 1.2 进行iOS settings配置

<center class="half">
    <img src="./../../resource/unity_setting_3.png" width="200"/>
</center>

>* 已经保存的配置存放在Yodo1/Suit/Resources/下，注意别被覆盖
>* 不使用suit支付功能，payment不需要勾选
>* AppsFlyer附加了deeplink功能，不使用可以不配置。配置好后，需要在XCode中检查domain配置
>* Debug Mode为日志打开和测试模式开启，上线时请关闭

### 1.3 AndroidManifest配置(针对需要定制启动)-使用unitypackage中自带的plugin/AndroidManifest.xml可以不用配置
#### 1.3.1 /Assets/Plugins/Android/AndroidManifest.xml 修改application：
```java	
android:name="com.yodo1.android.sdk.Yodo1Application"
```
#### 1.3.2 修改启动类
```java	
<!-- YODO1 SDK(Use PA System) Start -->
        <!-- 闪屏页,游戏必须配置com.yodo1.android.sdk.view.SplashActivity,其他配置游戏可自己定制，SplashActivity必须为应用启动组件,其screenOrientation属性，尽量根据游戏配置sensorLandscape/sensorPortrait“-->
        <activity android:name="com.yodo1.android.sdk.view.SplashActivity"
            android:hardwareAccelerated="true"
            android:launchMode="singleTop"
android:exported="true"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

         <!-- 闪屏页的跳转目标 -->
         <meta-data
            android:name="YODO1_MAIN_CLASS"
            android:value="com.yodo1.plugin.u3d.Yodo1UnityActivity"/>

        <activity
            android:name="com.yodo1.plugin.u3d.Yodo1UnityActivity"
            android:label="@string/app_name"
            android:screenOrientation="user"
android:exported="false"
            android:launchMode="singleTask"
android:configChanges="mcc|mnc|locale|touchscreen|keyboard|keyboardHidden|navigation|orientation|screenLayout|uiMode|screenSize|smallestScreenSize|fontScale">
            <meta-data android:name="unityplayer.SkipPermissionsDialog" android:value="true" />
     <meta-data android:name="unityplayer.UnityActivity" android:value="true" />
</activity>
<!-- YODO1 SDK(Use PA System) End -->
```

#### 1.3.3 打包依赖
OpenSuit使用Google的ExternalDependencyManager管理依赖，请[查看详情](https://github.com/googlesamples/unity-jar-resolver#overview)

### 2. 集成接入
### 2.1 初始化
yodo1 suit集成前，请正确接入yodo1 suit unitypackage plugin插件，详见上。目前apple store和googlePlay使用Unity打包方式，其他大陆国内渠道，推荐使用PA打包方式出包。

在游戏第一个界面中，尽可能提前地调用初始化方法。

```java	
//Your App Key 是yodo1分配的gameKey
Yodo1U3dSDK.InitWithAppKey("Your App Key");
//or
Yodo1U3dSDK.InitWithAppKey("Your App Key","RegionCode");
//or
//Your Config是json，格式如{"appKey":"asdb","regionCode":"asdfb","appsflyerCustomUserID":"1243"}
//无登录游戏，务必传appsflyerCustomUserID
Yodo1U3dSDK.InitWithConfig("Your Config");
```

### 2.2 激活码功能
yodo1 PA生成相关规则激活码。兑换码领奖品接口
Yodo1U3dUtils.VerifyActivationCode(“activation Code”);

设置回调：

```java	
/// <summary>
/// Verifies the activation code.
/// </summary>
/// <param name="activationCode">Activation code.</param>
Yodo1U3dUtils.VerifyActivationCode(“activation Code”);
  
/// <summary>
/// Set activity verify delegate
/// </summary>
/// <param name="activityVerifyDelegate"></param>
Yodo1U3dSDK.setActivityVerifyDelegate(ActivityVerifyDelegate);
  
void ActivityVerifyDelegate (Yodo1ActivationcodeData data) {
 Debug.Log ("reward:" + data.Rewards.ToString());
 foreach (string goodName in data.Rewards.Keys) {
 int value = 0;
 int.TryParse (data.Rewards [goodName].ToString (), out value);
 Debug.Log ("goodName:" + goodName + ", value:" + value);
 }
 Debug.Log ("rewardDes:" + data.RewardDes + ", errorMsg:" + data.ErrorMsg);
}
```

### 2.3 用户隐私协议Privacy
用户隐私协议只在 AppleStore 和 GooglePlay渠道有意义。如果应用app可以从其他三方获取下列标记，则通过set接口设置数据即可，不需要ShowUserConsent展示。如果应用无法获取到隐私标记，则需要ShowUserConsent展示年龄选择框，玩家完成后，可以通过回调或者get接口获取标记的值。

#### 2.3.1 GDPR-GDPR 欧盟 (EU) 一般数据保护条例
一般数据保护条例 (GDPR) 引入了新规定，适用于向欧盟 (EU) 民众提供商品和服务或收集并分析欧盟居民相关数据的组织。无论你或你的企业位于何处，都要遵守该规定。 本文档指导用户如何在使用 Microsoft 产品和服务时帮助用户根据 GDPR 遵守权限和履行义务。 

``` java
//如果用户已经同意，请将下面的标志设置为true。
Yodo1U3dSDK.SetUserConsent(true);
//如果用户没有同意，请将下面的标志设置为false。
Yodo1U3dSDK.SetUserConsent(false);
```

#### 2.3.2 COPPA-COPPA 美国儿童在线隐私权保护法
美国儿童在线隐私权保护法于2000年4月21日生效，主要针对在线收集13岁以下儿童个人信息的行为。它规定网站管理者要遵守隐私规则，必须说明何时和如何以一种可以验证的方式向儿童家长索求同意，并且网站管理者必须保护儿童在线隐私和安全。

``` java
//如果已知该用户属于年龄限制类别(即16岁以下的儿童)，请将标志设置为true。
Yodo1U3dSDK.SetTagForUnderAgeOfConsent(true);
//如果已知该用户不属于年龄限制类别(即， 16岁或以上)请将标志设为false。
Yodo1U3dSDK.SetTagForUnderAgeOfConsent(false);
```

#### 2.3.3 CCPA-CCPA 加州消费者隐私法案
美国儿童在线隐私权保护法于2000年4月21日生效，主要针对在线收集13岁以下儿童个人信息的行为。它规定网站管理者要遵守隐私规则，必须说明何时和如何以一种可以验证的方式向儿童家长索求同意，并且网站管理者必须保护儿童在线隐私和安全。

``` java
//设置一个标志，表明位于美国加利福尼亚州的用户是否选择不出售其个人数据
//如果同意出售个人数据，请将标志设置为false。
Yodo1U3dSDK.SetDoNotSell(false);
 
//如果不同意出售个人数据，请将标志设置为true。
Yodo1U3dSDK.SetDoNotSell(true);
```

#### 2.3.4 展示年龄选择框
<center class="half">
    <img src="./../../resource/unity_age.png" width="200"/>
</center>

``` java
//展示年龄选择框
Yodo1U3dSDK.ShowUserConsent();
//年龄选择框回调
Yodo1U3dSDK.setShowUserConsentDelegate(ShowUserConsentDelegate);
private void ShowUserConsentDelegate(bool isaccept, int userage, bool isgdprchild, bool iscoppachild)
{
Debug.Log(Yodo1U3dConstants.LOG_TAG + " isaccept:" + isaccept);
Debug.Log(Yodo1U3dConstants.LOG_TAG + " userage:" + userage);
Debug.Log(Yodo1U3dConstants.LOG_TAG + " isgdprchild:" + isgdprchild);
Debug.Log(Yodo1U3dConstants.LOG_TAG + " iscoppachild:" + iscoppachild);
}
```

### 2.4 获取协议地址，用来获取打开。（一般国内渠道Android渠道）
用在游戏内需要查看协议政策的功能时。sdk提供了openWeb功能，请查看其他API功能。

Yodo1U3dUtils.getTermsLink();  //获取用户同意协议链接地址

Yodo1U3dUtils.getPolicyLink();   //获取用户隐私政策链接地址

``` java
var dic = new Dictionary<string, string>();
dic.Add("isDialog","true"); // 是否以Dialog风格显示Web页面
dic.Add("hideActionBar","true"); //是否隐藏底部导航（上一页按钮和返回游戏按钮），如果隐藏了就只有通过设备返回键才能关闭这个按钮。
Yodo1U3dUtils.openWebPage("https://baidu.com/",dic); //如果不配置dic那么会走默认，全屏显示和有底部按钮
```

<center class="half">
    <img src="./../../resource/unity_web.png" width="200"/>
</center>

### 2.5 分享功能
snsType为二进制数字：

``` java
Yodo1SNSTypeNone(-1),
Yodo1SNSTypeTencentQQ(1 << 0), //朋友圈
Yodo1SNSTypeWeixinMoments(1 << 1), //朋友圈
Yodo1SNSTypeWeixinContacts(1 << 2),//聊天界面
Yodo1SNSTypeSinaWeibo(1 << 3), //新浪微博
Yodo1SNSTypeFacebook(1 << 4), //Facebook
Yodo1SNSTypeTwitter(1 << 5), //Twitter
Yodo1SNSTypeInstagram(1 << 6), //Instagram
Yodo1SNSTypeAll(1 << 7); //所有平台分享
```
可以使用程序员计算机计算，或者手动位计算十进制：
所有平台 = 127或者128
Facebook + Twitter+ Instagram = 112
朋友圈，qq控件，微信聊天，微博 = 15

``` java
/**
*  分享
* 分享list一个则直接分享，多个则出现分享到列表对话框。
**/
Yodo1U3dUtils.share();
//设置分享结果回调
Yodo1U3dSDK.setShareDelegate(ShareDelegate);
```

### 2.6 获取设备id,SIM,国家码,语言，版本号等

``` java
/**
 * 获取设备id
 */
Yodo1U3dUtils.getDeviceId();
/**
 * 获取PlayId>uid>deviceId
 */
Yodo1U3dUtils.getUserId();
/**
 * 获取当前系统地区
 */
Yodo1U3dUtils.getCountryCode();
/**
 * 设置当前应用语言
 */
Yodo1U3dSDK.SetLocalLanguage();
/**
 * 获取设备的sim卡
 *
 * @return 无卡 : 0   cmcc : 1   ct : 2   cu : 4
 */
Yodo1U3dUtils.getSIM();
/**
 * 获取版本号
 */
Yodo1U3dUtils.getVersionName();
/**
 * 判断是否是中国大陆.ext为空。
 */
Yodo1U3dUtils.IsChineseMainland();
```
### 2.7 打开web
``` java
/**
 * 打开app推荐界面，商店应用详情界面。
 */
Yodo1U3dUtils.openReviewPage();
/**
 * 开启应用内web页面
 */
Yodo1U3dUtils.openWebPage(String url, String valuePaireJson);
```

### 2.8 获取渠道号
``` java
/**
 * 获取当前渠道号。
 */
//Yodo1U3dUtils.getSdkcode();
/**
 * 获取发布渠道
 */
Yodo1U3dUtils.GetPublishChannelCode();
```
### 2.9 获取在线参数，开发工具辅助类
``` java
/**
 * 获取在线参数，值的分发。方便进行云控制
 */
Yodo1U3dUtils.getConfigParameter();
Yodo1U3dUtils.StringParams();
Yodo1U3dUtils.BoolParams();
 
/**
 * 用以展示对话框。AlertDialog.
 */
Yodo1U3dUtils.showAlert(String title,String message,String positiveButton,String negativeButton,String neutralButton,String objectName,String callbackMethod)
/**
 * 存储数据到原生层。从原生层获取数据。
 */
Yodo1U3dUtils.SaveToNativeRuntime(key,value);
Yodo1U3dUtils.GetnativeRuntime(key);
```
### 2.10 统计功能
#### 2.10.1 发送自定义事件
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
#### 2.10.2 充值事件-特定统计
``` java
//充值请求
 Yodo1U3dAnalytics.onRechargeRequest();
//充值成功
 Yodo1U3dAnalytics.onRechargeSuccess();
//充值失败
 Yodo1U3dAnalytics.onRechargeFail();
```
#### 2.10.3 用户相关-特定事件
``` obj-c
//统计平台的用户登录。游戏自定义玩家属性值，来配置填充到统计sdk上。eg.accountId(clientId,user,playId)
Yodo1U3dAnalytics.login(Yodo1U3dUser user);

//Google Play支付校验。如果使用sdk内GooglePlay支付，则不需要手动调用。
Yodo1U3dAnalytics.validateInAppPurchase_GooglePlay(String publicKey, String signature, String purchaseData, String price, String currency);
//AppleStore支付校验
Yodo1U3dAnalytics.validateInAppPurchase_Apple(string productId, string price, string currency, string transactionId);
```
#### 2.10.4 特定渠道事件统计
说明：当游戏应用不执行suit内置登录时，请使用initWithConfig进行初始化，并设置appsflyerCustomUserID值为用户或者设备唯一id。（可以获取使用deviceId）

``` java
Yodo1U3dAnalytics.customEventAppsflyer();
```
### 2.11 账号功能
#### 2.11.1 登录
``` java
Yodo1U3dAccount.Login();
/**
  *loginType:缺省代表渠道登录
  *Channel(0, "支付渠道账号登陆", "Channel"),,默认使用Channel方式登录
  *Device(1, "设备登陆", "Device"),
  *Google(2, "谷歌账号登陆", "Google"),
  *Yodo1(3, "游道易账号登录", "Yodo1"),
  *Wechat(4, "微信登录", "WECHAT"),
  *Sina(5, "新浪微博登录", "SINA"),
  *QQ(6, "QQ登录", "QQ");
  *extra      一般传null，有时有特殊配置
**/
Yodo1U3dAccount.Login(Yodo1U3dConstants.LoginType loginType, string extra)
```
设置登录回调：

``` java
//设置回调
Yodo1U3dAccount.SetLoginDelegate(LoginDelegate);
void LoginDelegate(Yodo1U3dConstants.AccountEvent accountEvent, Yodo1U3dUser user){
    if (accountEvent == Yodo1U3dConstants.AccountEvent.Success) {
Debug.Log ("login success");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.Fail) {
Debug.Log ("login failed");
}
}
```

#### 2.11.2 提交用户信息
登录成功后，游戏根据自己的逻辑处理上报给sdk和渠道sdk，设置玩家playerId，和其他信息。健壮后面的逻辑。

``` java
Yodo1U3dAccount.SubmitUser (Yodo1U3dUser );
```
Yodo1U3dUser结构：

| Key名称            | 描述 | 是否为空|
| -------------- | --------- | ----- |
| playedId       |   用户id   | 不可为空|
| nickName       |   用户昵称  | 可为空|
| level          |   等级     | 可为空|
| age            |   年龄     | 可为空|
| gender         |   性别     | 可为空|
| gameServerId   |   服务器id | 可为空|

#### 2.11.3 登出
退出登录，在切换登录等特定需要时接入。一般不接入。

``` java
Yodo1U3dAccount.Logout ();
//设置回调：Yodo1U3dAccount.SetLogoutDelegate(LogoutDelegate);
void LogoutDelegate (Yodo1U3dConstants.AccountEvent accountEvent) {
         Debug.Log ("----LogoutDelegate--- accountEvent: " + accountEvent);
     }
```

#### 2.11.4 判断是否已经登录
退出登录，在切换登录等特定需要时接入。一般不接入。

``` java
bool isLogin = Yodo1U3dAccount.IsLogin ();
```

#### 2.11.5 云存储功能/iCloud
``` java
Yodo1U3dPublish.saveToCloud（）
Yodo1U3dPublish.loadToCloud（）
 
 
//设置回调。googleCloud,iCloud.
Yodo1U3dSDK.setiCloudGetValueDelegate();
```

#### 2.11.6 成就功能/Achievement
``` java
Yodo1U3dPublish.achievementsOpen();
```

#### 2.11.7 排行榜功能/Leaderboard
``` java
Yodo1U3dPublish.leaderboardsOpen()；
```

#### 2.11.8 社区功能/Community,MoreGame,BBS
``` java
/**
 * 打开游戏社区。调用之前，判断是否有该功能
 */
Yodo1U3dUtils.OpenCommunity ();
bool hasCommunity = Yodo1U3dUtils.HasCommunity ()
//一些国内渠道支持更多游戏，方便进行推广拉新。获取更高的推荐。
Yodo1U3dUtils.ShowMoreGame();
/**
 * 打开游戏论坛
 */
Yodo1GameUtils.openBBS();
/**
 * 打开渠道评论反馈界面
 */
Yodo1GameUtils.openFeedback();
```

#### 2.11.9  其他功能
``` java
//更新成就分数
Yodo1U3dPublish.updateScore();
//开启录屏
Yodo1U3dPublish.BeginRecordVideo();
//停止录屏,仅支持iOS
Yodo1U3dPublish.StopRecordVideo();
//展示录屏,仅支持iOS
Yodo1U3dPublish.ShowRecordVideo();
//是否支持截屏
Yodo1U3dPublish.IsCaptureSupported();
```

### 2.12  支付IAP功能
#### 2.12.1  计费点配置和计费点托管
游戏内商品的iap 商品计费点，在项目中单独配置放置。大多数渠道包，通过打到包内的 xml 配置，获取商品最新的价格、名称、描述等信息。其中小米，华为，googlePlay等渠道，使用计费点托管到渠道服务器，根据对应的productId，来获取商品信息，或者发起支付。

这里提供一个excel模板。[点击打开IapConfig_sample.xls](./../../resource/IapConfig_sample.xls)

接入方，收集统计游戏内所有的商品信息，填入excel表格中，上传反馈到 yodo1 系统即可。需要进行托管的计费点，由运营人员编辑各个渠道所需要的格式，上传开启。游戏开发一视同仁。

OpenSuit Unity打包中，将excel表格改名为IapConfig，扩展名保持不变。放置于Yodo1/Suit/Resources/目录下。

#### 2.12.2  查询所有商品
一般在游戏实名认证结束后，或者登录成功后 进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。

``` java
//该方法会请求所有商品信息，然后在回调中全部返回
Yodo1U3dPayment.RequestProductsInfo();
或
//该方法只会获取指定的商品的信息， 然后在回调中返回 string puoductID = "iap_few_coins";
Yodo1U3dPayment.ProductInfoWithProductId(puoductID);
    
设置回调：Yodo1U3dPayment.SetRequestProductsInfoDelegate (RequestProductsInfoDelegate);
    
void RequestProductsInfoDelegate(bool success, List<Yodo1U3dProductData> products){
     if (products != null) {
           foreach (Yodo1U3dProductData product in products) {
              Debug.Log ("productId:" + product.ProductId + ",PriceDisplay:" + product.PriceDisplay + ",PriceDisplay:" + product.PriceDisplay);
              Debug.Log ("MarketId:" + product.MarketId + ",Currency:" + product.Currency + "\n" + "Description" + product.Description + "\n");
           }
     }
}
```

#### 2.12.3  查询已经拥有的订阅型商品
一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。备注：只适用于GooglePlay渠道，AppleStore渠道。

``` java
Yodo1U3dPayment.SetQuerySubscriptionsDelegate(QuerySubscriptionsDelegate);
  
Yodo1U3dPayment.QuerySubsriptions();
```

#### 2.12.4  查询已经拥有的消耗和非消耗商品
一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。备注：只适用于GooglePlay渠道。

``` java
Yodo1U3dPayment.SetVerifyProductsInfoDelegate(VerifyPurchasesDelegate);
  
Yodo1U3dPayment.RequestGoogleCode();
```

#### 2.12.5  恢复所有商品
一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。备注：只适用于GooglePlay渠道，AppleStore渠道。

``` java
Yodo1U3dPayment.SetRestorePurchasesDelegate(RestorePurchasesDelegate);
  
Yodo1U3dPayment.restorePurchase();
```

#### 2.12.6  支付
调用支付方法，对于需要用户登录才能拉起支付的时候会先自动调用登录。

``` java
/**该方法会根据引入的渠道展示支付方式（支付宝，微信，渠道，运营商）
* productId  商品Id
* extra 透传值，可为null
* 建议方式
**/i
Yodo1U3dPayment.Purchase(string productId, string extra)
```

设置支付回调：

``` java
Yodo1U3dPayment.SetPurchaseDelegate(PurchaseDelegate);
/**
* orderId,yodo1订单号
* channelOrderId , iOS订单号。（目前只在iOS中）
* productId，计费点文件的Id。
* extra，渠道支付返回的多余信息
* payType，支付类型
*/
void PurchaseDelegate (Yodo1U3dConstants.PayStatus status, string orderId, string productId, string extra, Yodo1U3dConstants.PayType payType)
{
        Debug.Log ("status : " + status + ",productId : "+productId+", orderId : "+orderId+ ", extra : " + extra);
if (status == Yodo1U3dConstants.PayStatus.PaySuccess) {
//支付成功
}
}
```
#### 2.12.7  查询漏单
一般在游戏实名认证结束,或者登录成功后进行，也可以在游戏大厅和在需要商品信息之前，请求获取到。
Yodo1U3dPayment.QueryLossOrder ();

设置回调：

``` java
Yodo1U3dPayment.SetLossOrderIdPurchasesDelegate(LossOrderIdPurchasesDelegate);
  
void LossOrderIdPurchasesDelegate(bool success, List<Yodo1U3dProductData> products) {
    if (success && products != null) {
        foreach (Yodo1U3dProductData product in products) { Debug.Log ("productId:" + product.ProductId + ",PriceDisplay:" + product.PriceDisplay + ",PriceDisplay:" +     product.PriceDisplay); Debug.Log ("MarketId:" + product.MarketId + ",Currency:" + product.Currency + "\n" + "Description" + product.Description + "\n");
      }
   }
}
```

#### 2.12.8   发货成功通知
 购买成功后，调用发货成功通知接口。。功能是健全购买流程，作为丢单的统计依据。

``` java
/**
 * 发送发货成功通知，可以不用在意回调处理。
 */
         Yodo1U3dPayment.sendGoods(orderId[]);
//可以不接入
  
         Yodo1U3dPayment.SetSendGoodsOverDelegate(SendGoodsOverDelegate);
```

#### 2.12.8  发货失败通知
 购买失败后，调用发货失败通知接口。。功能是健全购买流程，作为丢单的统计依据。

``` java
/**
 * 发送发货失败通知，可以不用在意回调处理。
 */
         Yodo1U3dPayment.sendGoodsFail(orderId[]);
//可以不接入
          Yodo1U3dPayment.SetSendGoodsFailDelegate(SendGoodsFailDelegate);
```

### 2.13  退出游戏
``` java
Yodo1U3dUtils.exit (this, exitCallback);
    
//退出游戏回调
void exitCallback(string msg){
     Debug.Log ("exitCallback, msg = " + msg);
}
```