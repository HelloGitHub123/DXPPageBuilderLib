//
//  DCPageBuildingViewController.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2022/11/23.
//

#import "DCPageBuildingViewController.h"
#import "DCPB.h"
#import "DCRouterManager.h"
#import "DCPBMenuItemModel.h"
#import "DCDashboardView.h"
#import "DCGaiaIconCell.h"
#import "DCPBManager.h"
#import "YYCategories.h"
#import "DCNewToolBarView.h"
#import "DCGeneralSelectPopView.h"
#import "DCTMDashboardCell.h"
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import "DCPBSMSVerificationPopView.h"
#import "HJVideoPlayerViewController.h"
#import <WebKit/WebKit.h>
#import "DCDITODashboardView.h"
#import "DCDashboardStickView.h"
#import "DCUserSubsDetailViewModel.h"
#import "DCVerifyOtpViewModel.h"
#import "DCSubsListModel.h"
#import "DCSubsBundleModel.h"
#import "DCSelectSubsListView.h"
#import "DCPBCurrentInfoModel.h"
#import "DCPBQryCampInfoViewModel.h"
#import "DCCampPopUpView.h"

#define IsPBNilOrNull(_ref)        (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define isPBEmptyString(x)         (IsPBNilOrNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || [x isEqual:@"null"] || [x isEqual:@"<null>"])

@interface DCPageBuildingViewController ()<HJVMRequestDelegate_PB>

@property (nonatomic, strong) DCNewToolBarView *newToolBar;
@property (nonatomic, strong) DCPBSMSVerificationPopView *alterView;
// model viewModel
@property (nonatomic, strong) DCUserSubsDetailViewModel *subsDetailVM;
@property (nonatomic, strong) DCPBQryCampInfoViewModel *qryCampInfoVM;
@property (nonatomic, strong) DCVerifyOtpViewModel *verifyOtpViewModel;
@property (nonatomic, strong) DCPBSubsItemModel *subsItemModel_Otp;
// Dashboard 弹框。类似DITO
@property (nonatomic, assign) CGFloat dbStickOffset; // dashboard便宜
@property (nonatomic, strong) DCDITODashboardView *ditoDBView;  // 展开 view
@property (nonatomic, strong) DCDashboardStickView *dbStickView; // 吸顶view
@property (nonatomic, assign) BOOL isShowDitoDBView; // 是否展示弹框Dashboard
@property (nonatomic, assign) BOOL isShowDitoStickView; // 是否展示吸顶View
// data
@property (nonatomic, strong) NSDictionary *Http_Data_Dic;
@property (nonatomic, strong) NSMutableArray *popUpViewArr;

@end

@implementation DCPageBuildingViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.navigationController setNavigationBarHidden:NO animated:NO];
	
	if (!self.ditoDBView.hidden) {
		self.ditoDBView.hidden = YES;
		self.isShowDitoDBView = YES;
	}
	
	// 生命周期回调
	if (self.viewWillDisappearBlock) {
		self.viewWillDisappearBlock(self);
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//隐藏导航栏
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	// 通知 刷新PB
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPageBuilding) name:REFRESH_PAGEBUILD_PAGE_NOTIFICATION object:nil];
	
	// 生命周期回调
	if (self.viewWillAppearBlock) {
		self.viewWillAppearBlock(self);
	}
}

// 刷新PB
- (void)refreshPageBuilding {
	[self getCMSData];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[[DCRouterManager sharedInstance] dealAfterLogin];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self initData];
	
	[self configView];
	
	[self getCMSData];
	
	[self registerNotification]; // 注册通知
	
	// 生命周期回调
	if (self.viewDidLoadBlock) {
		self.viewDidLoadBlock(self);
	}
}

- (void)initData {
	self.dbStickOffset = -1;
	self.dataSource = self.vcDataSource;
	[DCPBManager sharedInstance].parentSubsId = @"";
}

- (void)configView {
	[self addStickView];
	
	[self.view addSubview:self.tableView];
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
	CGFloat bottom = [self vg_safeDistanceBottom]+49;
	[self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.top.equalTo(@0);
		make.bottom.mas_equalTo(-bottom);
	}];
}

// 初始化全部添加，设置隐藏
- (void)addStickView {
	[self.view addSubview:self.dbStickView];
	self.dbStickView.hidden = YES;
	self.isShowDitoStickView = NO;
	
	[self.dbStickView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.equalTo(@0);
		make.top.equalTo(@(0));
		make.height.equalTo(@((142+24)+STATUS_BAR_HEIGHT));
	}];
	
	// 添加ditoDBView
	self.ditoDBView.hidden = YES;
	self.isShowDitoDBView = NO;
	[self.view addSubview:self.ditoDBView];
	[self.ditoDBView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.bottom.equalTo(@0);
	}];
}

