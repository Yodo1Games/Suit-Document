# 分享功能

snsType为二进制数字：

``` java
Yodo1SNSTypeNone(-1),
Yodo1SNSTypeTencentQQ(1 << 0), //朋友圈
Yodo1SNSTypeWeixinMoments(1 << 1), //朋友圈
Yodo1SNSTypeWeixinContacts(1 << 2),//聊天界面
Yodo1SNSTypeSinaWeibo(1 << 3), //新浪微博
Yodo1SNSTypeFacebook(1 << 4), //Facebook
Yodo1SNSTypeTwitter(1 << 5), //Twitter
Yodo1SNSTypeInstagram(1 << 6), //Instagram
Yodo1SNSTypeAll(1 << 7); //所有平台分享
```

Yodo1SNSType结构：

| Key名称                    | 描述          |
| ------------------------- | ------------- |
| Yodo1SNSTypeNone          |               |
| Yodo1SNSTypeTencentQQ     | QQ朋友圈       |
| Yodo1SNSTypeWeixinMoments | 微信朋友圈      |
| Yodo1SNSTypeWeixinContacts| 微信聊天界面    |
| Yodo1SNSTypeSinaWeibo     | 新浪微博       |
| Yodo1SNSTypeFacebook      | Facebook      |
| Yodo1SNSTypeTwitter       | Twitter       |
| Yodo1SNSTypeInstagram     | Instagram     |
| Yodo1SNSTypeAll           | 所有分享平台    |

可以使用程序员计算机计算，或者手动位计算十进制：
所有平台 = 127或者128
Facebook + Twitter+ Instagram = 112
朋友圈，qq控件，微信聊天，微博 = 15

``` java
/**
*  分享
* 分享list一个则直接分享，多个则出现分享到列表对话框。
**/
Yodo1U3dUtils.share();
//设置分享结果回调
Yodo1U3dSDK.setShareDelegate(ShareDelegate);
```

**Facebook分享** 使用unity插件6.1.3及之后的版本需要在xcode中做以下配置
#### 1.打开`项目target`->`Build Phases`->`Embed Frameworks`
选中`+`，添加`Add Other...`，如图所示：

<!-- markdownlint-disable -->
<figure> 
	 <img src="/zh/assets/images/xcode_share_0.png" width="300">
    <img src="/zh/assets/images/xcode_share_1.png" width="300">
</figure>
<!-- markdownlint-restore -->

#### 2.分别添加`FBSDKShareKit.framework` `FBSDKCoreKit_Basics.framework` `FBSDKCoreKit.framework` `FBAEMKit.framework`
对应的路径分别是：
`Pods/FBSDKShareKit/XCFrameworks/FBSDKShareKit.xcframework/ios-arm64_armv7/FBSDKShareKit.framework`
`Pods/FBSDKCoreKit_Basics/XCFrameworks/FBSDKCoreKit_Basics.xcframework/ios-arm64_armv7/FBSDKCoreKit_Basics.framework`
`Pods/FBSDKCoreKit/XCFrameworks/FBSDKCoreKit.xcframework/ios-arm64_armv7/FBSDKCoreKit.framework`
`Pods/FBAEMKit/XCFrameworks/FBAEMKit.xcframework/ios-arm64_armv7/FBAEMKit.framework`

如图所示：
<!-- markdownlint-disable -->
<figure> 
	 <img src="/zh/assets/images/xcode_share_2.png" width="300">
    <img src="/zh/assets/images/xcode_share_3.png" width="300">
    <img src="/zh/assets/images/xcode_share_4.png" width="300">
    <img src="/zh/assets/images/xcode_share_5.png" width="300">
    <img src="/zh/assets/images/xcode_share_6.png" width="300">
</figure>
<!-- markdownlint-restore -->

#### 3.添加完成，如图所示：
<!-- markdownlint-disable -->
<figure> 
	 <img src="/zh/assets/images/xcode_share_7.png" width="300">
<!-- markdownlint-restore -->