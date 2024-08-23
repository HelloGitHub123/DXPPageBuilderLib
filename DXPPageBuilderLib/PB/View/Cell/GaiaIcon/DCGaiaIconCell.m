//
//  DCGaiaIconCell.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/7.
//

#import "DCGaiaIconCell.h"
#import "EllipsePageControl.h"
#import "DCTopLabel.h"
#define  item_V_M  12
#import "DCDashboardView.h"


static CGFloat iconHW = 30; //每个icon宽高 对应375
static CGFloat iconTitleMidM = 10; //每个icon和文本对应间距
static CGFloat iconTitleH = 30; //每个icon底部文本高度


// ****************** Model ******************
@implementation DCGaiaIconCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

//- (void)coustructCellHeight {
//    [super coustructCellHeight];
//    self.isTab4 = [@"noTab4" isEqualToString: self.props.menuStyle];
//    NSInteger tabCount = self.isTab4 ? 4 : 8;
//    CGFloat oneRowH = iconHW / 375.0 * DCP_SCREEN_WIDTH + iconTitleMidM + iconTitleH;
//    self.pageNum =  ceil( 1.0 * self.props.sheet1Pictures.count / tabCount);
//    self.tabRows = self.isTab4 ? 1 : 2;
//    CGFloat cellH = oneRowH  * self.tabRows;
//    CGFloat pageConH = self.pageNum  > 1 ? 30 : 0;
//   
//    // 判断 是否能够滑动
//    self.cellHeight = self.cellHeight + cellH + pageConH + (self.tabRows - 1) * item_V_M + 40;
//}

- (NSString *)cellClsName {
    return NSStringFromClass([DCGaiaIconCell class]);
}
@end

// ****************** Cell ******************
@interface DCGaiaIconCell() <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DCGaiaIconCell
- (void)bindCellModel:(DCGaiaIconCellModel *)cellModel {
    [super bindCellModel:cellModel];
    DCGaiaIconCellModel *model = (DCGaiaIconCellModel*)cellModel;
    NSArray *items = (NSArray*)cellModel.customData;
    [_pageControl removeFromSuperview];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _pageControl = nil;
    
    if(DC_IsArrEmpty(items)){return;}
    CGFloat pageHM = 16;
//    [self.baseContainer mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.borderView).with.insets(UIEdgeInsetsMake( 20, pageHM, 20, pageHM));
//    }];
//    
    
    // 行数
    int tabRow =   items.count > 4 ? 2 : 1;
    // 页数
    int pageNum = ceil( 1.0 * items.count / 8);
    // 每页个数
    int tabCount = 8;
    
    [self.baseContainer addSubview:self.scrollView];
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
    if (model.pageNum > 1) {
        [self.baseContainer addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.bottom.equalTo(@-5);
            make.leading.trailing.equalTo(@0);
        }];
        self.pageControl.contentSize = CGSizeMake(DCP_SCREEN_WIDTH, 10);
        self.pageControl.numberOfPages = model.pageNum ;
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
    if (scrollView.contentOffset.x  == 0 ) {
        self.pageControl.currentPage = 0;
    }else if(scrollView.contentOffset.x  == width){
        self.pageControl.currentPage = 1;
    }
    //用户滚动的才处理
    //获取categoryView下面一点的所有布局信息，用于知道，当前最上方是显示的哪个section
    //使 第一个cell便宜到距离屏幕边界20的时候选中对应的标题=
    NSLog(@"--------%f,--------%f,",scrollView.contentOffset.x,scrollView.contentOffset.y);
//    CGRect leftRect;
//    leftRect = CGRectMake(scrollView.contentOffset.x + edge + 1, 0, 1, 100);
//    UICollectionViewLayoutAttributes *topAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:leftRect].lastObject;
//    ///目前滚动到的分区
//    NSUInteger currentSection = topAttributes.indexPath.section;
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
        _pageControl.otherColor = [UIColor hjp_colorWithHex:@"#2A2F38"];
        _pageControl.controlSpacing = 5;
        
    }
    return _pageControl;
}
@end
