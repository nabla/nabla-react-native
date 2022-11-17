#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NablaMessagingUIModule, NSObject)

RCT_EXTERN_METHOD(navigateToInbox: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(navigateToConversation: (id)conversationIdMap
                                callback: (RCTResponseSenderBlock)callback)

@end
