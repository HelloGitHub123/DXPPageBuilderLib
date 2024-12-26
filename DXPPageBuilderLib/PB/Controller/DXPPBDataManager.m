//
//  DXPPBDataManager.m
//  DXPPageBuild
//
//  Created by 李标 on 2024/7/14.
//

#import "DXPPBDataManager.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "DCPBCurrentInfoModel.h"
#import "DCPB.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <DXPToolsLib/SNAlertMessage.h>
#import "DXPPBConfigManager.h"
#import "DCMenuModel.h"
#import <DXPToolsLib/HJTool.h>
#import <DXPPageBuilderLib/DCPageBuildingViewController.h>

typedef void(^FinishMyProfileBlock) (void);

static DXPPBDataManager *manager = nil;

@interface DXPPBDataManager () {
}
@end


@implementation DXPPBDataManager

+ (instancetype)shareInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[DXPPBDataManager alloc] init];
	});
	return manager;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.totalSubsListArr = [[NSMutableArray alloc] init];
		self.totalSubsArr = [[NSMutableArray alloc] init];
		self.isSupportTouristMode = NO;
	}
	return self;
}

#pragma mark -- 开始请求，加载PB
- (void)launchPageBuildWithCode:(NSString *)pageCode {
	
}

#pragma mark -- get and set
- (void)setLoginToken:(NSString *)loginToken {
	_loginToken = loginToken;
	
	[[NSUserDefaults standardUserDefaults] setValue:_loginToken forKey:@"DCLoginToken"];
	
	[DCNetAPIClient userAddRequestHeader:loginToken forHeadFieldName:@"Token"];
	[DCNetAPIClient userAddRequestHeader:loginToken forHeadFieldName:@"authtoken"];
}

- (void)setMobile:(NSString *)mobile {
	_mobile = mobile;
}

#pragma mark -- 查询用户信息
- (void)queryUserInfo {
	if (DC_IsStrEmpty(self.mobile) && !self.isSupportTouristMode) {
		// 号码不能为空
		return;
	}
	if (DC_IsStrEmpty(self.loginToken) || self.isSupportTouristMode) {
		[[DXPPBDataManager shareInstance] queryDataAfterLoginSuccess];
	} else {
		[self queryCurrentInfoWithAccount:self.mobile currentAccNbr:@""];
	}
}

#pragma mark -- 查询当前选中信息 (用于登录场景调用)
- (void)queryCurrentInfoWithAccount:(NSString *)loginAccount currentAccNbr:(NSString *)currentAccNbr {
	
	__weak typeof(self)weakSelf = self;
	
	NSMutableDictionary * param = [[NSMutableDictionary alloc] init];
	[param setValue:loginAccount forKey:@"loginAccount"];
	[param setValue:currentAccNbr forKey:@"currentAccNbr"];
	
	[[DCNetAPIClient sharedClient] POST:@"/ecare/user/currentInfo" paramaters:param CompleteBlock:^(id res, NSError *error) {
		if (!error && !DC_isNull([res objectForKey:@"data"]) && [DC_HTTP_Code isEqualToString:DC_HTTP_Success]) {
			
			[DXPPBDataManager shareInstance].currentInfoModel = [DCPBCurrentInfoModel yy_modelWithDictionary:DC_HTTP_Data];
			
			NSDictionary * userInfo = [DC_HTTP_Data objectForKey:@"userInfo"];
			[DXPPBDataManager shareInstance].currentInfoModel.userInfo = [DCPBCurrentUserInfoModel yy_modelWithDictionary:userInfo];
			
			if ([[DXPPBDataManager shareInstance].currentInfoModel.userInfo.forceModPwd isEqualToString:@"Y"]
				|| [[DXPPBDataManager shareInstance].currentInfoModel.userInfo.pwdExpired isEqualToString:@"Y"]) {
				// 需要强制修改密码
				if (weakSelf.onNeedChangePasswordBlock) {
					weakSelf.onNeedChangePasswordBlock([DXPPBDataManager shareInstance].currentInfoModel);
				}
			} else {
				[[DXPPBDataManager shareInstance] queryDataWhenInHomePage];
			}
		}
	}];
}

#pragma mark -- 在展示首页后，需要调用接口获取数据
- (void)queryDataWhenInHomePage {
	if ([self.relType isEqualToString:@"E"]) {
		// 和客户绑定（relType=E）
		[self querySubsList];
	} else {
		// 和订户绑定（relType=F）
		[self queryUserSubsDetail];
	}
	[self queryMyProfileData:nil];
}

