//
//  HJVideoView.m
//  DITOApp
//
//  Created by 李标 on 2023/4/14.
//

#import "HJVideoView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import <Masonry/Masonry.h>

@interface HJVideoView ()

@property (nonatomic, strong) UIButton *playBtn;
@end

@implementation HJVideoView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.coverImageView];
    [self.coverImageView addSubview:self.playBtn];
    
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(0);
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@48);
        make.height.equalTo(@48);
        make.centerY.mas_equalTo(self.coverImageView.mas_centerY);
        make.centerX.mas_equalTo(self.coverImageView.mas_centerX);
    }];
}

#pragma mark -- mathod
- (void)setVideoCoverImage:(NSString *)videoURL {
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:videoURL] placeholderImage:[UIImage imageNamed:@"ic_video_coverImage"]];
}

#pragma mark -- lazy load
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
        _coverImageView.backgroundColor = UIColor.clearColor;
        _coverImageView.sd_imageTransition = [SDWebImageTransition fadeTransition];
        _coverImageView.userInteractionEnabled = YES;
    }
    return _coverImageView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setBackgroundImage:[UIImage imageNamed:@"ic_video_play"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(handleTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)handleTapGesture:(id)sender {
    if ([(id)_delegate respondsToSelector:@selector(coverItemWasTapped:)] ) {
        [_delegate coverItemWasTapped:self];
    }
}
@end