- (CGFloat)vg_safeDistanceBottom {
	if (@available(iOS 13.0, *)) {
		NSSet *set = [UIApplication sharedApplication].connectedScenes;
		UIWindowScene *windowScene = [set anyObject];
		UIWindow *window = windowScene.windows.firstObject;
		return window.safeAreaInsets.bottom;
	} else if (@available(iOS 11.0, *)) {
		UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
		return window.safeAreaInsets.bottom;
	}
	return 0;
}

#pragma mark -- 方法
- (void)setIsRedViewShow:(BOOL)isRedViewShow {
	self.newToolBar.redViewShow = isRedViewShow;
}

- (void)getData {
	[self.tableView.mj_header beginRefreshing];
}

#pragma mark -- 设置PageCode
- (void)setPageCode:(NSString *)pageCode {
	_pageCode = pageCode;
}

#pragma mark -- 展示DITO dashboard
- (void)showDashboardView {
	self.ditoDBView.hidden = NO;
	[self.view bringSubviewToFront:self.ditoDBView];
	self.dbStickView.hidden = YES;
	DCMutiBalanceDashboardCellModel *cellModel = (DCMutiBalanceDashboardCellModel *)[self.viewModel.modelList objectAtIndex:0];
	[self.ditoDBView bindWithModel:cellModel];
}

#pragma mark -- 更新ToolBar
- (void)updateNewToolBar:(PageCompositionItem *)toobarItem {
	BOOL redShow = self.newToolBar.redViewShow;
	
	[self.newToolBar removeFromSuperview];
	self.newToolBar = nil;
	
	self.newToolBar.toolBarActionBlock = self.toolBarActionBlock;
	__weak typeof(self)weakSelf = self;
	self.newToolBar.toolBarBackAction = ^{
		[weakSelf.navigationController popViewControllerAnimated:YES];
	};
	[self.newToolBar bindCellModel:toobarItem];
	[self.view addSubview:self.newToolBar];
	self.newToolBar.redViewShow = redShow;
}

#pragma mark -- 通知
/**
 非必要不要使用通知，通知不是一个很好的处理方式。
 添加需要明确使用目的，使用范围
 */
- (void)registerNotification {
	//    注册金刚区Icon编辑后保存的回调，这里有数据缓存 保存需要进行刷新首页
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFloorWithoutContent:) name:@"updateFloorWithoutContent" object:nil];
}

// MARK: 处理一些延时获取的楼层:需要比对楼层信息v
- (void)updateFloorWithoutContent:(NSNotification*)notification {
	NSDictionary *dic = notification.object;
	NSString *codeStr = [dic objectForKey:@"code"];
	if([codeStr isEqualToString:@"GAIAIcon"]){
		[self pb_gaiaIconModelWithData:[DCPBManager sharedInstance].iconMenuListData];
	}
}

- (void)getCMSData {
	[self.pageBuildVM requestCMSPageDetailByPageCode:self.pageCode complete:^(DCPageModel * _Nonnull model, bool success) {
		[self.tableView.mj_header endRefreshing];
		
		if (self.onPbDataLoadIsSuccessBlock) {
			self.onPbDataLoadIsSuccessBlock(success);
		}
		if (success) {
			// 初始化弹框
			self.dbStickView.hidden = YES;
			self.isShowDitoStickView = NO;
			
			// 整理数据
			[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(@DCP_NAV_HEIGHT);
			}];
			// 这里数据是判断是否是沉浸式状态栏
			if (!DC_IsArrEmpty(model.pageCompositionList) && model.pageCompositionList.count >=2) {
				PageCompositionItem *toobarItem = [model.pageCompositionList firstObject];
				PageCompositionItem *caourseItem = [model.pageCompositionList objectAtIndex:1];  // 第二个组件需要重新设置间距
				if ([toobarItem.content.type isEqualToString:@"NewToolbar"] ) {
					if ([@"color" isEqualToString:toobarItem.content.props.toolbarBgStyle]) {
						[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
							make.top.equalTo(@DCP_NAV_HEIGHT);
						}];
						caourseItem.content.props.immersive = NO;
					} else {
						// caourseItem.content.props.immersive = YES;
					}
					
					if ([caourseItem.content.type isEqualToString:@"CarouselPost"]
					   || [caourseItem.content.type isEqualToString:@"SinglePost"]) {
						// self.vcDataSource.immersive = YES;
						// caourseItem.content.props.immersive = YES;
					}
				}
			}
			
			// 这里数据预处理阶段
			[model.pageCompositionList enumerateObjectsUsingBlock:^(PageCompositionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				if ([obj.content.type isEqualToString:@"NewToolbar"]) {
					// 是否有导航，进行更新
					[self updateNewToolBar:obj];
				}
				if ([obj.content.type isEqualToString:@"Dashboard"]  && !DC_IsStrEmpty(obj.content.props.themeType) ) {
					self.vcDataSource.themeType = obj.content.props.themeType;
					// obj.content.type = @"Dashboard";
					*stop = YES;
				}
			}];
			
			// 更新pb数据
			[self updateFloorContent:model];
			
			__weak __typeof(&*self)weakSelf = self;
			__block CGFloat offsetTotla = 0;
			[self.viewModel.modelList enumerateObjectsUsingBlock:^(DCFloorBaseCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				offsetTotla = offsetTotla + obj.cellHeight;
				if (!DC_IsStrEmpty([[NSUserDefaults standardUserDefaults] valueForKey:@"DCLoginToken"])) { // 登录状态判断dashboard
					if ([@"MutiBalanceDashboard" isEqualToString:obj.code]) {
						weakSelf.dbStickOffset  = obj.cellHeight > 0 ?  offsetTotla : -1 ;
						*stop = YES;
					}
				}
			}];
		}
	}];
	
	//  请求一次  icon数据
	__weak typeof(self)weakSelf = self;
	[self.pageBuildVM requestMenuListComplete:^(NSMutableArray * _Nonnull homeDashboardArr) {
		[weakSelf pb_gaiaIconModelWithData:homeDashboardArr];
	}];
	
	///获取pop——up信息
	///"adviceCode":"", //固定APP_POPUP
	///"identityType":"", //固定传2
	///"identityId":"", //传当前登录的订户id，
	///"channelCode":"APP",
	NSString *currentSubsId = [DXPPBDataManager shareInstance].currentInfoModel.currentSubsId?:@"";
	[self.qryCampInfoVM qryCampInfoWithAdviceCode:@"APP_POPUP" identityType:@"2" identityId:currentSubsId channelCode:@"APP"];
}

