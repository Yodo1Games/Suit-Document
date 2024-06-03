# 社交功能

**集成准备**:

>* 下载[Unity插件](https://sdk-artifacts.yodo1.com/Yodo1Social/1.0.0/Unity/Release/Yodo1Social-1.0.0.unitypackage)

## 集成配置

### `Android`配置

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_edit_social_0.png" width="500"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_edit_social_android.png" width="500"> 
</figure>

#### 新浪微博配置

* [Weibo] AppKey: 新浪微博AppKey，用来鉴证第三方应用的身份，显示来源等。
* [Weibo] UniversalLink: 用于分享功能，苹果官方文档 [Support Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW1)。
* [Weibo] RedirectURI: 应用回调页，在进行授权登录认证时使用。

#### Facebook配置
* If you don't have a Facebook App ID for your app yet, see [Facebook SDK Quick Start for Android](https://developers.facebook.com/docs/android/getting-started#getting-started-with-the-facebook-sdk-for-android).
* Find your Facebook App ID on the [Apps](https://developers.facebook.com/apps) page of the developer portal and then see [Client Token](https://developers.facebook.com/docs/facebook-login/guides/access-tokens#clienttokens).

#### 配置游戏Logo和二维码Logo
* Game Logo File: 合成分享图片所需的游戏logo
* QR Logo File: 合成分享图片所需要的二维码logo

### `iOS`配置

<figure> 
    <img src="/zh/assets/images/unity_edit_social_0.png" width="500"> 
</figure>

<figure> 
    <img src="/zh/assets/images/unity_edit_social_ios.png" width="500"> 
</figure>

#### QQ配置

* [QQ] AppId: QQ的AppId
* [QQ] UniversalLink: QQ通用链接

#### 微信配置

* [WeChat] AppId: WeChat的AppId
* [WeChat] UniversalLink: WeChat通用链接

#### 新浪微博配置

* [Weibo] AppKey: 新浪微博AppKey，用来鉴证第三方应用的身份，显示来源等。
* [Weibo] UniversalLink: 通用链接，用于分享功能，苹果官方文档 [Support Universal Links](https://developer.apple.com/library/archive/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW1)。
* [Weibo] RedirectURI: 应用回调页，在进行授权登录认证时使用。

#### Facebook配置

* Find your Facebook App ID on the [Apps](https://developers.facebook.com/apps) page of the developer portal.

#### 配置游戏Logo和二维码Logo
* Game Logo File: 合成分享图片所需的游戏logo
* QR Logo File: 合成分享图片所需要的二维码logo

## 集成SDK

### 初始化SDK

在你初始化SDK的文件顶部包括以下行:

```c#
using Yodo1.Social;
```

推荐在`Start`方法中调用SDK初始化

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void Initialize();
```

* 初始化是根据编辑面板配置进行初始化

#### 示例代码

下面的例子演示了如何在`Start`方法中调用SDK初始化

```c#
void Start()  {
    Yodo1U3dSocial.Initialize();
}
```

### 授权关注

```c#
public static void Authorize(Yodo1U3dSocialType type = Yodo1U3dSocialType.Yodo1SocialTypeWeibo)
```

#### 授权回调

```c#
public static event System.Action<Yodo1U3dSocialAuthorizeResult> OnAuthorizeResultEvent;
```

#### 示例代码

```c#
void Start()
{
    Yodo1U3dSocial.Initialize();
    Yodo1U3dSocialSDK.OnAuthorizeResultEvent += HandleAuthorizeEvent;
}

void HandleAuthorizeEvent(Yodo1U3dSocialAuthorizeResult result)
{
    Debug.Log("HandleAuthorizeEvent Status: " + result.Status.ToString());
    if (result.Status == Yodo1U3dSocialBaseResult.SocialStatus.Success)
    {
        if (result.Follow)
        {
            // TODO Give rewards to the player
            Debug.Log("HandleAuthorizeEvent authorize success, the rewards should be give to the player.");
        }
        else
        {
            // TODO Remind the player to follow the official account to get rewards
            Debug.Log("HandleAuthorizeEvent authorize success, but have not follow the official account yet, so unable to receive rewards.");
        }
    }
    else if (result.Status == Yodo1U3dSocialBaseResult.SocialStatus.Cancel)
    {
        // TODO The player cancelled
        Debug.LogFormat("HandleAuthorizeEvent authorize cancelled by the player");
    }
    else if (result.Status == Yodo1U3dSocialBaseResult.SocialStatus.Failed)
    {
        if (result.Error.Code == Yodo1U3dSocialBaseResult.SocialError.AppNotInstalled)
        {
            // TODO App is not installed, remind the player to re-authorize and follow the official account after installing the App
            Debug.Log("HandleAuthorizeEvent authorize failure, the app is not installed, please re-authorize and follow the official account after installing the App");
        }
        else
        {
            // Authorize failure
            Debug.LogFormat("HandleAuthorizeEvent authorize failure with error({0},{1})", result.Error.Code, result.Error.Message);
        }
    }
}
```

### 分享功能

```c#
public static void Share(Yodo1U3dShareContent shareContent);
```

* `shareContent`是分享需要使用的内容

#### Yodo1U3dShareContent 结构

```c#
public Yodo1U3dShareType ShareType;
public Yodo1U3dShareContentType ContentType;
public string ContentTitle
public string ContentText;
public string ContentImage;
public string ContentUrl;
public string QrLogo;
public string QrText;
public float QrTextX;
public float QrImageX;
public string GameLogo;
public float GameLogoX;
public bool Composite;
```

| 参数名称     | 描述                                      |
| :----------- | :---------------------------------------- |
| ShareType    | 分享类型                                  |
| ContentType  | 分享内容类型(Link或者Image)               |
| ContentTitle | 分享标题(仅对qq和微信有效)                |
| ContentText  | 分享文字描述                              |
| ContentImage | 分享的图片                                |
| ContentUrl   | 分享的url(微信是链接地址)                 |
| QrLogo       | 二维码logo                                |
| QrText       | 二维码右边的文本,根据\n这个符号来分行     |
| GameLogo     | 分享到微信平台的Logo                      |
| GameLogoX    | 分享到微信平台的Logo偏移量(仅在iOS上有效) |
| QrTextX      | 文字偏移量(仅在iOS上有效)                 |
| QrImageX     | 二维码偏移量(仅在iOS上有效)               |
| Composite    | 是否启用图片合成(仅在Android上有效)       |

#### Yodo1U3dShareType 结构

``` c#
Yodo1ShareTypeTencentQQ = 1 << 0,/**< QQ分享 >*/
Yodo1ShareTypeWechatMoments = 1 << 1,/**< 朋友圈 >*/
Yodo1ShareTypeWechatContacts = 1 << 2, /**< 聊天界面 >*/
Yodo1ShareTypeSinaWeibo = 1 << 3,/**< 新浪微博 >*/
Yodo1ShareTypeFacebook = 1 << 4,/**< Facebook >*/
Yodo1ShareTypeAll = 1 << 5 /**< 所有平台分享 >*/
```

| 参数名称                     | 描述         | 备注  |
| :--------------------------- | :----------- | :---- |
| Yodo1ShareTypeTencentQQ      | QQ朋友圈     | 仅iOS |
| Yodo1ShareTypeWechatMoments  | 微信朋友圈   | 仅iOS |
| Yodo1ShareTypeWechatContacts | 微信聊天界面 | 仅iOS |
| Yodo1ShareTypeSinaWeibo      | 新浪微博     |       |
| Yodo1ShareTypeFacebook       | Facebook     |       |
| Yodo1ShareTypeAll            | 所有分享平台 |       |

#### Yodo1U3dShareContentType 结构

``` c#
LINK = 0,
IMAGE = 1,
```

#### 示例代码

``` c#
Yodo1U3dShareContent shareContent = new Yodo1U3dShareContent();
shareContent.ShareType = Yodo1U3dShareType.Yodo1ShareTypeAll;
shareContent.ContentType = Yodo1U3dShareContentType.LINK;
shareContent.ContentTitle = "<Title>";
shareContent.ContentText = "<Text>";
shareContent.ContentImage = "<Your Game Image>";
shareContent.ContentUrl = "<Url>";
shareContent.GameLogo = "<Game Logo Image>";
shareContent.GameLogoX = 0;
shareContent.QrLogo = "<QR Logo Image>";
shareContent.QrText = "长按识别二维码 \n 求挑战！求带走！";
shareContent.QrTextX = 0;
shareContent.QrImageX = 0;
shareContent.Composite = false;

Yodo1U3dSocial.Share(shareContent);
```

>* 注意
>
* shareContent.ShareType 可以自由组合，例：
 
``` c# 
shareContent.ShareType = Yodo1U3dShareType.Yodo1ShareTypeTencentQQ | 
                      Yodo1U3dShareType.Yodo1ShareTypeWechatMoments | 
                      Yodo1U3dShareType.Yodo1ShareTypeWechatContacts;
```

### 分享回调

``` c# 
public static event System.Action<Yodo1U3dShareResult> OnShareResultEvent;
```

#### 示例代码

``` c# 
Yodo1U3dSocialSDK.OnShareResultEvent += (Yodo1U3dShareResult shareResult) =>
{
	Debug.LogFormat("{0} Yodo1ShareResult {1}", Yodo1U3dShare.TAG, shareResult.ToString());
};
```

## 其他

### 获取SDK版本信息

```c#
/// <summary>
/// The GetSdkVersion method get sdk version.
/// </summary>
public static string GetSdkVersion();
```

### 开启日志

默认是不开启日志，上架之前请先关闭日志

```c#
/// <summary>
/// Whether to enable logging.
/// </summary>
public static void SetDebugLog(bool debugLog);
```

### 检查是否安装了App 

```c#
public static bool IsAppInstalled(Yodo1U3dSocialType type)
```