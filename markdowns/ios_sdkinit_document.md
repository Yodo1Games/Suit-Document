# ios_sdkinit_document

## 1.Preparations before SDK initialization
1>pod init
podfile -> 引入source
source 'https://github.com/Yodo1Games/Yodo1Spec.git'
source 'https://github.com/Yodo1Sdk/Yodo1Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

Import SDK
pod 'Yodo1Ads/OpenSuit_AnalyticsAppsFlyer'
pod 'Yodo1Ads/OpenSuit_AnalyticssUmeng'
pod 'Yodo1Ads/Yodo1_iCloud'
pod 'Yodo1Ads/Yodo1_UCenter'
pod 'Yodo1Ads/Yodo1_ConfigKey'
...

2>pod install(pod install --repo-update)

3>Setting Yodo1KeyInfo.plist parameters
![](./../../resource/ios_init_1.png)
4>Setting bitcode=No
![](./../../resource/ios_init_2.png)
5>Other Linker Flags添加-ObjC，-lxml2
![](./../../resource/ios_init_3.png)

## 2.SDK init
1>import header file
# #import "Yodo1Ads.h"
# #import "YD1AgePrivacyManager.h"

2>SDK init
[Yodo1Ads initWithAppKey:@"Your AppKey"];

3>Setting privacy
[Yodo1Ads setTagForUnderAgeOfConsent:<BOOL>];
[Yodo1Ads setUserConsent:<BOOL>];

4>log
[Yodo1Ads setLogEnable:<BOOL>];

5>Showing age selection box
[YD1AgePrivacyManager dialogShowUserConsentWithGameAppKey:@"Your AppKey" channelCode:@"appstore" viewController:self block:^(BOOL accept, BOOL child, int age) {...}];

