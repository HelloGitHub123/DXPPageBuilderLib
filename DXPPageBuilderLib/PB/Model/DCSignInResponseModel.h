//
//  DCSignInResponseModel.h
//  MOC
//
//  Created by Lee on 2022/2/17.
//


#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCSignInUserInfoModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * certNbr;

@property (nonatomic, copy) NSString * alias;

@property (nonatomic, copy) NSString * avatar;

@property (nonatomic, copy) NSString * birthday;

@property (nonatomic, copy) NSString * createdDate;

@property (nonatomic, copy) NSString * currentOpenId;

@property (nonatomic, copy) NSString * custCode;

@property (nonatomic, copy) NSString * custId;

@property (nonatomic, copy) NSString * defaultPwd;

@property (nonatomic, copy) NSString * email;

@property (nonatomic, copy) NSString * gender;

@property (nonatomic, copy) NSString * inviter;

@property (nonatomic, copy) NSString * lastLoginDate;

@property (nonatomic, copy) NSString * lastLoginIp;

@property (nonatomic, copy) NSString * mobile;

@property (nonatomic, copy) NSString * pwdModifiedDate;

@property (nonatomic, copy) NSString * state;

@property (nonatomic, copy) NSString * stateDate;

@property (nonatomic, copy) NSString * subsId;

@property (nonatomic, copy) NSString * updateDate;

@property (nonatomic, copy) NSString * userCode;

@property (nonatomic, copy) NSString * userId;

@property (nonatomic, copy) NSString * userName;

@property (nonatomic, copy) NSString * userType;

//用户是企业还是个人身份识别
@property (nonatomic,copy)  NSString *partyType;
//用于开户,用户填入后simArr 缓存,提交成功后,或返回首页后清除
@property (nonatomic,copy)  NSMutableArray *simArr;

@end

@interface DCSignInResponseModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * token;

@property (nonatomic, copy) NSString * referenceId;

@property (nonatomic, strong) DCSignInUserInfoModel * userInfo;



@end

@interface DCMenuItemModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * appUrl;
@property (nonatomic, copy) NSString * directory;
@property (nonatomic, copy) NSString * fixFlag;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * selectIcon;
@property (nonatomic, copy) NSString * menuCode;
@property (nonatomic, copy) NSString * menuId;
@property (nonatomic, copy) NSString * menuName;
@property (nonatomic, copy) NSString * parentMenuId;
@property (nonatomic, copy) NSString * needLogin;

// 判断底部tabbar是否凸起显示
@property (nonatomic, copy) NSString * primaryFlag;
@property (nonatomic, copy) NSString * sortIndex;
@property (nonatomic, copy) NSString * tagList;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * webUrl;
@property (nonatomic, copy) NSString * schemaType;
//该字段只在用户未编辑过菜单时使用， Y-显示在首页，N-不显示在首页
@property (nonatomic, copy) NSString * isDefault;
@property (nonatomic, copy) NSString * isLogin;
@property (nonatomic, copy) NSArray <DCMenuItemModel *>*children;

// 非接口字段，本地添加处理业务逻辑标志位
@property (nonatomic, assign) bool isDashboardShow; // 首页金刚区展示
@end


NS_ASSUME_NONNULL_END
