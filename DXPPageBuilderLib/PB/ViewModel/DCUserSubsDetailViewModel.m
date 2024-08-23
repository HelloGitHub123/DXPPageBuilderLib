//
//  DCUserSubsDetailViewModel.m
//  GaiaCLP
//
//  Created by Lee on 2022/7/14.
//

#import "DCUserSubsDetailViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <YYModel/YYModel.h>
#import "DCPB.h"

@implementation DCUserSubsDetailViewModel
- (void)getUserSubsDetailWithAccNbr:(NSString *)accNbr subsId:(NSString *)subsId prefix:(NSString *)prefix {
	
	__weak __typeof(&*self)weakSelf = self;
    
    NSMutableDictionary * parmas = [NSMutableDictionary new];
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:subsId forKey:@"subsId"];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:HJUserSubsDetail];
    }
 
    [[DCNetAPIClient sharedClient] POST:@"/ecare/subs/detail" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = DC_IsStrEmpty([res objectForKey:@"resultMsg"])?@"":[res objectForKey:@"resultMsg"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:HJUserSubsDetail];
                }
            }else{
                
                NSDictionary* data = [res objectForKey:@"data"];
                weakSelf.subDetailModel = [DCSubsDetailModel yy_modelWithDictionary:data];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:HJUserSubsDetail];
                }
            }
            
        }
        else {
            weakSelf.errorMsg = DC_IsStrEmpty([res objectForKey:@"resultMsg"])?@"":[res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:HJUserSubsDetail];
            }
        }
    }];
    
}
@end