- (void)refreshData {
	[self.pageBuildVM requestCMSPageDetailByPageCode:self.pageCode complete:^(DCPageModel * _Nonnull model, bool success) {
		[self.tableView.mj_header endRefreshing];
		
		if (self.onPbDataLoadIsSuccessBlock) {
			self.onPbDataLoadIsSuccessBlock(success);
		}
		if (success) {
			// 初始化弹框
			self.dbStickView.hidden = YES;
			self.isShowDitoStickView = NO;
			
			// 整理数据
			[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.top.equalTo(@DCP_NAV_HEIGHT);
			}];
			// 这里数据是判断是否是沉浸式状态栏
			if (!DC_IsArrEmpty(model.pageCompositionList) && model.pageCompositionList.count >=2) {
				PageCompositionItem *toobarItem = [model.pageCompositionList firstObject];
				PageCompositionItem *caourseItem = [model.pageCompositionList objectAtIndex:1];  // 第二个组件需要重新设置间距
				if ([toobarItem.content.type isEqualToString:@"NewToolbar"] ) {
					if ([@"color" isEqualToString:toobarItem.content.props.toolbarBgStyle]) {
						[self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
							make.top.equalTo(@DCP_NAV_HEIGHT);
						}];
						caourseItem.content.props.immersive = NO;
					} else {
						//                        caourseItem.content.props.immersive = YES;
					}
					
					if ([caourseItem.content.type isEqualToString:@"CarouselPost"]
					   || [caourseItem.content.type isEqualToString:@"SinglePost"]) {
						//                        self.vcDataSource.immersive = YES;
						//                        caourseItem.content.props.immersive = YES;
					}
				}
			}
			
			// 这里数据预处理阶段
			[model.pageCompositionList enumerateObjectsUsingBlock:^(PageCompositionItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				if([obj.content.type isEqualToString:@"NewToolbar"]){
					// 是否有导航，进行更新
					[self updateNewToolBar:obj];
				}
				if([obj.content.type isEqualToString:@"Dashboard"]  && !DC_IsStrEmpty(obj.content.props.themeType) ) {
					self.vcDataSource.themeType = obj.content.props.themeType;
					//                            obj.content.type = @"Dashboard";
					*stop = YES;
				}
			}];
			// 更新pb数据
			[self updateFloorContent:model];
		}
	}];
	///更新订户信息
	if ([self.navigationController.topViewController isKindOfClass:[DCPageBuildingViewController class]]) {
		if (self.refreshSubsListBlock) {
			// 刷新当前订户列表
			self.refreshSubsListBlock();
		}
	}
	
	//  请求一次  icon数据
	__weak typeof(self)weakSelf = self;
	[self.pageBuildVM requestMenuListComplete:^(NSMutableArray * _Nonnull homeDashboardArr) {
		[weakSelf pb_gaiaIconModelWithData:homeDashboardArr];
	}];
}

