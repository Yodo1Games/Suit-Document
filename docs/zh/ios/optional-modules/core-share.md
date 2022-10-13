# Share 集成

**开始前**:

>* ' iOS14 '要求' Xcode '版本为' 12+ '，请确保升级你的' Xcode '版本为' 12+ '。
>* ' SDK '要求' iOS '的最低版本为' iOS10.0 '
>*最简单的方法是使用' CocoaPods '(请使用' 1.10 '及以上)，如果你是' CocoaPods '的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using -cocoapods)，学习如何创建和使用' Podfile '

## 集成SDK

### 添加`iOS SDK`到项目中

#### 创建 `Podfile` 文件</br>

在项目的根目录中创建`Podfile`文件

```ruby
touch Podfile
```

#### 引入iOS SDK到项目中</br>

请打开项目中的`Podfile`文件并且将下面的代码添加到文件中:

```ruby
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1Share', '1.0.0'
```

在`终端`中执行以下命令:</br>

```ruby
pod install --repo-update
```

## `Xcode`项目配置

### 配置`LSApplicationQueriesSchemes`

需要在`Info.plist`中配置`LSApplicationQueriesSchemes`

* 添加 `LSApplicationQueriesSchemes` 类型 `Array`

``` xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbauth2</string>
  <string>fb-messenger-share-api</string>
  <string>fbshareextension</string>
  <string>fbapi</string>
  <string>sinaweibo</string>
  <string>weibosdk</string>
  <string>weibosdk2.5</string>
  <string>weixin</string>
  <string>weixinULAPI</string>
  <string>mqqapi</string>
  <string>mqqopensdkapiV2</string>
  <string>mqq</string>
  <string>mttbrowser</string>
  <string>weibosdk3.3</string>
  <string>mqqOpensdkSSoLogin</string>
  <string>mqzone</string>
  <string>mqqopensdkapiV3</string>
  <string>mqqapiwallet</string>
  <string>mqqwpa</string>
  <string>mqqbrowser</string>
  <string>mqqopensdknopasteboard</string>
</array>
```

### 设置URL types

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/ios_share_urltypes.png" width="300">
</figure>

## 集成步骤

### 初始化

#### 引入头文件`Yodo1Share.h`

``` obj-c
#import "Yodo1Share.h"
```

#### 初始化方式有两种（任选其一）

``` obj-c
- (void)initWithConfig:(nullable NSDictionary*)shareAppIds;
```

#### 初始化方式①

在`Info.plist` 文件中设置`AppId`和`Universal`

``` xml
<key>QQAppId</key> 
<string>[QQ AppdId]</string> 
<key>QQUniversalLink</key> 
<string>[QQ Universal Link]</string> 
<key>WechatAppId</key> 
<string>[Wechat AppId]</string>
<key>WechatUniversalLink</key> 
<string>[Wechat Universal Link]</string>
<key>SinaAppId</key> 
<string>[Sina AppId]</string> 
<key>SinaUniversalLink</key> 
<string>[Sina Universal Link]</string>
<key>FacebookAppID</key> 
<string>[Facebook AppID]</string> 

```

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/ios_ua_setting_0.png" width="300">
</figure>

##### 示例代码

``` obj-c
[[Yodo1Share sharedInstance]initWithConfig:nil];
```

#### 初始化方式②

##### 示例代码

``` obj-c
[[Yodo1Share sharedInstance] initWithConfig:@{kYodo1QQAppId:@"QQ AppdId",
                                                    kYodo1QQUniversalLink:@"QQ Universal Link",
                                                    kYodo1WechatAppId:@"Wechat AppId",
                                                    kYodo1WechatUniversalLink:@"Wechat Universal Link",
                                                    kYodo1SinaWeiboUniversalLink:@"Sina Universal Link",
                                                    kYodo1SinaWeiboAppKey:@"Sina AppKey",
                                                    kYodo1FacebookAppId:@"Facebook AppId",
                                                    kYodo1FacebookDisplayName:@"Facebook Display Name"}];
```

<font color=red>特殊: </font>如果需要使用Facebook分享功能，需要在`Info.plist`单独配置

``` xml
<key>FacebookAppID</key> 
<string>[Facebook AppID]</string>
```

### 分享

``` obj-c
@interface ShareContent : NSObject
@property (nonatomic,assign) Yodo1ShareType shareType;  //平台分享类型
@property (nonatomic,strong) NSString *title;       //仅对qq和微信有效
@property (nonatomic,strong) NSString *desc;        //分享描述
@property (nonatomic,strong) UIImage *image;        //分享图片
@property (nonatomic,strong) NSString *url;         //分享URL
@property (nonatomic,strong) UIImage *qrLogo;       //二维码logo
@property (nonatomic,strong) NSString *qrText;      //二维码右边的文本
@property (nonatomic,assign) float qrTextX;         //文字X偏移量
@property (nonatomic,assign) float qrImageX;        //二维码偏移量
@property (nonatomic,strong) UIImage *gameLogo;    //Share App of Logo
@property (nonatomic,assign) float gameLogoX;      //sharelogoX偏移量

@end

// 调用分享
- (void)showSocial:(nonnull ShareContent *)content
             block:(nullable ShareCompletionBlock)completionBlock;
```

#### 示例代码

``` obj-c
ShareContent* content = [[ShareContent alloc]init];
content.image = [UIImage imageNamed:@"share_test_image.jpg"];
content.title = @"测试";
content.desc = @"亲爱的xxxxxx";
content.url = @"https://itunes.apple.com/xxx";
content.gameLogo = [UIImage imageNamed:@"sharelogo.png"];
content.qrLogo = [UIImage imageNamed:@"AppIcon"];
content.qrText = @"一起长按识别别\n二维码分享分享 \n 求挑战！求带走！\n 求挑战！求带走！";
content.shareType = Yodo1ShareTypeAll;
    
[[Yodo1Share sharedInstance] showSocial:content block:^(Yodo1ShareType shareType, Yodo1ShareContentState state, NSError *error) {
       
}];
```

### 添加生命周期方法

#### 示例代码：（在`delegate`中openURL:sourceApplication:annotation:）

``` obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    return [[Yodo1Share sharedInstance]application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
```

#### 示例代码：（在`delegate`中openURL:options:）

``` obj-c
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    return [[Yodo1Share sharedInstance]application:application openURL:url options:options];
}
```

## 其他

### 获取SDK版本信息

``` obj-c
/**
 *  获取SDK版本
 */
- (NSString *)getSdkVersion;
```

### 开启日志

默认是不开启日志，上架之前请先关闭日志

``` obj-c
/**
 *  开启日志（默认是NO，不开启）
 */
- (void)setDebugLog:(BOOL)debugLog;
```