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
