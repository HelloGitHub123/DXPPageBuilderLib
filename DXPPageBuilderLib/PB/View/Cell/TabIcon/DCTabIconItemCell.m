//
//  DCTabIconItemCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/20.
//

#import "DCTabIconItemCell.h"
#import "DCPageCompositionContentModel.h"
#import <SDWebImage/SDWebImage.h>
#import "DCPB.h"

@implementation DCTabIconItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = NO;
        self.clipsToBounds = NO;
    }
    return self;
}


- (void)setItem:(PicturesItem *)item {
    [self.iconImageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    
    _iconImageView = nil;
    _titleLabel = nil;
//    self.titleLabel.verticalAlignment = VerticalAlignmentMiddle;
    self.titleLabel.text = item.iconName;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:item.src]];
    self.contentView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@74);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(@0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(@74);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
    }];
}

- (void)setItem:(NSDictionary *)item
      imageSize:(CGSize)size
      textColor:(NSString *)color
       textLine:(NSInteger)line
       fontSize:(CGFloat)fontSize
     fontWeight:(NSString *)weight
    titleHeight:(CGFloat)height
     lineHeight:(CGFloat)lineHeight{
    [self.iconImageView removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    [self.tagLabel removeFromSuperview];
    [self.tagImageView removeFromSuperview];
    _iconImageView = nil;
    _titleLabel = nil;
    _tagLabel = nil;
    _tagImageView = nil;

    NSString *imageUrl  = [item objectForKey:@"image"];
    NSString *text      = [item objectForKey:@"text"];
    
    self.titleLabel.numberOfLines = line;

    if (line > 1) {
//        self.titleLabel.verticalAlignment = VerticalAlignmentTop;
//        [self.titleLabel hnf_multipleLinesText:text lineHeight:lineHeight];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    } else {
//        self.titleLabel.verticalAlignment = VerticalAlignmentMiddle;
        self.titleLabel.text = text;
    }
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
//    [self.iconImageView autoSetDimensionsToSize:CGSizeMake(size.width, size.height)];
//    [self.iconImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [self.iconImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
//    [self.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
//    [self.titleLabel autoSetDimension:ALDimensionHeight toSize:height];
    
    //角标
//    NSDictionary *angle = [item objectForKey:@"angle"];
//    NSString *angleText = [angle objectForKey:@"text"];
//    NSString *icon      = [angle objectForKey:@"icon"];
//
//    NSDictionary *config= [angle objectForKey:@"config"];
//    CGFloat top         = HNFADAPT_V([[config objectForKey:@"top"] floatValue]);
//    CGFloat right       = HNFADAPT_V([[config objectForKey:@"right"] floatValue]);
//    CGFloat angleWidth  = HNFADAPT_V([[config objectForKey:@"width"] floatValue]);
//    CGFloat angleHeight = HNFADAPT_V([[config objectForKey:@"height"] floatValue]);
//
//    if (!HN_IsStrEmpty(icon)) {
//        [self.contentView addSubview:self.tagImageView];
//        [self.tagImageView autoSetDimensionsToSize:CGSizeMake(angleWidth, angleHeight)];
//        [self.tagImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.iconImageView withOffset:top];
//        [self.tagImageView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.iconImageView withOffset:-right];
//        [self.tagImageView sd_setImageWithURL:[NSURL URLWithString:HN_NSSTRING_NOT_NIL(icon)]];
//    } else if (!HN_IsStrEmpty(angleText)) {
//        NSString *background = [config objectForKey:@"background"];
//        NSString *color      = [config objectForKey:@"color"];
//        CGFloat fontSize     = HNFADAPT_V([[config objectForKey:@"fontSize"] floatValue]);
//        self.tagLabel.layer.masksToBounds = YES;
//        self.tagLabel.layer.cornerRadius = angleHeight/2;
//        self.tagLabel.backgroundColor = [UIColor hn_colorWithHex:HN_NSSTRING_NOT_NIL(background)];
//        self.tagLabel.textColor = [UIColor hn_colorWithHex:HN_NSSTRING_NOT_NIL(color)];
//        [self.contentView addSubview:self.tagLabel];
//        self.tagLabel.text = angleText;
//        [self.tagLabel autoSetDimensionsToSize:CGSizeMake(angleWidth, angleHeight)];
//        [self.tagLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.iconImageView withOffset:top];
//        [self.tagLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.iconImageView withOffset:-right];
//    }
}


#pragma mark - Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (DCTopLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[DCTopLabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor hjp_colorWithHex:@"2A2F38"];
		_titleLabel.font = FONT_S(14);
//        _titleLabel.verticalAlignment = VerticalAlignmentMiddle;
    }
    return _titleLabel;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}
@end
