#import "HyperswitchSdkNative.h"
#import "../Views/ApplePayHandler.h"
#import <React/RCTLog.h>

@interface HyperswitchSdkNative ()
@property (nonatomic, strong) ApplePayHandler *applePayHandler;
@property (nonatomic, copy) RCTResponseSenderBlock presentCallback;
@end

@implementation HyperswitchSdkNative

RCT_EXPORT_MODULE(HyperModules)

- (instancetype)init {
    self = [super init];
    if (self) {
        _applePayHandler = [[ApplePayHandler alloc] init];
    }
    return self;
}

- (void)sendMessageToNative:(NSString *)message {
    RCTLogInfo(@"sendMessageToNative called with: %@", message);
    // Forward to other modules if needed
}

- (void)launchApplePay:(NSString *)requestObj
              callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"launchApplePay called with: %@", requestObj);
    
    [self.applePayHandler startPayment:requestObj 
                            rnCallback:callback 
                       presentCallback:self.presentCallback];
}

- (void)startApplePay:(NSString *)requestObj
             callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"startApplePay called with: %@", requestObj);
    
    // This method is typically used as a confirmation callback
    // indicating that Apple Pay is ready to start
    callback(@[]);
}

- (void)presentApplePay:(NSString *)requestObj
               callback:(RCTResponseSenderBlock)callback {
    RCTLogInfo(@"presentApplePay called with: %@", requestObj);
    
    // Store the present callback for later use when Apple Pay sheet is presented
    self.presentCallback = callback;
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
    NSError *error;
    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (!error && resultDict) {
        NSString *status = resultDict[@"status"];
        RCTLogInfo(@"Payment result status: %@", status);
        
        // Find and dismiss the ReactViewController
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            UIViewController *presentedVC = rootViewController.presentedViewController;
            
            // Look for ReactViewController in the presented view controllers
            while (presentedVC) {
                if ([presentedVC isKindOfClass:NSClassFromString(@"ReactViewController")]) {
                    [presentedVC dismissViewControllerAnimated:YES completion:^{
                        // Call exitPaymentSheet on HyperswitchSdkReactNative to resolve the promise
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"HyperPaymentSheetExit"
                                                                            object:nil
                                                                          userInfo:resultDict];
                    }];
                    break;
                }
                presentedVC = presentedVC.presentedViewController;
            }
        });
    } else {
        RCTLogInfo(@"Failed to parse payment result: %@", error.localizedDescription);
        
        // Even if parsing fails, try to dismiss the controller with a default result
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
            UIViewController *presentedVC = rootViewController.presentedViewController;
            
            while (presentedVC) {
                if ([presentedVC isKindOfClass:NSClassFromString(@"ReactViewController")]) {
                    [presentedVC dismissViewControllerAnimated:YES completion:^{
                        NSDictionary *defaultResult = @{
                            @"status": @"failed",
                            @"message": @"Failed to parse payment result"
                        };
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"HyperPaymentSheetExit"
                                                                            object:nil
                                                                          userInfo:defaultResult];
                    }];
                    break;
                }
                presentedVC = presentedVC.presentedViewController;
            }
        });
    }

    self.presentCallback = nil;
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
