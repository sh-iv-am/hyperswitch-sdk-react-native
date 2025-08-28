#import "ApplePayView.h"
#import <PassKit/PassKit.h>

#import <react/renderer/components/HyperswitchSdkReactNativeSpec/ComponentDescriptors.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/EventEmitters.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/Props.h>
#import <react/renderer/components/HyperswitchSdkReactNativeSpec/RCTComponentViewHelpers.h>

#import "RCTFabricComponentsPlugins.h"

using namespace facebook::react;

@interface ApplePayView () <RCTApplePayViewViewProtocol>

@end

@implementation ApplePayView {
    UIView * _view;
}

+ (ComponentDescriptorProvider)componentDescriptorProvider
{
    return concreteComponentDescriptorProvider<ApplePayViewComponentDescriptor>();
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame]) {
    static const auto defaultProps = std::make_shared<const ApplePayViewProps>();
    _props = defaultProps;

    _view = [[UIView alloc] init];

    self.contentView = _view;
  }

  return self;
}

- (void)updateProps:(Props::Shared const &)props oldProps:(Props::Shared const &)oldProps
{
    const auto &oldViewProps = *std::static_pointer_cast<ApplePayViewProps const>(_props);
    const auto &newViewProps = *std::static_pointer_cast<ApplePayViewProps const>(props);

    [super updateProps:props oldProps:oldProps];
}

Class<RCTComponentViewProtocol> ApplePayViewCls(void)
{
    return ApplePayView.class;
}

@end
