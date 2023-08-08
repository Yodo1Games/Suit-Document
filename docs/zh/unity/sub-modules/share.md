# 分享功能集成

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Share/Yodo1-Share-1.0.3.unitypackage)

## 集成配置

### `Android`配置

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_edit_share_0.png" width="500"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_edit_share_android.png" width="500"> 
</figure>

#### Facebook配置
* If you don't have a Facebook App ID for your app yet, see [Facebook SDK Quick Start for Android](https://developers.facebook.com/micro_site/url/?click_from_context_menu=true&country=CN&destination=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fandroid%2Fgetting-started%23quick-start&event_type=click&last_nav_impression_id=1xS9zpVpa1paH5FcB&max_percent_page_viewed=25&max_viewport_height_px=920&max_viewport_width_px=1728&orig_http_referrer=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fsharing%2Fandroid%2F&orig_request_uri=https%3A%2F%2Fdevelopers.facebook.com%2Fajax%2Fdocs%2Fnav%2F%3Fpath1%3Dsharing%26path2%3Dandroid&region=apac&scrolled=true&session_id=1Hod3pJy5Oxr1a6Yk&site=developers).
* Find your Facebook App ID on the [Apps](https://developers.facebook.com/micro_site/url/?click_from_context_menu=true&country=CN&destination=https%3A%2F%2Fdevelopers.facebook.com%2Fapps&event_type=click&last_nav_impression_id=1xS9zpVpa1paH5FcB&max_percent_page_viewed=25&max_viewport_height_px=920&max_viewport_width_px=1728&orig_http_referrer=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fsharing%2Fandroid%2F&orig_request_uri=https%3A%2F%2Fdevelopers.facebook.com%2Fajax%2Fdocs%2Fnav%2F%3Fpath1%3Dsharing%26path2%3Dandroid&region=apac&scrolled=true&session_id=1Hod3pJy5Oxr1a6Yk&site=developers) page of the developer portal and then see [Add Your Facebook App ID and Client Token](https://developers.facebook.com/micro_site/url/?click_from_context_menu=true&country=CN&destination=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fandroid%2Fgetting-started%23app_id&event_type=click&last_nav_impression_id=1xS9zpVpa1paH5FcB&max_percent_page_viewed=25&max_viewport_height_px=920&max_viewport_width_px=1728&orig_http_referrer=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fsharing%2Fandroid%2F&orig_request_uri=https%3A%2F%2Fdevelopers.facebook.com%2Fajax%2Fdocs%2Fnav%2F%3Fpath1%3Dsharing%26path2%3Dandroid&region=apac&scrolled=true&session_id=1Hod3pJy5Oxr1a6Yk&site=developers).

#### 配置游戏和二维码Logo
* Game Logo File: 合成分享图片所需的游戏logo
* QR Logo File: 合成分享图片所需要的二维码logo

### `iOS`配置

<figure> 
    <img src="/zh/assets/images/unity_edit_share_0.png" width="500"> 
</figure>

<figure> 
    <img src="/zh/assets/images/unity_edit_share_ios.png" width="500"> 
</figure>

| 参数名称            | 描述                |
| ------------------ | ------------------ |
| QQAppId            | QQ App Id          |
| QQUniversalLink    | QQ通用链接           |
| WechatAppId        | 微信App Id          |
| WechatUniversalLink| 微信通用链接          |
| SinaAppId          | 新浪微博App Id       |
| SinaUniversalLink  | 新浪微博通用链接      |
| FacebookAppId      | Facebook App Id     |

## 集成SDK

### 初始化SDK

在你初始化SDK的文件顶部包括以下行:

```c#
using Yodo1.Share;
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
    Yodo1U3dShare.Initialize();
}
```

### 分享

```c#
public static void Share(Yodo1U3dShareContent shareContent);
```

* `shareContent`是分享需要使用的内容

#### Yodo1U3dShareContent 结构

```c#
public Yodo1U3dShareType ShareType;
public Yodo1U3dShareContentType ContentType;
public string ContentTitle;
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

| 参数名称     | 描述                           |
| ----------- | ----------------------------- |
| ShareType   | 分享类型                        |
| ContentType | 分享内容类型(Link或者Image)       |
| ContentTitle| 分享标题(仅对qq和微信有效)         |
| ContentText | 分享文字描述                     |
| ContentImage| 分享的图片                       |
| ContentUrl  | 分享的url(微信是链接地址)         |
| QrLogo      | 二维码logo                      |
| QrText      | 二维码右边的文本,根据\n这个符号来分行|
| GameLogo    | 分享到微信平台的Logo             |
| GameLogoX   | 分享到微信平台的Logo偏移量(仅在iOS上有效)  |
| QrTextX     | 文字偏移量(仅在iOS上有效)                |
| QrImageX    | 二维码偏移量(仅在iOS上有效)              |
| Composite   | 是否启用图片合成(仅在Android上有效)       |

#### Yodo1U3dShareType 结构

``` c#
Yodo1ShareTypeTencentQQ = 1 << 0,/**< QQ分享 >*/
Yodo1ShareTypeWeixinMoments = 1 << 1,/**< 朋友圈 >*/
Yodo1ShareTypeWeixinContacts = 1 << 2, /**< 聊天界面 >*/
Yodo1ShareTypeSinaWeibo = 1 << 3,/**< 新浪微博 >*/
Yodo1ShareTypeFacebook = 1 << 4,/**< Facebook >*/
Yodo1ShareTypeAll = 1 << 5 /**< 所有平台分享 >*/
```

| Key名称                    | 描述          |
| ------------------------- | ------------- |
| Yodo1ShareTypeTencentQQ     | QQ朋友圈       |
| Yodo1ShareTypeWeixinMoments | 微信朋友圈      |
| Yodo1ShareTypeWeixinContacts| 微信聊天界面    |
| Yodo1ShareTypeSinaWeibo     | 新浪微博       |
| Yodo1ShareTypeFacebook      | Facebook      |
| Yodo1ShareTypeAll           | 所有分享平台    |

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

Yodo1U3dShare.Share(shareContent);
```

>* 注意
>
* shareContent.ShareType 可以自由组合，例：
 
``` c# 
shareContent.ShareType = Yodo1U3dShareType.Yodo1ShareTypeTencentQQ | 
                      Yodo1U3dShareType.Yodo1ShareTypeWeixinMoments | 
                      Yodo1U3dShareType.Yodo1ShareTypeWeixinContacts;
```

### 分享回调

``` c# 
public static event System.Action<Yodo1U3dShareResult> OnResultEvent;
```

#### 示例代码

``` c# 
Yodo1U3dShareSDK.OnResultEvent += (Yodo1U3dShareResult shareResult) =>
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