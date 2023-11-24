# 录制屏幕功能

注意: 从 6.3.7 版本开始，下面的方法已经已经废弃，请仔细阅读下面新的集成文档

``` c#
Yodo1U3dPublish.BeginRecordVideo();
Yodo1U3dPublish.IsCaptureSupported();
//只iOS
Yodo1U3dPublish.StopRecordVideo();
//只iOS
Yodo1U3dPublish.ShowRecordVideo();
```

## 概述

录制能力为Suit SDK的子能力，通过接入该功能，可以实现游戏内容录制，并可以实现游戏创作内容快速分享。

* 录制能力支持：Apple录屏，抖音录屏
* 录屏方式支持：自动录制，自由录制

## 集成配置

### iOS配置

如需集成抖音录屏分享能力，请在编辑器中设置抖音录屏分享需要的`App Id`和`Client Key`

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/screen_record_setting_ios.png" width="500"> 
</figure>

## SDK初始化

### 调用时机

在Suit SDK初始化之后，录制能力调用之前。

### 接口声明

``` c#
Yodo1U3dReplay.Initialize(Yodo1ReplayConfig config)
```

接口调用后会触发代理事件回调

``` c#
public delegate void InitializeDelegate(bool success, string error);
```

### 参数说明

Yodo1ReplayConfig

|           名称           | 描述                              |
| ----------------------- | --------------------------------- |
| Yodo1ReplayPlatform     | 录制的方式，Apple ReplayKit，抖音录屏 |
| Yodo1ReplaySharingType  | 分享方式，录制完成自动分享，或手动分享   |
| Yodo1DouyinConfig       | 抖音录屏能力配置                     |

Yodo1ReplayPlatform

``` c#
public enum Yodo1ReplayPlatform
{
    Yodo1ReplayPlatformApple = 0,
    Yodo1ReplayPlatformDouyin = 1,
}
```

Yodo1ReplaySharingType

``` c#
public enum Yodo1ReplaySharingType
{
    Yodo1ReplaySharingTypeAuto = 0,   // 录屏完成后，SDK自动进行分享
    Yodo1ReplaySharingTypeManual = 1, // 录屏完成后，开发者自行选择时机进行分享
}
```

Yodo1DouyinConfig

``` c#
public class Yodo1DouyinConfig
{
    public Yodo1ReplayType replayType; // 录屏方式
    public string hashTag; // 分享话题
}
```

Yodo1ReplayType

``` c#
public enum Yodo1ReplayType
{
    Yodo1ReplayTypeAuto = 0,   // 开发者控制录制 
    Yodo1ReplayTypeManual = 1, // 用户自由录制
}
```

* 开发者控制录制：为接入方通过接口调用控制录制开始和结束。设置为开发者控制录制，隐藏悬浮窗；

* 用户自由录制：为用户通过点击屏幕按钮控制录制开始和结束。设置为用户自由录制，展示悬浮窗；

## 判断是否支持录屏

### 调用时机

录制能力初始化后，在录制能力启动前需要先确认能力是否可用，若不可用可不展示和录制相关的UI控件。

### 接口声明

``` c#
bool ret = Yodo1U3dReplay.IsSupport();
```

### 接口说明

根据三方SDK状态返回`bool`值，支持屏幕录制`true`， 不支持屏幕录制返回`false`；

## 判断是否正在录制中

### 调用时机

录制能力初始化后

### 接口声明

``` c#
bool ret = Yodo1U3dReplay.IsRecording();
```

### 接口说明

根据本地录制状态返回`bool`值，录制中返回`true`， 非录制中返回`false`；

## 【开发者控制录制】开始录制

### 调用时机

录制能力初始化之后，录制策略设置为【开发者控制录制】。

### 接口声明

``` c#
Yodo1U3dReplay.StartRecord();
```

### 接口说明

该接口需要录制策略设置为开发者控制录制才可用，接口调用后会触发代理事件回调

``` c#
public delegate void StartRecordDelegate(bool success, string error);
```

## 【开发者控制录制】结束录制

### 调用时机

录制能力初始化之后，录制策略设置为【开发者控制录制】。

### 接口声明

``` c#
Yodo1U3dReplay.StopRecord();
```

### 接口说明

该接口需要录制策略设置为开发者控制录制才可用，接口调用后会触发代理事件回调

``` c#
public delegate void StopRecordDelegate(bool success, string error);
```

## 展示已录制视频并分享

### 调用时机

录制视频成功回调后

### 接口声明

``` c#
Yodo1U3dReplay.ShowRecorder();
```

### 接口说明

展示录屏结果，以及是否分享等后续交互展示

## 录制策略设置

### 调用时机

游戏内需要改变抖音录制策略时调用，在录制中不可设置

### 接口声明

``` c#
Yodo1U3dReplay.SetType(Yodo1ReplayType);
```

### 接口说明

入参`type`为`Yodo1ReplayType`类型

## 代码示例

