//
//  DCFloorVCDataSource.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/7.
//

#import "DCFloorVCDataSource.h"
#import "DCFloorBaseCell.h"
#import "DCFloorCustomBaseView.h"
#import "DCDashboardView.h"
#import "DCPageViewModel.h"
#import "DCPBMenuItemModel.h"
#import "DCTMDashboardCell.h"
#import "DCDitoIconCell.h"
#import "DCBundleInfoModel.h"
#import "DCPB.h"
#import "UIImage+pbImgSize.h"
#import "DCFloorPosterViewCell.h"
#import "DCSubsDetailModel.h"
#import "DCSubsListModel.h"
#import "DCBroadbandAccountCellModel.h"
#import "DCBroadbandAccountCell.h"
#import "DCMutiBalanceDashboardCell.h"
#import "DCBundleDashboardCell.h"
#import <DXPManagerLib/HJLanguageManager.h>
#import "DCMainBalanceSummaryViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "DCOrderHistoryModel.h"
#import "DCBalanceModel.h"

@implementation DCFloorVCDataSource

/**
 * 组装自定义组件Model
 * @param cellModel  自定义组件所需数据模型
 * @param index  对应下标
 */
- (void)componentModelViewWithData:(DCFloorBaseCellModel *)cellModel
                             index:(NSInteger)index
                          callback:(DCFloorBaseViewDataCallback)callback {
    
    if([@"MeetingDashboard" isEqualToString:cellModel.code]){
         NSDictionary * dic =  [self.innerDBComponentDic objectForKey:@"MeetingDashboard"];
        if(dic){
            cellModel.innerComponentDataDic = dic;
            cellModel.props.showTitle = YES;
            cellModel.props.title = @"Overall View";
            cellModel.props.titleFontSize = 16;
            [cellModel coustructCellHeight];
            
            !callback?: callback(cellModel,index);
        }
    }else if ([@"GAIAIcon" isEqualToString:cellModel.code]) { // 组装数据
        // 判断是否有数据
       NSMutableArray *modelArr =  [self.innerDBComponentDic objectForKey:@"GAIAIcon"];
        if(DC_IsArrEmpty(modelArr)){
            cellModel.cellHeight = 0;
            cellModel.customData = @[];
        }else {
            cellModel.customData = modelArr;
            cellModel.cellHeight = modelArr.count > 4 ? 230 : 115;
        }
        DCDitoIconCellModel *model = (DCDitoIconCellModel *)cellModel;
//        model.themeType = self.themeType;
        !callback?: callback(model,index);
	} else if ([@"MutiBalanceDashboard" isEqualToString:cellModel.code]) {
		
		DCMutiBalanceDashboardCellModel *model = (DCMutiBalanceDashboardCellModel*)cellModel;
		NSMutableDictionary *customDic = [NSMutableDictionary new];
		if (cellModel.customData) {
			customDic = cellModel.customData;
		}
		model.dbCellType = DCMutiBalanceLikeDITO;
		NSString *num  =  [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr;
		if(DC_IsStrEmpty(num)){
			num  = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
		}
		[customDic setObject:num ?: @"" forKey:@"num"];
		[customDic setObject: [DXPPBDataManager shareInstance].selectedSubsModel.state?:@"" forKey:@"state"];
		[customDic setObject: [DXPPBDataManager shareInstance].selectedSubsModel.stateName?:@"" forKey:@"stateName"];
		cellModel.customData = customDic;
		[self getDBData:cellModel callback:callback index:index];
		
		!callback?: callback(cellModel,index);
		return;
		
    } else if ([@"BundleDashboard" isEqualToString:cellModel.code]) {
        // TO DO lishan
        DCBundleDashboardCellModel *model = (DCBundleDashboardCellModel*)cellModel;
        [self getBundleDashboardSubsDetail:model callback:callback index:index];
        !callback?: callback(cellModel,index);
        return;
        
    } else if([@"Dashboard" isEqualToString:cellModel.code]){
        
        if ([cellModel.props.dashboardType integerValue] == 5) {
            // FWB 组件
            DCTMDashboardCellModel *model = (DCTMDashboardCellModel*)cellModel;
            NSMutableDictionary *customDic = [NSMutableDictionary new];
            if (cellModel.customData) {
                customDic = cellModel.customData;
            }
            model.dbCellType = DCFWBDashboard;
            // 获取配置项，根据配置项取值
            [self requestConfigParamInfoByCodes:@"ecare.subs.fixed-line.attr-code" model:model callback:callback index:index];
            !callback?: callback(cellModel,index);
            return;
        }
		
		if ([cellModel.props.dashboardType integerValue] == 3) {
			DCTMDashboardCellModel *model = (DCTMDashboardCellModel*)cellModel;
			// 异步接口
			NSMutableDictionary *customDic = [NSMutableDictionary new];
			if (cellModel.customData) {
				customDic = cellModel.customData;
			}
			model.dbCellType = DCDashboardSIMDataVoice; // 流量球、sms voice
			
			NSString *num  =  [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr;
			if(DC_IsStrEmpty(num)){
				num  = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
			}
			
			[customDic setObject:num ?: @"" forKey:@"num"];
			[customDic setObject: [DXPPBDataManager shareInstance].selectedSubsModel.state?:@"" forKey:@"state"];
			[customDic setObject: [DXPPBDataManager shareInstance].selectedSubsModel.stateName?:@"" forKey:@"stateName"];
			cellModel.customData = customDic;
			[self getDBData:cellModel callback:callback index:index];

			!callback?: callback(cellModel,index);
			return;
		}
        
        DCTMDashboardCellModel *model = (DCTMDashboardCellModel*)cellModel;
        // 异步接口
        NSMutableDictionary *customDic = [NSMutableDictionary new];
        if (cellModel.customData) {
            customDic = cellModel.customData;
        }
        model.dbCellType = DCTMDashboardRegisterSim; // 开户
        // 判断是否已经开户
        NSString *currentCustId = [DXPPBDataManager shareInstance].currentInfoModel.currentCustId;
        NSString *currentCustNbr = [DXPPBDataManager shareInstance].currentInfoModel.currentCustNbr;
        // 判断是否 已经有订户
        NSArray *subsList = [DXPPBDataManager shareInstance].subsListModel.subsList;
        
        BOOL  isTheme5 = [@"5" isEqualToString:cellModel.props.themeType];
        // 需要展示流量球
        void(^getDBContentData)(DCFloorBaseCellModel *, DCFloorBaseViewDataCallback, NSInteger) = ^(DCFloorBaseCellModel *cellModel, DCFloorBaseViewDataCallback callback, NSInteger index){
            model.dbCellType = DCTMDashboardProgress; // 开户
            
            NSString *num  =  [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr;
            if(DC_IsStrEmpty(num)){
                num  = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
            }
            
            [customDic setObject:num ?: @"" forKey:@"num"];
            [customDic setObject: [DXPPBDataManager shareInstance].selectedSubsModel.state?:@"" forKey:@"state"];
            [customDic setObject: [DXPPBDataManager shareInstance].selectedSubsModel.stateName?:@"" forKey:@"stateName"];
            cellModel.customData = customDic;
            [self getDBData:cellModel callback:callback index:index];
        };
        
        
        
        if(isTheme5) {
            
            getDBContentData(cellModel,callback,index);
        }else {
            if(!DC_IsStrEmpty(currentCustId) && DC_IsStrEmpty(currentCustNbr)) {
                model.dbCellType = DCTMDashboardRegisterSim; // 激活
            }else if(!subsList && DC_IsArrEmpty(subsList)){
                //  调用接口查看是否有在开单
                [self queryUserOrderList:model callback:callback];
            }else {
                // 需要展示流量球
                getDBContentData(cellModel,callback,index);
            }
        }
        !callback?: callback(cellModel,index);
    }else if([@"DITOMCCMCarouselPost" isEqualToString:cellModel.code]) {
        [self getMccmData:cellModel callback:callback index:index];
    }else if ([@"TmFamilyPlanDetails" isEqualToString:cellModel.code]){
        [DCBundleInfoModel getBundleInfoComplete:^(DCBundleInfoModel * _Nonnull InfoModel, NSError * _Nonnull err) {
            if(InfoModel && [@"2" isEqualToString: InfoModel.bundleType] && !DC_IsArrEmpty(InfoModel.bundleSubsList)) {
                cellModel.customData = InfoModel.bundleSubsList;
                [cellModel coustructCellHeight];
                cellModel.isBinded = NO;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                        //主线程更新UI之类的操作
                    !callback?: callback(cellModel,index);
                });
            }
        }];
    }else if ([@"BroadbandAccount" isEqualToString:cellModel.code]){
        ///根据code 获取接口
//        model.customData = customDic;
//        [model coustructCellHeight];
//        !callback?: callback(model,index);
        // 获取配置项，根据配置项取值
        // FWB 组件
        DCBroadbandAccountCellModel *model = (DCBroadbandAccountCellModel*)cellModel;
        NSMutableDictionary *customDic = [NSMutableDictionary new];
        if (cellModel.customData) {
            customDic = cellModel.customData;
        }
        
        [self requestConfigParamInfoByCodes:@"ecare.subs.fixed-line.attr-code" model:model callback:callback index:index];
        dispatch_async(dispatch_get_main_queue(), ^{
                //主线程更新UI之类的操作
            !callback?: callback(cellModel,index);
            
        });
        
    }
}

// 获取配置项
- (void)requestConfigParamInfoByCodes:(NSString *)codes model:(DCFloorBaseCellModel *)model callback:(DCFloorBaseViewDataCallback)callback index:(NSInteger)index {
    NSString *urlStr = [NSString stringWithFormat:@"/ecare/common/system/configParam/list?configCodes=%@",codes];
	__weak __typeof(&*self)weakSelf = self;
    [[DCNetAPIClient sharedClient] GET:urlStr CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
                NSDictionary *dataDict = [res objectForKey:@"data"];
                NSString *attrCode = [dataDict objectForKey:@"ecare.subs.fixed-line.attr-code"];
                NSDictionary *dicAttrCode = [HJTool dictionaryWithJsonString:attrCode];
                if (dicAttrCode.allKeys > 0) {
                    [weakSelf getSubsDetail:model dic:dicAttrCode callback:callback index:index];
                }
            } else {
            }
        }
    }];
}