// MARK: 数据处理方法
// 接口返回的数据 ---- 采单接口返回的数据 --- 金刚区数据
- (void)pb_gaiaIconModelWithData:(NSMutableArray *)netData {
	if (!DC_IsArrEmpty(netData)) {
		NSMutableArray *modelArr = [NSMutableArray new];
		// 这里需要判断是否有缓存，缓存数据是DCMenuItemModel的数组
		__block int totalCount = 0;
		int maxCount = 15;
		
		// 查看缓存数据
		NSMutableArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"kHomeDashboardIconCache"];
		// 如果没有没缓存直接使用接口数据
		if (DC_IsArrEmpty(arr)) {
			[netData enumerateObjectsUsingBlock:^(DCPBMenuItemModel*  _Nonnull temp, NSUInteger idx, BOOL * _Nonnull stop1) {
				if (!DC_IsArrEmpty(temp.children)) {
					[temp.children enumerateObjectsUsingBlock:^(DCPBMenuItemModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop2) {
						if ([@"Y" isEqualToString:model.fixFlag] || [@"Y" isEqualToString:model.isDefault]) { // 添加
							model.isDashboardShow = YES;
							DCDashboardViewModel *vm = [[DCDashboardViewModel alloc]init];
							vm.title = model.menuName;
							vm.link = model.appUrl;
							vm.linkType = model.schemaType;
							vm.iconUrl = model.icon;
							[modelArr addObject:vm];
							totalCount++;
							if (totalCount >= maxCount) {
								*stop2 = YES;
								return;
							}
						}
					}];
				}
			}];
		} else {
			// 菜单全量数据，过滤缓存中不存在的数据
			NSMutableArray *dmModelArr = [NSMutableArray new];
			[arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				DCPBMenuItemModel *model = [DCPBMenuItemModel yy_modelWithJSON:obj];
				[dmModelArr addObject:model.menuId];
			}];
			
			[netData enumerateObjectsUsingBlock:^(DCPBMenuItemModel*  _Nonnull temp, NSUInteger idx, BOOL * _Nonnull stop1) {
				if (!DC_IsArrEmpty(temp.children)) {
					[temp.children enumerateObjectsUsingBlock:^(DCPBMenuItemModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop2) {
						if ([dmModelArr containsObject:model.menuId]) {
							DCDashboardViewModel *vm = [[DCDashboardViewModel alloc]init];
							vm.title = model.menuName;
							vm.link = model.appUrl;
							vm.iconUrl = model.icon;
							vm.linkType = model.schemaType;
							[modelArr addObject:vm];
							totalCount++;
							if (totalCount >= 15) {
								*stop2 = YES;
								return;
							}
						}
					}];
				}
			}];
		}
		
		DCDashboardViewModel *vmAll = [[DCDashboardViewModel alloc]init];
		vmAll.title = @"All";
		vmAll.link = @"dashboard_all";
		vmAll.iconUrl = @"icon_color_all";
		vmAll.linkType = @"1";
		vmAll.isAll = YES;
		[modelArr addObject:vmAll];
		[self.vcDataSource.innerDBComponentDic setObject:modelArr forKey:@"GAIAIcon"];
		[self updateFloorWithCode:@"GAIAIcon"];
	}
}

#pragma mark -- TableView的滚动回调
- (void)floorBasicScrollViewDidScroll:(UIScrollView *)scrollView {
	if (self.onPbPageScrollBlock) {
		self.onPbPageScrollBlock(scrollView, @"DidScroll");
	}
	
	if (scrollView.mj_offsetY <= 0) {
		self.newToolBar.bgAlpha = 0;
	} else if(scrollView.mj_offsetY >= DCP_NAV_HEIGHT) {
		self.newToolBar.bgAlpha = 1;
	} else {
		self.newToolBar.bgAlpha = 1 - (DCP_NAV_HEIGHT - scrollView.mj_offsetY )/DCP_NAV_HEIGHT;
	}
	
	if (self.dbStickOffset > 0 && self.ditoDBView.hidden == YES) {
		self.dbStickView.hidden = scrollView.contentOffset.y < self.dbStickOffset;
		self.isShowDitoStickView = !self.dbStickView.hidden;
		if (!self.isShowDitoStickView ) {
			self.dbStickView.isUpdateData = NO;
		}
		
		if (!self.dbStickView.isUpdateData && !self.dbStickView.hidden) {
			[self.view bringSubviewToFront:self.dbStickView];
			
			DCMutiBalanceDashboardCellModel *cellModel = (DCMutiBalanceDashboardCellModel *)[self.viewModel.modelList objectAtIndex:0];
			NSMutableDictionary *dic = cellModel.customData;
			CompositionProps *propsDic = cellModel.props;
			
			NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
			if ([paidFlag isEqualToString:@"1"]) {
				// 后付费
				NSString *usablePoint = [dic objectForKey:@"usablePoint"];
				if (!DC_IsStrEmpty(usablePoint) && [usablePoint floatValue] > 0) {
					// 有积分
					[self.dbStickView mas_updateConstraints:^(MASConstraintMaker *make) {
						make.height.equalTo(@((100+24)+STATUS_BAR_HEIGHT));
					}];
				} else {
					// 没有积分
					NSString *money = [dic objectForKey:@"money"];
					if ([money isEqualToString:@"0"]) {
						// No Outstanding Bills
						[self.dbStickView mas_updateConstraints:^(MASConstraintMaker *make) {
							make.height.equalTo(@((134+24)+STATUS_BAR_HEIGHT));
						}];
					} else {
						[self.dbStickView mas_updateConstraints:^(MASConstraintMaker *make) {
							make.height.equalTo(@((142+24)+STATUS_BAR_HEIGHT));
						}];
					}
				}
			} else {
				// 预付费
				NSString *usablePoint = [dic objectForKey:@"usablePoint"];
				if (!DC_IsStrEmpty(usablePoint) && [usablePoint floatValue] > 0) {
					// 有积分
					[self.dbStickView mas_updateConstraints:^(MASConstraintMaker *make) {
						make.height.equalTo(@((100+24)+STATUS_BAR_HEIGHT));
					}];
				} else {
					// 没有积分
					[self.dbStickView mas_updateConstraints:^(MASConstraintMaker *make) {
						make.height.equalTo(@((142+24)+STATUS_BAR_HEIGHT));
					}];
				}
			}
			
			[self.dbStickView bindWithModel:cellModel];
		}
	}
}

