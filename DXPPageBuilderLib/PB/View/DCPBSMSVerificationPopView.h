//
//  DCPBSMSVerificationPopView.h
//  BOL
//
//  Created by 李标 on 2023/7/23.
//  订户切换 短信验证码弹框


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kActionType) {
    kActionType_none      = 0, //
    kActionType_Cancel    = 1, //
    kActionType_OK  = 2, //
};

typedef void (^SMSVerificationBlock)(NSString * _Nonnull VerificationCode, kActionType action, NSString *contactNbr);

@interface DCPBSMSVerificationPopView : UIView

- (id)initWithSwitchedAccNbr:(NSString *)switchedAccNbr switchedServiceType:(NSString *)type block:(SMSVerificationBlock)block;

- (void)show;

- (void)diss;

- (void)setContentVal:(NSString *)errorStr;
@end

NS_ASSUME_NONNULL_END
