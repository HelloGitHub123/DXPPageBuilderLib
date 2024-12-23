//
//  PBBaseViewController.h
//  MPTCLPMall
//
//  Created by OO on 2020/9/2.
//  Copyright © 2020 OO. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PBBaseViewController : UIViewController

@property (nonatomic, assign) BOOL hideNaVLine;
// 设置导航栏颜色
@property (nonatomic, strong) UIColor * naviColor;
// 设置导航栏背景图
@property (nonatomic, strong) UIImage * naviImg;
// 设置导航栏字体颜色
@property (nonatomic, strong) UIColor * titleColor;

@property (nonatomic, strong) NSString *navTitleStr;

@property (nonatomic, copy) NSString *backImgName;

@property (nonatomic, assign) float topHight;//tableview 距离顶部的高度
@property (nonatomic, assign) long subsViewIndex;//设置所有subsview代码

@property (nonatomic, strong) NSMutableDictionary *paramsDic;

/**
 *  判断是否支持游客。如果路由中配置了isNeedLogin = Y 。那在游客模式下就跳转了登录。但是特殊情况下，像充值页面如果支持游客模块，那就需要将路由的 isNeedLogin = N  并透传到具体业务页面，做特殊判断过滤。
 *  具体页面具体使用判断，不能统一处理。
 *   总之:  如果 isNeedLogin = N (支持游客)  那么 isSupportTourist 在路由处就赋值为 Y
 *        如果 isNeedLogin = Y (不支持游客) 那么 isSupportTourist 在路由处就赋值为 N
 */
@property (nonatomic, assign) BOOL isSupportTourist;

@property (nonatomic, copy) void (^returnValue)(NSString *string);

- (void)ExChangeAppLanguage;
- (void)initDataFromParmas;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void)naviBackAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