// 订户详情
- (void)getSubsDetail:(DCFloorBaseCellModel *)model dic:(NSDictionary *)dic callback:(DCFloorBaseViewDataCallback)callback  index:(NSInteger)index {
    NSString *subsId = [DXPPBDataManager shareInstance].currentInfoModel.currentSubsId?:@"";
    NSString *accNbr = [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr?:@"";
    NSString *prefix = [DXPPBDataManager shareInstance].selectedSubsModel.prefix;
    
    NSMutableDictionary * parmas = [NSMutableDictionary new];
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:subsId forKey:@"subsId"];
	__weak typeof(self)weakSelf = self;
    [[DCNetAPIClient sharedClient] POST:@"/ecare/subs/detail" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary* data = [dict objectForKey:@"data"];
                NSMutableDictionary *customDic = [NSMutableDictionary new];
                if (model.customData) {
                    customDic = (NSMutableDictionary*)model.customData;
                }
                
				DCSubsDetailModel *subDetailModel = [DCSubsDetailModel yy_modelWithDictionary:data];
                NSString *offerName = subDetailModel.offerName;
                
                if (dic) { // FWB业务逻辑
                    // 取属性列表，根据配置项的attrCode 取 value
//                    NSString *downlinkRateConfig = [dic objectForKey:@"downlinkRate"];
//                    NSString *uplinkRateConfig = [dic objectForKey:@"uplinkRate"];
//
                    NSString *downLoadVal = @"";
                    NSString *upLoadVal = @"";
                    if (subDetailModel.internetInfo) {
                        downLoadVal = subDetailModel.internetInfo.downlinkRateDisplay;
                        upLoadVal = subDetailModel.internetInfo.uplinkRateDisplay;
                    }
//                    NSArray *attrList = subDetailModel.attrList;
//                    for (int i = 0; i< attrList.count; i++) {
//                        // Download Speed 的 attrCode 取 downlinkRate 对应的，Upload Speed 的 attrCode 取 uplinkRate 对应的。
//                        AttrItem *item = [attrList objectAtIndex:i];
//                        if ([item.attrCode isEqualToString:downlinkRateConfig]) {
//                            downLoadVal = isEmptyString(item.value)?@"":item.value;
//                        }
//                        if ([item.attrCode isEqualToString:uplinkRateConfig]) {
//                            upLoadVal = isEmptyString(item.value)?@"":item.value;
//                        }
//                    }
                    model.isBinded = NO;
                    [customDic setObject:DC_IsStrEmpty(offerName)?@"":offerName forKey:@"MainPlan"];
                    [customDic setValue:data forKey:@"subsDetail"];
                    // 地址
					DCInstallationAddrInfo *addrInfo = subDetailModel.installationAddrInfo;
                    [customDic setObject:DC_IsStrEmpty(addrInfo.displayAddr)?@"":addrInfo.displayAddr forKey:@"Address"];
                    [customDic setObject:DC_IsStrEmpty(upLoadVal)?@"0":upLoadVal forKey:@"upLoadVal"];
                    [customDic setObject:DC_IsStrEmpty(downLoadVal)?@"0":downLoadVal forKey:@"downLoadVal"];
                    model.customData = customDic;
                    [model coustructCellHeight];
                    !callback?: callback(model,index);
                }
                
                // 判断预后付费类型
                NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag;
                if ([paidFlag isEqualToString:@"1"]) {
                    // 后付费 调用 查询账户信控额度
                    [weakSelf queryBillOweInfoWithAcctId:subDetailModel.defaultAcctId acctNbr:subDetailModel.defaultAcctNbr model:model callback:callback index:index];
                } else {
                    [weakSelf getBalance:model callback:callback index:index];
                }
            }
        }
    }];
}

