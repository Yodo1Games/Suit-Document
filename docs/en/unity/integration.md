# Integration Guide

Yodo1 Suit SDK is an API wrapper for Yodo1's publishing services/business. It provides a comprehensive set of tools and APIs to effectively integrate Yodo1's services into your game development process. By utilizing Yodo1 Suit SDK, developers can easily implement features such as in-app purchases, ad monetization, analytics, anti-addition(China version COPPA) and more, improving your games and increasing revenue streams.

With Yodo1 Suit SDK, developers can focus on creating the best possible gaming experience for their users, while relying on a robust set of tools and services to quickly and efficiently bring their games to market. Whether you're looking to launch on iOS or Android, Yodo1 Suit SDK is designed to simplify the integration process and help developers achieve their goals effectively and efficiently.

And this page shows you how to download and set up Yodo1 Suit SDK in Unity.

## Getting started

**Notes**: Below are the enviroments/API level requirements for Yodo1Suit SDK

> Enviroments Requirements:
>
> - Unity LTS 2019 or above
> - CocoaPods is required for `iOS` build, you can install it by following the instructions [here](https://guides.cocoapods.org/using/getting-started.html#getting-started)
> - iOS15 requires `Xcode` 13+ or above
>
> API Level Requirements:
>
> - Android API 19 or above
> - iOS API 11 or above

## Download the Latest SDK(6.3.3)

You can download the Unity Plugin [via the link here](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Suit/Yodo1-Suit-6.3.3.unitypackage).

## iOS Configuration

### 1. Basic Settings

`App Key`: Unique identifier for your game, you can get it from Yodo1 team

`Debug Mode`: Enable/Disable debug mode, please turn it off before release your game to stores

`Region Code(Optional)`: You can get it from the Yodo1 team, which is optional

`UCpayment(Optional)`: In-app purchase enhancement

`iCloud(Optional)`: Enable this means you will use Yodo1's iCloud

`Thinking AppId & Server URL(Optional)`: Enable data analytics and using Thinking service to collected user-level data and provide insights

`AppsFlyer(Optional)`: Enable it to use AppsFlyer
<!-- markdownlint-disable -->

<figure> 
	 <img src="/zh/assets/images/unity_ios.png">
    <img src="/zh/assets/images/unity_setting_0.png">
</figure>
<!-- markdownlint-restore -->

### 2. iOS Resolver Settings

You need to add `user_frameworks!` to the podfile to use third-party Unity packages properly.  You can find the settings in your Unity editor: `Assets -> External Dependency Manager -> iOS Resolver -> Settings`

<!-- markdownlint-disable -->

<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>

<!-- markdownlint-restore -->

## Android Configuration

### 1. Android Basic Settings

<!-- markdownlint-disable -->
<figure> 
	<img src="/zh/assets/images/unity_android.png">
    <img src="/zh/assets/images/unity_setting_3.png"> 
    <!-- <figcaption>Unity Settings</figcaption>  -->
</figure>

>* **App Key**: Unique identifier for your game in Yodo1, you can get it from the Yodo1 team
>* **Region Code**: You can get it from the Yodo1 team, which is optional
>* **Publishing Store**: Please choice `GooglePlay` if your game is published on the Google Play store and uses Yodo's in-app purchase. Please choice `ChinaMainLand` if your game is published to the stores in China Mainland and contact the Yodo1 team for build
>* **Thinking Data**: Please fill in app id of Thinking Data
>* **AppsFlyer** is optional
>* **Debug Mode**: Enable debug log, please turn it off when you publish your game to stores

### 2. AndroidX Support Config

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) is required for `Android` build, you can enable it by selecting ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier***
GooglePlay channel must be configured this.Don't do this in chineaseMainLand if no have special requirements.
<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

### 3. Implement `Yodo1Application` lifecycle methods

If the Application is not customized for the APP, can skip this step.

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

### 4. Add `SplashActivity` to `AndroidManifest.xml` file as default LAUNCHER activity

If the LAUNCHER Page is not customized for the APP, can skip this step.

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

**Note**: You need to change `android:screenOrientation` with respect to your app's or game's settings

### 5. Add `Yodo1UnityActivity` to `AndroidManifest.xml` file

If the Unity Container Page is not customized for the APP, can skip this step.

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

## Initialize the SDK

Initialize the Yodo1 Suit SDK after finishing the configuration. It's recommended to initialize the SDK in the `Start` method.

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key");
}
```

If your game has multiple environments, you can use `RegionCode` to initialize the SDK. You can think of these environments as different regions for your game. Using `RegionCode` allows you to set up different server callbacks for your different backends.

```c#
void Start()  {
    Yodo1U3dSDK.InitWithAppKey("Your App Key","RegionCode");
}
```
