//
//  DCMenuModel.h
//  Product_CLP
//
//  Created by Lee on 2022/9/28.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCMenuModel : DMBaseObject_PB
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
@property (nonatomic, copy) NSArray <DCMenuModel *>*children;

// 非接口字段，本地添加处理业务逻辑标志位
@property (nonatomic, assign) bool isDashboardShow; // 首页金刚区展示
@property (nonatomic, assign) bool isMenuShowAll; //在侧边栏是否展开

@property (nonatomic, assign) BOOL isExpend;//侧边栏

@end

NS_ASSUME_NONNULL_END
