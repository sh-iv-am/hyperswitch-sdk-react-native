#import "HyperswitchSdkNative.h"
#import <React/RCTLog.h>

@implementation HyperswitchSdkNative

RCT_EXPORT_MODULE(HyperModules)

- (void)sendMessageToNative:(NSString *)message {
    RCTLogInfo(@"sendMessageToNative called with: %@", message);
    // Forward to other modules if needed
}

- (void)launchApplePay:(NSString *)requestObj
              callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"launchApplePay called");
    // Implementation for Apple Pay
    callback(@[@"Apple Pay implementation needed"]);
}

- (void)startApplePay:(NSString *)requestObj
             callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"startApplePay called");
    callback(@[@"Apple Pay start implementation needed"]);
}

- (void)presentApplePay:(NSString *)requestObj
               callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"presentApplePay called");
    callback(@[@"Apple Pay present implementation needed"]);
}

- (void)launchGPay:(NSString *)requestObj
          callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"launchGPay called");
    // Google Pay is not available on iOS, but we can provide a callback
    callback(@[@"Google Pay not available on iOS"]);
}

- (void)exitPaymentsheet:(double)rootTag
                  result:(NSString *)result
                   reset:(BOOL)reset {
    RCTLogInfo(@"exitPaymentsheet called with rootTag: %f, result: %@, reset: %@", 
               rootTag, result, reset ? @"YES" : @"NO");
    // Implementation for exiting payment sheet
}

- (void)exitPaymentMethodManagement:(double)rootTag
                             result:(NSString *)result
                              reset:(BOOL)reset {
    RCTLogInfo(@"exitPaymentMethodManagement called with rootTag: %f, result: %@, reset: %@", 
               rootTag, result, reset ? @"YES" : @"NO");
    // Implementation for exiting payment method management
}

- (void)exitWidget:(NSString *)result
        widgetType:(NSString *)widgetType {
    RCTLogInfo(@"exitWidget called with result: %@, widgetType: %@", result, widgetType);
    // Implementation for exiting widget
}

- (void)exitCardForm:(NSString *)result {
    RCTLogInfo(@"exitCardForm called with result: %@", result);
    // Implementation for exiting card form
}

- (void)exitWidgetPaymentsheet:(double)rootTag
                        result:(NSString *)result
                         reset:(BOOL)reset {
    RCTLogInfo(@"exitWidgetPaymentsheet called with rootTag: %f, result: %@, reset: %@", 
               rootTag, result, reset ? @"YES" : @"NO");
    // Implementation for exiting widget payment sheet
}

- (void)launchWidgetPaymentSheet:(NSString *)requestObj
                        callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"launchWidgetPaymentSheet called");
    // Implementation for launching widget payment sheet
    callback(@[@"Widget payment sheet implementation needed"]);
}

- (void)updateWidgetHeight:(double)height {
    RCTLogInfo(@"updateWidgetHeight called with height: %f", height);
    // Implementation for updating widget height
}

- (void)onAddPaymentMethod:(NSString *)data {
    RCTLogInfo(@"onAddPaymentMethod called with data: %@", data);
    // Implementation for adding payment method
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeHyperswitchSdkNativeSpecJSI>(params);
}

@end
