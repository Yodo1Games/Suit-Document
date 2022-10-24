# Getting started

>* SDK supports Unity LTS 2019 and above
>* SDK supports Android API 19 and above
>* SDK supports iOS API 10 and above
>* `CocoaPods` is required for `iOS` build, you can install it by following the instructions [here](https://guides.cocoapods.org/using/getting-started.html#getting-started)
>* iOS15 requires `Xcode` 13+, please make sure you are using the latest version of Xcode

## Integrate Configuration

### `Android` Configuration

#### Support for AndroidX

[Jetifier](https://developer.android.com/jetpack/androidx/releases/jetifier) is required for `Android` build, you can enable it by selecting ***Assets > External Dependency Manager > Android Resolver > Settings > Use Jetifier***

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/andriod_use_jetifier.png" width="300"> 
    <figcaption>andriod use jetifier</figcaption> 
</figure>

### `iOS` Configuration

#### Adds `use_framework`

Set the `use_framework` according to `Assets -> External Dependency Manager -> iOS Resolver -> Settings`

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/unity_setting_1.jpg" width="300"> 
</figure>
<figure> 
    <img src="/zh/assets/images/unity_setting_2.jpg" width="300"> 
</figure>
<!-- markdownlint-restore -->
