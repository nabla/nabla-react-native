#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NablaMessagingClientModule, NSObject)

RCT_EXTERN_METHOD(initializeMessagingModule: (RCTPromiseResolveBlock)resolve
                                   rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(createConversation: (NSString *)title
                         providerIds: (NSArray<NSString *> *)providerIds
                            callback: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(sendMessage: (id)input
               conversationId: (id)conversationIdMap
                      replyTo: (id)replyToMap
                     callback: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(deleteMessage: (id)messageIdMap
                 conversationId: (id)conversationIdMap
                       callback: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(markConversationAsSeen: (id)conversationIdMap
                                callback: (RCTResponseSenderBlock)callback)

RCT_EXTERN_METHOD(setIsTyping: (BOOL)isTyping
               conversationId: (id)conversationIdMap
                     callback: (RCTResponseSenderBlock)callback)
@end
