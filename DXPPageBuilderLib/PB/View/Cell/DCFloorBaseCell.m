//
//  DCFloorBaseCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/17.
//

#import "DCFloorBaseCell.h"
#import <DXPFontManagerLib/FontManager.h>
#import "UIImageView+PBSDWebImage.h"

@implementation DCFloorBaseCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)item {
    if (self = [super init]) {
        self.cellHeight = 0;
        self.isBinded = NO;
        self.contentMargin = UIEdgeInsetsZero;
        self.props = item.props;
        if(self.props.horizontalOutterMargin < 0 ) {
            self.props.horizontalOutterMargin = PAGE_H_M;
        }
        self.contentModel = item;
        [self coustructCellHeight];
    }
    return self;
}

// 计算是否有title高度
- (void)coustructCellHeight {
    CGFloat titleH = (self.props.showTitle ) || (self.props.showMore) ? Title_H : 0; 
    CGFloat topMargin = self.props.topMargin > 0 ? self.props.topMargin : 0;
    CGFloat topPadding = self.props.topPadding > 0 ? self.props.topPadding : 0;
    CGFloat bottomMargin = self.props.bottomMargin > 0 ? self.props.bottomMargin : 0;
    CGFloat bottomPadding = self.props.bottomPadding > 0 ? self.props.bottomPadding : 0;

    self.cellHeight = titleH + topMargin + topPadding + bottomMargin + bottomPadding;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCFloorBaseCell class]);
}

- (BOOL)checkPicturesDataVaild {
    bool a = !self.props.pictures;
    bool b = [self.props.pictures isKindOfClass:[NSArray class]] && DC_IsArrEmpty(self.props.pictures);
    bool c = [self.props.pictures isKindOfClass:[NSString class]];
    if (a || b || c ) {
       return NO;
    }
    return YES;
}
@end

// ****************** BaseCell ******************
@interface DCFloorBaseCell()
@property (nonatomic, strong) NSArray *baseContainerConstraint;
@property (nonatomic, strong) NSArray *borderViewConstraint;
@property (nonatomic, strong) NSArray *innerViewConstraint;
// 组件背景图
@property (nonatomic, strong) UIImageView *bgImgView;
@end

@implementation DCFloorBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.borderView];
        [_borderView addSubview:self.innerImgView];
        [_innerImgView addSubview:self.baseContainer];
        [self configView];
    }
    return self;
}

- (void)configView{
    // 子类实现
}


