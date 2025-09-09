#import "ReactViewController.h"
//#import "ApplePayView.h"

@implementation ReactViewController

- (instancetype)initWithProps:(NSDictionary *)props {
    self = [super init];
    if (self) {
        _initialProps = props;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reactNativeFactoryDelegate = [[ReactNativeDelegate alloc] init];
    [(ReactNativeDelegate *)self.reactNativeFactoryDelegate setDependencyProvider:[[RCTAppDependencyProvider alloc] init]];

    self.reactNativeFactory = [[RCTReactNativeFactory alloc] initWithDelegate:self.reactNativeFactoryDelegate];
    
    // Use initialProps if set, otherwise use default props
    NSDictionary *props = self.initialProps ?: @{
        @"props": @{
            @"type": @"payment",
            @"publishableKey": @"",
            @"clientSecret": @""
        }
    };
    
    self.view = [self.reactNativeFactory.rootViewFactory viewWithModuleName:@"hyperSwitch" initialProperties:props];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Call completion handler when view disappears (payment sheet dismissed)
    if (self.completionHandler) {
        // Default result when dismissed without explicit result
        NSDictionary *result = @{
            @"status": @"canceled",
            @"message": @"Payment sheet was dismissed"
        };
        self.completionHandler(result);
        self.completionHandler = nil;
    }
}

@end

@implementation ReactNativeDelegate

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge {
    return [self bundleURL];
}

- (BOOL)useDeveloperSupport:(RCTReactNativeFactory *)factory {
    return NO;
}

- (NSURL *)bundleURL {
//    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"hyperswitch" withExtension:@"bundle"];
    
//    if (!bundleURL) {
        NSBundle *hyperswitchBundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleURL = [hyperswitchBundle URLForResource:@"hyperswitch" withExtension:@"bundle"];
//    }
//    
//    if (!bundleURL) {
//        NSLog(@"ReactViewController: Could not find hyperswitch.bundle");
//    } else {
//        NSLog(@"ReactViewController: Found hyperswitch.bundle at: %@", bundleURL);
//    }
    
    return bundleURL;
}

//- (NSDictionary<NSString *, Class<RCTComponentViewProtocol>> *)thirdPartyFabricComponents {
//    return @{
//        @"ApplePayView": [ApplePayView class]
//    };
//}

@end
