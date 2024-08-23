//
//  DCHotNewsViewCell.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/18.
//

#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HotNewsEventDelegate <NSObject>

/// 公告点击事件
/// @param index 点击的索引
/// @param link 点击的跳转链接
/// @param target 当前对象
- (void)HotNewsViewClickByIndex:(NSInteger)index link:(NSString *)link targetId:(id)target;
@end

// ****************** Model ******************
@interface DCHotNewsViewModel : DCFloorBaseCellModel

@end

// ****************** Cell ******************
@interface DCHotNewsViewCell : DCFloorBaseCell

@property (nonatomic, assign) id<HotNewsEventDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