``` c#
using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Yodo1ReplayDemo : MonoBehaviour
{
    static bool isInitialized;
    static bool initStatus;

    static Yodo1U3dReplay.Yodo1ReplayConfig config;
    static Yodo1U3dReplay.Yodo1ReplayType replayType;

    // Start is called before the first frame update
    void Start()
    {
        InitializeReplay();
    }

    void InitializeReplay()
    {
        if (isInitialized)
        {
            return;
        }
        Yodo1U3dReplay.ReplayDelegate.SetInitializeDelegate(InitializeDelegate);
        Yodo1U3dReplay.ReplayDelegate.SetStartRecordDelegate(StartRecordDelegate);
        Yodo1U3dReplay.ReplayDelegate.SetStopRecordDelegate(StopRecordDelegate);
        Yodo1U3dReplay.ReplayDelegate.SetShowRecordDelegate(ShowRecordDelegate);

        replayType = Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeAuto;

        config = new Yodo1U3dReplay.Yodo1ReplayConfig();
        config.replayPlatform = Yodo1U3dReplay.Yodo1ReplayPlatform.Yodo1ReplayPlatformDouyin;
        config.sharingType = Yodo1U3dReplay.Yodo1ReplaySharingType.Yodo1ReplaySharingTypeManual;
        config.douyinConfig.replayType = replayType;
        config.douyinConfig.hashTag = "#疯狂动物园冬日奇迹 带话题带手柄";
        Yodo1U3dReplay.Initialize(config);
    }

    public void ChangeReplayType()
    {
        if (config.replayPlatform == Yodo1U3dReplay.Yodo1ReplayPlatform.Yodo1ReplayPlatformApple)
        {
            Yodo1U3dUtils.ShowAlert("提示", "Apple录屏不支持Type切换", "确定");
            return;
        }
        if (replayType == Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeAuto)
        {
            replayType = Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeManual;
        }
        else if (replayType == Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeManual)
        {
            replayType = Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeAuto;
        }
        Yodo1U3dReplay.SetType(replayType);
    }

    public void StartRecord()
    {
        if (!Yodo1U3dReplay.IsSupport())
        {
            Yodo1U3dUtils.ShowAlert("提示", "当前设备不支持录屏，请更换设备测试！", "确定");
            return;
        }

        if (Yodo1U3dReplay.IsRecording())
        {
            Yodo1U3dUtils.ShowAlert("提示", "正在录制中...", "确定");
            return;
        }

        if (config.replayPlatform == Yodo1U3dReplay.Yodo1ReplayPlatform.Yodo1ReplayPlatformDouyin &&
            replayType == Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeManual)
        { // 设置为用户自由录制，展示悬浮窗
            Yodo1U3dUtils.ShowAlert("提示", "用户自由录制，使用悬浮窗", "确定");
            return;
        }

        Yodo1U3dReplay.StartRecord();
    }

    public void StopRecord()
    {
        if (!Yodo1U3dReplay.IsSupport())
        {
            Yodo1U3dUtils.ShowAlert("提示", "当前设备不支持录屏，请更换设备测试！", "确定");
            return;
        }

        if (config.replayPlatform == Yodo1U3dReplay.Yodo1ReplayPlatform.Yodo1ReplayPlatformDouyin &&
            replayType == Yodo1U3dReplay.Yodo1ReplayType.Yodo1ReplayTypeManual)
        { // 设置为用户自由录制，展示悬浮窗
            Yodo1U3dUtils.ShowAlert("提示", "用户自由录制，使用悬浮窗", "确定");
            return;
        }
        Yodo1U3dReplay.StopRecord();
    }

    public void ShowRecorder()
    {
        if (!Yodo1U3dReplay.IsSupport())
        {
            Yodo1U3dUtils.ShowAlert("提示", "当前设备不支持录屏，请更换设备测试！", "确定");
            return;
        }

        if (Yodo1U3dReplay.IsRecording())
        {
            Yodo1U3dUtils.ShowAlert("提示", "正在录制中...", "确定");
            return;
        }

        if (config.sharingType == Yodo1U3dReplay.Yodo1ReplaySharingType.Yodo1ReplaySharingTypeAuto)
        { // 录屏完成后，SDK自动进行分享
            Yodo1U3dUtils.ShowAlert("提示", "录制完成后将自动分享!", "确定");
            return;
        }

        Yodo1U3dReplay.ShowRecorder();
    }

    #region Replay Delegate

    void InitializeDelegate(bool success, string error)
    {
        Debug.LogWarning(string.Format(Yodo1U3dConstants.LOG_TAG + "Handle the InitializeDelegate, success:{0}, error:{1}", success, error));
        isInitialized = true;
        initStatus = success;
    }

    void StartRecordDelegate(bool success, string error)
    {
        Debug.LogWarning(string.Format(Yodo1U3dConstants.LOG_TAG + "Handle the StartRecordDelegate, success:{0}, error:{1}", success, error));
    }

    void StopRecordDelegate(bool success, string error)
    {
        Debug.LogWarning(string.Format(Yodo1U3dConstants.LOG_TAG + "Handle the StopRecordDelegate, success:{0}, error:{1}", success, error));
    }

    void ShowRecordDelegate(bool success, string error)
    {
        Debug.LogWarning(string.Format(Yodo1U3dConstants.LOG_TAG + "Handle the ShowRecordDelegate, success:{0}, error:{1}", success, error));
    }
    #endregion
}

```