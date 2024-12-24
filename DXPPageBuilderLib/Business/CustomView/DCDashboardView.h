//
//  DCDashboardView.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/7.
//  金刚区view

#import "DCFloorCustomBaseView.h"

NS_ASSUME_NONNULL_BEGIN


/* View数据源model,为了提取此组件为公共组件 ,内部属性可以按需添加*/
@interface DCDashboardViewModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, assign) bool isAll; // 是不是最后all按钮

@end

@interface DCDashboardView : DCFloorCustomBaseView

@end

NS_ASSUME_NONNULL_END
