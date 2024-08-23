//
//  DCBundleInfoModel.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/3/17.
//


#import "DCPB.h"
#import "DCBundleInfoModel.h"
#import "DCSubsDetailModel.h"

@implementation DCBundleInfoModel
+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"bundleSubsList" : [DCPBBundleSubsList class],
    };
}


+ (void)getBundleInfoComplete:(DCBLMCompleteBlock)complete {
    
    void(^block)(CompleteBlock) = ^(DCBLMCompleteBlock complete2){
        [[DCNetAPIClient sharedClient] POST:@"/ecare/online/subs/bundleInfo" paramaters:@{@"subsId":[DCPBManager sharedInstance].parentSubsId?: @"" ,@"scopes":@"BAL_SUMMARY"} CompleteBlock:^(id res, NSError *error) {
            if (!error) {
                NSDictionary *dict = (NSDictionary *)res;
                if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                    @try {
                        NSDictionary * data = [dict objectForKey:@"data"];
                        DCBundleInfoModel *InfoModel = [DCBundleInfoModel yy_modelWithDictionary:data];
                        !complete2?: complete2(InfoModel,nil);
                        return;
                    } @catch (NSException *exception) {}
                }
            }
            !complete2?: complete2(nil,nil);
        }];
    };
    
    NSString *parentSubsId = [DCPBManager sharedInstance].parentSubsId;
    if(DC_IsStrEmpty(parentSubsId)) {
        NSString *accnbr = [DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr?:@"";
        [[DCNetAPIClient sharedClient] POST:@"/ecare/subs/detail" paramaters:@{@"prefix":@"",@"accNbr":accnbr,@"scopes":@"subsRelaList" } CompleteBlock:^(id res, NSError *error) {
            if (!error) {
                if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
					DCSubsDetailModel *subDetailModel = [DCSubsDetailModel yy_modelWithDictionary:DC_HTTP_Data];
                    if(!DC_IsStrEmpty(subDetailModel.parentSubsId)) {
                        [DCPBManager sharedInstance].parentSubsId = subDetailModel.parentSubsId;
                        block(complete);
                        return;
                    }
                }
            }else {
                complete(nil,nil);
            }
        }];
    }else {
        block(complete);
    }
}

+ (void)setPurchasePrivSubsId:(NSString *)subsId  principalSubsId:(NSString*)principalSubsId specialPurchaseFlag:(NSString *)specialPurchaseFlag  complete:(DCBLMCompleteBlock)complete {
    
    // subsId  设置权限副卡    specialPurchaseFlag    Y N    principalSubsId  主卡订户ID
    [[DCNetAPIClient sharedClient] POST:@"/ecare/online/subs/setMemberSpecialPurchasePriv" paramaters:@{ @"subsId" : subsId ?: @"" , @"specialPurchaseFlag" : specialPurchaseFlag ?: @"", @"principalSubsId": principalSubsId?:@"" } CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
                NSDictionary *result = DC_HTTP_Data;
                complete(result,nil);
                return;
            }else {
//                weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            }
        }
        complete(nil, error);
    }];
}


@end

@implementation DCPBBalSummaryList

@end

@implementation DCPBBundleSubsList
+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"balSummaryList" : [DCPBBalSummaryList class],
    };
}
@end

