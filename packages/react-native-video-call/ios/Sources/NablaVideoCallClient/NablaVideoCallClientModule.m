#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(NablaVideoCallClientModule, NSObject)

RCT_EXTERN_METHOD(initializeVideoCallModule: (RCTPromiseResolveBlock)resolve
                                   rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(joinVideoCall: (id)roomMap
                       callback: (RCTResponseSenderBlock)callback)

@end
