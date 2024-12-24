//
//  DCFloorVCDataSource.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/7.
//


#import <Foundation/Foundation.h>
#import "DCFloorBaseViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCFloorVCDataSource : NSObject<DCFloorBaseViewDataSource>

@property (nonatomic, copy) void(^updateView)(void);

@property (nonatomic, strong) NSMutableDictionary *innerDBComponentDic; // 内部数据源


// pb全局数据线
// 当前主题
@property (nonatomic, copy) NSString *themeType;

@property (nonatomic, assign) bool immersive; // 沉浸式
@end

NS_ASSUME_NONNULL_END
