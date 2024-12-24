//
//  DCPBDownUploadBtnView.h
//  DCPageBuilding
//
//  Created by Lee on 4.3.24.
//

#import <UIKit/UIKit.h>
@class DCBroadbandAccountCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface DCPBDownUploadBtnView : UIView
@property (nonatomic, strong) UIButton * iconBtn;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * speedLabel;

@property (nonatomic, strong) DCBroadbandAccountCellModel * cellModel;
@end

NS_ASSUME_NONNULL_END
