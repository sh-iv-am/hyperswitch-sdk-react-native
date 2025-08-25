#import "HyperswitchSdkReactNative.h"

@implementation HyperswitchSdkReactNative
RCT_EXPORT_MODULE()

- (void)launchPaymentSheet {
  dispatch_async(dispatch_get_main_queue(), ^{
    ReactViewController *reactVC = [[ReactViewController alloc] init];
    reactVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:reactVC animated:YES completion:nil];
  });
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeHyperswitchSdkReactNativeSpecJSI>(params);
}

@end
