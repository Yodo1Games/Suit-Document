# Statistics

## Set Account ID

When a user logs in, login can be called to set the user's account ID. After setting the account ID, the account ID will be used as the identification ID.

``` c#
Yodo1U3dAnalytics.login("Your Player ID");
```

``` c#
Yodo1U3dUser user = new Yodo1U3dUser();
user.playedId = "Your Player ID"
user.** = "***"
Yodo1U3dAnalytics.login(user);
```

## Thinking Data

### Send Custom Events

You can call 'TrackEvent' to upload game custom events, using the user's task as an example:

```c#
Dictionary<string, string> properties = new Dictionary<string, string>();
properties.Add("mission_id", "xxxx");
properties.Add("mission_name", "yyyy");
properties.Add("mission_finish", "true");

Yodo1U3dAnalytics.TrackEvent("mission", properties);
```

>* The name of the event is of type 'string', which can only start with a letter and can contain numbers, letters, and the underscore '_'. The maximum length is 50 characters and is not sensitive to letter case.
>* The attribute of an event is a 'Dictionary' object, where each element represents an attribute. The value of Key is the name of the attribute and is of type 'string'. It can only start with a letter and contains numbers, letters, and the underscore '_'. The maximum length is 50 characters and is not sensitive to letter case.

### Get Identifiers

You can call `GetIdentifiers` to get the identifiers of the Thinking Data, an example:

```c#
Dictionary<string, object> identifiers = Yodo1U3dAnalytics.GetIdentifiers();
string tdDistinctId = identifiers["td_distinct_id"].ToString();
string tdDeviceId = identifiers["td_device_id"].ToString();
```

## UA(Adjust)

Currently, UA is only applicable to Apple and Google Store,and when used in Google Store, it is required to properly integrate[User Privacy](/zh/unit/optional modules/privacy/),to ensure compliance.

### In application events

When you start integrating events within the application and UA by Adjust, please first download the[yodo1 ua events. xls](/zh/assets/yodo1_ua_events.xls.zip)file, fill in the event name and token you need (provided by the UA team), and place it in the 'Assets/Yodo1/Suit/Resources' directory.

#### Send Custom Events

You can call 'TrackUAEvent' to upload game UA related custom events, using the user's task as an example:

```c#
Dictionary<string, string> properties = new Dictionary<string, string>();
properties.Add("mission_id", "xxxx");
properties.Add("mission_name", "yyyy");
properties.Add("mission_finish", "true");

Yodo1U3dAnalytics.TrackUAEvent("mission", properties);
```

#### Track IAP revenue

1. Apply for an IAP revenue event token from the UA team and fill it in to yodo1_ Ua_ In the events file.
2. After the IAP purchase is successful, call the 'TrackIAPRevenue' method to report the IAP revenue. Note: If you are using Yodo1 Suit for in app purchases, the SDK will automatically report IAP revenue

   ```c#
   Yodo1U3dAnalytics.TrackIAPRevenue(Yodo1U3dIAPRevenue  iAPRevenue);
   ```

   Examples are as follows：

   ```c#
   using UnityEngine.Purchasing;

   public class GameObject : MonoBehaviour, IStoreListener
   {
     public static string kProductIDConsumable = "com.test.cons";

     void Start()
     {
         // TODO Initialization Suit SDK
     }

     public PurchaseProcessingResult ProcessPurchase(PurchaseEventArgs args)
     {
         var product = args.purchasedProduct;
         string prodID = args.purchasedProduct.definition.id
         string price = args.purchasedProduct.metadata.localizedPrice.ToString()
         string currency = args.purchasedProduct.metadata.isoCurrencyCode;

         string receipt = args.purchasedProduct.receipt;
         var recptToJSON = (Dictionary<string, object>)Yodo1JSONObject.Deserialize(product.receipt)
         var receiptPayload = (Dictionary<string, object>)Yodo1JSONObject.Deserialize((string)recptToJSON["Payload"]);
         var transactionID = product.transactionID;

         if (String.Equals(args.purchasedProduct.definition.id, kProductIDConsumable, StringComparison.Ordinal))
         {
            //TODO track IAP revenue
            Yodo1U3dIAPRevenue iAPRevenue = new Yodo1U3dIAPRevenue();
            iAPRevenue.ProductIdentifier = prodID;
            iAPRevenue.Revenue = price;
            iAPRevenue.Currency = currency;
   #if UNITY_IOS
            iAPRevenue.TransactionId = transactionID;
            iAPRevenue.ReceiptId = (string)recptToJSON["Payload"];
   #elif UNITY_ANDROID
            iAPRevenue.PublicKey = <google_public_key>;
            iAPRevenue.Signature = (string)receiptPayload["signature"];.
            iAPRevenue.PurchaseData = (string)receiptPayload["json"];
   #endif
            Yodo1U3dAnalytics.TrackIAPRevenue(iAPRevenue);
         }

         return PurchaseProcessingResult.Complete;
     }
   }
   ```

