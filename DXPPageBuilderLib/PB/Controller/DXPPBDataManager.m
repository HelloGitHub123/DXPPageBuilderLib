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
	}
	return self;
}

#pragma mark -- 开始请求，加载PB
- (void)launchPageBuildWithCode:(NSString *)pageCode {
	
}

@end
