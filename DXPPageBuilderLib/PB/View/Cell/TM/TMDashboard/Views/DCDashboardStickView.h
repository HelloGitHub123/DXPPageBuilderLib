//
//  DCDashboardStickView.h
//  DCPageBuilding
//
//  Created by 李标 on 2024/4/15.
//  吸顶View (包含 预付费 + 后付费)

#import <UIKit/UIKit.h>
#import "DCMutiBalanceDashboardCell.h"
#import "DCFloorEventModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCDashboardStickView : UIView


@property (nonatomic, copy) void(^showActionBlock)(void);
/**
 此属性判断是否需要再次更新。防止在scrollView滑动中无限调用updateWithDic
 */
@property (nonatomic, assign) bool isUpdateData;
@property (nonatomic, copy) void(^dbEventBlack)(DCFloorEventModel *model);

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 预付费 无积分 ******************
@interface DCPrepaidNoPointStickView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 预付费 有积分 ******************
@interface DCPrepaidStickView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 后付费 有积分 ******************
@interface DCPostpaidStickView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 后付费 无积分 ******************
@interface DCPostpaidNoPointStickView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 后付费 No Outstanding Bills ******************
@interface DCPostpaidNoOutstandingBillsStickView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 积分View ******************
@interface DCRightPointView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END
