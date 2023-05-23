# FAQ
**Why the game crash after I init the SDK?** 

Please double-check your settings to confirm your appkey and other params are all correct. Then check the logs if the issue is not fix.
If the logs tells you something as below(using iOS example):

```shell
...
*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: *** __NSDictionaryMsetObject:forKeyedSubscript: key cannot be nil ***
...
```

which means your project is lost the file `Yodo1KeyInfo.plist` you can confirm whether the file is in `Assets/Plugins/iOS/Yodo1KeyConfig.bundle` , if not please re-import Yodo1 Suit SDK Unity plugin.

