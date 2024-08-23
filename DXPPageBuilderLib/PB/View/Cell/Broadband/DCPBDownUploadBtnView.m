//
//  DCPBDownUploadBtnView.m
//  DCPageBuilding
//
//  Created by Lee on 4.3.24.
//

#import "DCPBDownUploadBtnView.h"
#import <Masonry/Masonry.h>
#import <DXPCategoryLib/UIImage+Category.h>
#import <DXPCategoryLib/UIColor+Category.h>
#import "DCBroadbandAccountCellModel.h"

@interface DCPBDownUploadBtnView ()


@end

@implementation DCPBDownUploadBtnView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self configView];
    }
    return self;
}

-(void)configView{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    [self addSubview:self.iconBtn];
    
    [self addSubview:self.titleLabel];
    
    [self addSubview:self.speedLabel];
    
    [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(12);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.leading.mas_equalTo(self.iconBtn.mas_trailing).offset(8);
        make.height.mas_equalTo(22);
    }];
    
    [_speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(0);
        make.leading.mas_equalTo(self.iconBtn.mas_trailing).offset(8);
        make.height.mas_equalTo(22);
        make.bottom.mas_equalTo(-6);
    }];
    
}

- (void)setCellModel:(DCBroadbandAccountCellModel *)cellModel{
    _cellModel = cellModel;
    
    
}


#pragma mark -- lazy load
- (UIButton *)iconBtn{
    if(!_iconBtn){
        _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _iconBtn.layer.masksToBounds = YES;
        _iconBtn.layer.cornerRadius = 16.f;
    }
    return _iconBtn;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FONT_S(14);
        _titleLabel.textColor = DC_UIColorFromRGB(0xffffff);
    }
    return _titleLabel;
}

- (UILabel *)speedLabel{
    if(!_speedLabel){
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.font = FONT_BS(14);
        _speedLabel.textColor = DC_UIColorFromRGB(0xffffff);
        _speedLabel.text = @"";
    }
    return _speedLabel;
}

@end