//获取订户列表
- (void)querySubsList {
	NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
	[parmas setValue:self.currentInfoModel.currentCustNbr forKey:@"custNbr"];
	[parmas setValue:self.currentInfoModel.currentCustId forKey:@"custId"];
	[HJMBProgressHUD showLoading];
	
	BOOL isList = [@"list" isEqualToString:[DXPPBConfigManager shareInstance].displayStyle];
	NSString *url;
	if (isList) {
		url = @"/ecare/subs/list"; // 查询订户列表
	} else {
		url = @"/ecare/subs/list-with-bundle"; //查询订户列表（带bundle）
	}
	[[DCNetAPIClient sharedUcClient] POST:url paramaters:parmas CompleteBlock:^(id res, NSError *error) {
		[HJMBProgressHUD hideLoading];
		if (!error) {
			if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
				self.subsListModel = [DCSubsListModel yy_modelWithDictionary:[res objectForKey:@"data"]];
				[self getTotalSubs];
				[self getTotalSubsListArrFunction];
				[self getCurrentSelectedSubsModel];
				//改为串行，先调用sub,再调用menelist进入首页
				[[DXPPBDataManager shareInstance] queryDataAfterLoginSuccess];
			}
		}
	}];
}

//查询订户详情
- (void)queryUserSubsDetail {
	NSMutableDictionary * parmas = [NSMutableDictionary new];
	[parmas setValue:@"" forKey:@"prefix"];
	[parmas setValue:self.currentInfoModel.currentAccNbr forKey:@"accNbr"];
	[parmas setValue:self.currentInfoModel.currentSubsId forKey:@"subsId"];
	
	[HJMBProgressHUD showLoading];
	[[DCNetAPIClient sharedClient] POST:@"/ecare/subs/detail" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
		[HJMBProgressHUD hideLoading];
		if (!error) {
			if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
				self.subDetailModel = [DCSubsDetailModel yy_modelWithDictionary:DC_HTTP_Data];
				//改为串行，先调用sub,再调用menelist进入首页
				[[DXPPBDataManager shareInstance] queryDataAfterLoginSuccess];
			}
		}
	}];
}

- (void)queryMyProfileData:(FinishMyProfileBlock)block {
	[HJMBProgressHUD showLoading];
	
	[[DCNetAPIClient sharedClient] POST:@"/ecare/user/custProfile" paramaters:@{} CompleteBlock:^(id res, NSError *error) {
		[HJMBProgressHUD hideLoading];
		if (!error) {
			if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
				self.myProfileModel = [DCPBMyProfileModel yy_modelWithDictionary:DC_HTTP_Data];
				if (block) block();
			}
		}
	}];
}

- (void)getTotalSubs {
	BOOL isList = [@"list" isEqualToString:[DXPPBConfigManager shareInstance].displayStyle];
	if (isList) {
		[self.totalSubsArr removeAllObjects];
		self.totalSubsArr = [self.subsListModel.subsList mutableCopy];
	} else {
		[self.totalSubsArr removeAllObjects];
		for (DCPBSubsItemModel *model in self.subsListModel.subsList) {
			[self.totalSubsArr addObject:model];
		}
		for (DCSubsBundleListModel *model in self.subsListModel.bundleSubsList) {
			for (DCPBSubsItemModel * subsModel in model.subsList) {
				[self.totalSubsArr addObject:subsModel];
			}
		}
	}
}

- (void)getTotalSubsListArrFunction {
	BOOL isList = [@"list" isEqualToString:[DXPPBConfigManager shareInstance].displayStyle];
	if (isList) {
		[self.totalSubsListArr removeAllObjects];
		
		for (DCPBSubsItemModel * model in self.subsListModel.subsList) {
			model.isFirstRow = YES;
			model.isLastRow = YES;
			NSMutableArray * itemArr = [[NSMutableArray alloc] init];
			[itemArr addObject:model];
			
			[_totalSubsListArr addObject:itemArr];
		}
	} else {
		[self.totalSubsListArr removeAllObjects];
		for (DCSubsBundleListModel *model in self.subsListModel.bundleSubsList) {
			DCPBSubsItemModel *firstItemModel = [model.subsList firstObject];
			DCPBSubsItemModel *lastItemModel = [model.subsList lastObject];
			firstItemModel.isFirstRow = YES;
			lastItemModel.isLastRow = YES;
			[_totalSubsListArr addObject:model.subsList];
		}
		
		for (DCPBSubsItemModel *model in self.subsListModel.subsList) {
			model.isFirstRow = YES;
			model.isLastRow = YES;
			NSMutableArray * itemArr = [[NSMutableArray alloc] init];
			[itemArr addObject:model];
			[_totalSubsListArr addObject:itemArr];
		}
	}
}

