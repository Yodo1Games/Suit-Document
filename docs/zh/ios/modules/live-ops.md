# Live Ops 集成

**开始前**:
>* ' iOS14 '要求' Xcode '版本为' 12+ '，请确保升级你的' Xcode '版本为' 12+ '。
>* ' SDK '要求' iOS '的最低版本为' iOS10.0 '
>*最简单的方法是使用' CocoaPods '(请使用' 1.10 '及以上)，如果你是' CocoaPods '的新手，请参考它的[官方文档](https://guides.cocoapods.org/using/using -cocoapods)，学习如何创建和使用' Podfile '

## 集成SDK

### 添加`iOS SDK`到项目中

#### 创建 `Podfile` 文件</br>

在项目的根目录中创建`Podfile`文件

```ruby
touch Podfile
```

#### 引入iOS SDK到项目中</br>

请打开项目中的`Podfile`文件并且将下面的代码添加到文件中:

```ruby
source 'https://github.com/Yodo1Games/Yodo1-Games-Spec.git'
source 'https://github.com/CocoaPods/Specs.git'

pod 'Yodo1LiveOps', '1.0.0'
```

在`终端`中执行以下命令:</br>

```ruby
pod install --repo-update
```

## 集成步骤

### 初始化SDK

#### 引入头文件`Yodo1LiveOps.h`

推荐在`didFinishLaunchingWithOptions`生命周期方法中进行初始化

``` obj-c
#import "Yodo1LiveOps.h"
```

#### 初始化

``` obj-c
[Yodo1LiveOps.sharedInstance initWithAppKey:@"<Your_App_Key>"];
```

### 设置初始化代理回调

#### 设置代理`Yodo1LiveOpsInitDelegate`

``` obj-c
#import "Yodo1LiveOps.h"

@interface xxxView ()<Yodo1LiveOpsInitDelegate>

@end
```

#### 实现代理方法

``` obj-c
// 实现代理方法
- (void)getLiveOpsInitSuccess:(int)result {
    NSLog(@"%d", result);
}
```

## 在线参数

### NSString类型
``` obj-c
/**
 Gets the online parameter configuration,return NSString Type
 - Parameters:
 - key: Online parameter configuration key
 - defaultValue: Pass in the expected value
 */
- (NSString *)stringValueWithKey:(NSString *)key
                    defaultValue:(NSString *)defaultValue;
```

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

### BOOL类型

``` obj-c
/**
 /**
 Gets the online parameter configuration,return Bool Type
 - Parameters:
 - key: Online parameter configuration key
 - defaultValue: Pass in the expected value
 */
- (BOOL)booleanValueWithKey:(NSString *)key
               defaultValue:(BOOL)defaultValue;
```

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

### int类型

``` obj-c
/**
 Gets the online parameter configuration,return Int Type
 - Parameters:
 - key: Online parameter configuration key
 - defaultValue: Pass in the expected value
 */
- (int)intValueWithKey:(NSString *)key
          defaultValue:(int)defaultValue;
```

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

### double类型

``` obj-c
/**
 Gets the online parameter configuration,return Double Type
 - Parameters:
 - key: Online parameter configuration key
 - defaultValue: Pass in the expected value
 */
- (double)doubleValueWithKey:(NSString *)key
                defaultValue:(double)defaultValue;
```

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

### float类型

``` obj-c
/**
 Gets the online parameter configuration,return Float Type
 - Parameters:
 - key: Online parameter configuration key
 - defaultValue: Pass in the expected value
 */
- (float)floatValueWithKey:(NSString *)key
              defaultValue:(float)defaultValue;
```

* `key`是获取在线参数value所对应的key值
* `defaultValue`是设置value的默认值

## 兑换码

### 校验兑换码
``` obj-c
/**
 * 兑换码/优惠券
 */
- (void)verifyWithActivationCode:(NSString *)activationCode
                    	callback:(void (^)(BOOL success,NSDictionary* _Nullable response, NSDictionary* _Nullable error))callback;
```

* `activationCode`是兑换码（NSString）

> 注意
>
>* `activationCode`不能包含空号和标点符号

#### 兑换码示例代码

``` obj-c
[Yodo1LiveOps.sharedInstance verifyWithActivationCode:@"<Your Code>" callback:^(BOOL success, NSDictionary * _Nullable response, NSDictionary * _Nullable error) {
            
}];
```

## 其他

### 获取SDK版本信息

``` obj-c
/**
 *  获取SDK版本
 */
- (NSString *)getSdkVersion;
```

### 开启日志

默认是不开启日志，上架之前请先关闭日志

``` obj-c
/**
 *  开启日志（默认是NO，不开启）
 */
- (void)setDebugLog:(BOOL)debugLog;
```