# 账号系统

## 登录

``` java
Yodo1U3dAccount.Login();
/**
  *loginType:缺省代表渠道登录
  *Channel(0, "支付渠道账号登陆", "Channel"),,默认使用Channel方式登录
  *Device(1, "设备登陆", "Device"),
  *Google(2, "谷歌账号登陆", "Google"),
  *Yodo1(3, "游道易账号登录", "Yodo1"),
  *Wechat(4, "微信登录", "WECHAT"),
  *Sina(5, "新浪微博登录", "SINA"),
  *QQ(6, "QQ登录", "QQ");
  *extra      一般传null，有时有特殊配置
**/
Yodo1U3dAccount.Login(Yodo1U3dConstants.LoginType loginType, string extra)
```

设置登录回调：

``` java
//设置回调
Yodo1U3dAccount.SetLoginDelegate(LoginDelegate);
void LoginDelegate(Yodo1U3dConstants.AccountEvent accountEvent, Yodo1U3dUser user){
    if (accountEvent == Yodo1U3dConstants.AccountEvent.Success) {
Debug.Log ("login success");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.Fail) {
Debug.Log ("login failed");
}
}
```

## 提交用户信息

登录成功后，游戏根据自己的逻辑处理上报给sdk和渠道sdk，设置玩家playerId，和其他信息。健壮后面的逻辑。

``` java
Yodo1U3dAccount.SubmitUser (Yodo1U3dUser);
```

Yodo1U3dUser结构：

| Key名称      | 描述     | 是否为空 |
| ------------ | -------- | -------- |
| playedId     | 用户id   | 不可为空 |
| nickName     | 用户昵称 | 可为空   |
| level        | 等级     | 可为空   |
| age          | 年龄     | 可为空   |
| gender       | 性别     | 可为空   |
| gameServerId | 服务器id | 可为空   |

## 登出（仅支持Andriod）

退出登录，在切换登录等特定需要时接入。一般不接入。

``` java
Yodo1U3dAccount.Logout ();
//设置回调：Yodo1U3dAccount.SetLogoutDelegate(LogoutDelegate);
void LogoutDelegate (Yodo1U3dConstants.AccountEvent accountEvent) {
         Debug.Log ("----LogoutDelegate--- accountEvent: " + accountEvent);
     }
```

## 判断是否已经登录

退出登录，在切换登录等特定需要时接入。一般不接入。

``` java
bool isLogin = Yodo1U3dAccount.IsLogin ();
```

## Error Codes

| ErrorCode | ErrorMessage                    |
| :-------- | :------------------------------ |
| 0         | ACCOUNT\_ERROR\_FAILED          |
| 1         | ACCOUNT\_CANCEL                 |
| 2         | ACCOUNT\_ERROR\_ACCOUNT\_ERROR  |
| 3         | ACCOUNT\_ERROR\_PLUGIN\_ERROR   |
| 4         | ACCOUNT\_ERROR\_NETWORK\_ERROR  |
| 11        | ACCOUNT\_ERROR\_OPS\_ERROR      |
| 12        | ACCOUNT\_ERROR\_NO\_LOGIN       |
| 13        | ACCOUNT\_ERROR\_NO\_PERMISSIONS |