- (void)getBundleDashboardSubsDetail:(DCBundleDashboardCellModel *)model  callback:(DCFloorBaseViewDataCallback)callback  index:(NSInteger)index {
    NSString *subsId = [DXPPBDataManager shareInstance].currentInfoModel.currentSubsId?:@"";
    NSString *accNbr = [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr?:@"";
    NSString *prefix = [DXPPBDataManager shareInstance].selectedSubsModel.prefix;
    
    NSMutableDictionary * parmas = [NSMutableDictionary new];
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:subsId forKey:@"subsId"];
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/subs/detail" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary* data = [dict objectForKey:@"data"];
				DCSubsDetailModel *subDetailModel = [DCSubsDetailModel yy_modelWithDictionary:data];
                
                NSMutableDictionary *customDic = [NSMutableDictionary new];
                
                [customDic setObject:DC_IsStrEmpty(subDetailModel.state)?@"":subDetailModel.state forKey:@"state"];
                [customDic setObject:DC_IsStrEmpty(subDetailModel.stateName)?@"":subDetailModel.stateName forKey:@"stateName"];
                [customDic setObject:DC_IsStrEmpty(subDetailModel.defaultAcctNbr)?@"":subDetailModel.defaultAcctNbr forKey:@"num"];
                [customDic setObject:DC_IsStrEmpty(subDetailModel.offerName)?@"":subDetailModel.offerName forKey:@"mainPlan"];
                // 地址
				DCInstallationAddrInfo *addrInfo = subDetailModel.installationAddrInfo;
                [customDic setObject:DC_IsStrEmpty(addrInfo.displayAddr)?@"":addrInfo.displayAddr forKey:@"Address"];
                
                model.customData = customDic;
                model.isBinded = NO;
                [model coustructCellHeight];
                !callback?: callback(model,index);
            }
        }
    }];
}

