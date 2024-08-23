//
//  DCDashboardView.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/7.
//

#import "DCDashboardView.h"
#import "EllipsePageControl.h"
#import "DCTopLabel.h"
#import "DCPBMenuItemModel.h"

@implementation DCDashboardViewModel

@end

@interface DCDashboardView()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DCDashboardView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [_pageControl removeFromSuperview];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _pageControl = nil;
    [self addSubview:self.scrollView];
}

// 数据源赋值，子类实现
- (void)setupComponent:(DCFloorBaseCellModel *)cellModel {
    [super setupComponent:cellModel];
    NSArray *items = (NSArray*)cellModel.customData;
    // 行数
    int tabRow =   items.count > 4 ? 2 : 1;
    // 页数
    int pageNum = ceil( 1.0 * items.count / 8);
    // 每页个数
    int tabCount = 8;
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo( @(tabRow *123));
    }];
    
    CGFloat onePageW = DCP_SCREEN_WIDTH - 2*PAGE_H_M;
    CGFloat oneRowH = 56 / 375.0 * DCP_SCREEN_WIDTH + 10 + 30;
    self.scrollView.contentSize = CGSizeMake( onePageW *pageNum, tabRow *  oneRowH);
    CGFloat w = (DCP_SCREEN_WIDTH - 2*PAGE_H_M)/4;
    [items enumerateObjectsUsingBlock:^(DCDashboardViewModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView* itemView = [self getItemView:obj index:idx];
        [self.scrollView addSubview:itemView];
        
        NSInteger page = idx / tabCount; // 第几页
        NSInteger col = idx%4; // 第几列
        NSInteger row = (idx - (page *  tabCount))/ 4; // 每页的第几行
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(w));
            make.height.equalTo(@(oneRowH));
            make.leading.equalTo(@(col *w +page * onePageW));
            make.top.equalTo(@(row *oneRowH));
        }];
    }];
    
    // 判断是否有pageControl
    if (pageNum > 1) {
        [self addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.bottom.equalTo(@-5);
            make.leading.trailing.equalTo(@0);
        }];
        self.pageControl.contentSize = CGSizeMake(DCP_SCREEN_WIDTH, 10);
        self.pageControl.numberOfPages = pageNum;
    }
}

- (void)itemClickAction:(UITapGestureRecognizer*)gestureRecognizer{
    NSArray *items = (NSArray*)self.cellModel.customData;
    NSInteger index = gestureRecognizer.view.tag - 1000;
    DCDashboardViewModel *item = items[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.linkType = item.linkType;
    model.link = item.link;
    model.name = item.title;
    model.floorEventType = item.isAll ? DCFloorEventCustome: DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

#pragma mark -
/// 这里是水平滚动的colletionView ,所以 使用了x
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating) || scrollView != self.scrollView) {
        //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
        return;
    }
    CGFloat width = DCP_SCREEN_WIDTH - 2 * PAGE_H_M;
    
    int index = scrollView.contentOffset.x / width;
    self.pageControl.currentPage = index;
}


- (UIView *)getItemView:(DCDashboardViewModel*)item index:(NSInteger)index  {
    UIView *contentView = [[UIView alloc]init];
    contentView.tag = 1000 + index;
    contentView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
    [contentView addGestureRecognizer:tap];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [contentView addSubview:iconImageView];
    
    if (item.isAll) {
        iconImageView.image = [UIImage imageNamed:@"icon_color_all"];
    }else {
        NSURL *url = [NSURL URLWithString:[item.iconUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]?:@""];
        [iconImageView sd_setImageWithURL:url];
    }
   
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(56/375.0 * DCP_SCREEN_WIDTH));
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(@12);
    }];
    
    DCTopLabel *titleLabel = [[DCTopLabel alloc] init];
    titleLabel.text = item.title;
    [contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor hjp_colorWithHex:@"#2A2F38"];
    titleLabel.font = FONT_S(12);
    titleLabel.verticalAlignment = DCVerticalAlignmentMiddle;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@74);
        make.top.equalTo(iconImageView.mas_bottom).offset(6);
    }];
    
    return contentView;
}



#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (NSArray *)items {
    if (!_items) {
        _items = [NSArray new];
    }
    return _items;
}

- (EllipsePageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[EllipsePageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pagecontrlStyle = EllipsePageControlStyleLine;
        _pageControl.currentColor = [UIColor redColor];
        _pageControl.otherColor =  [UIColor hjp_colorWithHex:@"#2A2F38"];
        _pageControl.controlSpacing = 5;
        
    }
    return _pageControl;
}
@end
