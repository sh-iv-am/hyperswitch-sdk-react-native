//
//  ApplePayHandler.mm
//  Hyperswitch
//
//  Created by Shivam Shashank on 10/12/22.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import <React/RCTBridgeModule.h>

@interface ApplePayHandler : NSObject <PKPaymentAuthorizationControllerDelegate>

@property (nonatomic, assign) PKPaymentAuthorizationStatus paymentStatus;
@property (nonatomic, copy) RCTResponseSenderBlock callback;

- (void)startPayment:(NSString *)rnMessage 
          rnCallback:(RCTResponseSenderBlock)rnCallback 
     presentCallback:(RCTResponseSenderBlock)presentCallback;

@end

@implementation ApplePayHandler

- (instancetype)init {
    self = [super init];
    if (self) {
        _paymentStatus = PKPaymentAuthorizationStatusFailure;
    }
    return self;
}

- (void)startPayment:(NSString *)rnMessage 
          rnCallback:(RCTResponseSenderBlock)rnCallback 
     presentCallback:(RCTResponseSenderBlock)presentCallback {
    
    self.callback = rnCallback;
    NSSet<PKContactField> *requiredBillingContactFields = nil;
    NSSet<PKContactField> *requiredShippingContactFields = nil;
    
    NSError *error;
    NSData *data = [rnMessage dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (!dict || error) {
        if (presentCallback) presentCallback(@[]);
        rnCallback(@[@{@"status": @"Error", @"message": @"01"}]);
        return;
    }
    
    NSDictionary *paymentRequestData = dict[@"payment_request_data"];
    if (!paymentRequestData) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"02"}]);
        self.callback = nil;
        return;
    }
    
    NSString *countryCode = paymentRequestData[@"country_code"];
    if (!countryCode) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"03"}]);
        self.callback = nil;
        return;
    }
    
    NSString *currencyCode = paymentRequestData[@"currency_code"];
    if (!currencyCode) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"04"}]);
        self.callback = nil;
        return;
    }
    
    NSDictionary *total = paymentRequestData[@"total"];
    if (!total) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"05"}]);
        self.callback = nil;
        return;
    }
    
    NSString *amount = total[@"amount"];
    NSString *label = total[@"label"];
    NSString *type = total[@"type"];
    
    if (!amount || !label || !type) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"06"}]);
        self.callback = nil;
        return;
    }
    
    NSArray<NSString *> *merchantCapabilitiesArray = paymentRequestData[@"merchant_capabilities"];
    if (!merchantCapabilitiesArray) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"07"}]);
        self.callback = nil;
        return;
    }
    
    NSString *merchantIdentifier = paymentRequestData[@"merchant_identifier"];
    if (!merchantIdentifier) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"08"}]);
        self.callback = nil;
        return;
    }
    
    NSArray<NSString *> *supportedNetworksArray = paymentRequestData[@"supported_networks"];
    if (!supportedNetworksArray) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"09"}]);
        self.callback = nil;
        return;
    }
    
    NSMutableArray<PKPaymentNetwork> *supportedNetworks = [NSMutableArray array];
    for (NSString *networkString in supportedNetworksArray) {
        PKPaymentNetwork network = [self mapStringToPaymentNetwork:networkString];
        if (network) {
            [supportedNetworks addObject:network];
        }
    }
    
    NSArray<NSString *> *requiredBillingContactFieldsArray = paymentRequestData[@"required_billing_contact_fields"];
    if (requiredBillingContactFieldsArray) {
        NSMutableSet<PKContactField> *billingFields = [NSMutableSet set];
        for (NSString *fieldString in requiredBillingContactFieldsArray) {
            PKContactField field = [self mapStringToPKContactField:fieldString];
            if (field) {
                [billingFields addObject:field];
            }
        }
        requiredBillingContactFields = [billingFields copy];
    }
    
    NSArray<NSString *> *requiredShippingContactFieldsArray = paymentRequestData[@"required_shipping_contact_fields"];
    if (requiredShippingContactFieldsArray) {
        NSMutableSet<PKContactField> *shippingFields = [NSMutableSet set];
        for (NSString *fieldString in requiredShippingContactFieldsArray) {
            PKContactField field = [self mapStringToPKContactField:fieldString];
            if (field) {
                [shippingFields addObject:field];
            }
        }
        requiredShippingContactFields = [shippingFields copy];
    }
    
    PKPaymentSummaryItem *paymentSummaryItem = [PKPaymentSummaryItem summaryItemWithLabel:label 
                                                                                   amount:[NSDecimalNumber decimalNumberWithString:amount] 
                                                                                     type:[type isEqualToString:@"final"] ? PKPaymentSummaryItemTypeFinal : PKPaymentSummaryItemTypePending];
    
    PKPaymentRequest *paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.paymentSummaryItems = @[paymentSummaryItem];
    paymentRequest.merchantIdentifier = merchantIdentifier;
    paymentRequest.countryCode = countryCode;
    paymentRequest.currencyCode = currencyCode;
    paymentRequest.requiredShippingContactFields = requiredShippingContactFields ?: [NSSet set];
    paymentRequest.requiredBillingContactFields = requiredBillingContactFields ?: [NSSet set];
    paymentRequest.supportedNetworks = supportedNetworks;
    
    for (NSString *capability in merchantCapabilitiesArray) {
        if ([capability isEqualToString:@"supports3DS"]) {
            paymentRequest.merchantCapabilities = PKMerchantCapability3DS;
        } else {
            paymentRequest.merchantCapabilities = PKMerchantCapabilityDebit;
        }
    }
    
    // Validate payment request
    if (![PKPaymentAuthorizationController canMakePayments] ||
        [paymentRequest.merchantIdentifier length] == 0 ||
        ![[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest]) {
        if (presentCallback) presentCallback(@[]);
        self.callback(@[@{@"status": @"Error", @"message": @"10"}]);
        self.callback = nil;
        return;
    }
    
    PKPaymentAuthorizationController *paymentController = [[PKPaymentAuthorizationController alloc] initWithPaymentRequest:paymentRequest];
    paymentController.delegate = self;
    
    [paymentController presentWithCompletion:^(BOOL presented) {
        if (presentCallback) presentCallback(@[]);
        if (presented) {
            // Reset payment status to indicate payment is in progress
            self.paymentStatus = (PKPaymentAuthorizationStatus)NSNotFound;
        } else {
            self.callback(@[@{@"status": @"Error", @"message": @"11"}]);
            self.callback = nil;
        }
    }];
}

