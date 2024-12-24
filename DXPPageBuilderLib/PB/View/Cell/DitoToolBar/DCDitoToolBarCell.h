//
//  DCDitoToolBarCell.h
//  DITOApp
//
//  Created by 孙全民 on 2022/7/22.
//

#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
// ****************** View ******************
static CGFloat DCDitoToolBarViewHeight = 56.0;
@interface DCDitoToolBarView : UIView
- (void)updateWithModel:(DCFloorBaseCellModel *)cellModel;
@end







// ****************** Model ******************
@interface DCDitoToolBarCellModel : DCFloorBaseCellModel

@end

// ****************** Cell ******************
@interface DCDitoToolBarCell : DCFloorBaseCell
@end

NS_ASSUME_NONNULL_END
