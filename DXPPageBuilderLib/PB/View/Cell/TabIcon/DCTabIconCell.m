//
//  DCTabIconCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/20.
//

#import "DCTabIconCell.h"
#import "DCTabIconItemCell.h"
#import "DCTabIconCollectionFlowLayout.h"
#import "EllipsePageControl.h"

// ****************** Model ******************
@implementation DCTabIconCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    self.selectIndex = 0;
    return self;
}

- (void)coustructCellHeight {
    self.cellHeight = 246+PAGE_TOP_M + 30 +53;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCTabIconCell class]);
}
@end



// ****************** Cell ******************
@interface DCTabIconCell() <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) UICollectionView *collectionView2;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *items2;
@property (nonatomic, strong) EllipsePageControl *pageControl1;
@property (nonatomic, strong) EllipsePageControl *pageControl2;

// 按钮
@property (nonatomic, strong) UIButton *tab1;
@property (nonatomic, strong) UIButton *tab2;
// 指示标
@property (nonatomic, strong) UIView *tag1;
@property (nonatomic, strong) UIView *tag2;
@end

@implementation DCTabIconCell
- (void)bindCellModel:(DCTabIconCellModel *)cellModel {
    [super bindCellModel:cellModel];
    [_tab1 removeFromSuperview];
    [_tab2 removeFromSuperview];
    [_tag1 removeFromSuperview];
    [_tag2 removeFromSuperview];
    [_pageControl1 removeFromSuperview];
    [_collectionView1 removeFromSuperview];
    _collectionView1 = nil;
    _pageControl1 = nil;
    [_pageControl2 removeFromSuperview];
    [_collectionView2 removeFromSuperview];
    _collectionView2 = nil;
    _pageControl2 = nil;
    _tab1 = nil;
    _tab2 = nil;
    _tag2 = nil;
    _tag1 = nil;
    

    // 添加tab
    [self.baseContainer addSubview:self.tab1];
    [self.baseContainer addSubview:self.tab2];
    [_tab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.leading.equalTo(@100);
    }];
    [_tab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.trailing.equalTo(@-100);
    }];
    
    
    // 添加tag
    [self.baseContainer addSubview:self.tag1];
    [self.baseContainer addSubview:self.tag2];
    [_tag1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(@20);
        make.height.equalTo(@4);
        make.centerX.equalTo(self.tab1.mas_centerX);
        
    }];
    [_tag2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(@20);
        make.height.equalTo(@4);
        make.centerX.equalTo(self.tab2.mas_centerX);
    }];
    
    
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSMutableArray *arr2 = [[NSMutableArray alloc]init];
    for (int i = 0; i< 16; i++) {
        [arr addObject:cellModel.props.sheet1Pictures[i%8]];
        int k = 15 - i;
        [arr2 addObject:cellModel.props.sheet1Pictures[k%8]];
    }

    self.items = arr;
    self.items2 = arr2;
    
    [self.baseContainer addSubview:self.collectionView1];
    [self.collectionView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(@53);
        make.height.equalTo(@246);
    }];
    [self.collectionView1 reloadData];
    
    [self.baseContainer addSubview:self.pageControl1];
    [self.pageControl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.bottom.equalTo(@-5);
        make.leading.trailing.equalTo(@0);
    }];
    self.pageControl1.contentSize = CGSizeMake(DCP_SCREEN_WIDTH, 10);
    self.pageControl1.numberOfPages = 2;

}


#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    DCTabIconCellModel *cellModel =  (DCTabIconCellModel*) self.cellModel;
    return cellModel.selectIndex == 0 ? self.items.count : self.items2.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCTabIconItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    NSDictionary *item  = [self.items hn_safeObjectAtIndex:indexPath.row];
//    CGFloat imageHeight = HNFADAPT_V([[config objectForKey:@"imageHeight"] floatValue]);
//    CGFloat imageWidth  = HNFADAPT_V([[config objectForKey:@"imageWidth"] floatValue]);
//    NSString *fontWeight = [config objectForKey:@"fontWeight"];
//    NSString *color     = [config objectForKey:@"color"];
//    NSInteger line      = [[config objectForKey:@"textLines"] integerValue];
//    CGFloat fontSize    = HNFADAPT_V([[config objectForKey:@"fontSize"] floatValue]);
//    CGFloat lineHeight  = HNFADAPT_V([[config objectForKey:@"lineHeight"] floatValue]);

    DCTabIconCellModel *cellModel =  (DCTabIconCellModel*) self.cellModel;
    if (cellModel.selectIndex == 0) {
        [cell setItem:[self.items objectAtIndex:indexPath.row]];
    }else{
        [cell setItem:[self.items2 objectAtIndex:indexPath.row]];
    }
//    [cell setItem:item imageSize:CGSizeMake(imageWidth, imageHeight) textColor:color textLine:line fontSize:fontSize fontWeight:fontWeight titleHeight:_labelHeight lineHeight:lineHeight];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *item = [self.items hn_safeObjectAtIndex:indexPath.row];
//    NSDictionary *userInfo = [item objectForKey:@"linkConfig"];
//    [self hn_routerEventWithName:HNFloorRouteEvent userInfo:userInfo];
}

