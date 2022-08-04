# 激活码功能

使用该功能，设置在线参数的key/value需要与Yodo1团队沟通，然后进行设置

 Yodo1 PA生成相关规则激活码。兑换码领奖品接口

```c#
/// <summary>
/// Verifies the activation code.
/// </summary>
/// <param name="activationCode">Activation code.</param>
Yodo1U3dUtils.VerifyActivationCode(“activation Code”);
```

设置回调：

```c#
/// <summary>
/// Set activity verify delegate
/// </summary>
/// <param name="activityVerifyDelegate"></param>
Yodo1U3dSDK.setActivityVerifyDelegate(ActivityVerifyDelegate);
  
void ActivityVerifyDelegate (Yodo1ActivationcodeData data) {
    Debug.Log ("reward:" + data.Rewards.ToString());
    foreach (string goodName in data.Rewards.Keys) {
        int value = 0;
        int.TryParse (data.Rewards [goodName].ToString (), out value);
        Debug.Log ("goodName:" + goodName + ", value:" + value);
    }
    Debug.Log ("rewardDes:" + data.RewardDes + ", errorMsg:" + data.ErrorMsg);
}
```
