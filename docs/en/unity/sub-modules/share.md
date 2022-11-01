# Share Plugin

**Getting started**:

>* Download [Unity Plugin](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Share/Yodo1-Share-1.0.0.unitypackage)

## Integrate Configuration

### `Android` Configuration

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_edit_share_0.png" width="500"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_edit_share_android.png" width="500"> 
</figure>

#### Facebook Configuration
* If you don't have a Facebook App ID for your app yet, see [Facebook SDK Quick Start for Android](https://developers.facebook.com/micro_site/url/?click_from_context_menu=true&country=CN&destination=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fandroid%2Fgetting-started%23quick-start&event_type=click&last_nav_impression_id=1xS9zpVpa1paH5FcB&max_percent_page_viewed=25&max_viewport_height_px=920&max_viewport_width_px=1728&orig_http_referrer=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fsharing%2Fandroid%2F&orig_request_uri=https%3A%2F%2Fdevelopers.facebook.com%2Fajax%2Fdocs%2Fnav%2F%3Fpath1%3Dsharing%26path2%3Dandroid&region=apac&scrolled=true&session_id=1Hod3pJy5Oxr1a6Yk&site=developers).
* Find your Facebook App ID on the [Apps](https://developers.facebook.com/micro_site/url/?click_from_context_menu=true&country=CN&destination=https%3A%2F%2Fdevelopers.facebook.com%2Fapps&event_type=click&last_nav_impression_id=1xS9zpVpa1paH5FcB&max_percent_page_viewed=25&max_viewport_height_px=920&max_viewport_width_px=1728&orig_http_referrer=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fsharing%2Fandroid%2F&orig_request_uri=https%3A%2F%2Fdevelopers.facebook.com%2Fajax%2Fdocs%2Fnav%2F%3Fpath1%3Dsharing%26path2%3Dandroid&region=apac&scrolled=true&session_id=1Hod3pJy5Oxr1a6Yk&site=developers) page of the developer portal and then see [Add Your Facebook App ID and Client Token](https://developers.facebook.com/micro_site/url/?click_from_context_menu=true&country=CN&destination=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fandroid%2Fgetting-started%23app_id&event_type=click&last_nav_impression_id=1xS9zpVpa1paH5FcB&max_percent_page_viewed=25&max_viewport_height_px=920&max_viewport_width_px=1728&orig_http_referrer=https%3A%2F%2Fdevelopers.facebook.com%2Fdocs%2Fsharing%2Fandroid%2F&orig_request_uri=https%3A%2F%2Fdevelopers.facebook.com%2Fajax%2Fdocs%2Fnav%2F%3Fpath1%3Dsharing%26path2%3Dandroid&region=apac&scrolled=true&session_id=1Hod3pJy5Oxr1a6Yk&site=developers).

#### Game and QR code Logos
* Game Logo File: The game logo is required by compose share the image, please ignore it if you don't need a composite image
* QR Logo File: The QR logo is required by compose share the image, please ignore it if you don't need a composite image

### `iOS` Configuration

<figure> 
    <img src="/zh/assets/images/unity_edit_share_0.png" width="500"> 
</figure>

<figure> 
    <img src="/zh/assets/images/unity_edit_share_ios.png" width="500"> 
</figure>

| Key                | Describe           |
| ------------------ | ------------------ |
| QQAppId            | QQ App Id          |
| QQUniversalLink    | QQ Universal Link  |
| WechatAppId        | WeChat App Id      |
| WechatUniversalLink| WeChat Universal Link |
| SinaAppId          | Sina App Id       |
| SinaUniversalLink  | Sina Universal Link |
| FacebookAppId      | Facebook App Id     |

## Integrate SDK

### Initialize SDK

Include the following line at the top of the file where you initialize the SDK

```c#
using Yodo1.Share;
```

It is recommended to call SDK initialization in the `Start` method

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void Initialize();
```

* Initialization is based on the edit panel configuration

#### Sample Code

The following example showing how to call SDK initialization in the `Start` method

```c#
void Start()  {
    Yodo1U3dShare.Initialize();
}
```

### Sharer

```c#
public static void Share(Yodo1U3dShareContent shareContent);
```

* `shareContent` is for sharing what needs to be used

#### `Yodo1U3dShareContent` Structure

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

| Key         | Describe                       |
| ----------- | ----------------------------- |
| ShareType   | Share type, e.g. Facebook, WeChat         |
| ContentType | Share content type(Link or Image)         |
| ContentTitle| Share title(Only valid for QQ and WeChat) |
| ContentText | Share Text description                    |
| ContentImage| Game image to share                       |
| ContentUrl  | The content Url string                    |
| QrLogo      | QR logo file name                         |
| QrText      | QR text, you can use '\n' to split lines  |
| GameLogo    | Game logo file name                       |
| GameLogoX   | Offset X of game Logo (Only valid on iOS)                   |
| QrTextX     | Offset X of QR text (Only valid on iOS)                     |
| QrImageX    | Offset X of QR image(Only valid on iOS)                     |
| Composite   | Whether image compositing is enabled(Only valid on Android) |

#### `Yodo1U3dShareType` Structure

``` c#
Yodo1ShareTypeTencentQQ = 1 << 0,
Yodo1ShareTypeWeixinMoments = 1 << 1,
Yodo1ShareTypeWeixinContacts = 1 << 2,
Yodo1ShareTypeSinaWeibo = 1 << 3,
Yodo1ShareTypeFacebook = 1 << 4,
Yodo1ShareTypeAll = 1 << 5
```

| Key                         | Describe                |
| --------------------------- | ----------------------- |
| Yodo1ShareTypeTencentQQ     | Share to QQ             |
| Yodo1ShareTypeWeixinMoments | Share to WeChat Moments |
| Yodo1ShareTypeWeixinContacts| Share to WeChat Contacts|
| Yodo1ShareTypeSinaWeibo     | Share to Sina           |
| Yodo1ShareTypeFacebook      | Share to Facebook       |
| Yodo1ShareTypeAll           | Share to all platform   |

#### `Yodo1U3dShareContentType` Structure

``` c#
LINK = 0,
IMAGE = 1,
```

#### Sample Code

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

>* Note
>
* shareContent.ShareType can be combined freely, the sample is as follows:
 
``` c# 
shareContent.ShareType = Yodo1U3dShareType.Yodo1ShareTypeTencentQQ | 
                      Yodo1U3dShareType.Yodo1ShareTypeWeixinMoments | 
                      Yodo1U3dShareType.Yodo1ShareTypeWeixinContacts;
```

### Set the share callback event

``` c# 
public static event System.Action<Yodo1U3dShareResult> OnResultEvent;
```

#### Sample Code

``` c# 
Yodo1U3dShareSDK.OnResultEvent += (Yodo1U3dShareResult shareResult) =>
{
	Debug.LogFormat("{0} Yodo1ShareResult {1}", Yodo1U3dShare.TAG, shareResult.ToString());
};
```

## Other Methods

### Get the SDK version

```c#
/// <summary>
/// The GetSdkVersion method get sdk version.
/// </summary>
public static string GetSdkVersion();
```

### Enable the debug log

The debug log is disabled by default. Please disable it before release to App stores

```c#
/// <summary>
/// Whether to enable logging.
/// </summary>
public static void SetDebugLog(bool debugLog);
```