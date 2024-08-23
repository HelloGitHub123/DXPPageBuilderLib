//
//  DCVerifyOtpViewModel.m
//  GaiaCLP
//
//  Created by mac on 2022/5/12.
//

#import "DCVerifyOtpViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>

@implementation DCVerifyOtpViewModel

- (void)verifyOtpRequest:(NSString *)account otp:(NSString *)otp businessType:(NSString *)businessType {
	
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:DCVerifyOtp];
    }
    
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
        
    [parmas setValue:account forKey:@"account"];
    [parmas setValue:otp forKey:@"otp"];
    [parmas setValue:businessType forKey:@"businessType"];
    
    NSString *url = @"/ecare/password/reset/otpVerify";
    if ([businessType isEqualToString:@"switchSubs"]) {
        url = @"/ecare/notification/otp/verify"; // 订户切换otp校验
    }

    [[DCNetAPIClient sharedClient] POST:url paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
                weakSelf.resultCode = [res objectForKey:@"resultCode"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:DCVerifyOtp];
                }
            }else{
                NSDictionary *dict = (NSDictionary *)res;
                NSDictionary * data = [dict objectForKey:@"data"];
                weakSelf.referenceId = [data objectForKey:@"referenceId"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:DCVerifyOtp];
                }
            }
            
        }
        else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            weakSelf.resultCode = [res objectForKey:@"resultCode"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:DCVerifyOtp];
            }
        }
    }];
    
}

@end
