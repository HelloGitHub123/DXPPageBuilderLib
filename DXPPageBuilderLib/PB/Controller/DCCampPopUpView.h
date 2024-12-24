//
//  DCCampPopUpView.h
//  DCPageBuilding
//
//  Created by Lee on 29.1.24.
//

#import <UIKit/UIKit.h>

@class DCPBCampInfoItemModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickPopUpActionBlock)(DCPBCampInfoItemModel * model);

typedef void(^ClickCloseActionBlock)(void);



@interface DCCampPopUpView : UIView

@property (nonatomic, strong) DCPBCampInfoItemModel *campInfoModel;
@property (nonatomic, copy) ClickPopUpActionBlock clickPopUpActionBlock;
@property (nonatomic, copy) ClickCloseActionBlock clickCloseActionBlock;

- (id)initWithFrame:(CGRect)frame withCampInfoModel:(DCPBCampInfoItemModel *)model;

- (void)showView;

- (void)dismissView;

@end

NS_ASSUME_NONNULL_END
