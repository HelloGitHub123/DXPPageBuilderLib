//
//  DCSinglePostCell.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/17.
//

#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SinglePostViewEventDelegate <NSObject>

/// 图片点击事件
/// @param index 点击的图片索引
/// @param link : 跳转链接
/// @param target 当前对象
- (void)SinglePostImgViewClickByIndex:(NSInteger)index jumpLink:(NSString *)link targetId:(id)target;
/// 点击more事件
/// @param link 跳转链接
/// @param target 当前对象
- (void)SinglePostMoreClickByLink:(NSString *)link targetId:(id)target;
@end

// ****************** Model ******************
@interface DCSinglePostCellModel : DCFloorBaseCellModel

@end


// ****************** Cell ******************
@interface DCSinglePostCell : DCFloorBaseCell

@property (nonatomic, assign) id<SinglePostViewEventDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
