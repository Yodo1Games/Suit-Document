# 退出游戏

``` c#
Yodo1U3dUtils.exit ();
    
//退出游戏回调
Yodo1U3dAccount.SetExitDelegate(exitCallback);
void exitCallback(string msg){
     Debug.Log ("exitCallback, msg = " + msg);
}
```
