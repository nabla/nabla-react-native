#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NablaMessagingUIClientModule, NSObject)

RCT_EXTERN_METHOD(navigateToConversation: (NSString *)conversationId
                            showComposer: (BOOL)showComposer)

@end
