//
//  DCMutiBalanceDashboardCell.h
//  DCPageBuilding
//
//  Created by 李标 on 2024/4/13.
//

#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"

// 点击事件类型
typedef NS_ENUM(NSInteger, DCMutiBalanceDashboardCellHeightType) {
	DCMutiBalanceLikeDITO = 0, // 类似 DITO 组件
};

NS_ASSUME_NONNULL_BEGIN

// ****************** Model ******************
@interface DCMutiBalanceDashboardCellModel : DCFloorBaseCellModel

// 区别类型
@property (nonatomic, assign) DCMutiBalanceDashboardCellHeightType dbCellType;

+ (CGFloat)getTMDBTopMargin;
@end

// ****************** Cell ******************
@interface DCMutiBalanceDashboardCell : DCFloorBaseCell

@end


// ****************** DCDBContainerDITOView ******************
// DB容器view
@interface DCDBContainerDITOView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** DCDBTopInfoView ******************
@interface DCDBTopInfoView : UIView

@property (nonatomic, assign) BOOL isStickView;
@property (nonatomic, copy) void(^dbEventBlack)(DCFloorEventModel *model);

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end

// ****************** 右边 预付费上面 有积分 ******************
@interface DCPrepaidRightTopInfoView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 右边 预付费上面 无积分 ******************
@interface DCPrepaidRightInfoView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end



// ****************** 右边 后付费上面 ******************
@interface DCPostpaidRightTopInfoView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


// ****************** 右边 后付费无积分 (看账单、支付账单) ******************
@interface DCPostpaidRightInfoView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end

// ****************** 右边 后付费无积分 (Outstanding Bill) ******************
@interface DCPostpaidOutstandingBillRightTopInfoView : UIView

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end

// ****************** 积分 ******************
@interface DCRightPointInfoView : UIView

@property (nonatomic, copy) void(^dbEventBlack)(DCFloorEventModel *model);

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end


NS_ASSUME_NONNULL_END
