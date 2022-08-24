# 在线参数

使用该功能，设置在线参数的key/value需要与Yodo1团队沟通，然后进行设置

## 获取在线参数

``` c#
/**
 * 获取在线参数，值的分发。方便进行云控制
 */
Yodo1U3dUtils.getConfigParameter();
Yodo1U3dUtils.StringParams();
Yodo1U3dUtils.BoolParams();
 
/**
 * 用以展示对话框。AlertDialog.
 */
Yodo1U3dUtils.showAlert(String title,
                        String message,
                        String positiveButton,
                        String negativeButton,
                        String neutralButton,
                        String objectName,
                        String callbackMethod);

/**
 * 存储数据到原生层。从原生层获取数据。
 */
Yodo1U3dUtils.SaveToNativeRuntime(key,value);
Yodo1U3dUtils.GetnativeRuntime(key);
```