#### Track advertising revenue

The Suit SDK provides the 'TrackAdRevenue' method to report advertising revenue.

```c#
Yodo1U3dAdRevenue adRevenue = new Yodo1U3dAdRevenue();
adRevenue.Source = Yodo1U3dAdRevenue.Source_Applovin_MAX;
adRevenue.Revenue = 0.01;
adRevenue.Currency = "USD";
adRevenue.NetworkName = "admob";
adRevenue.UnitId = "";
adRevenue.PlacementId = "";
Yodo1U3dAnalytics.TrackAdRevenue(adRevenue);
```

Currently, we cannot obtain advertising revenue from the standard integration method of the MAS SDK, so we need to use the[MAS Advertising Revenue Component](https://github.com/Yodo1Games/Yodo1-MAS-Ad-Revenue/blob/master/MAS-Ad-Revenue-Unity/README.md) Obtain advertising revenue, sample code as follows

```c#
using UnityEngine.Purchasing;

public class GameObject : MonoBehaviou
{
   void Start()
   {
      Yodo1MasAdRevenue.SetAdRevenueDelegate((string adPlatform, string adSource, string adFormat, string adUnitName, double revenue, string currency) => {
         Debug.LogFormat("{0} adPlatform:{1} adSource:{2} adFormat:{3} adUnitName:{4} revenue:{5} currency:{6}", Yodo1MasAdRevenue.TAG, adPlatform, adSource, adFormat, adUnitName, revenue, currency);
         // TODO You can track the data yourselves here. 

         Yodo1U3dAdRevenue adRevenue = new Yodo1U3dAdRevenue();
         adRevenue.Source = adPlatform.ToLower();
         adRevenue.Revenue = revenue;
         adRevenue.Currency = currency;
         adRevenue.NetworkName = adSource;
         adRevenue.UnitId = adUnitName;
         Yodo1U3dAnalytics.TrackAdRevenue(adRevenue);
      });
   }
}
```

### DeepLink

You can add the domain of the deeplink in the editor editing panel (Note: The prefix 'applink:' must be added before the domain)

Obtain deeplink data

```c#
public static string GetNativeRuntime(string key);
```

>* key = "appsflyer_deeplink"，Obtain deeplink data
>* key = "appsflyer_id"，Obtain the user ID of AF

Reset deeplink data

```c#
public static void SaveToNativeRuntime(string key, string valuepairs);
```

<!-- ### User Invitation

You can add a domain in the editor editing panel, which must be consistent with the deeplink. (Note: The prefix 'applink:' must be added before the domain)

Generate sharing URL

```c#
public static void generateInviteUrlWithLinkGenerator(Yodo1U3dAnalyticsUserGenerate generate);
```

>* Notice
>* Splice `&af after the obtained URL_ Force_ Deeplink=true 'can evoke applications already installed on the phone (URLs are intercepted during Facebook sharing, and the link will only jump to the AppStore. Joined with'&af_forceDeeplink=true 'can evoke applications)

Yodo1U3dAnalyticsUserGenerate structure

```c#
private string targetView; //Target Attempt Name
private string promoCode; //PROMO CODE
private string referrerId; //Referrer ID
private string campaign; //Activity Name
private string channel; //channel
private string url; //Shared domain
```

Report the 'User Attribution Sharing Link' event

```c#
public static void logInviteAppsFlyerWithEventData(Dictionary<string, string> value = null);
``` -->

<!-- ## UA测试流程 -->

## Adjust Testing process and data viewing method

### SDK log Output requirements

After completing the first SDK connection, please select Sandbox and enable the debug mode to facilitate integration inspection and testing.

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/sandbox_and_debug_mode.png" width="700">
</figure>

After checking that there are no issues, switch to production mode and go online.

### Test data viewing method

#### Test Console Viewing Method

The test console is a "real-time" query interface that allows the user ID to query the current installation information or clear installation records.

>* Note: Sandbox mode/Production mode data can be queried through the testing console.

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_1.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_2.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_3.png" width="700">
</figure>

* Android app：gps_adid / oaid / adid 
* iOS app：idfa / idfv / adid

>* Note: adid is a unique id created by adjust for each device. This value will only be returned when the adjust sdk successfully initializes and reports to the adjust server
   GPS_ Adid (also known as Google advertising id or gaid) and idfa are the only advertising ids on the device
>* Example of adid format： 12b3e453f674b51a9db517ba0f140612
>* Example of gps_adid/oaid/idfa/idfv format：12f34b56-32dc-4f8f-8725-499e8627df34

You can obtain it through adjust insights, as shown in the following example

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/adjust_insights.png" width="700">
</figure>

View test results

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_4.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/testing_console_5.png" width="700">
</figure>

Adjust permanent weight removal, which means that after the device is recorded for installation, regardless of whether it is uninstalled or reinstalled, we will not record the installation again or attribute it again. Therefore, the same testing device can be retested through the "clear device" method.

>* Note: First uninstall the application on the device, and then click 'Clear Device'

#### Data backend viewing method

Open Sandbox Mode

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/data_background_1.png" width="700">
</figure>

Click the edit button to view the defined events

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/data_background_2.png" width="700">
</figure>

Select KPIs for visualization

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/data_background_3.png" width="700">
</figure>

Definition of event query method: Select "Deliverable Data KPI", select "Event", search for and add a benchmark event in the event, click "Select Indicator", and then click "Confirm"

### Channel attribution data testing method

Tracking link testing method: Create tracking link - Splice parameters - Click on tracking link - Activate application - View testing console

We have created a test attribution channel (Yodo1 Test Channel) for ARBS, RODEO, and TEW. Before conducting attribution testing for other games, please follow the following steps to create a test attribution channel (Yodo1 Test Channel).
<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/attribution_1.png" width="700">
</figure>

<!-- markdownlint-disable -->
<figure> 
    <img src="/zh/assets/images/adjust/attribution_2.png" width="700">
</figure>

Get click tracking link：https://app.adjust.com/l5tuaz

Before clicking on the tracking link, please splice the message ID:

* Assuming Android GPS_ Adid is：12f34b56-32dc-4f8f-8725-499e8627df34
* Assuming Apple idfa is：45f34b56-32dc-4f8f-8725-499e8627df67

Get Android click tracking link：https://app.adjust.com/l5tuaz?gps_adid=12f34b56-32dc-4f8f-8725-499e8627df34

Get Apple Click Tracking Link：https://app.adjust.com/l5tuaz?idfa=45f34b56-32dc-4f8f-8725-499e8627df67

After triggering the tracking link in the browser, install the product locally, open the application, and query the attribution results in the test console

>* Note: Some media cannot add a device ID to the tracking link. As long as you jump to Google Play, Adjust can still accurately attribute it through a referrer;