#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ConversationWatcherModule, RCTEventEmitter)

RCT_EXTERN_METHOD(watchConversation: (id) conversationIdMap
                           callback: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(unsubscribeFromConversation: (id) conversationIdMap)

@end
