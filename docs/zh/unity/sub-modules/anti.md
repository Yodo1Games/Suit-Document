# 防沉迷

**集成准备**:

>* 下载最新[Unity插件3.2.9](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Anti-Addiction/Yodo1-Anti-Addiction-3.2.9.unitypackage)

## 集成配置

请联系发行商务人员，获取GameAppKey，将会得到值应用的配置内容。

请将AppKey填入SDK配置对象内(如果该游戏没有RegionCode可不填)，并推荐在调试阶段打开DebugMode及Log开关，正式包请关闭。

配置对象路径请参照插件的结构图:
/Assets/Yodo1/Anti/Resources/Yodo1U3dSettings.asset

<center class="half">
    <img src="/zh/assets/images/unity_anti_setting_0.png" width="400"/>
</center>

标题栏 Yodo1/Anti-Addication SDK/Settings，Android和iOS平台切换后需要单独配置。请开发者以示意图配置为主。

<!-- markdownlint-disable -->
<figure> 
	<img src="/zh/assets/images/unity_anti_setting_1.jpg" width="400">
    <figcaption>Unity Settings</figcaption> 
</figure>

App Key: 必填参数，标识游戏唯一。

Regin Code: 区域代码，可选。

Enabled: 是否开启功能，默认勾选打开。

Auto Load: 是否开启自动加载，自动调用初始化。

### 1. `Android`配置

#### 1.1 Android发布

发布Android包时，修改Assets/Plugins/Android/AndroidManifest.xml内以下标签的内容：

<font color=red>注意: </font>如果开发者需使用自己的AndroidManifest.xml，那么请将以下内容复制进去。

```c#	
<!-- 游戏要发布的目标平台的发布代码，这里置为默认值'Yodo1'即可。yodo1其他插件同样有保留一个 -->
<meta-data
   android:name="Yodo1ChannelCode"
   android:value="Yodo1"
   tools:replace="android:value" />
```

## SDK集成

### 1. 接入流程示意图

<center class="half">
    <img src="/zh/assets/images/unity_anti_process.png" width="400"/>
</center>

### 2. SDK初始化及设置事件监听器

接入插件后，请在项目初始化的时候在对象'Awake'的函数内调用相关代码。
首先要将所有的防沉迷事件的监听设置完毕：

#### 2.1 设置初始化回调

```c#
public static void SetInitCallBack(InitDelegate initCallBack);
```

#### 2.2 设置游戏时长回调

```c#
public static void SetTimeLimitNotifyCallBack(TimeLimitNotifyDelegate timeLimitNotifyCallBack);
```

#### 2.3 设置玩家掉线通知

```c#
public static void SetPlayerDisconnectionCallBack(PlayerDisconnectionDelegate playerDisconnectionCallback);
```

#### 2.4 初始化,自动初始化则不需要调用

```c#
public static void Init();
```

#### 示例代码

```c#
private void Awake() {
    // 设置sdk初始化结果回调，请在收到初始化成功的回调后再去调用其他接口。
    Yodo1U3dAntiAddiction.SetInitCallBack((bool result, string content) => {
        if (result) {
            // 初始化成功，可以继续执行游戏逻辑
            login();
        } else {
            // 初始化失败，请结束游戏
        }
    });
    // 设置接收玩家到达游戏时间上限的事件监听器。当未成年人或游客到达时间上限(或即将到达时)，SDK会通过此回调来通知开发者
    Yodo1U3dAntiAddiction.SetTimeLimitNotifyCallBack((Yodo1U3dEventAction action, int eventCode, string title, string content) => {
        if (action == Yodo1U3dEventAction.ResumeGame) {
            // 当状态值为ResumeGame时，代表仅需给玩家展示即将到时的提醒，此时不需要结束游戏。
            Dialog.ShowMsgDialog(title, content);
        } else if (action == Yodo1U3dEventAction.EndGame) {
            // 当状态为EndGame时，代表玩家已到达最大游戏时长，必须结束游戏。
            Dialog.ShowMsgDialog(title, content, true, ()=> {
                Application.Quit();
            });
        }
    });
    // 设置玩家掉线监听器。当玩家网络连接有问题，防沉迷系统不能正确统计时，SDK会通过此回调通知开发者
    Yodo1U3dAntiAddiction.SetPlayerDisconnectionCallBack((string title, string content) => {
        // 此时不可继续游戏。
        // 开发者应该主动调用上线接口尝试上线，直到返回成功才可让玩家继续游戏。
        Online();
    });
}
//当设置完全部的监听器后，调用初始化方法进行初始化。
//注意初始化是异步方法，请等到初始化回调触发后再继续其他动作。
private void Awake() {
    // TODO ... 省略之前设置监听器的代码
    Yodo1U3dAntiAddiction.Init();
}
```

### 3. 实名认证

玩家登录后，在进入游戏前必须进行实名验证。

