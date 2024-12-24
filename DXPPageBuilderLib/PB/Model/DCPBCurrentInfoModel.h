//
//  DCPBCurrentInfoModel.h
//  DCBaseKitLib
//
//  Created by Lee on 3.1.23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface DCPBCurrentUserInfoModel : NSObject
@property (nonatomic, copy) NSString * alias;
@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * birthday;
@property (nonatomic, copy) NSString * certNbr;
@property (nonatomic, copy) NSString * createdDate;
@property (nonatomic, copy) NSString * currentOpenId;
@property (nonatomic, copy) NSString * custCode;
@property (nonatomic, copy) NSString * custId;
@property (nonatomic, copy) NSString * defaultPwd;
@property (nonatomic, copy) NSString * email;
@property (nonatomic, copy) NSString * forceModPwd;
@property (nonatomic, copy) NSString * gender;
@property (nonatomic, copy) NSString * inviter;
@property (nonatomic, copy) NSString * lastLoginDate;
@property (nonatomic, copy) NSString * lastLoginIp;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * pwdExpired;
@property (nonatomic, copy) NSString * pwdModifiedDate;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * stateDate;
@property (nonatomic, copy) NSString * subsId;
@property (nonatomic, copy) NSString * updateDate;
@property (nonatomic, copy) NSString * userCode;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * userType;

@end


@interface DCPBCurrentInfoModel : NSObject
@property (nonatomic, copy) NSString * currentAccNbr;
@property (nonatomic, copy) NSString * currentCustId;
@property (nonatomic, copy) NSString * currentCustNbr;
@property (nonatomic, copy) NSString * currentRole;
@property (nonatomic, copy) NSString * currentSubsId;

@property (nonatomic, strong) DCPBCurrentUserInfoModel * userInfo;
@end

NS_ASSUME_NONNULL_END
