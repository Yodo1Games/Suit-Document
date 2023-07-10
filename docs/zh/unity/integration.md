# 集成引导

这向你展示了如何在Unity中下载和配置Yodo1 Suit SDK。

## 集成准备

**注意**: 下面是Yodo1Suit SDK的环境/API要求

> 开发环境的要求:
>
> - Unity LTS 2019以及以上版本
> - CocoaPods是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
> - iOS15 需要 `Xcode` 13+
>
> API的要求:
>
> - Android API 19+
> - iOS API 11+

## 下载最新的SDK(6.3.2)

你可以点击这里下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Yodo1Sdk_OpenSuit/Yodo1-Suit-6.3.2.unitypackage).

## iOS配置

### 1. iOS基本设置

`App Key`: 你的游戏的唯一标识符，你可以从Yodo1团队获得

`Debug Mode`: 启用/禁用调试模式，请在发布你的游戏到商店之前关闭它

`Region Code(Optional)`: 你可以从Yodo1团队获得它，这是可选的

`UCpayment(Optional)`: 应用内购买，这是可选的

`iCloud(Optional)`: 启用它意味着你将使用Yodo1的iCloud，这是可选的

`Thinking AppId & Server URL(Optional)`: 使用Thinking service收集用户级数据

`AppsFlyer(Optional)`: 使用AppsFlyer UA SDK

<!-- >* AppKey配置Yodo1 GameKey，RegionCode配置Yodo1 RegionCode（没有可以不用配置）
>* 如果使share功能，请勾选`Share`，同时配置对应的appkey和link
>* 如果使用支付功能，请勾选`UCpayment`
>* 如果使用iCloud功能，请勾选`iCloud`
>* 数据统计ThinkingData必须配置，请配置ThinkingData appid
>* 其他数据统计是可选的，如果需要请勾选，配置对应的配置信息（AppsFlyer附加了deeplink功能，不使用可以不配置。配置好后，需要在XCode中检查domain配置。注意：配置domain的域必须添加“applink:”前缀）
>* Debug Mode为日志打开和测试模式开启，上线时请关闭 -->

<!-- markdownlint-disable -->
<figure> 
	 <img src="/zh/assets/images/unity_ios.png">
    <img src="/zh/assets/images/unity_setting_0.png">
</figure>
<!-- markdownlint-restore -->

### 2. iOS解析器设置

你需要添加`user_frameworks!`到podfile，以正确使用第三方Unity包。你可以在Unity编辑器中找到设置: `Assets -> External Dependency Manager -> iOS Resolver -> Settings`

<!-- markdownlint-disable -->

<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>

<!-- markdownlint-restore -->

## Android配置

### 1. Android基本设置

<!-- markdownlint-disable -->
<figure> 
	<img src="/zh/assets/images/unity_android.png" width="800">
    <img src="/zh/assets/images/unity_setting_3.png" width="800"> 
</figure>

* `App Key`: 你的游戏的唯一标识符，你可以从Yodo1团队获得
* `Debug Mode`: 启用/禁用调试模式，请在发布你的游戏到商店之前关闭它
* `Region Code(Optional)`: 你可以从Yodo1团队获得它，这是可选的
* `Publishing Store`: 发行商店选项
    * `GooglePlay`: 如果使用Google支付功能，请选择它
    * `ChinaMainLand`： 如果要构建中国应用商店包，请选择它, 并联系Yodo1团队进行PA打包
* `Thinking AppId & Server URL(Optional)`: 使用Thinking service收集用户级数据
* `AppsFlyer(Optional)`: 如果你的游戏需要UA，请勾选，配置对应的配置信息（AppsFlyer附加了deeplink功能，不使用可以不配置）

### 2. Android解析器设置

#### 支持AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) 是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 来启用它，如下图所示：

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="500"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

### 3. 实现 `Yodo1Application` 声明周期方法

有两种方法实现`Yodo1Application`的生命周期方法

* 在 `AndroidManifest.xml` 中更改应用程序的 `android:name`，如下所示
  
  ```xml
  <application
    android:name="com.yodo1.android.sdk.Yodo1Application">
  ```

* 或者使用代码实现，如下所示
  
  ```java
  import com.yodo1.android.sdk.Yodo1Application;

  public class AppApplication extends Yodo1Application {
  }
  ```

### 4. 添加 `SplashActivity` 做为启动 `Activity`

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

注意:你需要根据你的游戏设置改变`android:screenOrientation`

### 5. 添加 `Yodo1UnityActivity`

  ```xml
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
  ```

## 初始化SDK

配置完成后初始化Yodo1 Suit SDK。建议在`Start`方法中初始化SDK。

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key");
}
```

如果你的游戏有多个环境，你可以使用`RegionCode`来初始化SDK。你可以将这些环境视为游戏的不同区域。使用`RegionCode`允许你为不同的后端设置不同的服务器回调。

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key","RegionCode");
}
```