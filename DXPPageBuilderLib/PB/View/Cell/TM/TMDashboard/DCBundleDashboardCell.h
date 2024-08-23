//
//  DCBundleDashboardCell.h
//  DCPageBuilding
//
//  Created by lishan on 2024/5/28.
//

#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

// ****************** Model ******************
@interface DCBundleDashboardCellModel : DCFloorBaseCellModel

+ (CGFloat)getTMDBTopMargin;

@end

// ****************** Cell ******************
@interface DCBundleDashboardCell : DCFloorBaseCell

@end

// ****************** DCDBContainerDITOView ******************
// DB容器view
@interface DCBundleDashboardView : UIView

@property (nonatomic, copy) void(^dbEventBlack)(DCFloorEventModel *model);

- (void)bindWithModel:(DCBundleDashboardCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
