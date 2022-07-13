# 设备信息获取

## 获取设备id,SIM,国家码,语言，版本号等

``` c#
/**
 * 获取设备id
 */
Yodo1U3dUtils.getDeviceId();
/**
 * 获取PlayId>uid>deviceId
 */
Yodo1U3dUtils.getUserId();
/**
 * 获取当前系统地区
 */
Yodo1U3dUtils.getCountryCode();
/**
 * 设置当前应用语言
 */
Yodo1U3dSDK.SetLocalLanguage();
/**
 * 获取设备的sim卡
 *
 * @return 无卡 : 0   cmcc : 1   ct : 2   cu : 4
 */
Yodo1U3dUtils.getSIM();
/**
 * 获取版本号
 */
Yodo1U3dUtils.getVersionName();
/**
 * 判断是否是中国大陆.ext为空。
 */
Yodo1U3dUtils.IsChineseMainland();
```

## 获取渠道号

``` c#
/**
 * 获取当前渠道号。
 */
//Yodo1U3dUtils.getSdkcode();
/**
 * 获取发布渠道
 */
Yodo1U3dUtils.GetPublishChannelCode();
```