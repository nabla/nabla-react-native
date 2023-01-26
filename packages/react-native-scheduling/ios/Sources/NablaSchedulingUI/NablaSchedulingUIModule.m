#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NablaSchedulingUIModule, NSObject)

RCT_EXTERN_METHOD(navigateToScheduleAppointmentScreen)
RCT_EXTERN_METHOD(navigateToAppointmentDetailScreen: (NSString *)appointmentId
                                           callback: (RCTResponseSenderBlock)callback)

@end
