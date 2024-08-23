//
//  HJSDCollectionViewCell.m
//  DITOApp
//
//  Created by 严贵敏 on 2023/2/23.
//

#import "HJSDCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HJSDCollectionViewCell()

@end

@implementation HJSDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.layer.masksToBounds = true;
    [self.contentView addSubview:_imageView];
    
}

- (void)setModel:(HJSDCycleModel *)model{
    _model = model;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[_model.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:nil];
}


@end

