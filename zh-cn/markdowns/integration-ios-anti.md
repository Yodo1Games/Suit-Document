# iOS AntiAddiction

**开始前**:
>* ' iOS14 '要求' Xcode '版本为' 12+ '，请确保升级你的' Xcode '版本为' 12+ '。
>* ' SDK '要求' iOS '的最低版本为' iOS10.0 '
>* 最简单的方法是使用' CocoaPods '(请使用' 1.10 '及以上)，如果你是' CocoaPods '的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using -cocoapods)，学习如何创建和使用' Podfile '


## 集成步骤
## 集成步骤
### 1. 添加`iOS SDK`到项目中
#### 1.1 创建 `Podfile` 文件</br>
在项目的根目录中创建`Podfile`文件

```ruby
touch Podfile
```

#### 1.2 引入iOS SDK到项目中</br>
请打开项目中的`Podfile`文件并且将下面的代码添加到文件中:

```ruby
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1AntiAddiction', '6.0.6'
```

在`终端`中执行以下命令:</br>
```ruby
pod install --repo-update
```

### 2. `Xcode`项目配置
#### 2.1 设置`Info.plist` 参数
``` xml
<key>KeyConfig</key> 
<dict>  
    	<key>GameKey</key> 
    	<string>[Yodo1 GameKey]</string>
</dict>
```
![](./../../resource/ios_anti_setting.jpg)

### 3. 初始化SDK
#### 3.1 引入头文件`Yodo1AntiAddiction.h`
``` obj-c
#import "Yodo1AntiAddiction.h"
```

#### 3.2 初始化方法
``` obj-c
/// 初始化 三种初始化方法
- (void)init:(NSString *)appKey delegate: (id<Yodo1AntiAddictionDelegate>)delegate;
- (void)init:(NSString *)appKey regionCode:(NSString *)regionCode delegate: (id<Yodo1AntiAddictionDelegate>)delegate;
- (void)init:(NSString *)appKey channel:(NSString *)channel regionCode:(NSString *)regionCode delegate: (id<Yodo1AntiAddictionDelegate>)delegate;
```

### 4. 防沉迷api使用
``` obj-c
// 是否是游客用户
- (BOOL)isGuestUser;

/// 验证玩家防沉迷信息
/// accountId 玩家账号ru
/// 如果 autoTimer == YES游客及未成年会自动开启计时
- (void)verifyCertificationInfo:(NSString *)accountId success:(Yodo1AntiAddictionSuccessful)success failure:(Yodo1AntiAddictionFailure)failure;

///是否已限制消费
/// money 单位: 分
/// [data[@"hasLimit"] boolValue] == true // 已被限制消费
/// data[@"alertMsg"]  // 提示文字
- (void)verifyPurchase:(NSInteger)money success:(Yodo1AntiAddictionSuccessful)success failure:(Yodo1AntiAddictionFailure)failure;

///上报消费信息 - 支付信息&商品信息
/// receipt.money 商品金额, 单位分
- (void)reportProductReceipt:(Yodo1AntiAddictionProductReceipt *)receipt success:(Yodo1AntiAddictionSuccessful)success failure:(Yodo1AntiAddictionFailure)failure;

///上线行为
- (void)online:(OnBehaviourResult)callback;


///下线行为
- (void)offline:(OnBehaviourResult)callback;

///判断是否是中国大陆
- (BOOL)isChineseMainland;

```