/**
 * cellModel赋值
 * 基类添加了  borderView 和 baseContainer的边距计算
*/
- (void)bindCellModel:(DCFloorBaseCellModel *)cellModel {
    
    cellModel.isBinded = YES;
    self.cellModel = cellModel;
    [self.baseContainerConstraint enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj uninstall];
    }];
    
    [self.borderViewConstraint enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj uninstall];
    }];
    [self.innerViewConstraint enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj uninstall];
    }];
    
    
    self.borderViewConstraint = nil;
    self.baseContainerConstraint = nil;
    self.innerViewConstraint = nil;
    
    // 公共按钮部分
    [_baseTitleLab removeFromSuperview];
    [_baseBtnMore removeFromSuperview];
    [_titleIcon removeFromSuperview];
    _baseTitleLab = nil;
    _baseBtnMore = nil;
    _titleIcon = nil;
    
    // 背景图
    [self.bgImgView removeFromSuperview];
    self.bgImgView = nil;
    
    if (cellModel.cellHeight <= 0) {
        return;
    }
    
    
    if ([@"Y" isEqualToString:cellModel.props.hasBackground] && !DC_IsStrEmpty(cellModel.props.bgImg.src)) {
        [self.contentView insertSubview:self.bgImgView atIndex:0];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(cellModel.props.topMargin, cellModel.props.horizontalOutterMargin, cellModel.props.bottomMargin, cellModel.props.horizontalOutterMargin));
        }];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.props.bgImg.src]];
    }
    
    /* 很无奈，接口返回了两种情况颜色背景的设置。 沟通无果， 希望后续能够删除这块逻辑*/
    if ([@"Color" isEqualToString:cellModel.props.backgroundType] && !DC_IsStrEmpty(cellModel.props.componentBgColor)) {
        self.contentView.backgroundColor = [UIColor hjp_colorWithHex:cellModel.props.componentBgColor];
    }else if([@"Image" isEqualToString:cellModel.props.backgroundType] && [cellModel.props.bgImg isKindOfClass:[PicturesItem class]] &&   !DC_IsStrEmpty(cellModel.props.bgImg.src)){
        [self.contentView insertSubview:self.bgImgView atIndex:0];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(cellModel.props.topMargin, cellModel.props.horizontalOutterMargin, cellModel.props.bottomMargin, cellModel.props.horizontalOutterMargin));
        }];
        [self.bgImgView dc_setImageWithURLString:cellModel.props.bgImg.src];
    }
    
    
    
    // 背景色判断
    if([@"Y" isEqualToString:cellModel.props.hasBg]){
        if([@"Color" isEqualToString:cellModel.props.bgType]&& !DC_IsStrEmpty(cellModel.props.bgColor)){
            NSInteger opacity = [cellModel.props.bgColorOpacity integerValue] ?: 100;
            self.borderView.backgroundColor = [UIColor hjp_colorWithHex:cellModel.props.bgColor alpha:opacity/100.0];
            
        }else if([@"Image" isEqualToString:cellModel.props.bgType]&& [cellModel.props.bgImg isKindOfClass:[PicturesItem class]] &&   !DC_IsStrEmpty(cellModel.props.bgImg.src)){
            
            [self.contentView insertSubview:self.bgImgView atIndex:0];
            [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(cellModel.props.topMargin, cellModel.props.horizontalOutterMargin, cellModel.props.bottomMargin, cellModel.props.horizontalOutterMargin));
            }];
            [self.bgImgView dc_setImageWithURLString:cellModel.props.bgImg.src];
        }
    }
    
    self.borderViewConstraint =  [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( cellModel.props.topMargin, cellModel.props.horizontalOutterMargin, cellModel.props.bottomMargin, cellModel.props.horizontalOutterMargin));
    }];
    
    CGFloat leftPadding = cellModel.props.horizontalInnerLeftPadding?cellModel.props.horizontalInnerLeftPadding:cellModel.props.horizontalInnerPadding;
    CGFloat rightPadding = cellModel.props.horizontalInnerRightPadding?cellModel.props.horizontalInnerRightPadding:cellModel.props.horizontalInnerPadding;;
    CGFloat topPadding = cellModel.props.topPadding;
    CGFloat bottomPadding = cellModel.props.bottomPadding;
    if ([cellModel.props.hasFixedBg isEqualToString:@"Y"]) {
        PicturesItem * bgModel = cellModel.props.bgImg;
        leftPadding = leftPadding/100.0*(DC_DCP_SCREEN_WIDTH);
        rightPadding = rightPadding/100.0*(DC_DCP_SCREEN_WIDTH);
        topPadding = topPadding/100.0*(bgModel.height*(DC_DCP_SCREEN_WIDTH-cellModel.props.horizontalOutterMargin*2)/375.0);
        bottomPadding = bottomPadding/100.0*(bgModel.height*(DC_DCP_SCREEN_WIDTH-cellModel.props.horizontalOutterMargin*2)/375.0);
    }
    
    
    
    self.innerViewConstraint = [self.innerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.borderView).with.insets(UIEdgeInsetsMake( topPadding, leftPadding,bottomPadding, rightPadding));
    }];
    
    // 是否展示more 按钮
    if (cellModel.props.showMore && !DC_IsStrEmpty(cellModel.props.moreName)) {
        [self.innerImgView addSubview:self.baseBtnMore];
        [self.baseBtnMore setTitle:cellModel.props.moreName  forState:UIControlStateNormal];
        [self.baseBtnMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            if (cellModel.props.horizontalInnerPadding > 0) {
                make.trailing.mas_equalTo(-cellModel.props.horizontalInnerPadding);
            }else{
                make.trailing.mas_equalTo(-16);
            }
//            make.trailing.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        if (!DC_IsStrEmpty(cellModel.props.staticTitleFontColor)) {
            [_baseBtnMore setTitleColor:[UIColor hjp_colorWithHex:cellModel.props.staticTitleFontColor alpha:cellModel.props.staticTitleFontColorOpacity > 0 ? cellModel.props.staticTitleFontColorOpacity / 100 : 1] forState:UIControlStateNormal];
        }
        
        if ([cellModel.props.isStaticTitleFontBold isEqualToString:@"Y"]) {
            if (cellModel.props.staticTitleFontSize > 0) {
                _baseBtnMore.titleLabel.font = [UIFont boldSystemFontOfSize:cellModel.props.staticTitleFontSize];
            }
        }else{
            if (cellModel.props.staticTitleFontSize > 0) {
                _baseBtnMore.titleLabel.font = [UIFont systemFontOfSize:cellModel.props.staticTitleFontSize];
            }
        }
        
    }
    
    // 判断添加标题和baseBtnMore
    if (cellModel.props.showTitle) {
        [self.innerImgView addSubview:self.baseTitleLab];
        [self.innerImgView addSubview:self.titleIcon];
        PicturesItem * iconItem = [cellModel.props.titleIcon firstObject];
        if (iconItem.width == 0||iconItem.height == 0) {
            self.baseTitleLab.text = DC_IsStrEmpty(cellModel.props.title) ?  @"" : cellModel.props.title;
            [self.baseTitleLab sizeToFit];
            [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
//                if (cellModel.props.horizontalInnerPadding > 0) {
//                    make.leading.mas_equalTo(cellModel.props.horizontalInnerPadding);
//                }else{
//                    make.leading.mas_equalTo(0);
//                }
                make.leading.mas_equalTo(0);
            }];
        }else{
            [_titleIcon sd_setImageWithURL:[NSURL URLWithString:iconItem.src]];
            self.baseTitleLab.text = DC_IsStrEmpty(cellModel.props.title) ?  @"" : cellModel.props.title;
            [self.baseTitleLab sizeToFit];
            if ([cellModel.props.titleIconPosition isEqualToString:@"L"]) {///放在左边
                [_titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(iconItem.width);
                    make.height.mas_equalTo(iconItem.height);
//                    if (cellModel.props.horizontalInnerPadding > 0) {
//                        make.leading.mas_equalTo(cellModel.props.horizontalInnerPadding);
//                    }else{
//                        make.leading.mas_equalTo(0);
//                    }
                    make.leading.mas_equalTo(0);
                }];
                [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.leading.mas_equalTo(self.titleIcon.mas_trailing).offset(4);
                }];
            }else{
                [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
//                    if (cellModel.props.horizontalInnerPadding > 0) {
//                        make.leading.mas_equalTo(cellModel.props.horizontalInnerPadding);
//                    }else{
//                        make.leading.mas_equalTo(0);
//                    }
                    make.leading.mas_equalTo(0);
                }];
                
                [_titleIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(iconItem.width);
                    make.height.mas_equalTo(iconItem.height);
                    make.leading.mas_equalTo(self.baseTitleLab.mas_trailing).offset(4);
                }];
            }
            
        }
        
        if (!DC_IsStrEmpty(cellModel.props.titleFontColor)) {
            self.baseTitleLab.textColor = [UIColor hjp_colorWithHex:cellModel.props.titleFontColor alpha:cellModel.props.titleFontColorOpacity > 0 ? cellModel.props.titleFontColorOpacity / 100 : 1];
        }
        
        if ([cellModel.props.isTitleFontBold isEqualToString:@"Y"]) {
            if (cellModel.props.titleFontSize > 0) {
                _baseTitleLab.font = [UIFont boldSystemFontOfSize:cellModel.props.titleFontSize];
            }
        }else{
            if (cellModel.props.titleFontSize > 0) {
                _baseTitleLab.font = [UIFont systemFontOfSize:cellModel.props.titleFontSize];
            }
        }
    }
    
    CGFloat titleH = cellModel.props.showTitle || cellModel.props.showMore ? Title_H  : 0 ;
    
    self.baseContainerConstraint =  [self.baseContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.innerImgView).with.insets(UIEdgeInsetsMake(titleH, 0, 0, 0));
    }];
    
}

