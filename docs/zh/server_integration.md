# Server接入文档(网游必接)


### **集成指引：**

提供可供回调的 域名地址，端口。目前只支持 http 协议。

可以根据业务需要提供多个地址，生成对应多个 regionCode，regionCode在游戏接入侧，init初始化填写，UnityEditor regionCode 可以留空。

### **接口开发：**

### **1，登录同步接口 userLoginSync。 （必接 Must）**

SuitSDK→ GameServer , 同步用户信息到 gameServer。

| HTTP Methods | Response Formats |
| --- | --- |
| POST | JSON |

**Request URL**

[http://domain/userLoginSync](http://domain/userLoginSync)（domain=url+port不同游戏服务器不同地址）

**Request Parameter**

| Name | Type | Description | Remark |
| --- | --- | --- | --- |
| uid | string | 用户在游戏中对应的id |  |
| yid | string | 用户唯一id |  |
| token | string |  |  |
| channel_code | string | 渠道代码 |  |
| isnewuser | int | 是否是新用户 | 1是 0否 |
| nickname | string | 昵称 |  |

**Request Example**

> [URL]
>
>
> > http://domain/userLoginSync 不同游戏服务器不同地址
> >

> [METHOD]
>
>
> > POST
> >

> [PARAMS]
>
>
> > {
> >
> >
> > "data": {
> >
> > "uid": "54c06aceb3c4f03d7000066c",
> >
> > "yid": "20215305",
> >
> > "token": "22d7398298754d92988b6755c1daa756",
> >
> > "channel_code": "AppStore",
> >
> > "nickname": "",
> >
> > "isnewuser": 0
> >
> > },
> >
> > "sign": "a7af0db71ac907dd3145277bd2dce745"
> >
> > }
> >

**Response Example**

> {"error_code":0,"error":""}
>

### **2，支付同步接口 userRechargeSync。（必接 Must）**

SuitSDK→ GameServer ,同步订单信息到 gameServer。此接口请求 contentType为 text，接收侧注意。

| HTTP Methods | Response Formats |
| --- | --- |
| POST | JSON |

**Request URL**

[http://domain/userRechargeSync](http://domain/userRechargeSync)（domain=url+port不同游戏服务器不同地址）

**Request Parameter**

| Key | Type | Required | Remark |
| --- | --- | --- | --- |
| orderid | string | Required | 订单号 |
| uid | string | Required | 用户id |
| item_code | string | Required | 购买道具代码 |
| extra | string | Required | 客户端上传附加信息 |
| money | stirng | Required | 充值金额 单位:分 |
| currency | string |  | 币种 默认人民币 |
| nickname | string |  | 玩家昵称 |
| game_appkey | string |  | 游戏appkey |
| pay_channel_code | string |  | 支付渠道 |
| pr_channel_code | stirng |  | 推广渠道 |
| sign | stirng | Required | md5("http://yodo1.com/"+orderid) |

**Request Example**

> [URL]
>
>
> > http://domain/userRechargeSync 不同游戏服务器不同地址
> >

> [METHOD]
>
>
> > POST
> >

> [PARAMS]
>
>
> > {
>   "data": {
>     "uid": "35534",
>     "orderid": "ht5h465greu5juuiiiuiert5467",
>     "item_code": "4g4tre",
>     "money": 10000,
>     "currency": "CNY",
>     "nickname": "aa",
>     "game_appkey": "er425u654ut",
>     "pay_channel_code": "4543",
>     "pr_channel_code": "yhgfhfgh",
>     "extra": ""
>   },
>   "sign": "fdafdgagrwe243t345345t345"
> }
> >

**Response Example**

> {"error_code":"0","error":"sdsdfsgsdfggfre"}
>

**附，客户端提交附加信息格式**

> "uid#,#orderid#,#game_appkey#,#region_code#,#item_code#,#extra"
字符串 "#,#" 是分隔符，extra中内容不要出现相同的分隔符
>

### **3，成功发货接口。（可选 optional）**

GameServer→ SuitSDK , 也可以通过 APP 端调用 SuitSDK接口实现，两种必须实现其中之一。网游建议使用服务端接口通知。

| HTTP Methods | Response Formats |
| --- | --- |
| POST | JSON |

**Request URL**

[https://payment.yodo1api.com](https://payment.yodo1api.com/payment)[/payment/order/sendGoodsOverForReject](http://domain/payment/order/sendGoodsOverForFault)

**Request Parameter**

| Key | Type | Required | Remark |
| --- | --- | --- | --- |
| data | json | Required | KeyTypeRequiredorderIdsstring逗号分隔的订单号(可以只传一个订单号)，例如：O20200430130534D6FVMGJ,O20200430130404NHIVU8MsourceTypestring传"3" |
| sign | string | Required | md5("yodo1"+orderids) |

**Request Example**

> [URL]
>
>
> > http://domain/payment/order/sendGoodsOver
> >

> [METHOD]
>
>
> > POST
> >

> [PARAMS]{ "sign":"6099384a01bcb7ddc08ec522be38d481", "data":{ "orderIds":"O20200430130534D6FVMGJ,O20200430130404NHIVU8M", "sourceType":"1" }}
>

**Response Example**

> {"error_code":"0","error":""}
>

### **4，拒绝发货通知。（可选 optional）**

GameServer→ SuitSDK , 也可以通过 APP 端调用 SuitSDK接口实现，两种必须实现其中之一。网游建议使用服务端接口通知。

| HTTP Methods | Response Formats |
| --- | --- |
| POST | JSON |

**Request URL**

[https://payment.yodo1api.com](https://payment.yodo1api.com/payment)[/payment/order/sendGoodsOverForReject](http://domain/payment/order/sendGoodsOverForFault)

**Request Parameter**

| Key | Type | Required | Remark |
| --- | --- | --- | --- |
| data | json | Required | KeyTypeRequiredorderIdsstring逗号分隔的订单号(可以只传一个订单号)，例如：O20200430130534D6FVMGJ,O20200430130404NHIVU8MsourceTypestring传"3" |
| sign | string | Required | md5("yodo1"+orderids) |

**Request Example**

> [URL]
>
>
> > http://domain/payment/order/sendGoodsOver
> >

> [METHOD]
>
>
> > POST
> >

> [PARAMS]{ "sign":"6099384a01bcb7ddc08ec522be38d481", "data":{ "orderIds":"O20200430130534D6FVMGJ,O20200430130404NHIVU8M", "sourceType":"1" }}
>

**Response Example**

> {"error_code":"0","error":""}
>