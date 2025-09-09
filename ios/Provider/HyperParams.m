//
//  HyperParams.m
//  Pods
//
//  Created by Kuntimaddi Manideep on 08/09/25.
//

#import "HyperParams.h"

@implementation HyperParams

+ (nullable NSString *)appId {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)sdkVersion {
    return @"0.1.0";
}

+ (nullable NSString *)country {
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (nullable NSString *)userAgent {
    // Uses WKWebView to fetch user-agent
    __block NSString *userAgent = nil;
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    dispatch_async(dispatch_get_main_queue(), ^{
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        [webView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id result, NSError *error) {
            if (!error && [result isKindOfClass:[NSString class]]) {
                userAgent = (NSString *)result;
            }
            dispatch_semaphore_signal(sema);
        }];
    });

    // Wait for user agent retrieval
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return userAgent;
}

+ (NSString *)deviceModel {
    return [[UIDevice currentDevice] model];
}

+ (NSString *)osVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (UIEdgeInsets)getSafeAreaInsets {
    UIWindowScene *scene = (UIWindowScene *)[[[UIApplication sharedApplication] connectedScenes] anyObject];
    UIWindow *window = scene.windows.firstObject;
    if (window != nil) {
        return window.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

+ (NSDictionary<NSString *, id> *)getHyperParams {
    UIEdgeInsets safeAreaInset = [self getSafeAreaInsets];
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970] * 1000;

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[self appId] ?: [NSNull null] forKey:@"appId"];
    [params setObject:[self sdkVersion] forKey:@"sdkVersion"];
    [params setObject:[self country] ?: [NSNull null] forKey:@"country"];
    [params setObject:[self userAgent] ?: [NSNull null] forKey:@"user-agent"];
    [params setObject:[self deviceModel] forKey:@"device_model"];
    [params setObject:[self osVersion] forKey:@"os_version"];
    [params setObject:@"ios" forKey:@"os_type"];
    [params setObject:@((long long)timestamp) forKey:@"launchTime"];
    [params setObject:@(safeAreaInset.top) forKey:@"topInset"];
    [params setObject:@(safeAreaInset.bottom) forKey:@"bottomInset"];
    [params setObject:@(safeAreaInset.left) forKey:@"leftInset"];
    [params setObject:@(safeAreaInset.right) forKey:@"rightInset"];

    return params;
}

@end
