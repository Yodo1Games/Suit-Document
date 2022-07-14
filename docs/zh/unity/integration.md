# 集成 SDK

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Yodo1Sdk_OpenSuit/Yodo1SDK(Suit)-6.1.2.unitypackage)
>* SDK支持Unity LTS 版本（2019或更高版本）
>* SDK支持Android API 19+
>* `CocoaPods`是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
>* iOS14需要`Xcode` 12+，请确保你的`Xcode`是最新的。

## 集成步骤

### 1. Android 配置

#### 1.1 设置SDK基本配置

<figure markdown>
    ![Unity Settings](/zh/assets/images/unity_setting_3.png){ width="300" }
</figure>

>* AppKey配置Yodo1 GameKey，RegionCode配置Yodo1 RegionCode（没有可以不用配置）
>* 如果使share功能，请勾选`Share`，同时配置对应的appkey和link
>* 如果使用渠道支付功能，请勾选`GooglePlay`
>* 数据统计ThinkingData必须配置，请配置ThinkingData appid
>* 其他数据统计是可选的，如果需要请勾选，配置对应的配置信息（AppsFlyer附加了deeplink功能，不使用可以不配置）
>* Debug Mode为日志打开和测试模式开启，上线时请关闭
>* 如果要构建中国应用商店包，请修改`Publish Channel`为`ChinaMainLand`, 并联系Yodo1团队进行PA打包

#### 1.2 设置支持AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) 是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 来启用它，如下图所示：

<figure markdown>
    ![andriod use jetifier](/zh/assets/images/andriod_use_jetifier.png){ width="300" }
</figure>

#### 1.3 实现 `Yodo1Application` 声明周期方法

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

#### 1.4 添加 `SplashActivity` 做为启动 `Activity`

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

#### 1.5 在 `AndroidManifest.xml` 中添加 `Yodo1UnityActivity`

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

### 2. iOS 配置

#### 2.1 设置SDK基本配置

 <figure markdown>
 ![andriod use jetifier](/zh/assets/images/unity_setting_0.png){ width="300" }
 </figure>

 >* AppKey配置Yodo1 GameKey，RegionCode配置Yodo1 RegionCode（没有可以不用配置）
 >* 如果使share功能，请勾选`Share`，同时配置对应的appkey和link
 >* 如果使用支付功能，请勾选`UCpayment`
 >* 如果使用iCloud功能，请勾选`iCloud`
 >* 数据统计ThinkingData必须配置，请配置ThinkingData appid
 >* 其他数据统计是可选的，如果需要请勾选，配置对应的配置信息（AppsFlyer附加了deeplink功能，不使用可以不配置。配置好后，需要在XCode中检查domain配置）
 >* Debug Mode为日志打开和测试模式开启，上线时请关闭

#### 2.2 添加 `use_framework`

 <figure markdown>
 ![andriod use jetifier](/zh/assets/images/unity_setting_1.jpg){ width="300" }
 ![andriod use jetifier](/zh/assets/images/unity_setting_2.jpg){ width="300" }
 </figure>

## 3. 初始化

在`Start`方法中调用SDK初始化

推荐的初始化方法如下

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key");
}
```

带有`RegionCode` 为过时方法，仅适用于已申请`RegionCode`的老游戏

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key","RegionCode");
}
```

<!-- ```java
//Your App Key 是yodo1分配的gameKey
Yodo1U3dSDK.InitWithAppKey("Your App Key");
//or
Yodo1U3dSDK.InitWithAppKey("Your App Key","RegionCode");
//or
//Your Config是json，格式如{"appKey":"asdb","regionCode":"asdfb","appsflyerCustomUserID":"1243"}
//无登录游戏，务必传appsflyerCustomUserID
Yodo1U3dSDK.InitWithConfig("Your Config");
``` -->
