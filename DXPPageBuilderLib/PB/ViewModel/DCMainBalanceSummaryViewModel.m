//
//  DCMainBalanceSummaryViewModel.m
//  GaiaCLP
//
//  Created by Lee on 2022/7/28.
//

#import "DCMainBalanceSummaryViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <YYModel/YYModel.h>
#import "DCSubsListModel.h"
#import "DCPB.h"

@implementation DCMainBalanceSummaryViewModel
- (void)getMainBalanceSummaryListWithPrefix:(NSString *)prefix accNbr:(NSString *)accNbr subsId:(NSString *)subsId defaultAcctId:(NSString *)defaultAcctId defaultAcctNbr:(NSString *)defaultAcctNbr {
	
	__weak typeof(self)weakSelf = self;
    
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:subsId forKey:@"subsId"];
	// TM中acctId 和 acctNbr 为可选参数; BOL不可选
	[parmas setValue: defaultAcctId?:@"" forKey:@"acctId"];
	[parmas setValue:defaultAcctNbr?:@"" forKey:@"acctNbr"];

    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:DCBalanceSummary];
    }
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/balance/summary/list" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = DC_IsStrEmpty([res objectForKey:@"resultMsg"])?@"":[res objectForKey:@"resultMsg"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:DCBalanceSummary];
                }
            }else{
                NSDictionary *dataDict = [dict objectForKey:@"data"];
                weakSelf.balanceSummaryModel = [DCMainBalanceSummaryModel yy_modelWithDictionary:dataDict];

                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:DCBalanceSummary];
                }
                
            }
            
        }
        else {
            weakSelf.errorMsg = DC_IsStrEmpty([res objectForKey:@"resultMsg"])?@"":[res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:DCBalanceSummary];
            }   
        }
    }];
}

+ (void)getMainBalanceSummaryListWithPrefix:(NSString *)prefix
                                     accNbr:(NSString *)accNbr
                                     subsId:(NSString *)subsId
							  defaultAcctId:(NSString *)defaultAcctId
							 defaultAcctNbr:(NSString *)defaultAcctNbr
                              completeBlock:(void (^)(bool success, DCMainBalanceSummaryModel *balanceSummaryModel))completeBlock {
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:subsId forKey:@"subsId"];
	// TM中acctId 和 acctNbr 为可选参数; BOL不可选
	[parmas setValue:defaultAcctId?:@"" forKey:@"acctId"];
	[parmas setValue:defaultAcctNbr?:@"" forKey:@"acctNbr"];
	
    [[DCNetAPIClient sharedClient] POST:@"/ecare/balance/summary/list" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                completeBlock(NO,nil);
            }else{
                NSDictionary *dataDict = [dict objectForKey:@"data"];
				DCMainBalanceSummaryModel *balanceSummaryModel = [DCMainBalanceSummaryModel yy_modelWithDictionary:dataDict];
                completeBlock(YES,balanceSummaryModel);
            }
        }
        else {
            completeBlock(NO,nil);
        }
        
    }];
}
@end
