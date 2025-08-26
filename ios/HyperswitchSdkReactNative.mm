#import "HyperswitchSdkReactNative.h"
#import <Foundation/Foundation.h>

// Import the generated Swift header
#import "HyperswitchSdkReactNative-Swift.h"

@implementation HyperswitchSDKReactNative : NSObject
RCT_EXPORT_MODULE()

- (void)launchPaymentSheet {
  [[HyperswitchSwiftImplementation shared] launchPaymentSheet];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeHyperswitchSdkReactNativeSpecJSI>(params);
}

- (void)confirmWithCustomerDefaultPaymentMethod:(nonnull NSDictionary *)sessionParams cvc:(NSString * _Nullable)cvc callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] confirmWithCustomerDefaultPaymentMethodWithSessionParams:sessionParams cvc:cvc callback:callback resolve:resolve reject:reject];
}

- (void)confirmWithCustomerLastUsedPaymentMethod:(nonnull NSDictionary *)sessionParams cvc:(NSString * _Nullable)cvc callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] confirmWithCustomerLastUsedPaymentMethodWithSessionParams:sessionParams cvc:cvc callback:callback resolve:resolve reject:reject];
}

- (void)confirmWithCustomerPaymentToken:(nonnull NSDictionary *)sessionParams cvc:(NSString * _Nullable)cvc paymentToken:(nonnull NSString *)paymentToken callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] confirmWithCustomerPaymentTokenWithSessionParams:sessionParams cvc:cvc paymentToken:paymentToken callback:callback resolve:resolve reject:reject];
}

- (void)getCustomerDefaultSavedPaymentMethodData:(nonnull NSDictionary *)sessionParams callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] getCustomerDefaultSavedPaymentMethodDataWithSessionParams:sessionParams callback:callback resolve:resolve reject:reject];
}

- (void)getCustomerLastUsedPaymentMethodData:(nonnull NSDictionary *)sessionParams callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] getCustomerLastUsedPaymentMethodDataWithSessionParams:sessionParams callback:callback resolve:resolve reject:reject];
}

- (void)getCustomerSavedPaymentMethodData:(nonnull NSDictionary *)sessionParams callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] getCustomerSavedPaymentMethodDataWithSessionParams:sessionParams callback:callback resolve:resolve reject:reject];
}

- (void)getCustomerSavedPaymentMethods:(nonnull NSDictionary *)sessionParams callback:(nonnull RCTResponseSenderBlock)callback resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] getCustomerSavedPaymentMethodsWithSessionParams:sessionParams callback:callback resolve:resolve reject:reject];
}

- (void)initPaymentSession:(nonnull NSDictionary *)params resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] initPaymentSessionWithParams:params resolve:resolve reject:reject];
}

- (void)presentPaymentSheet:(nonnull NSDictionary *)sessionParams resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  [[HyperswitchSwiftImplementation shared] presentPaymentSheetWithSessionParams:sessionParams resolve:resolve reject:reject];
}

@end
