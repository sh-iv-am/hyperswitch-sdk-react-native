#import "ApplePayView.h"
#import <PassKit/PassKit.h>

#import <react/renderer/components/HyperswitchSdkReactNativeSpec/ComponentDescriptors.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/EventEmitters.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/Props.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface SimpleApplePayHandler : NSObject <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, copy) void (^completionHandler)(NSDictionary *result);
@property (nonatomic, strong) PKPaymentRequest *paymentRequest;

- (void)presentApplePayWithRequest:(PKPaymentRequest *)request 
                fromViewController:(UIViewController *)viewController 
                        completion:(void (^)(NSDictionary *result))completion;

@end

@implementation SimpleApplePayHandler

- (void)presentApplePayWithRequest:(PKPaymentRequest *)request 
                fromViewController:(UIViewController *)viewController 
                        completion:(void (^)(NSDictionary *result))completion {
    
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        completion(@{
            @"status": @"error",
            @"message": @"Apple Pay is not available on this device"
        });
        return;
    }
    
    self.paymentRequest = request;
    self.completionHandler = completion;
    
    PKPaymentAuthorizationViewController *paymentVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    paymentVC.delegate = self;
    
    if (paymentVC) {
        [viewController presentViewController:paymentVC animated:YES completion:nil];
    } else {
        completion(@{
            @"status": @"error",
            @"message": @"Failed to create Apple Pay view controller"
        });
    }
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion {
    
    PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
    completion(result);
    
    NSString *paymentData = [[NSString alloc] initWithData:payment.token.paymentData encoding:NSUTF8StringEncoding];
    
    if (self.completionHandler) {
        self.completionHandler(@{
            @"status": @"success",
            @"paymentData": paymentData ?: @"",
            @"transactionIdentifier": payment.token.transactionIdentifier ?: @""
        });
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:^{
        if (self.completionHandler) {
            self.completionHandler(@{
                @"status": @"canceled",
                @"message": @"Payment was canceled by user"
            });
            self.completionHandler = nil;
        }
    }];
}

@end

@interface ApplePayView () <RCTApplePayViewViewProtocol>

@end

@implementation ApplePayView {
    PKPaymentButton *_paymentButton;
    SimpleApplePayHandler *_paymentHandler;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<ApplePayViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ApplePayViewProps>();
    _props = defaultProps;

    _paymentHandler = [[SimpleApplePayHandler alloc] init];
    [self setupDefaultButton];
  }

  return self;
}

- (void)setupDefaultButton {
    [self setupButtonWithType:PKPaymentButtonTypePlain style:PKPaymentButtonStyleBlack cornerRadius:4.0];
}

- (void)setupButtonWithType:(PKPaymentButtonType)type style:(PKPaymentButtonStyle)style cornerRadius:(CGFloat)cornerRadius {
    [_paymentButton removeFromSuperview];
    
    _paymentButton = [[PKPaymentButton alloc] initWithPaymentButtonType:type paymentButtonStyle:style];
    _paymentButton.cornerRadius = cornerRadius;
    
    [_paymentButton addTarget:self action:@selector(applePayButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_paymentButton];
    self.contentView = _paymentButton;
}

- (PKPaymentButtonType)paymentButtonTypeFromString:(NSString *)type {
    if ([type isEqualToString:@"buy"]) return PKPaymentButtonTypeBuy;
    if ([type isEqualToString:@"setUp"]) return PKPaymentButtonTypeSetUp;
    if ([type isEqualToString:@"inStore"]) return PKPaymentButtonTypeInStore;
    if ([type isEqualToString:@"donate"]) return PKPaymentButtonTypeDonate;
    if ([type isEqualToString:@"checkout"]) return PKPaymentButtonTypeCheckout;
    if ([type isEqualToString:@"book"]) return PKPaymentButtonTypeBook;
    if ([type isEqualToString:@"subscribe"]) return PKPaymentButtonTypeSubscribe;
    return PKPaymentButtonTypePlain;
}

- (PKPaymentButtonStyle)paymentButtonStyleFromString:(NSString *)style {
    if ([style isEqualToString:@"white"]) return PKPaymentButtonStyleWhite;
    if ([style isEqualToString:@"whiteOutline"]) return PKPaymentButtonStyleWhiteOutline;
    return PKPaymentButtonStyleBlack;
}

- (void)applePayButtonTapped:(PKPaymentButton *)button {
    if (![PKPaymentAuthorizationViewController canMakePayments]) {
        [self sendPaymentResult:@{
            @"status": @"error",
            @"message": @"Apple Pay is not available"
        }];
        return;
    }
    
    PKPaymentRequest *request = [self createPaymentRequest];
    if (!request) {
        [self sendPaymentResult:@{
            @"status": @"error", 
            @"message": @"Invalid payment configuration"
        }];
        return;
    }
    
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    __weak ApplePayView *weakSelf = self;
    [_paymentHandler presentApplePayWithRequest:request 
                             fromViewController:rootViewController 
                                     completion:^(NSDictionary *result) {
        [weakSelf sendPaymentResult:result];
    }];
}

- (PKPaymentRequest *)createPaymentRequest {
    PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
    
    // Use default values for now - these would be set via props in a complete implementation
    request.merchantIdentifier = @"merchant.com.example";
    request.countryCode = @"US";
    request.currencyCode = @"USD";
    request.supportedNetworks = @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex, PKPaymentNetworkDiscover];
    request.merchantCapabilities = PKMerchantCapability3DS;
    
    NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:@"1.00"];
    PKPaymentSummaryItem *summaryItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Payment" amount:amountDecimal];
    request.paymentSummaryItems = @[summaryItem];
    
    if ([request.merchantIdentifier length] == 0 || [amountDecimal compare:[NSDecimalNumber zero]] != NSOrderedDescending) {
        return nil;
    }
    
    return request;
}

- (void)sendPaymentResult:(NSDictionary *)result {
    // For now, just log the result - proper event emission would require 
    // defining the event in the component specification
    NSLog(@"Apple Pay Result: %@", result);
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    // Update props handling - would need to define proper props in component spec
    [super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _paymentButton.frame = self.bounds;
}

Class<RCTComponentViewProtocol> ApplePayViewCls(void)
{
    return ApplePayView.class;
}

@end