//
- (void)getPerCharge:(DCFloorBaseCellModel *)model  callback:(DCFloorBaseViewDataCallback)callback  index:(NSInteger)index {
    //     积分
    [[DCNetAPIClient sharedClient] POST:@"/ecare/common/sms/outside-package/per-charge" paramaters:@{} CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary *data = [dict objectForKey:@"data"];
                NSString *charge = [data objectForKey:@"charge"];
                NSString *chargeDisplay = [data objectForKey:@"chargeDisplay"];
                NSString *currencySymbol = [data objectForKey:@"currencySymbol"];
                currencySymbol = DC_IsStrEmpty(currencySymbol)?[DXPPBConfigManager shareInstance].currencySymbol:currencySymbol;
                
                //如果套餐外的 charge 大于 0，则直接 {currencySymbol} 拼接 {chargeDisplay} Per SMS，Per SMS 为国际化：
                // charge 小于等于 0，则表示不需要展示套餐外短信费用，还是展示剩余量，即 0（代码逻辑即：上面的 realBalance 或者 下面的 grossBalance 为0，则不需要展示单位 formatRealBalance 、formatGrossBalance）
                NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
                NSArray *arr = [customDic objectForKey:@"progressData"];
                [arr enumerateObjectsUsingBlock:^(DCMainBalanceSummaryItemModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.unitTypeId intValue] == 3) {
                        if ([charge floatValue] > 0) {
                            obj.valueStr = [NSString stringWithFormat:@"%@%@",currencySymbol,chargeDisplay];
							obj.totalStr =  [[HJLanguageManager shareInstance] getTextByKey:@"lb_per_sms"];
                        } else {
                            obj.valueStr = @"0";
                            obj.totalStr = @"0";
                        }
                    }
                }];
                [customDic setObject:arr forKey:@"progressData"];
                [customDic setObject:@(YES) forKey:@"progressUpdate"];
                model.customData = customDic;
                model.isBinded = NO;
                !callback?: callback(model,index);
            }
        }
    }];
    
}
// 异步获取数据区刷新
- (void)getDBData:(DCFloorBaseCellModel *)model  callback:(DCFloorBaseViewDataCallback)callback  index:(NSInteger)index {
    NSString *accNbr = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
    NSString *acctId = [DXPPBDataManager shareInstance].selectedSubsModel.defaultAcctId;
	
	
	[DCMainBalanceSummaryViewModel getMainBalanceSummaryListWithPrefix:[DXPPBDataManager shareInstance].selectedSubsModel.prefix accNbr:accNbr subsId:[DXPPBDataManager shareInstance].selectedSubsModel.subsId defaultAcctId:[DXPPBDataManager shareInstance].selectedSubsModel.defaultAcctId defaultAcctNbr:[DXPPBDataManager shareInstance].selectedSubsModel.defaultAcctNbr completeBlock:^(bool success, DCMainBalanceSummaryModel * _Nonnull balanceSummaryModel) {
		
		NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
		
		[customDic setObject:@(YES) forKey:@"progressUpdate"];
		if (success && balanceSummaryModel) {
			NSArray *arr = DC_IsArrEmpty(balanceSummaryModel.balanceSummaryList) ?@[] :balanceSummaryModel.balanceSummaryList;
			
			[arr enumerateObjectsUsingBlock:^(DCMainBalanceSummaryItemModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
				obj.valueStr = [NSString stringWithFormat:@"%@%@",obj.formatRealBalance,obj.formatRealBalanceUnitName];
				obj.totalStr = [NSString stringWithFormat:@"%@%@",obj.formatGrossBalance,obj.formatGrossBalanceUnitName];
			}];
			[customDic setObject:arr forKey:@"progressData"];
			model.customData = customDic;

			/*
			 (1) 判断 /ecare/balance/summary/list 返回的对应SMS类型的 realBalance 是不是大于 0，如果大于 0，展示 剩余量（/ecare/balance/summary/list 的formatRealBalance）  Total: 总量（/ecare/balance/summary/list 的 formatGrossBalance）
			 
			 (2) 如果 /ecare/balance/summary/list 返回的对应SMS类型的 realBalance 如果小于等于 0，则调用 套餐外的每条短信费用 /ecare/common/sms/outside-package/per-charge，判断返回的 charge，如果套餐外的 charge 大于 0，则直接 {currencySymbol} 拼接 {chargeDisplay} Per SMS，Per SMS 为国际化：
			 
			 (3) 如果 /common/sms/outside-package/per-charge 返回的 charge 小于等于 0，则表示不需要展示套餐外短信费用，还是展示剩余量，即 0（代码逻辑即：上面的 realBalance 或者 下面的 grossBalance 为0，则不需要展示单位 formatRealBalance 、formatGrossBalance）
			 */
			[arr enumerateObjectsUsingBlock:^(DCMainBalanceSummaryItemModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
				if ([obj.unitTypeId intValue] == 3 && [obj.realBalance floatValue] <= 0) {
					[self getPerCharge:model callback:callback index:index];
				}
			}];
		}
		model.isBinded = NO;
		!callback?: callback(model,index);
	}];
	
	
    // balance
    // 是有角色区分的
    // 判断预后付费类型
    [self getSubsDetail:model dic:nil callback:callback index:index];
    
    NSString *url = DC_stringFormat(@"%@/promotion/point/info", [DXPPBConfigManager shareInstance].promotionBaseUrl);
    [[DCNetAPIClient sharedClient] POST:url paramaters:@{@"userType":@"1", @"userId":[DXPPBDataManager shareInstance].currentInfoModel.userInfo.userId,@"pointAcctType":@"1",@"expiringData":@""} CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if ([[dict objectForKey:@"retCode"] isEqualToString:@"0"]) {
                NSArray *dataList = [dict objectForKey:@"data"];
                if (!DC_IsArrEmpty(dataList)) {
                    NSDictionary *dic = [dataList objectAtIndex:0];
                    NSString *usablePoint = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usablePointDisplay"]?:@""];
                    NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
                    model.isBinded = NO;
                    [customDic setObject:usablePoint forKey:@"usablePoint"];
                    !callback?: callback(model,index);
                }
            }
        }
    }];
    
    //     积分