- (void)getCurrentSelectedSubsModel {
	BOOL isList = [@"list" isEqualToString:[DXPPBConfigManager shareInstance].displayStyle];
	if (isList) {
		BOOL isfind = NO;
		for (DCPBSubsItemModel *model in self.subsListModel.subsList) {
			if ([model.subsId isEqualToString:[DXPPBDataManager shareInstance].currentInfoModel.currentSubsId]) {
				self.selectedSubsModel = model;
				isfind = YES;
				break;
			}
		}
		
		if (!isfind) {
			self.selectedSubsModel = [self.subsListModel.subsList firstObject];
		}
		
	} else {
		BOOL isfind = NO;
		for (DCPBSubsItemModel *model in self.subsListModel.subsList) {
			if ([model.subsId isEqualToString:[DXPPBDataManager shareInstance].currentInfoModel.currentSubsId]) {
				self.selectedSubsModel = model;
				isfind = YES;
				break;
			}
		}
		
		if (!isfind) {
			for (DCSubsBundleListModel *model in self.subsListModel.bundleSubsList) {
				for (DCPBSubsItemModel * subsModel in model.subsList) {
					if ([subsModel.subsId isEqualToString:[DXPPBDataManager shareInstance].currentInfoModel.currentSubsId]) {
						self.selectedSubsModel = subsModel;
						isfind = YES;
						break;
					}
				}
				
			}
			if(!isfind){
				DCSubsBundleListModel *model = [self.subsListModel.bundleSubsList firstObject];
				self.selectedSubsModel = [model.subsList firstObject];
			}
		}
	}
}

- (void)refreshSubsListWhenOpenSimSuccess {
	if (!DC_IsStrEmpty([DXPPBDataManager shareInstance].loginToken)) {
		if (DC_IsStrEmpty([DXPPBDataManager shareInstance].currentInfoModel.currentCustId)
			|| [DXPPBDataManager shareInstance].totalSubsListArr.count == 0
			|| [[[DXPPBDataManager shareInstance].currentInfoModel.currentRole uppercaseString] isEqualToString:@"INITIAL"]
			|| [[[DXPPBDataManager shareInstance].currentInfoModel.currentRole uppercaseString] isEqualToString:@"NORMAL"]) {
			
			//当前账号没有订户的情况下，需要请求currentInfo,获取currentCustNbr，currentCustId
			[[DCNetAPIClient sharedClient] POST:@"/ecare/user/currentInfo" paramaters:@{} CompleteBlock:^(id res, NSError *error) {
				if (!error && !DC_isNull([res objectForKey:@"data"]) && [DC_HTTP_Code isEqualToString:DC_HTTP_Success]) {
					[DXPPBDataManager shareInstance].currentNewUserInfo = [DCPBCurrentInfoModel yy_modelWithDictionary:DC_HTTP_Data];
					if (!DC_IsStrEmpty([DXPPBDataManager shareInstance].currentNewUserInfo.currentCustId)) {
						///由没有账户到有账户，并默认选择开户账户，所以需要先获取subsList列表，在切换到开户账号（即再次调用currentInfo进行渲染）
						//                        NSDictionary * userInfo = [HTTP_Data objectForKey:@"userInfo"];
						//                        [HJGlobalDataManager shareInstance].currentInfoModel.userInfo = [DCCurrentUserInfoModel yy_modelWithDictionary:userInfo];
						[[DXPPBDataManager shareInstance] querySubsListAfterOpenSIMSuccess];
					} else {
						[DXPPBDataManager shareInstance].currentInfoModel = [DCPBCurrentInfoModel yy_modelWithDictionary:DC_HTTP_Data];
					}
				}
			}];
		} else {
			[[DXPPBDataManager shareInstance] queryDataWhenInHomePage];
		}
	}
}

