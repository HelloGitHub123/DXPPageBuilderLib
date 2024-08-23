//
//  DCPageBuildingViewController.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2022/11/23.
//

#import <UIKit/UIKit.h>
#import "DCFloorBaseVC.h"
#import "DCPageViewModel.h"
#import "DCFloorVCDataSource.h"
#import "DCNewToolBarView.h"

// 刷新pagebuild页面
#define  REFRESH_PAGEBUILD_PAGE_NOTIFICATION    @"refreshPageBuildingNotification"


//  组件导航中的 type
typedef NS_ENUM(NSUInteger,DCFloorNavType) {
    DCFloorNavType_Bol = 0, // Bol  默认
    DCFloorNavType_CLP = 1, // CLP
    DCFloorNavType_TM = 2, // TM
};


NS_ASSUME_NONNULL_BEGIN

@interface DCPageBuildingViewController : DCFloorBaseVC

@property (nonatomic, copy) NSString *pageCode;

@property (nonatomic, strong) DCPageViewModel *pageBuildVM;
@property (nonatomic, strong) DCPageViewModel *pvm;
@property (nonatomic, strong) DCFloorVCDataSource *vcDataSource;
@property (nonatomic, assign) DCFloorNavType floorNavType;
// 是否展示toolbar 站内信红点
@property (nonatomic, assign) BOOL isRedViewShow;

// 导航栏事件
@property (nonatomic, copy) void(^toolBarActionBlock) (DCNewToolBarViewActionType  type,PicturesItem *item);

/* pb点击返回事件
 * link: 跳转路由
 * linkType: 跳转类型
 * fromVC: 源头VC
 * title: 目标页面标题
 * needLogin: 是否需要登录 字符串：Y or N
 */
@property (nonatomic, copy) void (^onPbItemClickBlock)(NSString *link, int linkType, UIViewController *fromVC, NSString *title, NSString *needLogin);

// 埋点回调
@property (nonatomic, copy) void (^trackWithEventBlock)(DCFloorEventModel *eventModel);

// 公共埋点回调
@property (nonatomic, copy) void (^registerSuperPropertiesBlock)(void);

// PageBuild 生命周期  --- viewWillDisappear
@property (nonatomic, copy) void(^viewWillDisappearBlock) (DCPageBuildingViewController *pbViewController);

// PageBuild 生命周期  --- viewWillAppear
@property (nonatomic, copy) void(^viewWillAppearBlock) (DCPageBuildingViewController *pbViewController);

// PageBuild 生命周期  --- viewDidLoad
@property (nonatomic, copy) void(^viewDidLoadBlock) (DCPageBuildingViewController *pbViewController);

// pageBuild 页面滚动回调
@property (nonatomic, copy) void(^onPbPageScrollBlock)(UIScrollView *scrollView, NSString *scrollState);

// pageBuild 数据加载是否成功 回调
@property (nonatomic, copy) void (^onPbDataLoadIsSuccessBlock)(BOOL isSuccess);

// cell 曝光埋点回调
@property (nonatomic, copy) void (^cellExposureTrackBlock)(DCFloorBaseCellModel *cellModel);

// 切换账号回调
@property (nonatomic, copy) void (^swichSubModelBlock)(DCPBSubsItemModel *subsItemModel, DCSubsBundleListModel *selectedBundleModel , NSDictionary *Http_Data_Dic, NSDictionary * userInfo);

// 重新加载PB\Tab\menu等数据
@property (nonatomic, copy) void (^queryDataAfterLoginSuccessBlock)(void);

// 刷新当前订户列表
@property (nonatomic, copy) void (^refreshSubsListBlock)(void);
@end

NS_ASSUME_NONNULL_END
