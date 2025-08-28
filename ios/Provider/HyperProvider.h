#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PaymentResult : NSObject
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *message;

- (instancetype)initWithStatus:(NSString *)status message:(NSString *)message;
@end

typedef void (^PaymentResultCallback)(PaymentResult *result);

@interface HyperProvider : NSObject

- (instancetype)initWithViewController:(UIViewController *)viewController;

- (void)initialiseWithPublishableKey:(nullable NSString *)publishableKey
                    customBackendUrl:(nullable NSString *)customBackendUrl
                       customLogUrl:(nullable NSString *)customLogUrl
                       customParams:(nullable NSDictionary *)customParams;

- (void)initPaymentSessionWithClientSecret:(nullable NSString *)clientSecret;

- (void)presentPaymentSheetWithCallback:(PaymentResultCallback)callback;

@end