//	NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//	NSDictionary *global = json[@"global"];
//	NSString *pointSystem = global[@"pointSystem"];
//	
//	if ([pointSystem isEqualToString:@"internal"]) {
//		// 查询积分信息
//		[[DCNetAPIClient sharedClient] POST:@"/ecare/point/summary" paramaters:@{@"acctId":acctId?:@""} CompleteBlock:^(id res, NSError *error) {
//			if (!error) {
//				NSDictionary *dict = (NSDictionary *)res;
//				if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
//					NSDictionary *data = [dict objectForKey:@"data"];
//					NSString *usablePoint = [NSString stringWithFormat:@"%@",[data objectForKey:@"usablePoint"]?:@""];
//					NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
//					model.isBinded = NO;
//					[customDic setObject:usablePoint forKey:@"usablePoint"];
//					!callback?: callback(model,index);
//				}
//			}
//		}];
//		
//	} else if ([pointSystem isEqualToString:@"external"]) {
//		// 获取积分基本信息
//		NSString *custId = isEmptyString([HJGlobalDataManager shareInstance].subDetailModel.custId)?@"":[HJGlobalDataManager shareInstance].subDetailModel.custId;
//		NSString *custNbr = @"";
//		NSString *acctNbr = isEmptyString([HJGlobalDataManager shareInstance].subDetailModel.defaultAcctNbr)?@"":[HJGlobalDataManager shareInstance].subDetailModel.defaultAcctNbr;
//		NSString *acctId = isEmptyString([HJGlobalDataManager shareInstance].subDetailModel.defaultAcctId)?@"":[HJGlobalDataManager shareInstance].subDetailModel.defaultAcctId;
//		
//		[[DCNetAPIClient sharedClient] POST:@"/ecare/point/detail" paramaters:@{@"acctId":acctId,@"acctNbr":acctNbr,@"custNbr":@"",@"custId":custId} CompleteBlock:^(id res, NSError *error) {
//			if (!error) {
//				NSDictionary *dict = (NSDictionary *)res;
//				if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
//					NSDictionary *data = [dict objectForKey:@"data"];
//					NSString *usablePoint = [NSString stringWithFormat:@"%@",[data objectForKey:@"usablePoint"]?:@""];
//					NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
//					model.isBinded = NO;
//					[customDic setObject:usablePoint forKey:@"usablePoint"];
//					!callback?: callback(model,index);
//				}
//			}
//		}];
//	}
}

