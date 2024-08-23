//
//  DCIconCell.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/7.
//

#import "DCIconCell.h"
#import "EllipsePageControl.h"
#import "DCTopLabel.h"
#import "DCDashboardView.h"
#import <DXPManagerLib/HJTokenManager.h>

#define  item_V_M  12

static CGFloat iconHW = 30; //每个icon宽高 对应375
static CGFloat iconTitleMidM = 10; //每个icon和文本对应间距
static CGFloat iconTitleH = 24; //每个icon底部文本高度
static CGFloat marginBottom = 8;
static CGFloat iconTopH = 12;

// ****************** Model ******************
@implementation DCIconCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    self.isTab4 = [@"noTab4" isEqualToString: self.props.menuStyle];
    NSInteger tabCount = self.isTab4 ? 4 : 8;
    PicturesItem *item = [self.props.sheet1Pictures firstObject];
    CGFloat oneRowH = item.height/2 + iconTitleMidM + iconTitleH + iconTopH;
    self.pageNum =  ceil( 1.0 * self.props.sheet1Pictures.count / tabCount);
    self.tabRows = self.isTab4 ? 1 : 2;
    CGFloat cellH = oneRowH  * self.tabRows;
    CGFloat pageConH = self.pageNum  > 1 ? 30 : 0;
    // 判断 是否能够滑动
    self.cellHeight = self.cellHeight + cellH + pageConH + (self.tabRows - 1) * item_V_M  + marginBottom;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCIconCell class]);
}
@end

// ****************** Cell ******************
@interface DCIconCell() <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DCIconCell
- (void)bindCellModel:(DCIconCellModel *)cellModel {
    [super bindCellModel:cellModel];
    NSArray *items = (NSArray*)cellModel.props.sheet1Pictures;
    [_pageControl removeFromSuperview];
    [_scrollView removeFromSuperview];
    _scrollView = nil;
    _pageControl = nil;
    
    if(DC_IsArrEmpty(items)){return;}
    [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(-marginBottom));
    }];
    // 每页个数
    NSInteger tabCount = cellModel.isTab4 ? 4 : 8;
    
    // 行数
    NSInteger tabRow =  cellModel.tabRows;
    // 页数
    NSInteger pageNum = cellModel.pageNum;
    
    [self.baseContainer addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(@0);
        make.height.equalTo( @(tabRow *123));
    }];
    
    CGFloat onePageW = DCP_SCREEN_WIDTH - 2*self.cellModel.props.horizontalOutterMargin;
    CGFloat oneRowH = 48 + 10 + 30;
    self.scrollView.contentSize = CGSizeMake( onePageW *pageNum, tabRow *  oneRowH);
    CGFloat w = (DCP_SCREEN_WIDTH - 2*self.cellModel.props.horizontalOutterMargin)/4;
     
	__block NSString *iconName = @"";
    [items enumerateObjectsUsingBlock:^(PicturesItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
		
		iconName = [iconName stringByAppendingFormat:@"/%@",obj.iconName];
		
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
        
//        // 埋点
//        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//        [dict setValue:[HJGlobalDataManager shareInstance].currentInfoModel.currentRole forKey:@"userProfile"];
//        [dict setValue:[HJGlobalDataManager shareInstance].currentInfoModel.userInfo.mobile forKey:@"mobile"];
//        [dict setValue:[HJGlobalDataManager shareInstance].currentInfoModel.userInfo.email forKey:@"email"];
//        [dict setValue:NSUSER_DEF(@"DCpageCode") forKey:@"pageCode"];
//        [dict setValue: obj.iconName forKey:@"menuName"];
//        [dict setValue:@(idx+1) forKey:@"$element_position"];
//        [dict setValue:self.cellModel.props.floorName forKey:@"$element_name"];
//        [dict setValue: obj.link forKey:@"jumpLink"];
//
//        
//        [[GoogleAnalyticsManagement sharedInstance] logEventWithName:@"TopMenuExposure" withProperties:dict];
//        [[SensorsManagement sharedInstance] trackWithName:@"TopMenuExposure" withProperties:dict];
    }];
    
    // 判断是否有pageControl
    if (pageNum > 1) {
        [self.baseContainer addSubview:self.pageControl];
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.bottom.equalTo(@-5);
            make.centerX.equalTo(self.baseContainer.mas_centerX);
            make.width.equalTo(@200);
        }];
        self.pageControl.contentSize = CGSizeMake(200, 10);
        self.pageControl.numberOfPages = pageNum;
    }
}

