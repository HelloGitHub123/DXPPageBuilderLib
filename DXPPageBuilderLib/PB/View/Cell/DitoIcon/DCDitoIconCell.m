//
//  DCDitoIconCell.m
//  DITOApp
//
//  Created by 孙全民 on 2022/7/21.
//

#import "DCDitoIconCell.h"
#import "DCTopLabel.h"
#import "MJExtension.h"

CGFloat paddingH = 8;
CGFloat oneItemW = 92;


CGFloat indicatorH = 6.0;
CGFloat indicatorMarginTop = 15.0;
// ****************** Model ******************
@implementation DCDitoIconCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    // 防止崩溃
    if (!self.props.sheet1Pictures) return;
    if([self.props.sheet1Pictures isKindOfClass:[NSArray class]] && DC_IsArrEmpty(self.props.sheet1Pictures))return;
    if([self.props.sheet1Pictures isKindOfClass:[NSString class]])return;
   
    
    CGFloat oneItemH = 58.0/375 * DCP_SCREEN_WIDTH + 10 + 30;
    CGFloat contentW = self.props.sheet1Pictures.count * (oneItemW + paddingH) - paddingH;
    CGFloat indTotalH = contentW > DCP_SCREEN_WIDTH ? (indicatorH + indicatorMarginTop) : 0;
    self.cellHeight = oneItemH + indTotalH + 16 + 10; // 底部 16  顶部10
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCDitoIconCell class]);
}
@end

// ****************** Cell ******************
@interface DCDitoIconCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *btnContainer; // 按钮容器(方便管理)
@property (nonatomic, strong) UIScrollView *contentScrollView; // 按钮内容
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) UIView *indicatorBGView;
@end
@implementation DCDitoIconCell

- (void)bindCellModel:(DCDitoIconCellModel *)cellModel {
    [super bindCellModel:cellModel];
    if (!cellModel.props.sheet1Pictures) return;
    if([cellModel.props.sheet1Pictures isKindOfClass:[NSArray class]] && DC_IsArrEmpty(cellModel.props.sheet1Pictures))return;
    if([cellModel.props.sheet1Pictures isKindOfClass:[NSString class]])return;
   
    
    [_indicatorBGView removeFromSuperview];
    [_indicatorView removeFromSuperview];
    [_contentScrollView removeFromSuperview];
    _indicatorBGView = nil;
    _indicatorView = nil;
    _contentScrollView = nil;

    CGFloat oneItemH = 58.0/375 *DCP_SCREEN_WIDTH + 10 + 30;
    [self.baseContainer addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.mas_equalTo(oneItemH);
    }];
    
    // 添加按钮
    
    CGFloat contentW = cellModel.props.sheet1Pictures.count * (oneItemW + paddingH) - paddingH;
    self.contentScrollView.contentSize = CGSizeMake(0, contentW);
    UIView *iconContentView = [UIView new];
    [self.contentScrollView addSubview:iconContentView];
    [iconContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(@0);
        make.height.mas_equalTo(oneItemH);
        make.width.mas_equalTo(contentW);
    }];
    
    [cellModel.props.sheet1Pictures enumerateObjectsUsingBlock:^(PicturesItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView* itemView = [self getItemView:obj index:idx];
        itemView.accessibilityIdentifier = [NSString stringWithFormat:@"%@", obj.src];
        [iconContentView addSubview:itemView];
        if (cellModel.props.sheet1Pictures.count <= 1) {
            [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.top.bottom.equalTo(@0);
            }];
        }
    }];
    if (iconContentView.subviews.count > 1) {
        [iconContentView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [iconContentView.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
        }];
    }
    // 添加指示器
    if (contentW > DCP_SCREEN_WIDTH) {
        [self.baseContainer addSubview:self.indicatorBGView];
        [self.indicatorBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(54);
            make.height.mas_equalTo(indicatorH);
            make.centerX.equalTo(self.baseContainer.mas_centerX);
            make.top.equalTo(self.contentScrollView.mas_bottom).offset(indicatorMarginTop);
        }];
        
        [self.indicatorBGView addSubview:self.indicatorView];
        self.indicatorView.frame = CGRectMake(0, 0, 14, indicatorH);
    }
}

- (UIView *)getItemView:(PicturesItem*)item index:(NSInteger)index  {
    UIView *contentView = [[UIView alloc]init];
    contentView.tag = 1000 + index;
    contentView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
    [contentView addGestureRecognizer:tap];

    UIImageView *iconImageView = [[UIImageView alloc] init];
    [contentView addSubview:iconImageView];
    
    if([item.src isEqualToString:@"Icon_More"]) {
        iconImageView.image = [UIImage imageNamed:@"Icon_More"];
    } else{
        NSURL *url = [NSURL URLWithString:[item.src stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]?:@""];
        [iconImageView sd_setImageWithURL:url];
    }
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(58.0/375 * DCP_SCREEN_WIDTH);
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(@0);
    }];
     
    DCTopLabel *titleLabel = [[DCTopLabel alloc] init];
    NSString *iconName = [item.iconName stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    titleLabel.text = iconName;
    [contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor hjp_colorWithHex:@"#3E3E3E"];
    titleLabel.font = FONT_BS(12);
    titleLabel.verticalAlignment = DCVerticalAlignmentMiddle;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(0);
        make.top.equalTo(iconImageView.mas_bottom).offset(7);
    }];
    
    return contentView;
}

- (void)itemClickAction:(UITapGestureRecognizer*)gestureRecognizer{
    NSInteger index = gestureRecognizer.view.tag - 1000;
    PicturesItem *item = self.cellModel.props.sheet1Pictures[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = item.link;
    model.linkType = item.linkType;
    model.needLogin = item.needLogin;
    model.name = item.iconName;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat maxOffsetX = self.cellModel.props.sheet1Pictures.count * (oneItemW + paddingH) - paddingH - DCP_SCREEN_WIDTH;
    if (maxOffsetX > 0) {
        CGFloat maxX = 40.0;
        CGFloat offsetX =  scrollView.contentOffset.x;
        self.indicatorView.frame = CGRectMake(maxX *  offsetX  / maxOffsetX,0,self.indicatorView.frame.size.width,self.indicatorView.frame.size.height);

    }
}

// MARK: LAZY
- (UIView *)btnContainer {
    if (!_btnContainer) {
        _btnContainer = [UIView new];
    }
    return _btnContainer;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [UIScrollView new];
        _contentScrollView.delegate = self;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
    }
    return _contentScrollView;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.backgroundColor = [UIColor hjp_colorWithHex:@"#1801E7"];
        _indicatorView.layer.cornerRadius = 3.0;
    }
    return _indicatorView;
}

- (UIView *)indicatorBGView {
    if (!_indicatorBGView) {
        _indicatorBGView = [UIView new];
        _indicatorBGView.backgroundColor = [UIColor hjp_colorWithHex:@"#DEDFE7"];
        _indicatorBGView.layer.cornerRadius = 3.0;
        _indicatorBGView.clipsToBounds = YES;
    }
    return _indicatorBGView;
}
@end
