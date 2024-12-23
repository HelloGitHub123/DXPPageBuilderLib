//
//  DCCustomizedComponentCell.h
//  AFNetworking
//
//  Created by 李标 on 2024/9/13.
//

#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DCCustomizedComponentCellType) {
	DCCustomizedComponentCellType_REGISTRATION_REQUIRED = 0,
	DCCustomizedComponentCellType_MHAWALA_BALANCE = 1, // ETA自定义
};

@interface DCCustomizedComponentCellModel : DCFloorBaseCellModel

// 区别类型
@property (nonatomic, assign) DCCustomizedComponentCellType componentCellType;

+ (CGFloat)getTMDBTopMargin;
@end


@interface DCCustomizedComponentCell : DCFloorBaseCell

- (void)bindCellModel:(DCCustomizedComponentCellModel *)cellModel;
@end



@interface DCUnVerifiedComponentView : UIView

- (void)bindWithModel:(DCCustomizedComponentCellModel *)cellModel;
@end


@interface DCVerifiedComponentView : UIView

- (void)bindWithModel:(DCCustomizedComponentCellModel *)cellModel;
@end



@interface DCMhawalaBalanceView : UIView

- (void)bindWithModel:(DCCustomizedComponentCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END