- (void)itemClickAction:(UITapGestureRecognizer*)gestureRecognizer{
    NSArray *items = (NSArray*)self.cellModel.props.sheet1Pictures;
    NSInteger index = gestureRecognizer.view.tag - 1000;
    PicturesItem *item = items[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.needLogin = self.cellModel.contentModel.props.needLogin;
    model.linkType = item.linkType;
    model.link = item.link;
    model.name = item.iconName;
	model.floorTitle = item.iconName;
//    model.floorEventType = item.isAll ? DCFloorEventCustome: DCFloorEventFloor;
    [self hj_routerEventWith:model];
    
    // 埋点
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:[HJGlobalDataManager shareInstance].currentInfoModel.currentRole forKey:@"userProfile"];
//    [dict setValue:[HJGlobalDataManager shareInstance].currentInfoModel.userInfo.mobile forKey:@"mobile"];
//    [dict setValue:[HJGlobalDataManager shareInstance].currentInfoModel.userInfo.email forKey:@"email"];
//    [dict setValue:NSUSER_DEF(@"DCpageCode") forKey:@"pageCode"];
//    [dict setValue: item.iconName forKey:@"menuName"];
//    [dict setValue: item.link forKey:@"jumpLink"];
//    [dict setValue:@(index+1) forKey:@"$element_position"];
//    [dict setValue:self.cellModel.props.floorName forKey:@"$element_name"];
//    [[GoogleAnalyticsManagement sharedInstance] logEventWithName:@"TopMenuclick" withProperties:dict];
//    [[SensorsManagement sharedInstance] trackWithName:@"TopMenuclick" withProperties:dict];
}

#pragma mark -
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSLog(@"offsetX===%.f",scrollView.contentOffset.x);
	CGFloat width = DCP_SCREEN_WIDTH - 2 * self.cellModel.props.horizontalOutterMargin;
	
	NSLog(@"asasdf:%f",DCP_SCREEN_WIDTH);
	
	NSInteger index = scrollView.contentOffset.x / width;
	self.pageControl.currentPage = index;
}

/// 这里是水平滚动的colletionView ,所以 使用了x
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating) || scrollView != self.scrollView) {
        //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
        return;
    }
    CGFloat width = DCP_SCREEN_WIDTH - 2 * self.cellModel.props.horizontalOutterMargin;
	
	NSInteger index = scrollView.contentOffset.x / width;
	NSLog(@"index:%ld",(long)index);
//	self.pageControl.currentPage = index;
	
//    if (scrollView.contentOffset.x  == 0 ) {
//        self.pageControl.currentPage = 0;
//    }else if(scrollView.contentOffset.x  > width){
//        self.pageControl.currentPage = 1;
//    }
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

- (UIView *)getItemView:(PicturesItem*)item index:(NSInteger)index  {
    UIView *contentView = [[UIView alloc]init];
    contentView.tag = 1000 + index;
    contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
    [contentView addGestureRecognizer:tap];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    [contentView addSubview:iconImageView];
    
   
    NSURL *url = [NSURL URLWithString:[item.src stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]?:@""];
    [iconImageView sd_setImageWithURL:url];

    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(item.width/2));
        make.centerX.equalTo(contentView.mas_centerX);
        make.top.equalTo(@(iconTopH));
    }];
    
	
	CGFloat w = (DCP_SCREEN_WIDTH - 2*self.cellModel.props.horizontalOutterMargin)/4;
	
    DCTopLabel *titleLabel = [[DCTopLabel alloc] init];
    titleLabel.text = item.iconName;
    [contentView addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor hjp_colorWithHex:@"#2A2F38"];
    titleLabel.font = FONT_S(12);
    titleLabel.verticalAlignment = DCVerticalAlignmentMiddle;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.width.equalTo(@(w));
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
        _pageControl.backgroundColor = [UIColor whiteColor];
        _pageControl.pagecontrlStyle = EllipsePageControlStyleLine;
        _pageControl.currentColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-global-color-primary"];
        _pageControl.otherColor =  [UIColor hjp_colorWithHex:@"#aaaaaa"];
        _pageControl.controlSpacing = 5;
        
    }
    return _pageControl;
}
@end
