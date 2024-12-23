//
//  DCMarketingOfferListCell.h
//  DXPPageBuilderLib
//
//  Created by 李标 on 2024/11/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"
#import "DCPromotionsModel.h"

NS_ASSUME_NONNULL_BEGIN

// ****************** Model ******************
@interface DCMarketingOfferListCellModel : DCFloorBaseCellModel

- (void)coustructCellHeight;
@end


// ****************** Cell ******************
@interface DCMarketingOfferListCell : DCFloorBaseCell

@end


// ****************** DCMarketingOfferView ******************
// DB容器view
@interface DCMarketingOfferView : UIView

@property (nonatomic, copy) void(^dbEventBlack)(DCFloorEventModel *model);
@property (nonatomic, strong) OfferItem *offerItemModel;

- (void)bindWithModel:(DCMarketingOfferListCellModel *)cellModel;

@end

NS_ASSUME_NONNULL_END
