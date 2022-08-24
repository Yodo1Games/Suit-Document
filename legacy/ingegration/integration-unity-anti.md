# Unity AntiAddiction

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Yodo1SdkUnityPlugin_AntiIndulged/Yodo1AntiAddictionSDK_3.2.1.unitypackage)
>* SDK支持Unity 3D 版本（2017或更高版本）
>* SDK支持Android API 19+
> * `CocoaPods`是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
> * iOS14需要`Xcode` 12+，请确保你的`Xcode`是最新的。

## 集成步骤

### 1. 集成配置

### 1.1 插件结构

<center class="half">
    <img src="./../../resource/unity_anti_structure.jpg" width="200"/>
</center>

请联系Yodo1团队申请应用相关的ID和秘钥，将会得到应用的配置内容。

请将AppKey填入SDK配置对象内(如果该游戏没有RegionCode可不填)，并推荐在调试阶段打开DebugMode及Log开关，正式包请关闭。

配置对象路径请参照插件的结构图:
Yodo1AntiIndulgedSDK/User/Resources/Yodo1U3dSettings.asset

<center class="half">
    <img src="./../../resource/unity_anti_setting_0.png" width="300"/>
</center>

>* Ios Setting配置`App Key`和`Region Code`
>* Andriod Setting配置`App Key`和`Region Code`

### 1.2 发布Android包时的配置

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier)是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 启用

<center class="half">
    <img src="./../../resource/andriod_use_jetifier.png" width="300"/>
</center>

发布Android包时，请先检查Assets/Yodo1AntiAddictionSDK/Plugins/Android/anti-addiction-unity-x.x.x文件是否存在，并在上文提到的Yodo1U3dSetting.asset里配置好Android Settings部分的内容。

之后，修改Assets/Plugins/Android/AndroidManifest.xml内以下标签的内容：

<font color=red>注意: </font>如果开发者需使用自己的AndroidManifest.xml，那么请将以下内容复制进去。

```java	
<!-- 游戏要发布的目标平台的平台代码，这里置为默认值'Yodo1'即可。yodo1其他插件同样有保留一个 -->
<meta-data
   android:name="Yodo1ChannelCode"
   android:value="Yodo1"
   tools:replace="android:value" />
```

另外说明，标题栏Assets/Yodo1Anti Settings，只对Android配置有效。请开发者以上图示意配置为主。

<center class="half">
    <img src="./../../resource/unity_anti_setting_1.png" width="300"/>
</center>

### 1.3 发布iOS包时的配置
发布iOS包时，请正确配置上文提到的Yodo1U3dSetting.asset里Ios Settings部分的内容

### 1.4 接入说明
接入流程图

<center class="half">
    <img src="./../../resource/unity_anti_ process.png" width="300"/>
</center>


``` java
//如果已知该用户属于年龄限制类别(即16岁以下的儿童)，请将标志设置为true。
Yodo1U3dSDK.SetTagForUnderAgeOfConsent(true);
//如果已知该用户不属于年龄限制类别(即， 16岁或以上)请将标志设为false。
Yodo1U3dSDK.SetTagForUnderAgeOfConsent(false);
```

### 2. 集成接口说明
### 2.1 SDK初始化及设置事件监听器
接入插件后，请在项目初始化的时候在对象'Awake'的函数内调用相关代码。
首先要将所有的防沉迷事件的监听设置完毕：

``` java
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
### 2.2 实名认证
玩家登录后，在进入游戏前必须进行实名验证。

开发者只需在玩家每次进入游戏之前都调用实名认证接口，并等待回调结果即可。

防沉迷SDK会自动判断玩家先前是否已经进行过实名认证，如果没有会弹出窗口来引导玩家进行实名制。

<font color=red>注意: </font>此接口中需要传入的accountId可为游戏自身的账号ID，也可以在接入Yodo1的账号SDK后使用账号系统返回的。如果都没有，请使用设备ID。

``` java
public void readyEnterGame(string accountId) {
    // 调用实名认证接口
    Yodo1U3dAntiAddiction.VerifyCertificationInfo(accountId, (Yodo1U3dEventAction eventAction) => {
        if (eventAction == Yodo1U3dEventAction.ResumeGame) {
            // 实名认证成功后可查询玩家是否为游客模式
            bool isGuestUser = Yodo1U3dAntiIndulged.IsGuestUser();
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

### 2.3 玩家上线及下线
当实名认证验证成功后，最后一步是调用上线接口，来通知防沉迷SDK玩家将要开始游戏。
收到成功结果之后，此时所有步骤已进行完毕，可以让玩家进行游戏了。

``` java
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
补充说明：防沉迷已替开发者处理好APP生命周期中自动触发的上下线动作，例如在游戏被切换到后台、从后台返回以及被销毁等。

### 2.4 付款限制与上传商品信息
对游客与未成年人玩家，限制了他们每日/月可消费的最大金额。

开发者需要在调用支付接口进行支付之前，先调用付费限制来判断玩家是否还可继续购买。

如果玩家被允许购买，那么请在玩家实际购买成功后，向防沉迷SDK上传本次购买的商品的信息，这些信息仅用于防沉迷SDK统计玩家的累计购买金额。

``` java
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

### 3. 其他功能说明
使用Yodo1打包系统需要修改的内容

如果开发者准备使用Yodo1的打包系统处理游戏包，那么请注释以下文件中的配置：
Asset/Yodo1AntiAddictionSDK/Editor/Dependencies/AntiAddictionDependencies.xml

``` java
<dependencies>
  <iosPods>
    <sources>
      <source>https://github.com/Yodo1Sdk/Yodo1Spec.git</source>
    </sources>
    <iosPod name="Yodo1AntiAddiction2.0" version="0.9.3" minTargetSdk="9.0">
    </iosPod>
  </iosPods>
  <androidPackages>
    <repositories>
      <repository>http://nexus.yodo1.com:8081/repository/maven-public/</repository>
    </repositories>
    <!-- 使用Yodo1打包系统需要注释部分，检查版本名为最新版本 -->
    <!-- <androidPackage spec="com.yodo1.common:support:1.0.2" /> -->
    <!-- <androidPackage spec="com.yodo1.anti-addiction:core:3.0.23" /> -->
    <!-- End -->
  </androidPackages>
</dependencies>
```