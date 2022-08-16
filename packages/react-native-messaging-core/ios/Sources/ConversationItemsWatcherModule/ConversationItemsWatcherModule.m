#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(ConversationItemsWatcherModule, RCTEventEmitter)


RCT_EXTERN_METHOD(watchConversationItems: (id) conversationIdMap
                                callback: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(loadMoreItemsInConversation: (id) conversationIdMap
                                    callback: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(unsubscribeFromConversationItems: (id) conversationIdMap)

@end
