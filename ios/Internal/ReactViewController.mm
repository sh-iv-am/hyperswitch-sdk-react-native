#import "ReactViewController.h"

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

- (NSURL *)bundleURL {
    return [[NSBundle mainBundle] URLForResource:@"hyperswitch" withExtension:@"bundle"];
}

@end
