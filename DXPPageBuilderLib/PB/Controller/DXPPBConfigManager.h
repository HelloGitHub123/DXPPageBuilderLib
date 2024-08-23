//
//  DXPPBConfigManager.h
//  DXPPageBuild
//
//  Created by 李标 on 2024/7/13.
//  PB对外开放配置管理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DXPPBConfigManager : NSObject

+ (instancetype)shareInstance;

// 货币单位
@property (nonatomic, copy) NSString *currencySymbol;
// 精度 读取配置项 spi.common.currency-type 获取  默认:0
@property (nonatomic, copy) NSString *displayScale;

// 读取配置项 webs.ecare.promition.baseUrl 获取
@property (nonatomic, copy) NSString *promotionBaseUrl;
// 倒计时 默认：60
@property (nonatomic, assign) int countDown;
// 号码段号规则 比如 3,3,3
@property (nonatomic, copy) NSString *serviceNbrBreakRule;

// 取property 配置 showStatusTag 默认 NO
@property (nonatomic, assign) BOOL showStatusTag;
// 取property 配置 showPaidFlagTag 默认 NO
@property (nonatomic, assign) BOOL showPaidFlagTag;
//  取property 配置 displayStyle 默认: group
@property (nonatomic, copy) NSString *displayStyle;
// 取property 配置 dateFormatApp 默认: "dd/MM/yyyy"
@property (nonatomic, copy) NSString *dateFormatApp;

// 读取配置项 ecare.ios.webview-safari.url-list 获取
@property (nonatomic, copy) NSString *safariUrl;
@end

NS_ASSUME_NONNULL_END
