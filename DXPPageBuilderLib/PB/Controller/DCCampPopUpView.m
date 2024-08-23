//
//  DCCampPopUpView.m
//  DCPageBuilding
//
//  Created by Lee on 29.1.24.
//

#import "DCCampPopUpView.h"
#import <YYCategories/YYCategories.h>
#import <Masonry/Masonry.h>
#import "DCPBQryCampInfoViewModel.h"
#import <SDWebImage/SDWebImage.h>
#import "DCPB.h"
 
@interface DCCampPopUpView()
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UIImageView * closeImgView;
@end
@implementation DCCampPopUpView

- (id)initWithFrame:(CGRect)frame withCampInfoModel:(DCPBCampInfoItemModel *)model{
    self = [super initWithFrame:frame];
    if (self) {
        _campInfoModel = model;
        self.width = DC_DCP_SCREEN_WIDTH;//距离左右边框24px
        if (frame.size.width > 0) self.width = frame.size.width;
        
        self.height = DC_SCREEN_HEIGHT;
        if (frame.size.height > 0) self.height = frame.size.height;
        self.backgroundColor = DC_RGBA(0, 0, 0, 0.35);
        [self initUI];
    }
    return self;
}


- (void)initUI {
    [self addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(0);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    [_bgView addSubview:self.imgView];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_campInfoModel.imgWidth);
        make.height.mas_equalTo(_campInfoModel.imgHeight);
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        if ([_campInfoModel.showCloseButton isEqualToString:@"N"]) {
            make.bottom.mas_equalTo(0);
        }
    }];
    
    if (![_campInfoModel.showCloseButton isEqualToString:@"N"]) {
        [_bgView addSubview:self.closeImgView];
        [_closeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(32);
            make.height.mas_equalTo(32);
            make.centerX.mas_equalTo(self.imgView.mas_centerX);
            make.top.mas_equalTo(self.imgView.mas_bottom).offset(50);
            make.bottom.mas_offset(0);
        }];
    }
    
    NSString * urlStr = [_campInfoModel.thumbURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

#pragma mark -- function
- (void)showView{
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

- (void)dismissView{
    [self removeFromSuperview];
}



#pragma mark -- lazy load
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.userInteractionEnabled = YES;
		__weak __typeof(&*self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf dismissView];
            if (weakSelf.clickPopUpActionBlock) {
                weakSelf.clickPopUpActionBlock(weakSelf.campInfoModel);
            }
        }];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}
- (UIImageView *)closeImgView{
    if (!_closeImgView) {
        _closeImgView = [[UIImageView alloc] initWithImage:DC_image(@"pb_popup_close")];
        _closeImgView.userInteractionEnabled = YES;
		__weak __typeof(&*self)weakSelf = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf dismissView];
            if (weakSelf.clickCloseActionBlock) {
                weakSelf.clickCloseActionBlock();
            }
        }];
        [_closeImgView addGestureRecognizer:tap];
    }
    return _closeImgView;
}


@end