#pragma mark - Helper Methods

- (PKPaymentNetwork)mapStringToPaymentNetwork:(NSString *)networkString {
    if ([networkString isEqualToString:@"visa"]) {
        return PKPaymentNetworkVisa;
    } else if ([networkString isEqualToString:@"masterCard"]) {
        return PKPaymentNetworkMasterCard;
    } else if ([networkString isEqualToString:@"amex"]) {
        return PKPaymentNetworkAmex;
    } else if ([networkString isEqualToString:@"discover"]) {
        return PKPaymentNetworkDiscover;
    } else if ([networkString isEqualToString:@"quicPay"]) {
        return PKPaymentNetworkQuicPay;
    }
    return nil;
}

- (PKContactField)mapStringToPKContactField:(NSString *)fieldString {
    if ([fieldString isEqualToString:@"postalAddress"]) {
        return PKContactFieldPostalAddress;
    } else if ([fieldString isEqualToString:@"email"]) {
        return PKContactFieldEmailAddress;
    } else if ([fieldString isEqualToString:@"phone"]) {
        return PKContactFieldPhoneNumber;
    } else if ([fieldString isEqualToString:@"name"]) {
        return PKContactFieldName;
    } else if ([fieldString isEqualToString:@"phoneticName"]) {
        return PKContactFieldPhoneticName;
    }
    return nil;
}

