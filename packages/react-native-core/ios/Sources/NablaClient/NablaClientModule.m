#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(NablaClientModule, RCTEventEmitter)

RCT_EXTERN_METHOD(initialize: (NSString *)apiKey
        networkConfiguration: (NSDictionary *)networkConfiguration
                    resolver: (RCTPromiseResolveBlock)resolve
                    rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(willAuthenticateUser: (NSString *)userId)

RCT_EXTERN_METHOD(provideTokens: (NSString *)refreshToken
                    accessToken: (NSString *)accessToken)
@end
