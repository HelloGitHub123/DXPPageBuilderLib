//
//  DCIconEditCell.m
//  Pods
//
//  Created by 孙全民 on 2023/2/13.
//

#import "DCIconEditCell.h"
#import "DCPB.h"
#import "DCPBMenuItemModel.h"
#import <DXPFontManagerLib/FontManager.h>
#import "UIImageView+PBSDWebImage.h"
#import <DXPManagerLib/HJImageManager.h>

@implementation DCIconEditCellModel

@end


// ****************** Cell ******************
@interface DCIconEditCell()
@property (nonatomic, strong) UIImageView   *iconImageView;
@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UIImageView   *tagImageView;
@end

@implementation DCIconEditCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.clipsToBounds = NO;
        self.clipsToBounds = NO;
        [self configView];
    }
    return self;
}

- (void)configView {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.tagImageView];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@48);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(@28);
    }];
    self.iconImageView.image = [[HJImageManager shareInstance] getImageByName:@"telcoIcon"];
    
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.iconImageView.mas_trailing);
        make.bottom.equalTo(self.iconImageView.mas_top).offset(-4);
        make.width.height.equalTo(@16);
       
    }];
    self.tagImageView.image = [[HJImageManager shareInstance] getImageByName:@"littleAddBtn"];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(8);
        make.leading.trailing.equalTo(@0);
    }];
    self.titleLabel.text = @"FaceBook";
}


- (void)bindCellModel:(DCIconEditCellModel *)model {
	DCPBMenuItemModel *data = model.data;
    self.titleLabel.text = data.menuName;
    self.tagImageView.hidden = !model.isEditing;
    
    if (model.isShow) {
        _tagImageView.image = [[HJImageManager shareInstance] getImageByName:@"db_icon_del"];
        if (model.isFixed) {
            _tagImageView.image = [[HJImageManager shareInstance] getImageByName:@"db_icon_fixed"];
        }
    }else {
        _tagImageView.image = [[HJImageManager shareInstance] getImageByName:@"db_icon_add"];
    }
    
    [self.iconImageView dc_setImageWithURLString:[data.icon stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]?:@""];
}

#pragma mark - Getter
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UIImageView *)tagImageView {
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] init];
    }
    return _tagImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
		_titleLabel.font =  [FontManager setNormalFontSize:12];
    }
    return _titleLabel;
}
@end
