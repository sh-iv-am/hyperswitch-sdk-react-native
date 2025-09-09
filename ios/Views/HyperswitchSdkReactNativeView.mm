#import "HyperswitchSdkReactNativeView.h"

#import <react/renderer/components/HyperswitchSdkReactNativeSpec/ComponentDescriptors.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/EventEmitters.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/Props.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface HyperswitchSdkReactNativeView () <RCTHyperswitchSdkReactNativeViewViewProtocol>

@end

@implementation HyperswitchSdkReactNativeView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<HyperswitchSdkReactNativeViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const HyperswitchSdkReactNativeViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];
    
    // Set default styling to make the box visible
    _view.backgroundColor = [UIColor systemBlueColor];
    _view.layer.borderWidth = 2.0f;
    _view.layer.borderColor = [UIColor blackColor].CGColor;
    _view.layer.cornerRadius = 8.0f;
    
    // Add a label to show it's working
    UILabel *label = [[UILabel alloc] init];
    label.text = @"Hyperswitch Box";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.frame = CGRectMake(0, 0, 200, 50);
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_view addSubview:label];
    
    NSLog(@"HyperswitchSdkReactNativeView: Created view with frame %@", NSStringFromCGRect(frame));

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<HyperswitchSdkReactNativeViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<HyperswitchSdkReactNativeViewProps const>(props);

    if (oldViewProps.color != newViewProps.color) {
        NSString * colorToConvert = [[NSString alloc] initWithUTF8String: newViewProps.color.c_str()];
        [_view setBackgroundColor:[self hexStringToColor:colorToConvert]];
    }

    [super updateProps:props oldProps:oldProps];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Ensure the inner view fills the entire container
    if (_view) {
        _view.frame = self.bounds;
        NSLog(@"HyperswitchSdkReactNativeView: Layout updated to frame %@", NSStringFromCGRect(self.bounds));
    }
}

Class<RCTComponentViewProtocol> HyperswitchSdkReactNativeViewCls(void)
{
    return HyperswitchSdkReactNativeView.class;
}

- hexStringToColor:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *stringScanner = [NSScanner scannerWithString:noHashString];

    unsigned hex;
    if (![stringScanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;

    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

@end
