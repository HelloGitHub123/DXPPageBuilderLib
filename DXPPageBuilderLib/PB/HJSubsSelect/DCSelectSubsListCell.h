//
//  DCSelectSubsListCell.h
//  GaiaCLP
//
//  Created by mac on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "DCSubsBundleModel.h"

@class DCPBSubsItemModel;
NS_ASSUME_NONNULL_BEGIN

@interface DCSelectSubsListCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIView *lineView;

- (void)setContentWithIndexPath:(NSIndexPath *)indexPath;

- (void)setContentWithModel:(DCPBSubsItemModel *)model;

- (void)setContentWithBundleModel:(DCSubsBundleModel *)model;
@end

NS_ASSUME_NONNULL_END
