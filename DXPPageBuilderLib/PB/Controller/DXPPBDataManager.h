//
//  DXPPBDataManager.h
//  DXPPageBuild
//
//  Created by 李标 on 2024/7/14.
//  PB对外开放数据管理

#import <Foundation/Foundation.h>
#import "DCPBCurrentInfoModel.h"
#import "DCSubsListModel.h"
#import "DCPBMyProfileModel.h"
#import "DCSubsDetailModel.h"
#import "DCSignInResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DXPPBDataManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong) DCPBCurrentInfoModel *currentInfoModel;
@property (nonatomic, strong) DCPBCurrentInfoModel *currentNewUserInfo;
@property (nonatomic, strong) DCSubsListModel *subsListModel;//每个账户下的订户列表
@property (nonatomic, strong) DCPBSubsItemModel *selectedSubsModel;//默认取DCSubsListModel的第一个
@property (nonatomic, strong) DCSubsBundleListModel *selectedBundleModel;
@property (nonatomic, strong) DCPBMyProfileModel *myProfileModel;
@property (nonatomic, strong) DCSubsDetailModel *subDetailModel;
@property (nonatomic, strong) DCSignInResponseModel *signInResponseModel;//登录成功后返回的数据

// 不管group 还是 list，都整合成2维数组
@property (nonatomic, strong) NSMutableArray *totalSubsListArr;
// 不管group 还是 list，将所有的订户整合
@property (nonatomic, strong) NSMutableArray *totalSubsArr;
// 侧边栏
@property (nonatomic, strong) NSMutableArray *sidebarMenuList;
// 底部TabBar
@property (nonatomic, strong) NSMutableArray *bottomMenuList;

@end

NS_ASSUME_NONNULL_END
