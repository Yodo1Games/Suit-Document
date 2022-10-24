# 集成准备

>* 下载[Unity插件](https://bj-ali-opp-sdk-update.oss-cn-beijing.aliyuncs.com/Unity_Plugins/Analytics/Yodo1-Analytics-1.0.1.unitypackage)
>* SDK支持Unity LTS 版本（2019或更高版本）
>* SDK支持Android API 19+
>* `CocoaPods`是`iOS`构建所必需的，可以按照[这里](https://guides.cocoapods.org/using/getting-started.html#getting-started)的说明安装。
>* iOS14需要`Xcode` 12+，请确保你的`Xcode`是最新的。

## 集成配置

### `Android`配置

#### 设置支持AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) 是Android构建所必需的，可以通过选择 ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier*** 来启用它，如下图所示：

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>


### 2. `iOS`配置

#### 2.1 添加 `use_framework`

设置路径：Assets -> External Dependency Manager -> iOS Resolver -> Settings（如图所示）

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>
<!-- markdownlint-restore -->