# 防沉迷功能

## 概述

目前，所有想要进入中国移动市场发行游戏的开发者都必须遵守中国政府关于保护儿童的相关政策:

为了保护儿童的身心健康，18岁以下的用户将受到防沉迷系统的限制。当用户成为成人后，反成瘾限制策略将被取消(限制策略可以在每个特定的游戏类别中有所不同。请以游戏中实际触发为准)。

因此，我们针对相应国家政策的核心要求，制作了接口和插件，让任何使用Yodo1防沉迷SDK的用户都可以轻松访问防沉迷功能，并通过中国商店审核。

游戏集成SDK后，一定要实现以下核心功能:

* 实名认证
* 游戏时长限制
* 游戏付款限额

当你开始集成前，请查看此流程图

<!-- markdownlint-disable -->
<figure>
    <img src="/zh/assets/images/unity_anti_process.png" width="600"/>
</figure>

## 集成SDK

### 1. 下载最新[Unity插件(3.2.10)](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Anti-Addiction/Yodo1-Anti-Addiction-3.2.10.unitypackage)

### 2. 集成配置

请切换到Android或iOS平台，然后填写配置

<!-- markdownlint-disable -->
<figure> 
	<img src="/zh/assets/images/unity_anti_setting_1.jpg" width="400">
</figure>

>* **App Key**: 你的游戏在Yodo1的唯一标识符，你可以从Yodo1团队获得
>* **Region Code**: 你可以从Yodo1团队获得它，这是可选的
>* **Enabled**: 是否启用该功能，请默认选择
>* **Auto Load**: 是否开启自动加载，自动调用初始化

<!-- 配置对象路径请参照插件的结构图:
/Assets/Yodo1/Anti/Resources/Yodo1U3dSettings.asset

<center class="half">
    <img src="/zh/assets/images/unity_anti_setting_0.png" width="400"/>
</center> -->

#### `Android`配置

发布Android包时，修改Assets/Plugins/Android/AndroidManifest.xml内以下标签的内容：

<font color=red>注意: </font>如果开发者需使用自己的AndroidManifest.xml，那么请将以下内容复制进去。

```c#	
<!-- 游戏要发布的目标平台的发布代码，这里置为默认值'Yodo1'即可。yodo1其他插件同样有保留一个 -->
<meta-data
   android:name="Yodo1ChannelCode"
   android:value="Yodo1"
   tools:replace="android:value" />
```

### 3. SDK初始化

推荐在`Awake`方法中调用初始化代码

#### 3.1 设置初始化回调

```c#
/// <summary>
/// Return initialization result callback.
/// </summary>
/// <param name="result">
///    <see value="true">Initialization successful.</see>
///    <see value="false">Initialization failed.</see>
/// </param>
/// <param name="content">Information content when initialization fails.</param>
public delegate void InitDelegate(bool result, string content);
```

#### 3.2 Initialize method

```c#
public static void Init();
```

**Note** 

* 初始化是一个异步方法，所以要等到初始化回调触发后再调用其他方法。
* 如果在编辑器窗口中选择了自动加载，则不需要调用初始化方法。

#### 示例: 初始化

```c#
using Yodo1.AntiAddiction;

public class Sample : MonoBehaviour {
    private void Awake() {
        // Set SDK initialization callback.
        Yodo1U3dAntiAddiction.SetInitCallBack((bool result, string content) => {
            if (result) {
                // Initialization successful.
                // TODO do the success flow and game begin.
            } else {
                // Initialization failed.
                // TODO do the fail flow, e.g. show the popup message to user. 
            }
            Debug.LogFormat("result = {0}, content = {1}", result, content);
        });

        // There is no need to call the initialization method if auto load is selected in the editor window
        Yodo1U3dAntiAddiction.Init();
    }
}
```

### 4. 实名认证

当游戏开始时，应该设置一个“进入游戏”按钮。点击后会弹出实名验证窗口。用户必须输入中华人民共和国公民身份证相关信息，用户只有通过验证才能进入游戏，开始体验游戏内容。

* 如果玩家已经有一个真实的名字或完成了真实的名字，继续玩游戏。
* 如果玩家无法核实自己的真实姓名或拒绝使用自己的真实姓名，可以引导他使用自己的真实姓名。他必须完成他的真实姓名认证才能玩游戏，否则他不能开始游戏。

```c#
/// <summary>
/// Real name authentication(实名认证).
/// </summary>
/// <param name="accountId">Account id(用户ID).</param>
/// <param name="verifyCertificationCallBack">Real name authentication callback(实名认证回调).</param>
public static void VerifyCertificationInfo(string accountId, VerifyCertificationDelegate verifyCertificationCallBack)
```

accountId可以是下面的ID:

* 游戏端的账号ID 
* 如果您正在使用Yodo1用户系统，您可以使用登录返回的userId
* 如果以上都不存在，则可以使用设备ID

