//
//  DCPBMenuItemModel.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2022/12/15.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCPBMenuItemModel : NSObject<YYModel,NSCopying>
@property (nonatomic, copy) NSString * appUrl;
@property (nonatomic, copy) NSString * directory;
@property (nonatomic, copy) NSString * fixFlag;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * selectIcon;
@property (nonatomic, copy) NSString * menuCode;
@property (nonatomic, copy) NSString * menuId;
@property (nonatomic, copy) NSString * menuName;
@property (nonatomic, copy) NSString * parentMenuId;
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
@property (nonatomic, copy) NSArray <DCPBMenuItemModel *>*children;
@property (nonatomic, assign) bool isDashboardShow;


@end

NS_ASSUME_NONNULL_END
