//
//  DCFloorBaseCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/17.
//

#import "DCFloorBaseCell.h"


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
    self.cellHeight = titleH + topMargin;
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

// 组件背景图
@property (nonatomic, strong) UIImageView *bgImgView;
@end

@implementation DCFloorBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.borderView];
        [self.borderView addSubview:self.baseContainer];
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
    self.borderViewConstraint = nil;
    self.baseContainerConstraint = nil;
    
    
    // 公共按钮部分
    [_baseTitleLab removeFromSuperview];
    [_baseBtnMore removeFromSuperview];
    _baseTitleLab = nil;
    _baseBtnMore = nil;
   
   
    // 背景图
    [self.bgImgView removeFromSuperview];
    self.bgImgView = nil;
    
    if (cellModel.cellHeight <= 0) {
        return;
    }
    
    
    if ([@"Y" isEqualToString:cellModel.props.hasBackground] && !DC_IsStrEmpty(cellModel.props.bgImg.src)) {
        [self.contentView insertSubview:self.bgImgView atIndex:0];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.props.bgImg.src]];
    }
    
    /* 很无奈，接口返回了两种情况颜色背景的设置。 沟通无果， 希望后续能够删除这块逻辑*/
    if ([@"Color" isEqualToString:cellModel.props.backgroundType] && !DC_IsStrEmpty(cellModel.props.componentBgColor)) {
        self.contentView.backgroundColor = [UIColor hjp_colorWithHex:cellModel.props.componentBgColor];
    }else if([@"Image" isEqualToString:cellModel.props.backgroundType] && [cellModel.props.bgImg isKindOfClass:[PicturesItem class]] &&   !DC_IsStrEmpty(cellModel.props.bgImg.src)){
        [self.contentView insertSubview:self.bgImgView atIndex:0];
        [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.props.bgImg.src]];
    }
    
    
    
    // 背景色判断
    if([@"Y" isEqualToString:cellModel.props.hasBg]){
        if([@"Color" isEqualToString:cellModel.props.bgType]&& !DC_IsStrEmpty(cellModel.props.bgColor)){
            NSInteger opacity = [cellModel.props.bgColorOpacity integerValue] ?: 100;
            self.borderView.backgroundColor = [UIColor hjp_colorWithHex:cellModel.props.bgColor alpha:opacity/100.0];
            
        }else if([@"Image" isEqualToString:cellModel.props.bgType]&& [cellModel.props.bgImg isKindOfClass:[PicturesItem class]] &&   !DC_IsStrEmpty(cellModel.props.bgImg.src)){
            
            [self.contentView insertSubview:self.bgImgView atIndex:0];
            [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
            }];
            [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.props.bgImg.src]];
        }
    }

    self.borderViewConstraint =  [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( cellModel.props.topMargin, cellModel.props.horizontalOutterMargin, 0, cellModel.props.horizontalOutterMargin));
    }];
    
    // 是否展示more 按钮
    if (cellModel.props.showMore && !DC_IsStrEmpty(cellModel.props.moreName)) {
        [self.borderView addSubview:self.baseBtnMore];
        [self.baseBtnMore setTitle:cellModel.props.moreName  forState:UIControlStateNormal];
        [self.baseBtnMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.equalTo(@0);
            make.height.equalTo(@20);
        }];
        
        if (!DC_IsStrEmpty(cellModel.props.staticTitleFontColor)) {
            [_baseBtnMore setTitleColor:[UIColor hjp_colorWithHex:cellModel.props.staticTitleFontColor alpha:cellModel.props.staticTitleFontColorOpacity > 0 ? cellModel.props.staticTitleFontColorOpacity / 100 : 1] forState:UIControlStateNormal];
        }
        
        if (cellModel.props.staticTitleFontSize > 0) {
            _baseBtnMore.titleLabel.font = FONT_S(cellModel.props.staticTitleFontSize);
        }
    }
    
    // 判断添加标题和baseBtnMore
    if (cellModel.props.showTitle) {
        [self.borderView addSubview:self.baseTitleLab];
        self.baseTitleLab.text = DC_IsStrEmpty(cellModel.props.title) ?  @"" : cellModel.props.title;
        [self.baseTitleLab sizeToFit];
        [self.baseTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(@0);
        }];
        
        if (!DC_IsStrEmpty(cellModel.props.titleFontColor)) {
            self.baseTitleLab.textColor = [UIColor hjp_colorWithHex:cellModel.props.titleFontColor alpha:cellModel.props.titleFontColorOpacity > 0 ? cellModel.props.titleFontColorOpacity / 100 : 1];
        }
        
        if (cellModel.props.titleFontSize > 0) {
            _baseTitleLab.font =  FONT_S(cellModel.props.titleFontSize);
        }
    }
    
    CGFloat titleH = cellModel.props.showTitle || cellModel.props.showMore ? Title_H  : 0 ;
    self.baseContainerConstraint =  [self.baseContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.borderView).with.insets(UIEdgeInsetsMake(titleH, 0, 0, 0));
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
        _baseTitleLab.font = FONT_S(18);
        _baseTitleLab.textColor = DC_UIColorFromRGB(0x242424);
    }
    return _baseTitleLab;
}

- (UIButton *)baseBtnMore {
    if (!_baseBtnMore) {
        _baseBtnMore = [UIButton buttonWithType:UIButtonTypeCustom];
        _baseBtnMore.titleLabel.font = FONT_S(14);
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

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
    }
    return _bgImgView;
}
@end
