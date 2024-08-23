//
//  DCTabIconCell.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/20.
//

#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
// ****************** Model ******************
@interface DCTabIconCellModel : DCFloorBaseCellModel
@property (nonatomic, assign) NSInteger selectIndex;
@end

// ****************** Cell ******************
@interface DCTabIconCell : DCFloorBaseCell

@end

NS_ASSUME_NONNULL_END
