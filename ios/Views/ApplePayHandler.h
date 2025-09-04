//
//  ApplePayHandler.h
//  Hyperswitch
//
//  Created by Shivam Shashank on 10/12/22.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>
#import <React/RCTBridgeModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplePayHandler : NSObject <PKPaymentAuthorizationControllerDelegate>

@property (nonatomic, assign) PKPaymentAuthorizationStatus paymentStatus;
@property (nonatomic, copy, nullable) RCTResponseSenderBlock callback;

- (void)startPayment:(NSString *)rnMessage 
          rnCallback:(RCTResponseSenderBlock)rnCallback 
     presentCallback:(nullable RCTResponseSenderBlock)presentCallback;

@end

NS_ASSUME_NONNULL_END