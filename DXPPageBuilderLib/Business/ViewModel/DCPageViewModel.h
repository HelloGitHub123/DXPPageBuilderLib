//
//  DCPageViewModel.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
// 

#import <Foundation/Foundation.h>
#import "DCPageModel.h"
#import "DCFloorBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

#define KPBDetailData      @"PageBuildingData_UserDefault" // 持久化存储PB的数据，用于缓存
#define kCMSPageDetailUrl  @"/ecare/cms/page/detail" // cms page build

@interface DCPageViewModel : NSObject
// 数据源
@property (nonatomic, strong) NSDictionary * data;
/// 数据model
@property (nonatomic, strong) DCPageModel *pageModel;
///  代理
///
/// 接口失败信息
@property (nonatomic, copy) NSString *errorMsg;

/// eg: 请求页面配置信息
/// @param pageCode 页面Code
- (void)requestCMSPageDetailByPageCode:(NSString *)pageCode complete:(void(^)(DCPageModel *model,bool success))complete;


/// eg: 请求页面采单数据
- (void)requestMenuListComplete:(nonnull void (^)(NSMutableArray *homeDashboardArr))completeBlock;



/// eg: 请求用户信息列表 /order/userOrder/list
- (void)requestUserOrderListComplete:(nonnull void (^)(NSMutableArray *homeDashboardArr))completeBlock;


/// eg: 请求用账本信息  /balance/summary/list
- (void)requestBalanceSummaryListComplete:(nonnull void (^)(NSMutableArray *homeDashboardArr))completeBlock;


@end

NS_ASSUME_NONNULL_END
