#import "HyperswitchSdkReactNative.h"
#import "HyperProvider.h"
#import "RCTUtils.h"

@interface HyperswitchSdkReactNative ()
@property (nonatomic, strong, nullable) HyperProvider *hyperProvider;
@property (nonatomic, copy, nullable) RCTPromiseResolveBlock presentPaymentSheetResolver;
@property (nonatomic, copy, nullable) RCTPromiseRejectBlock presentPaymentSheetRejecter;
@end

@implementation HyperswitchSdkReactNative
RCT_EXPORT_MODULE()

- (instancetype)init {
    self = [super init];
    if (self) {
        // Listen for payment sheet exit notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlePaymentSheetExit:)
                                                     name:@"HyperPaymentSheetExit"
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handlePaymentSheetExit:(NSNotification *)notification {
    NSDictionary *result = notification.userInfo;
    if (result) {
        [self exitPaymentSheet:result];
    }
}

- (void)initialise:(NSString *)publishableKey
  customBackendUrl:(nullable NSString *)customBackendUrl
     customLogUrl:(nullable NSString *)customLogUrl
     customParams:(nullable NSDictionary *)customParams
          resolve:(RCTPromiseResolveBlock)resolve
           reject:(RCTPromiseRejectBlock)reject {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
//      UIViewController *rootViewController = RCTPresentedViewController();
        
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

- (void)presentPaymentSheet:(NSDictionary *)configuration
                    resolve:(RCTPromiseResolveBlock)resolve
                     reject:(RCTPromiseRejectBlock)reject {
    
    if (self.hyperProvider) {
        // Store the promise for later resolution
        self.presentPaymentSheetResolver = resolve;
        self.presentPaymentSheetRejecter = reject;
        
        [self.hyperProvider presentPaymentSheetWithConfiguration:configuration
                                                         callback:^(PaymentResult *result) {
        }];
    } else {
        reject(@"PRESENT_ERROR", @"HyperProvider not initialized", nil);
    }
}

- (void)exitPaymentSheet:(NSDictionary *)result {
    if (self.presentPaymentSheetResolver) {
        NSString *status = result[@"status"];
        if ([status isEqualToString:@"succeeded"] || [status isEqualToString:@"cancelled"]) {
            self.presentPaymentSheetResolver(result);
        } else {
            NSString *message = result[@"message"] ?: @"Payment failed";
            if (self.presentPaymentSheetRejecter) {
                self.presentPaymentSheetRejecter(@"PAYMENT_ERROR", message, nil);
            }
        }
        
        // Clear the stored promises
        self.presentPaymentSheetResolver = nil;
        self.presentPaymentSheetRejecter = nil;
    }
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeHyperswitchSdkReactNativeSpecJSI>(params);
}

@end