// 获取balance
- (void)getBalance:(DCFloorBaseCellModel *)model callback:(DCFloorBaseViewDataCallback)callback  index:(NSInteger)index {
    
    NSString *accNbr = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
    NSString *acctNbr = [DXPPBDataManager shareInstance].selectedSubsModel.defaultAcctNbr;
    NSString *acctId = [DXPPBDataManager shareInstance].selectedSubsModel.defaultAcctId;
    
    
//    accNbr = @"SRBN5012001037";
//    acctNbr = @"903012319";
//    acctId = @"12319";
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/balance" paramaters:@{@"accNbr":accNbr?:@"",@"acctNbr":acctNbr?:@"",@"acctId":acctId?:@""} CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary* dataDic = [res objectForKey:@"data"];
                // 数据
                NSDictionary* acctBalanceDic = [dataDic objectForKey:@"acctBalance"];
                NSDictionary* acctDue = [dataDic objectForKey:@"acctDue"];
                if(DC_IsNilOrNull(acctDue)){  acctDue = @{}; }
                if(DC_IsNilOrNull(acctBalanceDic)){  acctBalanceDic = @{}; }
                NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag;
                NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
                model.isBinded = NO;
                if(![@"0" isEqualToString:paidFlag]) { // 后付费 展示欠费和欠费到期时间：欠费取 acctDue.totalDueDisplay，下面的文本展示为 Due by ，时间取 acctDue.dueDate。
                    NSInteger totalDue = 0;
                    NSString *totalDueDisplay;
                    NSString *dueDate;
                    if (!DC_isNull(acctDue) && acctDue.allKeys > 0) {
                        if (!DC_IsNilOrNull([acctDue objectForKey:@"totalDue"])) {
                            totalDue = [[acctDue objectForKey:@"totalDue"] integerValue];
                        }
                        totalDueDisplay = [acctDue objectForKey:@"totalDueDisplay"]?:@"";
                        dueDate = [acctDue objectForKey:@"dueDate"]?:@"";
                    }

                    [customDic setObject:totalDue == 0 ? @"" : totalDueDisplay forKey:@"money"];
                    [customDic setObject:DC_IsStrEmpty(dueDate) ? @"" : dueDate  forKey:@"effDate"];

                }else {
                    // 预付费
					DCBalanceModel *balanceModel = [DCBalanceModel yy_modelWithDictionary:acctBalanceDic];
                    [customDic setObject:DC_IsStrEmpty(balanceModel.formatBalance)?@"":balanceModel.formatBalance forKey:@"money"];
                    [customDic setObject:DC_IsStrEmpty(balanceModel.expDate) ? @"" : balanceModel.expDate  forKey:@"effDate"]; // 20240307155043
                }
                [customDic setObject:DC_IsStrEmpty(paidFlag)?@"":paidFlag forKey:@"paidFlag"];

                model.customData = customDic;
                !callback?: callback(model,index);
            }
        }
    }];
    
}

