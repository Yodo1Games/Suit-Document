# 集成 SDK

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Yodo1Sdk_OpenSuit/Yodo1SDK(Suit)-6.1.1.unitypackage)
>* SDK支持Unity LTS 版本（2019或更高版本）
>* SDK支持Android API 19+
>* `CocoaPods`是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
>* iOS14需要`Xcode` 12+，请确保你的`Xcode`是最新的。

## 集成配置

### Android 配置

<figure markdown>
  ![Unity Settings](/zh/assets/images/unity_setting_3.png){ width="300" }
</figure>

<!-- ![Unity Settings](/zh/assets/images/unity_setting_3.png){ width="100" } -->

>* AppKey配置Yodo1 GameKey，RegionCode配置Yodo1 RegionCode（没有可以不用配置）
>* 如果使share功能，请勾选`Share`，同时配置对应的appkey和link
>* 如果使用渠道支付功能，请勾选`GooglePlay`
>* 数据统计ThinkingData必须配置，请配置ThinkingData appid
>* 其他数据统计是可选的，如果需要请勾选，配置对应的配置信息（AppsFlyer附加了deeplink功能，不使用可以不配置）
>* Debug Mode为日志打开和测试模式开启，上线时请关闭

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) 是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 启用

<figure markdown>
![andriod use jetifier](/zh/assets/images/andriod_use_jetifier.png){ width="300" }
</figure>

AndroidManifest配置(针对需要定制启动)-使用unitypackage中自带的 `plugin/AndroidManifest.xml`可以不用配置
`/Assets/Plugins/Android/AndroidManifest.xml` 修改application：

```java
android:name="com.yodo1.android.sdk.Yodo1Application"
```

修改启动类

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

### iOS 配置

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

<figure markdown>
![andriod use jetifier](/zh/assets/images/unity_setting_1.jpg){ width="300" }
![andriod use jetifier](/zh/assets/images/unity_setting_2.jpg){ width="300" }
</figure>

>* use_framework必须添加

## 初始化

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