- (void)querySubsListAfterOpenSIMSuccess {
	NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
	[parmas setValue:[DXPPBDataManager shareInstance].currentNewUserInfo.currentCustNbr forKey:@"custNbr"];
	[parmas setValue:[DXPPBDataManager shareInstance].currentNewUserInfo.currentCustId forKey:@"custId"];
	
	[HJMBProgressHUD showLoading];
	
	BOOL isList = [@"list" isEqualToString:[DXPPBConfigManager shareInstance].displayStyle];
	NSString *url;
	if (isList) {
		url = @"/ecare/subs/list"; // 查询订户列表
	} else {
		url = @"/ecare/subs/list-with-bundle"; //查询订户列表（带bundle）
	}
	
	[[DCNetAPIClient sharedUcClient] POST:url paramaters:parmas CompleteBlock:^(id res, NSError *error) {
		[HJMBProgressHUD hideLoading];
		if (!error) {
			if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
				[DXPPBDataManager shareInstance].subsListModel = [DCSubsListModel yy_modelWithDictionary:[res objectForKey:@"data"]];
				[self getTotalSubs];
				[self getTotalSubsListArrFunction];
				[self getCurrentSelectedSubsModel];
				///默认选择订户后，更新currentInfo
				NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
				[dict setValue:@"" forKey:@"loginAccount"];
				[dict setValue:[DXPPBDataManager shareInstance].selectedSubsModel.accNbr forKey:@"currentAccNbr"];
				if(!DC_IsStrEmpty([DXPPBDataManager shareInstance].selectedSubsModel.accNbr) || ![self.currentInfoModel.currentRole isEqualToString:self.currentNewUserInfo.currentRole]){//如果开始有数据或者用户角色发生改变，再次调用currentInfo
					[[DCNetAPIClient sharedClient] POST:@"/ecare/user/currentInfo" paramaters:dict CompleteBlock:^(id res, NSError *error) {
						if (!error && !DC_isNull([res objectForKey:@"data"]) && [DC_HTTP_Code isEqualToString:DC_HTTP_Success]) {
							[DXPPBDataManager shareInstance].currentInfoModel = [DCPBCurrentInfoModel yy_modelWithDictionary:DC_HTTP_Data];
							if (!DC_IsStrEmpty([DXPPBDataManager shareInstance].currentInfoModel.currentCustId)) {
								NSDictionary *userInfo = [DC_HTTP_Data objectForKey:@"userInfo"];
								[DXPPBDataManager shareInstance].currentInfoModel.userInfo = [DCPBCurrentUserInfoModel yy_modelWithDictionary:userInfo];
								[[DXPPBDataManager shareInstance] queryDataAfterLoginSuccess];
								[self queryMyProfileData:nil];
							}
						}
					}];
				} else {
					
				}
			}
		}
	}];
}

#pragma mark - 一、在进入首页前，需要调用接口获取数据
- (void)queryDataAfterLoginSuccess {
	[DCNetAPIClient userAddRequestHeader:[DXPPBDataManager shareInstance].loginToken forHeadFieldName:@"Token"];
	[DCNetAPIClient userAddRequestHeader:[DXPPBDataManager shareInstance].loginToken forHeadFieldName:@"authtoken"];
	
	//	[[NSNotificationCenter defaultCenter] postNotificationName:@"GotoTabBarControllerNotification" object:nil];
	
	DCPageBuildingViewController *pageBuildVC = [[DCPageBuildingViewController alloc] init];
	pageBuildVC.onPbItemClickBlock = ^(NSString * _Nonnull link, int linkType, UIViewController * _Nonnull fromVC, NSString * _Nonnull title, NSString * _Nonnull needLogin, id  _Nonnull coustomData) {
		
		
	};
	pageBuildVC.pageCode =  self.pageCode; //@"XLHomepage";
	pageBuildVC.floorNavType = DCFloorNavType_CLP;
	
	//	if ([self topViewController]) {
	//		[[self topViewController] addChildViewController:pageBuildVC];
	//		[[self topViewController].view addSubview:pageBuildVC.view];
	//	}
	if (self.showPBBlock) {
		self.showPBBlock(pageBuildVC.view);
	}
}

#pragma mark -- 获取当前栈顶控制器
- (UIViewController *)topViewController {
	UIViewController *resultVC;
	resultVC = [self _topViewController:[[self keyWindow] rootViewController]];
	while (resultVC.presentedViewController) {
		resultVC = [self _topViewController:resultVC.presentedViewController];
	}
	return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
	if ([vc isKindOfClass:[UINavigationController class]]) {
		return [self _topViewController:[(UINavigationController *)vc topViewController]];
	} else if ([vc isKindOfClass:[UITabBarController class]]) {
		return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
	} else {
		return vc;
	}
	return nil;
}

// 获取当前window
- (UIWindow *)keyWindow {
	return [UIApplication sharedApplication].keyWindow;
}

@end
