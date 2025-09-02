#import "HyperProvider.h"
#import "ReactViewController.h"

@implementation PaymentResult

- (instancetype)initWithStatus:(NSString *)status message:(NSString *)message {
    self = [super init];
    if (self) {
        _status = status;
        _message = message;
    }
    return self;
}

@end

@interface HyperProvider ()
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong, nullable) NSString *publishableKey;
@property (nonatomic, strong, nullable) NSString *customBackendUrl;
@property (nonatomic, strong, nullable) NSString *customLogUrl;
@property (nonatomic, strong, nullable) NSDictionary *customParams;
@property (nonatomic, strong, nullable) NSString *clientSecret;
@property (nonatomic, copy, nullable) PaymentResultCallback paymentCallback;
@end

@implementation HyperProvider

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (void)initialiseWithPublishableKey:(nullable NSString *)publishableKey
                    customBackendUrl:(nullable NSString *)customBackendUrl
                       customLogUrl:(nullable NSString *)customLogUrl
                       customParams:(nullable NSDictionary *)customParams {
    self.publishableKey = publishableKey;
    self.customBackendUrl = customBackendUrl;
    self.customLogUrl = customLogUrl;
    self.customParams = customParams;
}

- (void)initPaymentSessionWithClientSecret:(nullable NSString *)clientSecret {
    self.clientSecret = clientSecret;
}

- (void)presentPaymentSheetWithCallback:(PaymentResultCallback)callback {
    [self presentPaymentSheetWithConfiguration:nil callback:callback];
}

- (void)presentPaymentSheetWithConfiguration:(NSDictionary *)configuration
                                    callback:(PaymentResultCallback)callback {
    self.paymentCallback = callback;
    
    if (!self.viewController) {
        PaymentResult *result = [[PaymentResult alloc] initWithStatus:@"failed" 
                                                              message:@"View controller is nil"];
        callback(result);
        return;
    }
    
    // Set up the props similar to Android implementation
    NSMutableDictionary *props = [@{
        @"type": @"payment",
        @"publishableKey": self.publishableKey ?: @"",
        @"clientSecret": self.clientSecret ?: @"",
        @"configuration": configuration
    } mutableCopy];
    
    if (self.customBackendUrl) {
        props[@"customBackendUrl"] = self.customBackendUrl;
    }
    
    if (self.customLogUrl) {
        props[@"customLogUrl"] = self.customLogUrl;
    }
    
    if (self.customParams) {
        props[@"customParams"] = self.customParams;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Create ReactViewController with props passed directly to initializer
//        NSLog(@"Presenting payment sheet with props: %@", props);
        ReactViewController *reactVC = [[ReactViewController alloc] initWithProps:@{@"props": props}];
        
        reactVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        reactVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        // Set up completion handler for payment result
        __weak HyperProvider *weakSelf = self;
        reactVC.completionHandler = ^(NSDictionary *result) {
            __strong HyperProvider *strongSelf = weakSelf;
            if (strongSelf && strongSelf.paymentCallback) {
                NSString *status = result[@"status"] ?: @"unknown";
                NSString *message = result[@"message"] ?: @"Payment completed";
                
                PaymentResult *paymentResult = [[PaymentResult alloc] initWithStatus:status 
                                                                             message:message];
                strongSelf.paymentCallback(paymentResult);
                strongSelf.paymentCallback = nil;
            }
        };
        
        [self.viewController presentViewController:reactVC animated:YES completion:nil];
    });
}

@end