#### 示例: 实名认证

```c#
using Yodo1.AntiAddiction;

public class Sample : MonoBehaviour {
    public void readyEnterGame(string accountId) {
        Yodo1U3dAntiAddiction.VerifyCertificationInfo(accountId, (Yodo1U3dEventAction eventAction) => {
            if (eventAction == Yodo1U3dEventAction.ResumeGame) {
                // Real name authentication successfully, continue to play game

            } else if (eventAction == Yodo1U3dEventAction.EndGame) {
                // Real name authentication failure prompt and exit the game
                Dialog.ShowMsgDialog("Warm prompt", "Real name authentication failed!", true, () => {
                    Application.Quit();
                });
            }
        });
    }
}
```

### 5. 游戏时长限制

儿童玩家将在总游戏时间累积到一定时间后收到警告。当游戏时间超过限制时，他们将不能进入游戏。

```c#
/// <summary>
/// Set remaining time notification callback(设置剩余时间通知回调).
/// </summary>
/// <param name="timeLimitNotifyCallBack">Remaining time notification callback(剩余时间通知回调).</param>
public static void SetTimeLimitNotifyCallBack(TimeLimitNotifyDelegate timeLimitNotifyCallBack)
```

#### 示例: 游戏时长限制

```c#
// Set the event callback method that receives the player reaching the game time limit. This callback notifies the developer when the child has reached the time limit (or is about to arrive)
Yodo1U3dAntiAddiction.SetTimeLimitNotifyCallBack((Yodo1U3dEventAction action, int eventCode, string title, string content) => {
    if (action == Yodo1U3dEventAction.ResumeGame) {
        // Prompt when x minutes remain.
        // TODO Warning user it's few time left for playing. 
    } else if (action == Yodo1U3dEventAction.EndGame) {
        // The game handles the pop-up prompt to exit the game(游戏处理退出游戏的弹框提示).
        // TODO Get time limit event, user can't play game util next day. 
        Dialog.ShowMsgDialog(title, content, true, ()=> {
            Application.Quit();
        });
    }
});
```

### 6. 玩家上线及下线

当实名认证验证成功后，需要调用一次在线方法通知SDK此玩家开始游戏，让玩家收到成功结果后开始游戏。

有时，一些游戏场景如大堂、购物车、地图等，它们不计入游戏时间，可以根据调用线上和线下的方法来管理游戏时间。

**注意**: SDK已经处理在APP生命周期中触发的游戏时间计数，如当游戏切换到后台，从后台返回，和销毁。

#### 6.1 设置玩家掉线通知回调

当玩家无法连接网络时，SDK将通过这个回调通知开发者，防沉迷系统将无法正确计算游戏时间。你应该尝试调用在线方法。

```c#
/// <summary>
/// Set player has disconnection callback(设置玩家掉线时的回调).
/// </summary>
/// <param name="playerDisconnectionCallback">when the player has disconnection to AntiAddiction-System callback(当玩家从防沉迷系统中断开时的回调).</param>
public static void SetPlayerDisconnectionCallBack(PlayerDisconnectionDelegate playerDisconnectionCallback)
```

#### 6.2 玩家上线

当实名认证验证成功时，您应该调用在线方法一次，通知SDK玩家开始游戏

```c#
/// <summary>
/// player go online
/// </summary>
/// <param name="behaviorResultCallback">execution result callback(行为执行结果回调).</param>
public static void Online(BehaviorResultDelegate behaviorResultCallback);
```

#### 示例: 玩家上线

```c#
using Yodo1.AntiAddiction;

public class Sample : MonoBehaviour {
    private void Awake() {
        // Set SDK initialization callback.
        Yodo1U3dAntiAddiction.SetInitCallBack((bool result, string content) => {
            if (result) {
                // Initialization successful.
                // TODO do the success flow and game begin.
            } else {
                // Initialization failed.
                // TODO do the fail flow, e.g. show the popup message to user. 
            }
            Debug.LogFormat("result = {0}, content = {1}", result, content);
        });

        Yodo1U3dAntiAddiction.SetPlayerDisconnectionCallBack((string title, string content) => {
            Online();
        });

        // There is no need to call the initialization method if auto load is selected in the editor window
        Yodo1U3dAntiAddiction.Init();
    }

    public void readyEnterGame(string accountId) {
        Yodo1U3dAntiAddiction.VerifyCertificationInfo(accountId, (Yodo1U3dEventAction eventAction) => {
            if (eventAction == Yodo1U3dEventAction.ResumeGame) {
                // Real name authentication successfully, continue to play game
                Online();
            } else if (eventAction == Yodo1U3dEventAction.EndGame) {
                // Real name authentication failure prompt and exit the game
                Dialog.ShowMsgDialog("Warm prompt", "Real name authentication failed!", true, () => {
                    Application.Quit();
                });
            }
        });
    }

    public void Online() {
        Yodo1U3dAntiAddiction.Online((bool result, string content) => {
            if (result) {
                // TODO continue to play game 
            }
        });
    }
}
```

