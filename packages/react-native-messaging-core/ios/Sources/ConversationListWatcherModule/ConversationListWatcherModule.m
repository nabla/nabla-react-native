#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ConversationListWatcherModule, RCTEventEmitter)

RCT_EXTERN_METHOD(loadMoreConversations: (RCTResponseSenderBlock)callback)

@end
