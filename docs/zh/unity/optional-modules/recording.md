# 录制屏幕功能

``` c#
/**
 * 录屏老接口(老接口)
**/
Yodo1U3dPublish.BeginRecordVideo();
Yodo1U3dPublish.IsCaptureSupported();
//只iOS
Yodo1U3dPublish.StopRecordVideo();
//只iOS
Yodo1U3dPublish.ShowRecordVideo();
 
 
/**
 * 录屏新接口
**/
//开启录屏
Yodo1U3dReplay.Initialize(Yodo1ReplayConfig config);
//停止录屏
Yodo1U3dReplay.StopRecord();
//开始录屏
Yodo1U3dReplay.StartRecord();
//是否支持录屏
Yodo1U3dReplay.IsSupport();
//是否正在录屏
Yodo1U3dReplay.IsRecording();
//设置录屏模式。玩家控制录屏开始(浮标按钮,此时start/stop没意义)，还是API控制开关。
Yodo1U3dReplay.SetType(Yodo1ReplayType);
//展示录屏结果。(是否分享等后续交互展示)
Yodo1U3dReplay.ShowRecorder();
```