- (void)floorBasicScrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if (self.onPbPageScrollBlock) {
		self.onPbPageScrollBlock(scrollView, @"WillBeginDragging");
	}
}

- (void)floorBasicScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (self.onPbPageScrollBlock) {
		self.onPbPageScrollBlock(scrollView, @"EndDragging");
	}
}

- (void)floorBasicScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if (self.onPbPageScrollBlock) {
		self.onPbPageScrollBlock(scrollView, @"EndDecelerating");
	}
}

#pragma mark -- 事件处理
- (void)hj_routerEventWith:(DCFloorEventModel *)eventModel {
	[super hj_routerEventWith:eventModel];
	[self trackWithEventFloor:eventModel];
	
	switch (eventModel.floorEventType) {
		case DCFloorEventFloor:
			if (!isPBEmptyString(eventModel.link)) {
				NSString *title = [eventModel.floorTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
				if (self.onPbItemClickBlock) {
					self.onPbItemClickBlock(eventModel.link, [eventModel.linkType intValue], self, title, eventModel.needLogin);
				}
			}
			break;
		case DCFloorEventCustome: {
			if ([@"dashboard_all" isEqualToString:eventModel.link]) {
				//                DCFloorDashboardSettingVC *next = [[HJFloorDashboardSettingVC alloc]init];
				//                next.rowIndexStr = eventModel.floorIndex >= 0 ? [NSString stringWithFormat:@"%ld",eventModel.floorIndex] : @"";
				//                next.hidesBottomBarWhenPushed = YES;
				//                [self.navigationController pushViewController:next animated:YES];
			} else if([@"EXCHANDE_NUM" isEqualToString:eventModel.link]) {
				__weak typeof(self)weakSelf = self;
				DCSelectSubsListView *view = [[DCSelectSubsListView alloc] initWithBlock:^(DCPBSubsItemModel * _Nonnull model) {
					[weakSelf queryCurrentInfoWithAccount:model];
				}];
				view.switchBundleBlock = ^(DCSubsBundleModel * _Nonnull switchBundleModel) {
					[weakSelf queryCurrentInfoWithBundleAccount:switchBundleModel];
				};
				view.titleStr = [[HJLanguageManager shareInstance] getTextByKey:@"lb_service_number"];
				[view show];
				
			} else if ([eventModel.link isEqualToString:@"DitoDashboardCell_VIDEO_DETAIL"]) {
				NSDictionary *coustomData = eventModel.coustomData;
				CompositionProps *props = [coustomData objectForKey:@"props"];
				NSInteger index = [[coustomData objectForKey:@"index"] integerValue];
				if (props) {
					PicturesItem *item = [props.pictures objectAtIndex:index];
					HJVideoPlayerViewController *playerVideoVc = [[HJVideoPlayerViewController alloc] init];
					playerVideoVc.hidesBottomBarWhenPushed = YES;
					playerVideoVc.picturesItem = item;
					playerVideoVc.compositionPropsItem = props;
					[self.navigationController pushViewController:playerVideoVc animated:YES];
				}
			} else if ([eventModel.link isEqualToString:@"DitoDashboardCell_ARROW"]) {
				[self showDashboardView];
			}
			break;
		case DCFloorEventMCCM: {
			// mccm 路由跳转
			if (!isPBEmptyString(eventModel.link)) {
				NSString *title = [eventModel.floorTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@""];
				if (self.onPbItemClickBlock) {
					self.onPbItemClickBlock(eventModel.link, [eventModel.linkType intValue], self, title, eventModel.needLogin);
				}
			}
			break;
		}
		default:
			break;
		}
	}
}

// 查询当前选中信息
- (void)queryCurrentInfoWithAccount:(DCPBSubsItemModel *)subsItemModel {
	__weak __typeof(&*self)weakSelf = self;
	[HJMBProgressHUD showLoading];
	[[DCNetAPIClient sharedClient] POST:@"/ecare/user/currentInfo" paramaters:@{@"loginAccount":subsItemModel.accNbr?:@"",@"currentAccNbr":subsItemModel.accNbr?:@""} CompleteBlock:^(id res, NSError *error) {
		[HJMBProgressHUD hideLoading];
		if (!error && !DC_isNull([res objectForKey:@"data"]) && [DC_HTTP_Code isEqualToString:DC_HTTP_Success]) {
			// 根据角色 弹出OTP框
			DCPBCurrentInfoModel *currentInfoModel = [DXPPBDataManager shareInstance].currentInfoModel;
			if ([[currentInfoModel.currentRole lowercaseString] containsString:@"supplementary"]) {
				// 弹出OTP框，进行校验
				weakSelf.subsItemModel_Otp = subsItemModel;
				weakSelf.Http_Data_Dic = DC_HTTP_Data;
				[weakSelf switchSubsOTPAlertViewBySwitchedAccNbr:subsItemModel.accNbr switchedServiceType:subsItemModel.serviceType];
			} else {
				[DXPPBDataManager shareInstance].selectedSubsModel = subsItemModel;
				[DCPBManager sharedInstance].parentSubsId = @"";
				[[NSUserDefaults standardUserDefaults] setValue:subsItemModel.accNbr forKey:@"currentAccNbr"];
				[DXPPBDataManager shareInstance].currentInfoModel = [DCPBCurrentInfoModel yy_modelWithDictionary:DC_HTTP_Data];
				NSDictionary * userInfo = [DC_HTTP_Data objectForKey:@"userInfo"];
				[DXPPBDataManager shareInstance].currentInfoModel.userInfo = [DCPBCurrentUserInfoModel yy_modelWithDictionary:userInfo];
				if (self.swichSubModelBlock) {
					// 回调，同步给外部
					self.swichSubModelBlock(subsItemModel, nil ,DC_HTTP_Data, userInfo);
				}
				// 重新请求数据刷新tab，侧边栏等数据
				if (self.queryDataAfterLoginSuccessBlock) {
					self.queryDataAfterLoginSuccessBlock();
				}
				[self registerSuperProperties];
			}
		}
	}];
}

//查询当前选中信息
- (void)queryCurrentInfoWithBundleAccount:(DCSubsBundleModel *)bundleModel {
	__weak __typeof(&*self)weakSelf = self;
	[HJMBProgressHUD showLoading];
	
	NSString *currentAccNbr = bundleModel.bundleAccNbr;
	NSMutableDictionary *prama = [NSMutableDictionary new];
	[prama setValue:currentAccNbr forKey:@"currentAccNbr"];
	
	[[DCNetAPIClient sharedClient] POST:@"/ecare/user/currentInfo" paramaters:prama CompleteBlock:^(id res, NSError *error) {
		[HJMBProgressHUD hideLoading];
		if (!error && !DC_isNull([res objectForKey:@"data"]) && [DC_HTTP_Code isEqualToString:DC_HTTP_Success]) {
			// 切换订户后，需要查询一遍广告接口，进行刷新
			//            [[DCADManager sharedMgr] fetchMktAdList];
			
			// 根据角色 弹出OTP框
			DCPBCurrentInfoModel *currentInfoModel = [DXPPBDataManager shareInstance].currentInfoModel;
			if ([[currentInfoModel.currentRole lowercaseString] containsString:@"supplementary"]) {
				weakSelf.Http_Data_Dic = DC_HTTP_Data;
				[weakSelf switchSubsOTPAlertViewBySwitchedAccNbr:currentAccNbr switchedServiceType:@""];
			} else {
				[DXPPBDataManager shareInstance].selectedSubsModel = nil;
				
				DCSubsBundleListModel *model = [[DCSubsBundleListModel alloc] init];
				model.bundleAccNbr = currentAccNbr;
				model.bundleSubsId = bundleModel.bundleSubsId;
				model.bundleOfferNbr = bundleModel.bundleOfferNbr;
				model.bundleOfferName = bundleModel.bundleOfferName;
				[DXPPBDataManager shareInstance].selectedBundleModel = model;
				
				[DCPBManager sharedInstance].parentSubsId = @"";
				[[NSUserDefaults standardUserDefaults] setValue:currentAccNbr forKey:@"currentAccNbr"];
				[DXPPBDataManager shareInstance].currentInfoModel = [DCPBCurrentInfoModel yy_modelWithDictionary:DC_HTTP_Data];
				NSDictionary * userInfo = [DC_HTTP_Data objectForKey:@"userInfo"];
				[DXPPBDataManager shareInstance].currentInfoModel.userInfo = [DCPBCurrentUserInfoModel yy_modelWithDictionary:userInfo];
//				[[DXPPBDataManager shareInstance] queryDataAfterLoginSuccess];
				if (self.swichSubModelBlock) {
					// 回调，同步给外部
					self.swichSubModelBlock(nil, model, DC_HTTP_Data, userInfo);
				}
				// 重新请求数据刷新tab，侧边栏等数据
				if (self.queryDataAfterLoginSuccessBlock) {
					self.queryDataAfterLoginSuccessBlock();
				}
				[weakSelf registerSuperProperties];
			}
		}
	}];
}

- (void)switchSubsOTPAlertViewBySwitchedAccNbr:(NSString *)switchedAccNbr switchedServiceType:(NSString *)switchedServiceType {
	__weak __typeof(&*self)weakSelf = self;
	self.alterView = [[DCPBSMSVerificationPopView alloc] initWithSwitchedAccNbr:switchedAccNbr switchedServiceType:switchedServiceType block:^(NSString * _Nonnull VerificationCode, kActionType action, NSString *contactNbr) {
		if (action == kActionType_OK) {
			[weakSelf.verifyOtpViewModel verifyOtpRequest:contactNbr otp:VerificationCode businessType:@"switchSubs"];
		}
	}];
	[self.alterView show];
}

#pragma mark -- HJVMRequestDelegate_PB
- (void)requestSuccess:(NSObject *)vm method:(NSString *)methodFlag {
	if ([methodFlag isEqualToString:HJUserSubsDetail]) {
		[self getData];
		
	} else if ([methodFlag isEqualToString:DCVerifyOtp]) {
		
		[self.alterView removeFromSuperview];
		self.alterView = nil;
		
		// 弹框校验成功 切换订户
		[DXPPBDataManager shareInstance].selectedSubsModel = self.subsItemModel_Otp;
		[DCPBManager sharedInstance].parentSubsId = @"";
		[[NSUserDefaults standardUserDefaults] setValue:self.subsItemModel_Otp.accNbr forKey:@"currentAccNbr"];
		[DXPPBDataManager shareInstance].currentInfoModel = [DCPBCurrentInfoModel yy_modelWithDictionary:self.Http_Data_Dic];
		NSDictionary *userInfo = [self.Http_Data_Dic objectForKey:@"userInfo"];
		[DXPPBDataManager shareInstance].currentInfoModel.userInfo = [DCPBCurrentUserInfoModel yy_modelWithDictionary:userInfo];
		
		if (self.swichSubModelBlock) {
			// 回调，同步给外部
			self.swichSubModelBlock(self.subsItemModel_Otp, nil, self.Http_Data_Dic, userInfo);
		}
		// 重新请求数据刷新tab，侧边栏等数据
		if (self.queryDataAfterLoginSuccessBlock) {
			self.queryDataAfterLoginSuccessBlock();
		}
		[self registerSuperProperties];
		
	} else if ([methodFlag isEqualToString:QryCampInfoStr]) {
		///创建弹框队列
		[self.popUpViewArr removeAllObjects];
		for (DCPBCampInfoItemModel * model in self.qryCampInfoVM.campInfoArr) {
			DCCampPopUpView * popView = [[DCCampPopUpView alloc] initWithFrame:CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, DC_SCREEN_HEIGHT) withCampInfoModel:model];
			__weak __typeof(&*self)weakSelf = self;
			popView.clickCloseActionBlock = ^{
				[weakSelf.popUpViewArr removeObjectAtIndex:0];
				DCCampPopUpView * nextView = [weakSelf.popUpViewArr firstObject];
				[nextView showView];
			};
			
			popView.clickPopUpActionBlock = ^(DCPBCampInfoItemModel * _Nonnull model) {///点击图片跳转
				[weakSelf.popUpViewArr removeObjectAtIndex:0];
				DCCampPopUpView * nextView = [weakSelf.popUpViewArr firstObject];
				[nextView showView];
				
				if (!DC_IsStrEmpty(model.jumpLink)) {
					NSString * str =@"";
					if ([model.jumpLink containsString:@"?"]) {
						str = [NSString stringWithFormat:@"&batchId=%@&campaignCode=%@&sendTime=%@",model.batchId,model.campaignCode,model.sendTime];
					} else {
						str = [NSString stringWithFormat:@"?batchId=%@&campaignCode=%@&sendTime=%@",model.batchId,model.campaignCode,model.sendTime];
					}
					
					model.jumpLink = [model.jumpLink stringByAppendingString:str];
					NSString *linkType = model.linkType;
					if ([model.linkType isEqualToString:@"A"]) {
						linkType = @"1";
					} else if ([model.linkType isEqualToString:@"B"]) {
						linkType = @"3";
					} else if ([model.linkType isEqualToString:@"C"]) {
						linkType = @"4";
					} else if ([model.linkType isEqualToString:@"D"]) {
						linkType = @"2";
					} else if ([model.linkType isEqualToString:@"E"]) {
						linkType = @"1";
					}
					
					// 跳转回调
					if (self.onPbItemClickBlock) {
						self.onPbItemClickBlock(model.jumpLink, [linkType intValue], self, @"", @"Y");
					}
					
				}
			};
			[_popUpViewArr addObject:popView];
		}
		
		if (_popUpViewArr.count>0) {
			DCCampPopUpView * nextView = [_popUpViewArr firstObject];
			[nextView showView];
		}
	}
}

