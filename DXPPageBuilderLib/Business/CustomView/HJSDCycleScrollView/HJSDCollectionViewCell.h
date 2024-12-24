//
//  HJSDCollectionViewCell.h
//  DITOApp
//
//  Created by 严贵敏 on 2023/2/23.
//

#import <UIKit/UIKit.h>
#import "HJSDCycleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJSDCollectionViewCell : UICollectionViewCell
/**  数据模型 */
@property (nonatomic, strong) HJSDCycleModel *model;

@property (nonatomic,strong) UIImageView *imageView;
@end

NS_ASSUME_NONNULL_END
