# ios_share_document

##Use of the share function
setting Yodo1KeyInfo.plist Sharing of Parameters
![](./../../resource/ios_share_1.png)

# #import "OpenSuitSNSManager.h"

/**
*  
* Call the shared interface UI
* 
*/
- (void)showSocial:(SMContent *)content
             block:(SNSShareCompletionBlock)completionBlock;