#### 6.3 玩家下线

请在玩家准备退出游戏前调用离线方法通知SDK，为确保数据的准确性，请在收到成功回调之前不要退出游戏。

```c#
/// <summary>
/// player go offline
/// </summary>
/// <param name="behaviorResultCallback">execution result callback(行为执行结果回调).</param>
public static void Offline(BehaviorResultDelegate behaviorResultCallback)
```

#### 示例: 玩家下线

```c#
using Yodo1.AntiAddiction;

public class Sample : MonoBehaviour {
    public void QuitGame() {
        Yodo1U3dAntiAddiction.Offline((bool result, string content) => {
            if (result) {
                // TODO continue to play game 
            }
        });
    }
}
```

### 7. 游戏付款限额

当游戏中的支付金额达到一定限额时，儿童用户将无法持续购买游戏中的物品。在这种情况下，开发人员需要在调用支付接口之前确定用户是否被限制支付。

#### 7.1 检查支付限额

```c#
/// <summary>
/// Whether the callback of consumption has been restricted(是否已限制消费的回调).
/// </summary>
/// <param name="isAllow">
///    <see value="true">Available for purchase(可购买).</see>
///    <see value="false">Not available for purchase(不可购买).</see>
/// </param>
/// <param name="content">Notice content that needs to be displayed in the game when it is not available for purchase(不可购买时的需要游戏展示的通知内容).</param>
public delegate void VerifyPurchaseDelegate(bool isAllow, string content);
```

```c#
/// <summary>
/// Verify consumption is restricted(验证是否已限制消费).
/// </summary>
/// <param name="priceCent">The price of the commodity, in cent(商品的价格，单位为分).</param>
/// <param name="currency">Corresponding currency symbol(对应货币符号,商品信息里获得).</param>
public static void VerifyPurchase(double priceCent, string currency, VerifyPurchaseDelegate callBack)


/// <summary>
/// Verify consumption is restricted(验证是否已限制消费).
/// </summary>
/// <param name="priceYuan">The price of the commodity, in yuan(商品的价格，单位为元).</param>
/// <param name="currency">Corresponding currency symbol(对应货币符号,商品信息里获得).</param>
public static void VerifyPurchaseYuan(double priceYuan, string currency, VerifyPurchaseDelegate callBack)
```

#### 示例: 检查支付限额

```c#
// The price of the commodity, in cent
Yodo1U3dAntiAddiction.VerifyPurchase(priceCent, currency,  (bool isAllow, string content) => {
    if (isAllow) {
        // can be purchased, execute the purchase process.
        
    } else {
        // Can't buy prompt to player
        Dialog.ShowMsgDialog("Warm prompt", content);
    }
});
```

#### 7.2 报告消费信息

当玩家购买成功后，开发人员必须调用SDK的`ReportProductReceipt`方法来上报玩家消费信息。

```c#
/// <summary>
/// 商品价格单位为分时请使用此接口
/// Report consumption information(上报消费信息).
/// </summary>
/// <param name="productId">Product id(消费产品id).</param>
/// <param name="productType">Product type(消费产品类型).</param>
/// <param name="priceCent">Product price in cent(消费产品价格，单位为分).</param>
/// <param name="currency">Product currency(对应货币类型).</param>
/// <param name="orderId">Store order number(商店订单号).</param>
public static void ReportProductReceipt(string productId, Yodo1U3dProductType productType, double priceCent,
            string currency, string orderId);

///<summary>
/// 商品价格单位为元时请使用此接口
/// Report consumption information(上报消费信息).
/// </summary>
/// <param name="productId">Product id(消费产品id).</param>
/// <param name="productType">Product type(消费产品类型).</param>
/// <param name="priceYuan">Product price(消费产品价格，单位为元).</param>
/// <param name="currency">Product currency(对应货币类型).</param>
/// <param name="orderId">Store order number(商店订单号).</param>
public static void ReportProductReceiptYuan(string productId, Yodo1U3dProductType productType, double priceYuan,
            string currency, string orderId);
```

#### 示例: 报告消费信息

```c#
//Report the information after the transaction is successful
string productId = "xxx.xxx.xxx";
Yodo1U3dProductType type = Yodo1U3dProductType.Consumables;
double priceCent = 100;  // Price Unit: cent
string currency = "CNY";
string orderId = "order id";
Yodo1U3dAntiAddiction.ReportProductReceipt(productId, type, priceCent, currency, orderId);
```

## 其他功能

### 获取玩家年龄

```c#
public static int getAge();
```
### 获取SDK版本号

```c#
public static string GetSDKVersion();
```