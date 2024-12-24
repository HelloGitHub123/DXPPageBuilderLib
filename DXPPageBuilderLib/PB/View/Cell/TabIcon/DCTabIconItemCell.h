//
//  DCTabIconItemCell.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/20.
//

#import <UIKit/UIKit.h>
#import "DCTopLabel.h"
#import <Masonry/Masonry.h>
#import "UIColor+DCPCategory.h"

NS_ASSUME_NONNULL_BEGIN
@class PicturesItem;
@interface DCTabIconItemCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) DCTopLabel    *titleLabel;
@property (nonatomic, strong) UILabel       *tagLabel;
@property (nonatomic, strong) UIImageView   *tagImageView;


- (void)setItem:(PicturesItem *)item;
- (void)setItem:(NSDictionary *)item
      imageSize:(CGSize)size
      textColor:(NSString *)color
       textLine:(NSInteger)line
       fontSize:(CGFloat)fontSize
     fontWeight:(NSString *)weight
    titleHeight:(CGFloat)height
     lineHeight:(CGFloat)lineHeight;


@end

NS_ASSUME_NONNULL_END
