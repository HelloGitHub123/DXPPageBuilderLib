//
//  DCCountdownPostCell.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/29.
//

#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
// ****************** Model ******************
@interface DCCountdownPostCellModel : DCFloorBaseCellModel
+ (NSDate *)dateByAddingHours:(NSInteger)hours date:(NSDate*)date;
@end


// ****************** Cell ******************
@interface DCCountdownPostCell : DCFloorBaseCell

@end

NS_ASSUME_NONNULL_END
