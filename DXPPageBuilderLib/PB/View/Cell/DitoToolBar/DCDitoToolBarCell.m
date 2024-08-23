//
//  DCDitoToolBarCell.m
//  DITOApp
//
//  Created by 孙全民 on 2022/7/22.
//

#import "DCDitoToolBarCell.h"
// ****************** Model ******************
@implementation DCDitoToolBarCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    self.props.showMore = NO;
    self.props.showTitle = NO;
    return self;
}

- (void)coustructCellHeight {
    self.cellHeight = DCDitoToolBarViewHeight;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCDitoToolBarCell class]);
}
@end

// ****************** Cell ******************
@interface DCDitoToolBarCell()
@property (nonatomic, strong) DCDitoToolBarView *toolbarView;
@end

@implementation DCDitoToolBarCell
- (void)bindCellModel:(DCFloorBaseCellModel *)cellModel {
    [super bindCellModel:cellModel];
    
    [self.toolbarView removeFromSuperview];
    self.toolbarView = nil;
    
    [self.baseContainer addSubview:self.toolbarView];
    [self.toolbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseContainer).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self.toolbarView updateWithModel:cellModel];
}

- (DCDitoToolBarView *)toolbarView {
    if (!_toolbarView) {
        _toolbarView = [DCDitoToolBarView new];
    }
    return _toolbarView;
}
@end




// ****************** View ******************
@interface DCDitoToolBarView()
@property (nonatomic, strong) UILabel *hiLbl; //
@property (nonatomic, strong) NSMutableArray *iconArr; // 右边icon数组
@property (nonatomic, strong) CompositionProps *props;
@end

@implementation DCDitoToolBarView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.hiLbl];
    [self.hiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

- (void)updateWithModel:(DCFloorBaseCellModel *)cellModel {
    self.props = cellModel.props;
    // 设置文字
    self.hiLbl.text = cellModel.props.title;
    if (!DC_IsStrEmpty(cellModel.props.titleFontColor)) {
        self.hiLbl.textColor = [UIColor hjp_colorWithHex:cellModel.props.titleFontColor];
    }
    // 右边按钮
    [self.iconArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.iconArr removeAllObjects];
    __block CGFloat imgsTotalW = 20;
    CGFloat width = 40;
    NSDictionary *dic = cellModel.customData;
    NSString *unreadNumberStr = [dic objectForKey:@"unreadNumber"];
    NSInteger unreadNumber = DC_IsStrEmpty(unreadNumberStr) ? 0 : [unreadNumberStr integerValue];
    [cellModel.props.pictures enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *img = [[UIImageView alloc]init];
        img.tag = 1000+idx;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(iconClickAction:)];
        [img addGestureRecognizer:tap];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [img sd_setImageWithURL:[NSURL URLWithString:obj.src]];
        img.accessibilityIdentifier = [NSString stringWithFormat:@"%@", obj.src];
        [self addSubview:img];
        [self.iconArr addObject:img];
//        CGFloat width = obj.width  ? : 50;
        if (unreadNumber > 0 && [obj.link isEqualToString:@"tmapp://Message"]) {
            UIView *redDot = [UIView new];
            redDot.backgroundColor = [UIColor hjp_colorWithHex:@"#CE1126"];
            redDot.layer.cornerRadius = 5;
            [img addSubview:redDot];
            [redDot mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@10);
                make.top.equalTo(@5);
                make.trailing.equalTo(@-5);
            }];
        }
        
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@(-imgsTotalW));
            make.height.mas_equalTo(width);
            make.width.mas_equalTo(width);
            make.centerY.equalTo(self.mas_centerY);
        }];
        imgsTotalW =  imgsTotalW + width + 7;
    }];
    
    [self.hiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@(-imgsTotalW));
    }];
}

- (void)iconClickAction:(UITapGestureRecognizer*)gestureRecognizer {
    NSInteger index = gestureRecognizer.view.tag - 1000;
    PicturesItem *item = self.props.pictures[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = item.link;
    model.linkType = item.linkType;
    model.name = item.iconName;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}


// MARK: LAZY
- (UILabel *)hiLbl {
    if (!_hiLbl) {
        _hiLbl = [UILabel new];
        _hiLbl.font =  FONT_BS(18); 
        _hiLbl.textColor = [UIColor blackColor];
        _hiLbl.text = @"Hi, DITOzen!";
        _hiLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _hiLbl;
}


- (NSMutableArray *)iconArr {
    if (!_iconArr) {
        _iconArr = [NSMutableArray new];
    }
    return _iconArr;
}
@end
