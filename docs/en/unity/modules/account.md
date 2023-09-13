# Account system

## Login

```c#
Yodo1U3dAccount.Login();
/**
  *loginType: Default representative channel login
  *Channel(0, "Channel Login", "Channel"),By default, log in using Channel mode
  *Device(1, "Device Login", "Device"),
  *Yodo1(3, "Yodo1 Login", "Yodo1"),
  *extra      Normally passed as null, sometimes with special configurations
**/
Yodo1U3dAccount.Login(Yodo1U3dConstants.LoginType loginType, string extra)
```

Yodo1U3dConstants.LoginType structure：

| Key名称      | 描述            |
| ----------- |---------------|
| Channel     | Channel Login |
| Device      | Device Login  |
| Yodo1       | Yodo1 Login   |

Set login callback：

```c#
Yodo1U3dAccount.SetLoginDelegate(LoginDelegate);

void LoginDelegate(Yodo1U3dConstants.AccountEvent accountEvent, Yodo1U3dUser user){
    if (accountEvent == Yodo1U3dConstants.AccountEvent.Success) {
        Debug.Log ("login success");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.Fail) {
        ebug.Log ("login failed");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.Cancel) {
        Debug.Log ("login cancel");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.Fail_Plugin) {
        Debug.Log ("login failed for plugin");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.Fail_NetWork) {
        Debug.Log ("login failed for network");
    } else if (accountEvent == Yodo1U3dConstants.AccountEvent.NeedRealName) {
        Debug.Log ("need real name");
    }
}
```

Yodo1U3dConstants.AccountEvent structure：

| Key Name     | Description     |
|--------------|-----------------|
| Success      | Login succeeded |
| Fail         | Login failure   |
| Cancel       | Cancel login    |
| Fail_Plugin  | plugin failure  |
| Fail_NetWork | Network connection failed          |
| NeedRealName | Real name required          |

## Submit Player User Info

After successful login, the game will process and report to SDK and channel SDK based on its own logic, set player playerId, and other information. The logic behind robustness.

``` c#
Yodo1U3dAccount.SubmitUser (Yodo1U3dUser);
```

Yodo1U3dUser结构：

| Key Name     | description | Is it empty |
|--------------|-------------|------------|
| playedId     | user id     | nonullable |
| nickName     | NickName    | nullable   |
| level        | Level       | nullable   |
| age          | Age         | nullable   |
| gender       | gender      | nullable   |
| gameServerId | gameServerId | nullable  |

## Logout（Optional）

Log out and log in. If there are multiple accounts in the game and you need to call the login method when switching accounts, please note that only Android is supported.

``` c#
Yodo1U3dAccount.Logout ();
```

Set logout callback

``` c#
Yodo1U3dAccount.SetLogoutDelegate(LogoutDelegate);

void LogoutDelegate (Yodo1U3dConstants.AccountEvent accountEvent) {
    Debug.Log ("----LogoutDelegate--- accountEvent: " + accountEvent);
}
```

## Determine if you have logged in

``` c#
bool isLogin = Yodo1U3dAccount.IsLogin ();
```

## error code

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
