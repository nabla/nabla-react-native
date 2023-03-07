#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(NablaClientModule, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize: (NSString *)apiKey
             enableReporting: (BOOL)enableReporting
        networkConfiguration: (NSDictionary *)networkConfiguration
                    resolver: (RCTPromiseResolveBlock)resolve
                    rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(setCurrentUser: (NSString *)userId
                        resolver: (RCTPromiseResolveBlock)resolve
                        rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(clearCurrentUser: (RCTPromiseResolveBlock)resolve
                          rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(provideTokens: (NSString *)refreshToken
                    accessToken: (NSString *)accessToken)
@end
