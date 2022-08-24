# 云存储功能/iCloud

``` c#
Yodo1U3dPublish.saveToCloud（）
Yodo1U3dPublish.loadToCloud（）
 
//设置回调。googleCloud,iCloud.
Yodo1U3dSDK.setiCloudGetValueDelegate();
```

Xcode工程中，在“Capabilities”中添加“iCloud”，勾选“Key-value storage”和“iCloudKit”
<!-- markdownlint-disable -->
<figure> 
	 <img src="/zh/assets/images/xcode_icloud.png" width="400">
</figure>
<!-- markdownlint-restore -->


## GameCenter功能

### 成就功能/Achievement

``` c#
// 打开成就
Yodo1U3dPublish.achievementsOpen();

// 解锁成就
Yodo1U3dPublish. achievementsUnlock(tring achievementStr);

// 更新成就分数
Yodo1U3dPublish.updateScore();
```

### 排行榜功能/Leaderboard

``` c#
Yodo1U3dPublish.leaderboardsOpen()；
```
