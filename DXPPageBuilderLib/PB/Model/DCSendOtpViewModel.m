//
//  DCSendOtpViewModel.m
//  MOC
//
//  Created by Lee on 2022/2/22.
//

#import "DCSendOtpViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>

@implementation DCSendOtpViewModel
- (void)sendOtpRequestAction:(NSString *)prefix accNbr:(NSString *)accNbr certNbr:(NSString *)certNbr businessType:(NSString *)businessType{
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:sendOtpAction];
    }
    
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
        
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:certNbr forKey:@"certNbr"];
    [parmas setValue:businessType forKey:@"businessType"];
    [[DCNetAPIClient sharedClient] POST:@"/ecare/notification/sendOtp" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:sendOtpAction];
                }
            } else {
                NSDictionary * data = [dict objectForKey:@"data"];
                weakSelf.resultStr = [data objectForKey:@"result"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:sendOtpAction];
                }
            }
        } else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:sendOtpAction];
            }
        }
    }];
}

- (void)sendOtpByCertNbrAction:(NSString *)prefix accNbr:(NSString *)accNbr certNbr:(NSString *)certNbr businessType:(NSString *)businessType{
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:sendOtpByCertNbr];
    }
    
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
        
    [parmas setValue:prefix forKey:@"prefix"];
    [parmas setValue:accNbr forKey:@"accNbr"];
    [parmas setValue:certNbr forKey:@"certNbr"];
    [parmas setValue:businessType forKey:@"businessType"];
    [[DCNetAPIClient sharedClient] POST:@"/ecare/notification/sendOtpByCertNbr" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            NSDictionary * data = [dict objectForKey:@"data"];
            weakSelf.resultStr = [data objectForKey:@"result"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                [weakSelf.delegate requestSuccess:weakSelf method:sendOtpByCertNbr];
            }
        }
        else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:sendOtpByCertNbr];
            }
        }
    }];
    
}


// 查话单发OTP
- (void)sendCDROtp {
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:sendCDROtp];
    }
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/cdr/query/otp/send" paramaters:@{} CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:sendCDROtp];
                }
            } else {
                NSDictionary * data = [dict objectForKey:@"data"];
                weakSelf.contactNbr = [data objectForKey:@"contactNbr"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:sendCDROtp];
                }
            }
        } else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:sendCDROtp];
            }
        }
    }];
}

// 订户切换发OTP
- (void)sendSwitchSubsOtpWithSwitchedAccNbr:(NSString *)switchedAccNbr switchedServiceType:(NSString *)switchedServiceType {
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:sendSwitchSubsOtp];
    }
    
    NSMutableDictionary * parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:switchedAccNbr forKey:@"switchedAccNbr"];
    [parmas setValue:switchedServiceType forKey:@"switchedServiceType"];
    
    [[DCNetAPIClient sharedClient] POST:@"/ecare/notification/switch-subs/send-otp" paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            if (![[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                    [weakSelf.delegate requestFailure:weakSelf method:sendSwitchSubsOtp];
                }
            } else {
                NSDictionary * data = [dict objectForKey:@"data"];
                weakSelf.contactNbr = [data objectForKey:@"contactNbr"];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                    [weakSelf.delegate requestSuccess:weakSelf method:sendSwitchSubsOtp];
                }
            }
        } else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:sendSwitchSubsOtp];
            }
        }
    }];
}

@end
