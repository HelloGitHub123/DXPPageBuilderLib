//
//  DCTMFamilyPlanCell.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/3/17.
//

#import "DCFloorBaseCell.h"
#import "DCBundleInfoModel.h"
NS_ASSUME_NONNULL_BEGIN
// ****************** Model ******************
@interface DCTMFamilyPlanCellModel : DCFloorBaseCellModel
@property (nonatomic, assign) NSInteger selectIndex;
@end



// ****************** Cell ******************
@interface DCTMFamilyPlanCell : DCFloorBaseCell

@end


// ****************** 自定义组件 ******************
@interface DCTMFamilyPlanItem : UIView  // 每一个内容组件

- (void)bindViewWith:(DCPBBundleSubsList *)subModel;
@end




NS_ASSUME_NONNULL_END
