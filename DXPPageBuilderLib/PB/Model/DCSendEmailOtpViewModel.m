//
//  DCSendEmailOtpViewModel.m
//  MOC
//
//  Created by Lee on 2022/4/14.
//

#import "DCSendEmailOtpViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>

@implementation DCSendEmailOtpViewModel
- (void)userSendEmailOtpRequest:(NSString *)email businessType:(NSString *)businessType{
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:userSendEmailOtp];
    }
    
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
        
    [parmas setValue:email forKey:@"email"];
    [parmas setValue:businessType forKey:@"businessType"];
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/notification/sendEmailOtp" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:userSendEmailOtp];
                }
            }else{
//                weakSelf.subsListModel = [DCSubsListModel yy_modelWithDictionary:[res objectForKey:@"data"]];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:userSendEmailOtp];
                }
            }
            
        }
        else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:userSendEmailOtp];
            }
        }
    }];
    
    
}
@end
