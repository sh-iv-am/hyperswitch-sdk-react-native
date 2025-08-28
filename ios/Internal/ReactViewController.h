#import <React/RCTBundleURLProvider.h>
#import <RCTReactNativeFactory.h>
#import <RCTDefaultReactNativeFactoryDelegate.h>
#import <ReactAppDependencyProvider/RCTAppDependencyProvider.h>

typedef void (^ReactViewControllerCompletionHandler)(NSDictionary *result);

@interface ReactViewController : UIViewController

@property (nonatomic, strong) RCTReactNativeFactory *reactNativeFactory;
@property (nonatomic, strong) id<RCTReactNativeFactoryDelegate> reactNativeFactoryDelegate;
@property (nonatomic, strong, nullable) NSDictionary *initialProps;
@property (nonatomic, copy, nullable) ReactViewControllerCompletionHandler completionHandler;

- (instancetype)initWithProps:(NSDictionary *)props;

@end

@interface ReactNativeDelegate : RCTDefaultReactNativeFactoryDelegate
@end
