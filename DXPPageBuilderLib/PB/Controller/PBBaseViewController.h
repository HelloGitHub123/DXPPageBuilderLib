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

@property (nonatomic, copy) void (^returnValue)(NSString *string);

- (void)ExChangeAppLanguage;
- (void)initDataFromParmas;
- (UIImage *)imageWithColor:(UIColor *)color;
- (void)naviBackAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