/// 这里是水平滚动的colletionView ,所以 使用了x
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!(scrollView.isTracking || scrollView.isDecelerating) || scrollView != self.collectionView1) {
        //不是用户滚动的，比如setContentOffset等方法，引起的滚动不需要处理。
        return;
    }
    
    CGFloat width = DCP_SCREEN_WIDTH - 2 * PAGE_H_M;
    if (scrollView.contentOffset.x  == 0 ) {
        self.pageControl1.currentPage = 0;
    }else if(scrollView.contentOffset.x  == width){
        self.pageControl1.currentPage = 1;
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

#pragma mark - Event
- (void)tabClickAction:(UIButton *)btn {
    if (btn.selected) return;
    DCTabIconCellModel *cellModel =  (DCTabIconCellModel*) self.cellModel;
    cellModel.selectIndex = btn.tag == 1 ? 0 : 1;
    self.tag1.hidden = btn.tag != 1;
    self.tag2.hidden = btn.tag != 2;
    self.tab1.selected = btn.tag == 1;
    self.tab2.selected = btn.tag == 2;
    self.tab1.titleLabel.font =  btn.tag == 1? FONT_BS(16) : FONT_S(16);
    self.tab2.titleLabel.font =  btn.tag == 1?  FONT_S(16) : FONT_BS(16);
    [self.collectionView1 reloadData];
    self.pageControl1.currentPage = 0;
}


#pragma mark - Getter
- (UICollectionView *)collectionView1 {
    if (!_collectionView1) {
        CGFloat width = (DCP_SCREEN_WIDTH - 2*PAGE_H_M)/4;
        NSUInteger rowCount = 2;
        if ([self.cellModel.props.menuStyle rangeOfString:@"4"].location >= 0) {
            rowCount = 1;
        }
        
        DCTabIconCollectionFlowLayout *layout = [[DCTabIconCollectionFlowLayout alloc]init];
        layout.itemCountPerRow = 4; // 每行几个item
        layout.rowCount = 2; // 一页显示几行
        layout.itemSize = CGSizeMake(width, 122);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionFootersPinToVisibleBounds = NO;
        layout.sectionHeadersPinToVisibleBounds = NO;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView1.dataSource = self;
        _collectionView1.delegate = self;
        _collectionView1.backgroundColor = [UIColor clearColor];
        _collectionView1.showsHorizontalScrollIndicator = NO;
        _collectionView1.pagingEnabled = YES;
        _collectionView1.clipsToBounds = NO;
        [_collectionView1 registerClass:[DCTabIconItemCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView1;
}

- (NSArray *)items {
    if (!_items) {
        _items = [NSArray new];
    }
    return _items;
}
- (EllipsePageControl *)pageControl1 {
    if (!_pageControl1) {
        _pageControl1 = [[EllipsePageControl alloc] init];
        _pageControl1.backgroundColor = [UIColor clearColor];
        _pageControl1.pagecontrlStyle = EllipsePageControlStyleLine;
        _pageControl1.currentColor = [UIColor redColor];
        _pageControl1.otherColor = [UIColor hjp_colorWithHex:@"#2A2F38"];
        _pageControl1.controlSpacing = 5;
        
    }
    return _pageControl1;
}

- (UIButton *)tab1{
    if (!_tab1) {
        _tab1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tab1.titleLabel.font = FONT_BS(16);
        _tab1.tag = 1;
        [_tab1 setTitle:@"Hot" forState:UIControlStateNormal];
        [_tab1 setTitleColor:[UIColor hjp_colorWithHex:@"#545454"] forState:UIControlStateNormal];
        [_tab1 setTitleColor:[UIColor hjp_colorWithHex:@"#E20020"] forState:UIControlStateSelected];
        _tab1.selected = YES;
        [_tab1 addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tab1;
}
- (UIButton *)tab2{
    if (!_tab2) {
        _tab2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _tab2.titleLabel.font = FONT_S(16);
        _tab2.tag = 2;
        [_tab2 setTitle:@"Life Service" forState:UIControlStateNormal];
        [_tab2 setTitleColor:[UIColor hjp_colorWithHex:@"#545454"]forState:UIControlStateNormal];
        [_tab2 setTitleColor:[UIColor hjp_colorWithHex:@"#E20020"]forState:UIControlStateSelected];
        [_tab2 addTarget:self action:@selector(tabClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tab2;
}

- (UIView *)tag1 {
    if (!_tag1) {
        _tag1 = [[UIView alloc]init];
        _tag1.backgroundColor = [UIColor hjp_colorWithHex:@"#E20020"];
        _tag1.layer.cornerRadius = 2;
        _tag1.clipsToBounds = YES;
    }
    return _tag1;
}

- (UIView *)tag2 {
    if (!_tag2) {
        _tag2 = [[UIView alloc]init];
        _tag2.backgroundColor =  [UIColor hjp_colorWithHex:@"#E20020"];
        _tag2.layer.cornerRadius = 2;
        _tab2.clipsToBounds = YES;
        _tag2.hidden = YES;
    }
    return _tag2;
}
@end