// 后付费取信控额度
- (void)queryBillOweInfoWithAcctId:(NSString *)acctId acctNbr:(NSString *)acctNbr model:(DCFloorBaseCellModel *)model callback:(DCFloorBaseViewDataCallback)callback index:(NSInteger)index {
    
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:acctId forKey:@"acctId"];
    NSString *prefix = [DXPPBDataManager shareInstance].selectedSubsModel.prefix;
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:acctNbr forKey:@"acctNbr"];
    NSString *currentAccNbr = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr?:@"";
    [parmas setValue:currentAccNbr forKey:@"accNbr"];
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/bill/acctOweInfo" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                NSDictionary *dataDic = [res objectForKey:@"data"];
                NSDictionary *acctOweInfoDic = [dataDic objectForKey:@"acctOweInfo"];
                if (acctOweInfoDic.allKeys.count > 0) {
                    NSString *amount = [acctOweInfoDic objectForKey:@"openingAmount"];
                    NSString *val = @"";
                    if (DC_isNull(amount) || [amount integerValue] == 0) {
                        val = @"0";
                    } else {
                        val = [acctOweInfoDic objectForKey:@"openingAmountDisplay"];
                    }
                    NSMutableDictionary *customDic = (NSMutableDictionary*)model.customData;
                    [customDic setValue:val forKey:@"money"];
                    // 时间
                    NSString *dueDate = [acctOweInfoDic objectForKey:@"dueDate"];
                    [customDic setValue:dueDate forKey:@"effDate"];
                    model.customData = customDic;
                    model.isBinded = NO;
                    !callback?: callback(model,index);
                }
            }
        }
    }];
}