- (void)resetViewborder {}

- (void)moreClickAction {/*more按钮事件*/
    if (!DC_IsStrEmpty(self.cellModel.props.moreLink)) {
        DCFloorEventModel *model = [DCFloorEventModel new];
//        model.type = self.cellModel.contentModel.type;
        model.floorId = self.cellModel.contentModel.ids;
        model.linkType = self.cellModel.props.moreLinkType;
        model.link = self.cellModel.props.moreLink;
        model.name = self.cellModel.props.moreName ?: @"more";
        model.floorEventType = DCFloorEventFloor;
        [self hj_routerEventWith:model];
    }
}

- (UIView *)baseContainer {
    if (!_baseContainer) {
        _baseContainer = [UIView new];
        _baseContainer.clipsToBounds = YES;
    }
    return _baseContainer;
}

- (UILabel *)baseTitleLab {
    if (!_baseTitleLab) {
        _baseTitleLab = [[UILabel alloc]init];
       _baseTitleLab.numberOfLines = 0;
       _baseTitleLab.textAlignment = NSTextAlignmentLeft;
       _baseTitleLab.lineBreakMode = NSLineBreakByWordWrapping;
		_baseTitleLab.font = [FontManager setNormalFontSize:18];
        _baseTitleLab.textColor = DC_UIColorFromRGB(0x242424);
    }
    return _baseTitleLab;
}

- (UIButton *)baseBtnMore {
    if (!_baseBtnMore) {
        _baseBtnMore = [UIButton buttonWithType:UIButtonTypeCustom];
		_baseBtnMore.titleLabel.font = [FontManager setNormalFontSize:14];
        [_baseBtnMore setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_baseBtnMore addTarget:self action:@selector(moreClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _baseBtnMore;
}

- (UIView *)borderView {
    if (!_borderView) {
        _borderView = [UIView new];
    }
    return _borderView;
}

- (UIImageView *)innerImgView {
    if (!_innerImgView) {
        _innerImgView = [UIImageView new];
        _innerImgView.userInteractionEnabled = YES;
    }
    return _innerImgView;
}


- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
    }
    return _bgImgView;
}
@end
