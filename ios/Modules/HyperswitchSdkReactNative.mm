#import "HyperswitchSdkReactNative.h"
#import "HyperProvider.h"

@interface HyperswitchSdkReactNative ()
@property (nonatomic, strong, nullable) HyperProvider *hyperProvider;
@end

@implementation HyperswitchSdkReactNative
RCT_EXPORT_MODULE()

- (void)initialise:(NSString *)publishableKey
  customBackendUrl:(nullable NSString *)customBackendUrl
     customLogUrl:(nullable NSString *)customLogUrl
     customParams:(nullable NSDictionary *)customParams
          resolve:(RCTPromiseResolveBlock)resolve
           reject:(RCTPromiseRejectBlock)reject {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        
        if (rootViewController) {
            self.hyperProvider = [[HyperProvider alloc] initWithViewController:rootViewController];
            [self.hyperProvider initialiseWithPublishableKey:publishableKey
                                             customBackendUrl:customBackendUrl
                                                customLogUrl:customLogUrl
                                                customParams:customParams];
            resolve([NSNull null]);
        } else {
            reject(@"INITIALIZATION_ERROR", @"Root view controller is nil", nil);
        }
    });
}

- (void)initPaymentSession:(NSString *)paymentIntentClientSecret
                   resolve:(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject {
    
    if (self.hyperProvider) {
        [self.hyperProvider initPaymentSessionWithClientSecret:paymentIntentClientSecret];
        resolve([NSNull null]);
    } else {
        reject(@"INIT_ERROR", @"HyperProvider not initialized", nil);
    }
}

- (void)presentPaymentSheet:(RCTPromiseResolveBlock)resolve
                     reject:(RCTPromiseRejectBlock)reject {
    
    if (self.hyperProvider) {
        [self.hyperProvider presentPaymentSheetWithCallback:^(PaymentResult *result) {
            if ([result.status isEqualToString:@"completed"]) {
                NSDictionary *resultDict = @{
                    @"status": result.status,
                    @"message": result.message
                };
                resolve(resultDict);
            } else if ([result.status isEqualToString:@"canceled"]) {
                NSDictionary *resultDict = @{
                    @"status": result.status,
                    @"message": @"canceled"
                };
                resolve(resultDict);
            } else {
                reject(@"PAYMENT_ERROR", result.message, nil);
            }
        }];
    } else {
        reject(@"PRESENT_ERROR", @"HyperProvider not initialized", nil);
    }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeHyperswitchSdkReactNativeSpecJSI>(params);
}

@end
