//
//  DCSendOtpViewModel.h
//  MOC
//
//  Created by Lee on 2022/2/22.
//

#import "DMBaseObject_PB.h"
static NSString * _Nullable const sendOtpAction = @"HJSendOtpAction";
static NSString * _Nullable const sendOtpByCertNbr = @"sendOtpByCertNbr";
static NSString * _Nullable const sendCDROtp = @"sendCDROtp";
static NSString * _Nullable const sendSwitchSubsOtp = @"sendSwitchSubsOtp";


NS_ASSUME_NONNULL_BEGIN

@interface DCSendOtpViewModel : DMBaseObject_PB
@property (nonatomic, weak) id<HJVMRequestDelegate_PB> delegate;

@property (nonatomic, copy) NSString * errorMsg;

@property (nonatomic, copy) NSString * resultStr;

@property (nonatomic, copy) NSString * contactNbr;


/**
 注册 register
 密码/OTP登录 login
 补全用户信息 completeUser
 OAuth注册/绑定用户 oauthBinding
 忘记密码 resetPassword
 修改用户信息 modUser
 修改账户联系信息 modAcct
 添加Billing账户新增用户关系 addUserRel
 话单使用量查询 qryCdrUsage
 线索开户 leadNewConnection
 开户 newConnection
 E-stapling管理 estaplingMgr
 Go Green goGreen
 移机 subsShifting
 切换套餐 changePlan
 停机 suspension
 */
- (void)sendOtpRequestAction:(NSString *)prefix accNbr:(NSString *)accNbr certNbr:(NSString *)certNbr businessType:(NSString *)businessType;

- (void)sendOtpByCertNbrAction:(NSString *)prefix accNbr:(NSString *)accNbr certNbr:(NSString *)certNbr businessType:(NSString *)businessType;

// 查话单发OTP
- (void)sendCDROtp;

// 订户切换发OTP
- (void)sendSwitchSubsOtpWithSwitchedAccNbr:(NSString *)switchedAccNbr switchedServiceType:(NSString *)switchedServiceType;
@end

NS_ASSUME_NONNULL_END
