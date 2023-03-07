#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NablaSchedulingClientModule, NSObject)

RCT_EXTERN_METHOD(initializeSchedulingModule: (RCTPromiseResolveBlock)resolve
                                    rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setupCustomPaymentStep:)
RCT_EXTERN_METHOD(didSucceedPaymentStep)
RCT_EXTERN_METHOD(didFailPaymentStep)

@end
