//
//  HyperParams.h
//  Pods
//
//  Created by Kuntimaddi Manideep on 08/09/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyperParams : NSObject

+ (nullable NSString *)appId;
+ (NSString *)sdkVersion;
+ (nullable NSString *)country;
+ (nullable NSString *)userAgent;
+ (NSString *)deviceModel;
+ (NSString *)osVersion;

+ (UIEdgeInsets)getSafeAreaInsets;
+ (NSDictionary<NSString *, id> *)getHyperParams;

@end

NS_ASSUME_NONNULL_END
