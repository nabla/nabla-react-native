#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface RCT_EXTERN_MODULE(LogWatcherModule, RCTEventEmitter)

RCT_EXTERN_METHOD(setLogLevel: (NSString *)logLevel)

@end
