//
//  DCPBMyProfileModel.h
//  SDEC
//
//  Created by mac on 2023/4/27.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCPBCustExtDataModel : DMBaseObject_PB

@property (nonatomic, strong) NSString *sarawakId;

@end

@interface DCPBCustProfileModel : DMBaseObject_PB

@property (nonatomic, strong) NSString *custName;//客户名称
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *certTypeId;//证件类型ID
@property (nonatomic, strong) NSString *certTypeCode;//证件类型Code
@property (nonatomic, strong) NSString *certTypeName;//证件类型名称
@property (nonatomic, strong) NSString *certNbr;//证件号
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *gender;//1男 2女 3其他
@property (nonatomic, strong) NSString *contactNbr;//联系人号码
@property (nonatomic, strong) NSString *contactEmail;//contactEmail
@property (nonatomic, strong) NSString *contactId;//
@property (nonatomic, strong) NSString *isVerified;//
@property (nonatomic, strong) DCPBCustExtDataModel *extData;
@property (nonatomic, strong) NSString *custType;//B为企业，A为个人，默认也是个人

@end

@interface DCPBUserProfileModel : DMBaseObject_PB

@property (nonatomic, strong) NSString *userCode;//用户编码
@property (nonatomic, strong) NSString *userName;//用户名
@property (nonatomic, strong) NSString *alias;//别名
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *mobile;//手机号
@property (nonatomic, strong) NSString *email;//邮箱
@property (nonatomic, strong) NSString *loginAccount;


@end

@interface DCPBMyProfileModel : DMBaseObject_PB

@property (nonatomic, strong) DCPBUserProfileModel *userProfile;
@property (nonatomic, strong) DCPBCustProfileModel *custProfile;

@end

NS_ASSUME_NONNULL_END
