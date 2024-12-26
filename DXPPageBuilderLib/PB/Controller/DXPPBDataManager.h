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

//@class DCPageBuildingViewController;

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
//@property (nonatomic, strong) NSMutableArray *sidebarMenuList;
// 底部TabBar
//@property (nonatomic, strong) NSMutableArray *bottomMenuList;

// 是否支持游客模式 默认支持 Y
@property (nonatomic, assign) BOOL isSupportTouristMode;
// propty 配置  和客户绑定（relType=E） 和订户绑定（relType=F）
@property (nonatomic, copy) NSString *relType;
// 登录后的token
@property (nonatomic, copy) NSString *loginToken;
// 登录后用户信息mobile
@property (nonatomic, copy) NSString *mobile;
// pageCode
@property (nonatomic, copy) NSString *pageCode;
// 需要修改密码
@property (nonatomic, copy) void (^onNeedChangePasswordBlock)(DCPBCurrentInfoModel *currentInfoModel);
// 创建成功后，展示PB
@property (nonatomic, copy) void (^showPBBlock)(UIView *pbView);

// 请求用户信息
- (void)queryUserInfo;
// 刷新当前订户列表
- (void)refreshSubsListWhenOpenSimSuccess;

- (void)queryDataAfterLoginSuccess;

@end

NS_ASSUME_NONNULL_END
