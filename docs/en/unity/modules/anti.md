# Anti-Addiction plugin

## Overview

At present, all of the developers who want to enter the China mobile market to release games have to abide by the relevant policies of the Chinese government on the protection of children:

In order to protect the physical and mental health of children, users under the age of 18 will be restricted by the anti-addiction system. When users become adults, the anti-addiction restriction strategy will be lifted (restriction strategies can be different in each specific game categories. Please be subject to the actual trigger in the game).

Therefore, we have made interfaces and plug-ins for the core requirements of the corresponding national policies, so that any user who uses the Yodo1 anti-addiction SDK can easily access the anti-addiction functions and passed the Chinese store review.

After the game is integrated with our SDK, be sure to implement the following core functions:

* Real name authentication
* Game play time limit
* Game payment limit

## Integrate SDK

### 1. Download Latest [Unity Plugin(3.2.10)](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Anti-Addiction/Yodo1-Anti-Addiction-3.2.10.unitypackage)

### 2. Integrate Configuration

Please switch to Android or iOS platform, and then fill in it

<!-- markdownlint-disable -->
<figure> 
	<img src="/zh/assets/images/unity_anti_setting_1.jpg" width="400">
</figure>

>* **App Key**: Unique identifier for your game in Yodo1, you can get it from the Yodo1 team
>* **Region Code**: You can get it from the Yodo1 team, which is optional
>* **Enabled**: Whether to enabled the function, please choice it by default
>* **Auto Load**: Whether to enable automatic call initialization

<!-- ### 3. Integration flow chart

<center class="half">
    <img src="/zh/assets/images/unity_anti_process.png" width="500"/>
</center> -->

### 3. SDK initialization

Call the relevant code in the function of object `Awake` during project initialization

#### 3.1 Set the initialization delegate

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

* The initialization is an asynchronous method, so wait until the initialization callback fires before call other methods.
* There is no need to call the initialization method if auto load is selected in the editor window

#### Example: initialization 

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

### 4. Real name authentication

When the game starts, a "enter the game" button should be set. After clicking, a real-name verification window will pop up. Users have to enter the citizen ID and relevant information of the People's Republic of China.

Users can enter the game and begin to experience the game content only after passing the verification.

* If the player already has a real name or has completed the real name, continues play the game.
* If the player fails to verify his real name or refuses to use his real name, he can be guided to use his real name. He must complete his real name authentication to play the game, otherwise he cann’t start the game.

```c#
/// <summary>
/// Real name authentication(实名认证).
/// </summary>
/// <param name="accountId">Account id(用户ID).</param>
/// <param name="verifyCertificationCallBack">Real name authentication callback(实名认证回调).</param>
public static void VerifyCertificationInfo(string accountId, VerifyCertificationDelegate verifyCertificationCallBack)
```

The Account Id can be the following ID 

* Account ID on the game side 
* If you are using the Yodo1 user system, you can use the userId returned by the login 
* If none of the above exists, the device ID can be used

#### Example: Real name authentication 

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

### 5. Play time limit

Child players will receive a warning after the total play time accumulates to a certain period of time. When the play time exceeds the limit, they will not be able to enter the game.

```c#
/// <summary>
/// Set remaining time notification callback(设置剩余时间通知回调).
/// </summary>
/// <param name="timeLimitNotifyCallBack">Remaining time notification callback(剩余时间通知回调).</param>
public static void SetTimeLimitNotifyCallBack(TimeLimitNotifyDelegate timeLimitNotifyCallBack)
```

#### Example: play time limit

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

### 6. Players are online and offline

When the real name authentication verification is successful, the online method needs to be called once to notify the SDK that this players to start the game, let the player play the game after receiving a successful result.

Sometimes, some game scenes such as lobby, shopping cart, map, etc., they do not count into the game time, online and offline methods can be called according to manage the game time.

**Note**: The SDK already handles count play time that are triggered during the APP lifecycle, such as when the game is switched to the background, returned from the background, and destroyed.

#### 6.1 Set the player disconnect callback

The SDK will notify the developer through this callback when the player is unable to connect to the network, the anti-addiction system will not correctly count the time of playing the game. You should try to call online method here.

```c#
/// <summary>
/// Set player has disconnection callback(设置玩家掉线时的回调).
/// </summary>
/// <param name="playerDisconnectionCallback">when the player has disconnection to AntiAddiction-System callback(当玩家从防沉迷系统中断开时的回调).</param>
public static void SetPlayerDisconnectionCallBack(PlayerDisconnectionDelegate playerDisconnectionCallback)
```

#### 6.2 Player online

You should call the online method once to notify the SDK the player to start the game when the real name authentication verification is successfully

```c#
/// <summary>
/// player go online
/// </summary>
/// <param name="behaviorResultCallback">execution result callback(行为执行结果回调).</param>
public static void Online(BehaviorResultDelegate behaviorResultCallback);
```

#### Example: player online

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

#### 6.3 Player offline

Please call the offline method to notify the SDK before the player is ready to quit the game, to ensure the accuracy of the data, please do not quit the game until you receive a successful callback.

```c#
/// <summary>
/// player go offline
/// </summary>
/// <param name="behaviorResultCallback">execution result callback(行为执行结果回调).</param>
public static void Offline(BehaviorResultDelegate behaviorResultCallback)
```

#### Example: player offline

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

### 7. Game payment amount limit

Due to restrictions, child users will not be able to continuously purchase in-game items when the payment amount in the game reaches a certain limit.

In this case, developers need to determine whether the user has been restricted from payment before calling the payment interface.

#### 7.1 Check payment limits

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

#### Example: verify purchase

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

#### 7.2 Report consumption information

The developers have to call the SDK's amount reporting method to record the user's cumulative payment amount during each payment.

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

#### Example: report transaction information

```c#
//Report the information after the transaction is successful
string productId = "xxx.xxx.xxx";
Yodo1U3dProductType type = Yodo1U3dProductType.Consumables;
double priceCent = 100;  // Price Unit: cent
string currency = "CNY";
string orderId = "order id";
Yodo1U3dAntiAddiction.ReportProductReceipt(productId, type, priceCent, currency, orderId);
```

## Other Methods

### Get user's age

```c#
public static int getAge();
```
### Get SDK version

```c#
public static string GetSDKVersion();
```