1，如果玩家已经实名或者完成了实名，ResumeGame 继续游戏。

2，如果玩家实名失败或者拒绝实名，可以引导玩家进行实名制，务必完成实名操作才能进行游戏，否则EndGame 结束游戏。

<font color=red>注意: </font>此接口中需要传入的accountId可为游戏自身的账号ID，也可以在接入Yodo1 Suit SDK后使用账号系统返回的userId。如果都没有，请使用设备ID。
防沉迷系统使用accountId来表示唯一用户。

```c#
public static void VerifyCertificationInfo(string accountId,
            VerifyCertificationDelegate verifyCertificationCallBack);
```

#### 示例代码

```c#
public void readyEnterGame(string accountId) {
    // 调用实名认证接口
    Yodo1U3dAntiAddiction.VerifyCertificationInfo(accountId, (Yodo1U3dEventAction eventAction) => {
        if (eventAction == Yodo1U3dEventAction.ResumeGame) {
            // 此时可继续游戏
            Online();
        } else if (eventAction == Yodo1U3dEventAction.EndGame) {
            // 实名认证失败后，或者年龄不允许，不可继续进入游戏
            Dialog.ShowMsgDialog("提示", "实名认证出现问题,无法游戏", true, () => {
                Application.Quit();
            });
 
        }
    });
}
```

### 4. 玩家上线及下线

当实名认证验证成功后，最后一步是调用一次上线接口，来通知防沉迷SDK玩家将要开始游戏。
收到成功结果之后，此时所有步骤已进行完毕，可以让玩家进行游戏了。有时开发者根据需要，一些游戏场景例如大厅,购物车,地图等不算入
游戏时长，则可根据界面切换调用下线和上线。

补充说明：防沉迷已替开发者处理好APP生命周期中自动触发的上下线动作，例如在游戏被切换到后台、从后台返回以及被销毁等。


```c#
public static void Online(BehaviorResultDelegate behaviorResultCallback);
public static void Offline(BehaviorResultDelegate behaviorResultCallback)
```

#### 示例代码

```c#
public void Online () {
    Yodo1U3dAntiAddiction.Online((bool result, string content) => {
        if (result) {
            // 上线成功，开始游戏
            startGame();
        }
    });
}
之后，再玩家准备结束游戏之前，调用下线接口来通知防沉迷SDK。
为了保证数据的准确性，请在收到成功回调之后再进行结束游戏的动作。
private void Offline() {
    Yodo1U3dAntiAddiction.Offline((bool result, string content) => {
        if (result) {
            // 下线成功，退出游戏
            exitGame();   
        }
    });
}
```


### 5. 付款限制与上报商品信息

对未成年人玩家，规则限制了他们每日/月可消费的最大金额。

开发者需要在调用支付接口进行支付之前，先调用付费限制来判断玩家是否还可继续购买。

如果玩家被允许购买，那么请在玩家实际购买成功后，向防沉迷SDK上传本次购买的商品的信息，这些信息仅用于防沉迷SDK统计玩家的累计购买金额。

```c#
// 商品价格单位为：分
public static void VerifyPurchase(double priceCent, string currency, VerifyPurchaseDelegate callBack);
public static void ReportProductReceipt(string productId, Yodo1U3dProductType productType, double priceCent,
            string currency, string orderId);
// 商品价格单位为：元
public static void VerifyPurchaseYuan(double priceYuan, string currency, VerifyPurchaseDelegate callBack);
public static void ReportProductReceiptYuan(string productId, Yodo1U3dProductType productType, double priceYuan,
            string currency, string orderId);
```

#### 示例代码

```c#
// 接口需要传入商品价格(单位为分)，以及货币符号(CNY)。
Yodo1U3dAntiAddiction.VerifyPurchase(priceCent, currency,  (bool isAllow, string content) => {
    if (isAllow) {
        // 可以继续购买，请继续支付流程
        Purchase(price);
    } else {
        // 已达到上限，不可继续购买。此时请用回调中返回的content提示玩家
        Dialog.ShowMsgDialog("提示", content);
    }
});
购买成功后，上传该商品的信息
// 购买成功后，向防沉迷SDK上传商品信息
void OnPurchaseSuccess(ProductInfo info) {
    string productId = info.productId;  // 商品ID
    Yodo1U3dProductType type = Yodo1U3dProductType.Consumables; // 商品类型，消耗品/非消耗品
    double priceCent = info.price;  // 价格，单位为分
    string currency = info.currency;   // 货币符号，CNY
    string orderId = info.orderId; // 订单号
    Yodo1U3dAntiAddiction.ReportProductReceipt(productId, type, priceCent, currency, orderId);
}
```

### 6. 其他功能

```c#
/// 在实名完成后,调用可获取到玩家年龄
public static int getAge();

/// Get sdk version(获取SDK版本).
public static string GetSDKVersion();
```
