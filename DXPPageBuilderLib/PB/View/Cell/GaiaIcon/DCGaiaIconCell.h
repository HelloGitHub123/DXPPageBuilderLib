//
//  DCGaiaIconCell.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/7.
//

#import "DCFloorBaseCell.h"


NS_ASSUME_NONNULL_BEGIN
// ****************** Model ******************
@interface DCGaiaIconCellModel : DCFloorBaseCellModel
@property (nonatomic, assign) NSInteger pageNum; // 为1的时候不展示底部pageControl
@property (nonatomic, assign) bool isTab4; // 目前只有tab4  和tab8
@property (nonatomic, assign) NSInteger tabRows; // tab的row

@end

// ******************NoTab Cell ******************
@interface DCGaiaIconCell : DCFloorBaseCell

@end

NS_ASSUME_NONNULL_END