- (void)requestFailure:(NSObject *)vm method:(NSString *)methodFlag {
	if ([methodFlag isEqualToString:DCVerifyOtp]) {
		if ([self.verifyOtpViewModel.resultCode isEqualToString:@"40904106"]) { // 特殊处理
			[self.alterView setContentVal:self.verifyOtpViewModel.errorMsg];
		} else {
			[SNAlertMessage displayMessageInView:[UIApplication sharedApplication].keyWindow Message:self.verifyOtpViewModel.errorMsg];
		}
	} else if ([methodFlag isEqualToString:QryCampInfoStr]) {
		// 弹框队列
	}
}

// 父类调用
- (void)cellExposureTrackWtihCellModel:(DCFloorBaseCellModel*)cellModel {
	if (self.cellExposureTrackBlock) {
		// cell 曝光埋点回调
		self.cellExposureTrackBlock(cellModel);
	}
}

// 埋点
- (void)trackWithEventFloor:(DCFloorEventModel *)eventModel {
	if (self.trackWithEventBlock) {
		self.trackWithEventBlock(eventModel);
	}
}

// 埋点，公共埋点
- (void)registerSuperProperties {
	if (self.registerSuperPropertiesBlock) {
		self.registerSuperPropertiesBlock();
	}
}

#pragma mark -- lazy load
- (DCPageViewModel *)pageBuildVM {
	if (!_pageBuildVM) {
		_pageBuildVM = [[DCPageViewModel alloc] init];
	}
	return _pageBuildVM;;
}

