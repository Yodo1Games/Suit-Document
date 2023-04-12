# Integrate SDK

**Getting started**:

>* Download [Unity Plugin](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Yodo1Sdk_OpenSuit/Yodo1SDK(Suit)-6.1.16.unitypackage)
>* SDK supports Unity LTS 2019 and above
>* SDK supports Android API 19 and above
>* SDK supports iOS API 10 and above
>* `CocoaPods` is required for `iOS` build, you can install it by following the instructions [here](https://guides.cocoapods.org/using/getting-started.html#getting-started)
>* iOS15 requires `Xcode` 13+, please make sure you are using the latest version of Xcode

## Integrate Configuration

### 1. Android Configuration

#### 1.1 Set the SDK basic configuration

<!-- markdownlint-disable -->
<figure> 
	<img src="/zh/assets/images/unity_android.png">
    <img src="/zh/assets/images/unity_setting_3.png"> 
    <!-- <figcaption>Unity Settings</figcaption>  -->
</figure>

>* **App Key**: Unique identifier for your game in Yodo1, you can get it from Yodo1 team.
>* **Region Code**: You can get it from Yodo1 team, which is optional.
>* **Publishing Store**: Please select `GooglePlay` if your game is published on the Google Play store and uses Yodo's in-app purchase. Please select `ChinaMainLand` if your game is published to the stores in China Mainland and contact Yodo1 team for cloud building.
>* **Thinking Data**: Please fill in app id of Thinking Data.
>* **AppsFlyer** is optional.
>* **Debug Mode**: This is to enable debug logs, Turn this off when you publish your game to store.

#### 1.2 Support for AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) is required for `Android` build, you can enable it by selecting ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier***

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

#### 1.3 Implement `Yodo1Application` lifecycle methods

There are two ways to implement lifecycle methods of `Yodo1Application`

* Change the `android:name` of the application in `AndroidManifest.xml` file as below
  
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

#### 1.4 Add `SplashActivity` to `AndroidManifest.xml` file as default LAUNCHER activity

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

**Note**: You need to change `android:screenOrientation` with respect to your app's/game's settings

#### 1.5 Add `Yodo1UnityActivity` to `AndroidManifest.xml` file

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

### 2. iOS Configuration

#### 2.1 Set the basic SDK configuration

<!-- markdownlint-disable -->
<figure> 
	 <img src="/zh/assets/images/unity_ios.png">
    <img src="/zh/assets/images/unity_setting_0.png">
</figure>
<!-- markdownlint-restore -->

>* **App Key**: Unique identifier for your game in Yodo1, you can get it from Yodo1 team.
>* **Region Code**: You can get it from Yodo1 team, which is optional.
>* **UCpayment**: Please select `UCpayment` if your game uses Yodo1's in-app purchase.
>* **iCloud**: Please select `iCloud` if your game uses Yodo1's iCloud.
>* **Thinking Data**: Please fill in app id of Thinking Data.
>* **AppsFlyer** is optional.
>* **Debug Mode**: This is to enable debug logs, Turn this off when you publish your game to store.

#### 2.2 Add `use_framework`

Set the `use_framework` according to `Assets -> External Dependency Manager -> iOS Resolver -> Settings`

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>
<!-- markdownlint-restore -->

## Initialize SDK

It is recommended to call SDK initialization in the `Start` method.

The recommended initialization method is as follows

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key");
}
```

Initializing with regionCode is outdated and it works only for older games where `RegionCode` has been applied.

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key","RegionCode");
}
```
