//
//  DCDITODashboardView.h
//  DCPageBuilding
//
//  Created by 李标 on 2024/4/14.
//

#import <UIKit/UIKit.h>
#import "DCMutiBalanceDashboardCell.h"
#import "DCFloorEventModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HJDITODashBoardActionType) {
	HJDITODashBoardActionTypeInfo,
	HJDITODashBoardActionTypeBottomArrow,
};


@interface DCDITODashboardView : UIView

@property (nonatomic, copy) void(^showActionBlock)(HJDITODashBoardActionType type);
@property (nonatomic, copy) void(^dbEventBlack)(DCFloorEventModel *model);

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END
