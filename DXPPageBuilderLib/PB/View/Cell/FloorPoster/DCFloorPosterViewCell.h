//
//  DCFloorPosterViewCell.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/21.
//  楼层

#import "DCFloorBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

// Floor组件 子组件布局类型
typedef NS_ENUM(NSInteger, ComponentFloorStyle) {
    ComponentFloorStyle_R1C1  = 1,  //R1C1  一行一列
    ComponentFloorStyle_R1C2  = 2, //R1C2  一行两列
    ComponentFloorStyle_R1C3  = 3, //R1C3  一行三列
    ComponentFloorStyle_L1R2  = 4, //L1R2  左一右二
    ComponentFloorStyle_L2R1  = 5, //L2R1  左二右一
    ComponentFloorStyle_INF   = 6, //INF   可横向滑动
    ComponentFloorStyle_MCCM  = 7, //MCCM   带定时器可横向滑动
};


// Floor组件 子组件布局类型
typedef NS_ENUM(NSInteger, DCFloorPosterViewStyle) {
    DCFloorPosterView_DEFAULT  = 0,
    DCFloorPosterView_MCCM  = 1,
    
};

@protocol FloorPosterViewEventDelegate <NSObject>

/// 图片点击事件
/// @param index 点击的图片索引
/// @param link : 跳转链接
/// @param target 当前对象
- (void)FloorPosterImgViewClickByIndex:(NSInteger)index jumpLink:(NSString *)link targetId:(id)target;

/// 点击more事件
/// @param link 跳转链接
/// @param target 当前对象
- (void)FloorPosterMoreClickByLink:(NSString *)link targetId:(id)target;

@end

// ****************** Model ******************
@interface DCFloorPosterViewModel : DCFloorBaseCellModel
// 子组件布局类型
@property (nonatomic, assign) ComponentFloorStyle floorStyle;

@property (nonatomic, assign) DCFloorPosterViewStyle viewStyle; //
@end

// ****************** Cell ******************
@interface DCFloorPosterViewCell : DCFloorBaseCell

@property (nonatomic, assign) id<FloorPosterViewEventDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
