#import <React/RCTBundleURLProvider.h>
#import "RCTReactNativeFactory.h"
#import "RCTDefaultReactNativeFactoryDelegate.h"
#import <ReactAppDependencyProvider/RCTAppDependencyProvider.h>

@interface ReactViewController : UIViewController

@property (nonatomic, strong) RCTReactNativeFactory *reactNativeFactory;
@property (nonatomic, strong) id<RCTReactNativeFactoryDelegate> reactNativeFactoryDelegate;

@end

@interface ReactNativeDelegate : RCTDefaultReactNativeFactoryDelegate
@end
