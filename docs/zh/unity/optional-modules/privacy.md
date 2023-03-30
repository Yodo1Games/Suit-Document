# Privacy合规

用户隐私协议只在 AppleStore 和 GooglePlay渠道有意义。

如果应用app可以从其他三方获取下列标记，则通过set接口设置数据即可，不需要ShowUserConsent展示。

如果应用无法获取到隐私标记，则需要ShowUserConsent展示年龄选择框，玩家完成后，可以通过回调或者get接口获取标记的值。


### 1，GDPR-GDPR 欧盟 (EU) 一般数据保护条例 

小于13-16岁（儿童）, 不上报数据（Yoodo1统计和第三方统计平台）

```c#
//如果用户已经同意，请将下面的标志设置为true。
Yodo1U3dSDK.SetUserConsent(true);
//如果用户没有同意，请将下面的标志设置为false。
Yodo1U3dSDK.SetUserConsent(false);
```

### 2，COPPA-COPPA 美国儿童在线隐私权保护法

小于13岁（儿童）, 不上报数据（Yoodo1统计和第三方统计平台）

```c#
//如果已知该用户属于年龄限制类别(即16岁以下的儿童)，请将标志设置为true。
Yodo1U3dSDK.SetTagForUnderAgeOfConsent(true);
//如果已知该用户不属于年龄限制类别(即， 16岁或以上)请将标志设为false。
Yodo1U3dSDK.SetTagForUnderAgeOfConsent(false);
```

### 3，3，CCPA-CCPA 加州消费者隐私法案

```c#
//设置一个标志，表明位于美国加利福尼亚州的用户是否选择不出售其个人数据
//如果同意出售个人数据，请将标志设置为false。
Yodo1U3dSDK.SetDoNotSell(false);
 
//如果不同意出售个人数据，请将标志设置为true。
Yodo1U3dSDK.SetDoNotSell(true);
```

### 4，展示年龄选择框

```c#
//展示年龄选择框
Yodo1U3dSDK.ShowUserConsent();
//年龄选择框回调
Yodo1U3dSDK.setShowUserConsentDelegate(ShowUserConsentDelegate);

private void ShowUserConsentDelegate(bool isaccept, int userage, bool isgdprchild, bool iscoppachild)
{
Debug.Log(Yodo1U3dConstants.LOG_TAG + " isaccept:" + isaccept);
Debug.Log(Yodo1U3dConstants.LOG_TAG + " userage:" + userage);
Debug.Log(Yodo1U3dConstants.LOG_TAG + " isgdprchild:" + isgdprchild);
Debug.Log(Yodo1U3dConstants.LOG_TAG + " iscoppachild:" + iscoppachild);
}
```