// MCCM 网络请求
- (void)getMccmData:(DCFloorBaseCellModel *)model  callback:(DCFloorBaseViewDataCallback)callback  index:(NSInteger)index{

    NSString *currentSubsId = [DXPPBDataManager shareInstance].currentInfoModel.currentSubsId?:@"";
    NSString *currentAccNbr = [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr?:@"";
    
    NSDictionary *param = @{@"accNbr": currentAccNbr, @"adviceCode": @"Banner",@"channelCode":@"APP",@"identityId":currentSubsId,@"identityType":@"2"};
    [[DCNetAPIClient sharedClient] POST:@"/mccm-outerfront/dmc/mccm/market/MccMarketingController/qryCampInfo" paramaters:param CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSDictionary *dict = (NSDictionary *)res;
                NSArray *arr = [dict objectForKey:@"subsMrkContactDtos"];
                if (!DC_IsArrEmpty(arr)) {
                    NSMutableArray *arrImg = [NSMutableArray array];
                    for (NSDictionary *dic in arr) {
                        NSString *src = dic[@"thumbURL"];
                        if (!DC_IsStrEmpty(src)) {
                            PicturesItem *item = [PicturesItem new];
                            item.src = [NSString stringWithFormat:@"%@",src];
                            item.link =  dic[@"jumpLink"]?:@"";
                            item.linkType = DC_IsStrEmpty(dic[@"linkType"])?@"":dic[@"linkType"];
                            CGSize size = [UIImage getImageSizeWithURL:[NSURL URLWithString:item.src]];
                            item.width = (DC_DCP_SCREEN_WIDTH - 32)*2;
                            item.height = size.height > 0 && size.width > 0 ?  size.height  / size.width * (DC_DCP_SCREEN_WIDTH - 32)*2  : 320 ;
                            [arrImg addObject:item];
                        }
                    }
                    
                    DCFloorPosterViewModel *vm  = (DCFloorPosterViewModel*)model;
                    vm.viewStyle = DCFloorPosterView_MCCM;
                    if (!DC_IsArrEmpty(arrImg)) {
                        vm.props.pictures = arrImg;
                        vm.props.floorStyle = @"MCCM";
                        vm.floorStyle = ComponentFloorStyle_MCCM;
                        [vm coustructCellHeight];
                        dispatch_async(dispatch_get_main_queue(), ^{
                                //主线程更新UI之类的操作
                            !callback?: callback(vm,index);
                        });
                       
                    }
                }
            });
        }
    }];
}

// 是否有在途的开户订单
- (void)queryUserOrderList:(DCTMDashboardCellModel *)model callback:(DCFloorBaseViewDataCallback)callback{
	__weak __typeof(&*self)weakSelf = self;
    [[DCNetAPIClient sharedClient] POST:@"/ecare/order/userOrder/list" paramaters:@{ @"onWayFlag":@"Y",@"eventTypeId":@(0)} CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            NSDictionary * data = [dict objectForKey:@"data"];
            
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                @try {
					DCOrderHistoryModel *orderHistoryModel = [DCOrderHistoryModel yy_modelWithDictionary:data];
                    if(DC_IsArrEmpty(orderHistoryModel.orderList)) {
                        model.dbCellType = DCTMDashboardOpenAccount;
                    }else {
                        model.dbCellType = DCTMDashboardRegisterSim;
                    }
                    !callback?: callback(model,index);
                } @catch (NSException *exception) {
                    
                }
            }
        }
    }];
    
}

/**
 * 返回一个自定义组件view
 * @param cellModel  自定义组件所需数据模型
 */
- (UIView *)componentViewWithData:(DCFloorBaseCellModel *)cellModel {
    NSString *clsName = [self classNameWithModel:cellModel];
    if (DC_IsStrEmpty(clsName)) {
       return nil;
    }
    DCFloorCustomBaseView *customView = [[NSClassFromString(clsName) alloc]initWithFrame:CGRectZero];
    [customView setupComponent:cellModel];
    return customView;
}


/**
 * 获取自定义组件的类名
 * @param model  数据模型
 */
- (NSString *)classNameWithModel:(DCFloorBaseCellModel *)model {
    NSString *clsName = @"";
    if ([model.code isEqualToString:@"GAIAIcon"]) {
        clsName = NSStringFromClass([DCDashboardView class]);
    }
    return clsName;
}
/**
 * 返回一个自定义组件高度
 * @param cellModel  自定义组件所需数据模型
*/
- (CGFloat)heightForComponentWithData:(DCFloorBaseCellModel *)cellModel {
    return 0;
}


// MARK: LAZY
- (NSMutableDictionary *)innerDBComponentDic {
    if (!_innerDBComponentDic) {
        _innerDBComponentDic = [NSMutableDictionary new];
    }
    return _innerDBComponentDic;
}

@end
