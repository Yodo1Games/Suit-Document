# Share

**集成准备**:

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/UA/Yodo1-UA-1.0.0.unitypackage)
>* SDK支持Unity LTS 版本（2019或更高版本）
>* SDK支持Android API 19+
>* `CocoaPods`是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
>* iOS14需要`Xcode` 12+，请确保你的`Xcode`是最新的。

## 集成配置

### 1. `Android`配置

#### 1.1 设置支持AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) 是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 来启用它，如下图所示：

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

## 集成SDK

### 初始化SDK

推荐在`Start`方法中调用SDK初始化

```c#
/// <summary>
/// Initialize the default instance of the SDK.
/// </summary>
public static void InitializeWithConfig(Yodo1U3dShareConfig config);
```

* `config`是初始化需要使用的各个分享平台的`AppId`和`UniversalLink`

#### Yodo1U3dShareConfig结构

```c#
// QQ Share
public string QQAppId;
public string QQUniversalLink;
// WeChat Share
public string WechatAppId;
public string WechatUniversalLink;
// Sina Share
public string SinaAppId;
public string SinaUniversalLink;
// Facebook Share
public string FacebookAppId;
public string FacebookDisplayName;
```

| 参数名称                    | 描述                              |
| ------------------ | ------------------ |
| QQAppId                     | QQ App Id                    |
| QQUniversalLink          | QQ通用链接                  |
| WechatAppId               | 微信App Id                   |
| WechatUniversalLink    | 微信通用链接                |
| SinaAppId                   | 新浪微博App Id             |
| SinaUniversalLink        | 新浪微博通用链接          |
| FacebookAppId           | Facebook App Id           |
| FacebookDisplayName | Facebook Display Name |

#### 示例代码

下面的例子演示了如何在`Start`方法中调用SDK初始化

```c#
void Start()  {

	Yodo1U3dShareConfig config = new Yodo1U3dShareConfig();
    config.QQAppId = "<QQ_App_Id>";
    config.QQUniversalLink = "<QQ_Universal_Link>";
    config.WechatAppId = "<Wechat_App_Id>";
    config.WechatUniversalLink = "<Wechat_Universal_Link>";
    config.SinaAppId = "<Sina_App_Id>";
    config.SinaUniversalLink = "<Sina_Universal_Link>";
    config.FacebookAppId = "<Facebook_App_Id>";
    config.FacebookDisplayName = "<Facebook_Display_Name>";
    Yodo1U3dShare.InitializeWithConfig(config);
}
```

>* 注意
>
* 给个分享平台都是可以自由组合选择配置，如果不设置对应平台的`AppId`和`UniversalLink`（`DisplayName`）则表示不使用该分享平台

### 分享

```c#
public static void Share(Yodo1U3dShareInfo shareInfo);
```

* `shareInfo`是分享需要使用的内容

#### Yodo1U3dShareInfo结构

```c#
public Yodo1U3dShareConstants.Yodo1SNSType SNSType;
public string Title;
public string Desc;
public string Image;
public string QrLogo;
public string QrText;
public string Url;
public string GameLogo;
public float GameLogoX;
public float QrTextX;
public float QrImageX;
public bool Composite;
```

| 参数名称     | 描述                    |
| ----------- | ---------------------- |
| SNSType     | 分享类型                |
| Title       | 分享标题(仅对qq和微信有效) |
| Desc        | 分享文字描述             |
| Image       | 分享的图片               |
| QrLogo      | 二维码logo              |
| QrText      | 二维码右边的文本,根据\n这个符号来分行|
| Url         | 分享的url(微信是链接地址)  |
| GameLogo    | 分享到微信平台的Logo      |
| GameLogoX   | 分享到微信平台的Logo偏移量 |
| QrTextX     | 文字偏移量                          |
| QrImageX    | 二维码偏移量                       |
| Composite   | 是否启用图片合成                 |

#### Yodo1SNSType结构

``` c#
Yodo1SNSTypeNone(-1),
Yodo1SNSTypeTencentQQ(1 << 0), //朋友圈
Yodo1SNSTypeWeixinMoments(1 << 1), //朋友圈
Yodo1SNSTypeWeixinContacts(1 << 2),//聊天界面
Yodo1SNSTypeSinaWeibo(1 << 3), //新浪微博
Yodo1SNSTypeFacebook(1 << 4), //Facebook
Yodo1SNSTypeAll(1 << 5); //所有平台分享
```

| Key名称                    | 描述          |
| ------------------------- | ------------- |
| Yodo1SNSTypeNone          |               |
| Yodo1SNSTypeTencentQQ     | QQ朋友圈       |
| Yodo1SNSTypeWeixinMoments | 微信朋友圈      |
| Yodo1SNSTypeWeixinContacts| 微信聊天界面    |
| Yodo1SNSTypeSinaWeibo     | 新浪微博       |
| Yodo1SNSTypeFacebook      | Facebook      |
| Yodo1SNSTypeAll           | 所有分享平台    |

#### 示例代码


``` c#
Yodo1U3dShareInfo shareInfo = new Yodo1U3dShareInfo();
shareInfo.SNSType = Yodo1U3dShareConstants.Yodo1SNSType.Yodo1SNSTypeAll;
shareInfo.Title = "<Title>";
shareInfo.Desc = "<Desc>";
shareInfo.Image = "share_test_image.png";
shareInfo.Url = "<Url>";
shareInfo.GameLogo = "sharelogo.png";
shareInfo.GameLogoX = 0;
shareInfo.QrLogo = "qrLogo.png";
shareInfo.QrText = "长按识别二维码 \n 求挑战！求带走！";
shareInfo.QrTextX = 0;
shareInfo.QrImageX = 0;
shareInfo.Composite = true;

Yodo1U3dShare.Share(shareInfo);
```

>* 注意
>
* shareInfo.SNSType可以自由组合，例：
 
``` c# 
 shareInfo.SNSType = Yodo1U3dShareConstants.Yodo1SNSType.Yodo1SNSTypeTencentQQ | Yodo1U3dShareConstants.Yodo1SNSType.Yodo1SNSTypeWeixinMoments | Yodo1U3dShareConstants.Yodo1SNSType.Yodo1SNSTypeWeixinContacts;
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