- (NSDictionary *)convertPKContactToDictionary:(PKContact *)contact {
    NSMutableDictionary *contactDict = [NSMutableDictionary dictionary];
    
    if (contact.name) {
        NSMutableDictionary *nameDict = [NSMutableDictionary dictionary];
        if (contact.name.givenName) nameDict[@"givenName"] = contact.name.givenName;
        if (contact.name.familyName) nameDict[@"familyName"] = contact.name.familyName;
        if (contact.name.namePrefix) nameDict[@"namePrefix"] = contact.name.namePrefix;
        if (contact.name.nameSuffix) nameDict[@"nameSuffix"] = contact.name.nameSuffix;
        if (contact.name.nickname) nameDict[@"nickname"] = contact.name.nickname;
        if (contact.name.middleName) nameDict[@"middleName"] = contact.name.middleName;
        contactDict[@"name"] = nameDict;
    }
    
    if (contact.postalAddress) {
        NSMutableDictionary *addressDict = [NSMutableDictionary dictionary];
        addressDict[@"street"] = contact.postalAddress.street ?: @"";
        addressDict[@"city"] = contact.postalAddress.city ?: @"";
        addressDict[@"state"] = contact.postalAddress.state ?: @"";
        addressDict[@"postalCode"] = contact.postalAddress.postalCode ?: @"";
        addressDict[@"country"] = contact.postalAddress.country ?: @"";
        addressDict[@"subLocality"] = contact.postalAddress.subLocality ?: @"";
        addressDict[@"subAdministrativeArea"] = contact.postalAddress.subAdministrativeArea ?: @"";
        addressDict[@"isoCountryCode"] = contact.postalAddress.ISOCountryCode ?: @"";
        contactDict[@"postalAddress"] = addressDict;
    }
    
    if (contact.phoneNumber) {
        contactDict[@"phoneNumber"] = contact.phoneNumber.stringValue;
    }
    
    if (contact.emailAddress) {
        contactDict[@"emailAddress"] = contact.emailAddress;
    }
    
    return [contactDict copy];
}

#pragma mark - PKPaymentAuthorizationControllerDelegate

- (void)paymentAuthorizationController:(PKPaymentAuthorizationController *)controller 
                   didAuthorizePayment:(PKPayment *)payment 
                               handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion {
    
    NSArray *errors = @[];
    PKPaymentAuthorizationStatus status = PKPaymentAuthorizationStatusSuccess;
    self.paymentStatus = status;
    
    NSString *dataString = [payment.token.paymentData base64EncodedStringWithOptions:0];
    
    NSString *paymentType = @"debit";
    switch (payment.token.paymentMethod.type) {
        case PKPaymentMethodTypeDebit:
            paymentType = @"debit";
            break;
        case PKPaymentMethodTypeCredit:
            paymentType = @"credit";
            break;
        case PKPaymentMethodTypeStore:
            paymentType = @"store";
            break;
        case PKPaymentMethodTypePrepaid:
            paymentType = @"prepaid";
            break;
        case PKPaymentMethodTypeEMoney:
            paymentType = @"eMoney";
            break;
        default:
            paymentType = @"unknown";
            break;
    }
    
    self.callback(@[@{
        @"status": @"Success",
        @"payment_data": dataString,
        @"payment_method": @{
            @"type": paymentType,
            @"network": payment.token.paymentMethod.network ?: @"",
            @"display_name": payment.token.paymentMethod.displayName ?: @""
        },
        @"transaction_identifier": payment.token.transactionIdentifier,
        @"billing_contact": [self convertPKContactToDictionary:payment.billingContact],
        @"shipping_contact": [self convertPKContactToDictionary:payment.shippingContact]
    }]);
    
    PKPaymentAuthorizationResult *result = [[PKPaymentAuthorizationResult alloc] initWithStatus:self.paymentStatus errors:errors];
    completion(result);
}

- (void)paymentAuthorizationControllerDidFinish:(PKPaymentAuthorizationController *)controller {
    [controller dismissWithCompletion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.paymentStatus == PKPaymentAuthorizationStatusFailure) {
                self.callback(@[@{@"status": @"Failed"}]);
            } else if (self.paymentStatus == (PKPaymentAuthorizationStatus)NSNotFound) {
                self.callback(@[@{@"status": @"Cancelled"}]);
            }
        });
    }];
}

@end