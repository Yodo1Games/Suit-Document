# Exit the game

``` c#
Yodo1U3dUtils.exit ();
    
//Exit Game Delegate
Yodo1U3dAccount.SetExitDelegate(exitCallback);
void exitCallback(string msg){
     Debug.Log ("exitCallback, msg = " + msg);
}
```
