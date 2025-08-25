#import "ReactViewController.h"

@implementation ReactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reactNativeFactoryDelegate = [[ReactNativeDelegate alloc] init];
    [(ReactNativeDelegate *)self.reactNativeFactoryDelegate setDependencyProvider:[[RCTAppDependencyProvider alloc] init]];
    
    self.reactNativeFactory = [[RCTReactNativeFactory alloc] initWithDelegate:self.reactNativeFactoryDelegate];
  
    NSDictionary *props = @{
        @"props": @{
            @"type": @"payment",
            @"publishableKey": @"",
            @"clientSecret": @""
        }
    };
    
    self.view = [self.reactNativeFactory.rootViewFactory viewWithModuleName:@"hyperSwitch" initialProperties:props];
}

@end

@implementation ReactNativeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    return [self bundleURL];
}

- (NSURL *)bundleURL {
    return [[NSBundle mainBundle] URLForResource:@"hyperswitch" withExtension:@"bundle"];
}

@end