- (DCVerifyOtpViewModel *)verifyOtpViewModel {
	if (!_verifyOtpViewModel) {
		_verifyOtpViewModel = [[DCVerifyOtpViewModel alloc] init];
		_verifyOtpViewModel.delegate = self;
	}
	return _verifyOtpViewModel;
}

- (DCFloorVCDataSource *)vcDataSource {
	if (!_vcDataSource) {
		_vcDataSource = [DCFloorVCDataSource new];
	}
	return _vcDataSource;
}

- (DCNewToolBarView *)newToolBar {
	if(!_newToolBar) {
		_newToolBar = [[DCNewToolBarView alloc]init];
		NSString *logoImg = @"pb_logo";
		switch (self.floorNavType) {
			case DCFloorNavType_TM:
				logoImg = @"pb_logo_clp";
				break;
			case DCFloorNavType_CLP:
				logoImg = @"pb_logo_clp";
				break;
			default:
				break;
		}
	}
	return _newToolBar;
}

- (DCUserSubsDetailViewModel *)subsDetailVM{
	if (!_subsDetailVM) {
		_subsDetailVM = [[DCUserSubsDetailViewModel alloc] init];
		_subsDetailVM.delegate = self;
	}
	return _subsDetailVM;
}

- (DCDITODashboardView *)ditoDBView {
	if (!_ditoDBView) {
		_ditoDBView = [[DCDITODashboardView alloc] init];
		
		_ditoDBView.layer.masksToBounds = NO; // 允许阴影效果
		// 设置投影
		_ditoDBView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
		_ditoDBView.layer.shadowOpacity = 1; // 投影透明度，范围0.0~1.0
		_ditoDBView.layer.shadowRadius = 10.0; // 投影模糊半径
		_ditoDBView.layer.shadowOffset = CGSizeMake(0, 5); // 投影偏移量
		
		__weak __typeof(&*self)weakSelf = self;
		_ditoDBView.dbEventBlack = ^(DCFloorEventModel * _Nonnull model) {
			[weakSelf hj_routerEventWith:model];
		};
		_ditoDBView.showActionBlock = ^(HJDITODashBoardActionType type) {
			if (type == HJDITODashBoardActionTypeBottomArrow) {
				weakSelf.ditoDBView.hidden = YES;
				weakSelf.isShowDitoDBView = NO;
				if (weakSelf.isShowDitoStickView) {
					weakSelf.dbStickView.hidden = NO;
				}
			}
		};
	}
	return _ditoDBView;
}

- (DCDashboardStickView *)dbStickView {
	if (!_dbStickView) {
		_dbStickView = [[DCDashboardStickView alloc] init];
		__weak typeof(self)weakSelf = self;
		_dbStickView.dbEventBlack = ^(DCFloorEventModel * _Nonnull model) {
			[weakSelf hj_routerEventWith:model];
		};
		_dbStickView.showActionBlock = ^{
			weakSelf.dbStickView.hidden = YES;
			[weakSelf showDashboardView];
		};
	}
	return _dbStickView;
}

- (DCPBQryCampInfoViewModel *)qryCampInfoVM {
	if (!_qryCampInfoVM) {
		_qryCampInfoVM = [[DCPBQryCampInfoViewModel alloc] init];
		_qryCampInfoVM.delegate = self;
	}
	return _qryCampInfoVM;
}

@end
