//
//  DCRouterManager.h
//  DCControls
//
//  Created by Lee on 2022/10/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCRouterManager : NSObject
+ (instancetype)sharedInstance;

- (void)loadRouterFromPlist:(NSString *)path;

- (UIViewController *)getViewController:(NSString *)code;

- (UIViewController *)getViewController:(NSString *)code type:(NSInteger)type loadUrl:(NSString *)url serviceName:(NSString *)serviceName;

- (void)dealAfterLogin; // 登录后在进行跳转页面，逻辑在内部进行判断
- (void)dealWithViewNameWithUrl:(NSString *)urlStr
                           type:(NSInteger)type
                         fromVc:(UIViewController *)fromVC
                    serviceName:(NSString *)serviceName
                      needLogin:(NSString *)needLogin;


- (void)dealWithViewNameWithUrl:(NSString *)urlStr
                           type:(NSInteger)type
                         fromVc:(UIViewController *)fromVC
                    serviceName:(NSString *)serviceName;

@end

NS_ASSUME_NONNULL_END
