//
//  DCVerifyOtpViewModel.h
//  GaiaCLP
//
//  Created by mac on 2022/5/12.
//

#import <Foundation/Foundation.h>
#import "DMBaseObject_PB.h"

static NSString * _Nullable const DCVerifyOtp = @"DCVerifyOtp";

NS_ASSUME_NONNULL_BEGIN

@interface DCVerifyOtpViewModel : DMBaseObject_PB

@property (nonatomic, weak) id<HJVMRequestDelegate_PB> delegate;

@property (nonatomic, copy) NSString * errorMsg;

@property (nonatomic, copy) NSString * resultCode;

@property (nonatomic, copy) NSString * referenceId;

- (void)verifyOtpRequest:(NSString *)account otp:(NSString *)otp businessType:(NSString *)businessType;

@end

NS_ASSUME_NONNULL_END
