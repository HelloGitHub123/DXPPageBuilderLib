//
//  DCMeetingCell.m
//  DCModuleLibs
//
//  Created by 孙全民 on 2023/1/7.
//

#import "DCMeetingCell.h"
#import "DCTopLabel.h"
#import "MJExtension.h"


// ****************** Model ******************
@implementation DCMeetingCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    
    if(!self.innerComponentDataDic) {
        self.cellHeight = 0;
        return;
    }
    self.cellHeight = self.cellHeight + 90.0/375 * DCP_SCREEN_WIDTH;

}

- (NSString *)cellClsName {
    return NSStringFromClass([DCMeetingCell class]);
}
@end

// ****************** Cell ******************
@interface DCMeetingCell()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *btnContainer; // 按钮容器(方便管理)
@property (nonatomic, strong) UIScrollView *contentScrollView; // 按钮内容
@property (nonatomic, strong) UIView *itemView1;
@property (nonatomic, strong) UIView *itemView2;
@property (nonatomic, strong) UIView *itemView3;
@property (nonatomic, strong) UIView *itemView4;
@end
@implementation DCMeetingCell


- (void)configView {
    CGFloat oneItemH = 90.0/375 * DCP_SCREEN_WIDTH;
    CGFloat oneItemW = 154.0/375 * DCP_SCREEN_WIDTH;
    CGFloat paddingH = 16.0;

   
    [self.baseContainer addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.mas_equalTo(oneItemH);
    }];
    
    // 添加按钮
   
    
    UIView *iconContentView = [UIView new];

    self.itemView1 = [self getItemView:0 tag:1 image:@"bg_sign" type:@"Check in" total:0];
    [iconContentView addSubview:self.itemView1];

    self.itemView2 = [self getItemView:0  tag:2 image:@"bg_green" type:@"Log in" total:0];
    [iconContentView addSubview:self.itemView2];

    self.itemView3 = [self getItemView:0 tag:3  image:@"bg_survey" type:@"Survey" total:0];
    [iconContentView addSubview:self.itemView3];
    
    self.itemView4 = [self getItemView:0 tag:4  image:@"bg_orange" type:@"Charge Off" total:0];
    [iconContentView addSubview:self.itemView4];
   
    CGFloat contentW = 4 * (oneItemW + paddingH) - paddingH;
    self.contentScrollView.contentSize = CGSizeMake(0, contentW);
    [self.contentScrollView addSubview:iconContentView];
    [iconContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.bottom.trailing.equalTo(@0);
        make.height.mas_equalTo(oneItemH);
        make.width.mas_equalTo(contentW);
    }];
    
    if (iconContentView.subviews.count > 1) {
        [iconContentView.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:paddingH leadSpacing:0 tailSpacing:0];
    }else {}
}

- (void)bindCellModel:(DCMeetingCellModel *)cellModel {
    [super bindCellModel:cellModel];
    if (!self.cellModel.innerComponentDataDic) return;
    [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( self.cellModel.props.topMargin?:0 , 16, 0, 16));
    }];
    
    NSInteger userTotal = [[self.cellModel.innerComponentDataDic objectForKey:@"userTotal"] integerValue]  ;
    NSInteger loginCountCurrent = [[self.cellModel.innerComponentDataDic objectForKey:@"loginCountCurrent"] integerValue] ;
    NSInteger signInCountCurrent = [[self.cellModel.innerComponentDataDic objectForKey:@"signInCountCurrent"] integerValue] ;
    NSInteger surveyCountCurrent = [[self.cellModel.innerComponentDataDic objectForKey:@"surveyCountCurrent"] integerValue] ;
    NSInteger voucherUsed = [[self.cellModel.innerComponentDataDic objectForKey:@"voucherUsed"] integerValue] ;
    
    UILabel *lbl1 = [self.itemView1 viewWithTag:1];
    lbl1.text = [NSString stringWithFormat:@"%ld",signInCountCurrent];
    UILabel *lbl11 = [self.itemView1 viewWithTag:11];
    lbl11.text = [NSString stringWithFormat:@"/%ld",userTotal];
    
    UILabel *lbl2 = [self.itemView2 viewWithTag:2];
    lbl2.text = [NSString stringWithFormat:@"%ld",loginCountCurrent];
    UILabel *lbl12 = [self.itemView2 viewWithTag:12];
    lbl12.text = [NSString stringWithFormat:@"/%ld",userTotal];
    
    UILabel *lbl3 = [self.itemView3 viewWithTag:3];
    lbl3.text = [NSString stringWithFormat:@"%ld",surveyCountCurrent];
    UILabel *lbl13 = [self.itemView3 viewWithTag:13];
    lbl13.text = [NSString stringWithFormat:@"/%ld",userTotal];
    
    UILabel *lbl4 = [self.itemView4 viewWithTag:4];
    lbl4.text = [NSString stringWithFormat:@"%ld",voucherUsed];
    UILabel *lbl14 = [self.itemView4 viewWithTag:14];
    lbl14.text = [NSString stringWithFormat:@"/%ld",userTotal];
}


- (UIView *)getItemView:(NSInteger)count tag:(NSInteger)tag image:(NSString*)img type:(NSString*)type total:(NSInteger)total {
    // 背景图片
    UIImageView *contentView = [[UIImageView alloc] init];
    contentView.image = [UIImage imageNamed:img];
    contentView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
    [contentView addGestureRecognizer:tap];

    
//    title
    UILabel *typeLbl = [UILabel new];
    typeLbl.text = type;
    typeLbl.textColor = [UIColor whiteColor];
    typeLbl.font = FONT_BS(14);
    [contentView addSubview:typeLbl];
    [typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(@18);
    }];
    
    UILabel *numLbl = [UILabel new];
    numLbl.tag = tag;
    numLbl.text = [NSString stringWithFormat:@"%ld",count];
    numLbl.textColor = [UIColor whiteColor];
    numLbl.font = [UIFont boldSystemFontOfSize:28];
    [contentView addSubview:numLbl];
    [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.top.equalTo(@40);
    }];

    UILabel *totalLbl = [UILabel new];
    totalLbl.tag = tag + 10;
    totalLbl.text = [NSString stringWithFormat:@"/%ld",total];
    totalLbl.textColor = [UIColor whiteColor];
    totalLbl.font = FONT_BS(14);
    [contentView addSubview:totalLbl];
    [totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(numLbl.mas_trailing).offset(1);
        make.centerY.equalTo(numLbl.mas_centerY).offset(3);
    }];
    
    return contentView;
}
- (void)itemClickAction:(UITapGestureRecognizer*)gestureRecognizer{
    NSInteger index = gestureRecognizer.view.tag - 1000;
    PicturesItem *item = self.cellModel.props.sheet1Pictures[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = item.link;
    model.linkType = item.linkType;
    model.name = item.iconName;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}


/// 这里是水平滚动的colletionView ,所以 使用了x
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating) || scrollView != self.contentScrollView) {
        return;
    }
    NSLog(@"-----------%lf",scrollView.contentOffset.x);
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


@end
