//
//  DCCarouselPostCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/18.
//

#import "DCCarouselPostCell.h"
#import "SDCycleScrollView.h"
#import "EllipsePageControl.h"

// ****************** Model ******************
@implementation DCCarouselPostCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    
    if(![self checkPicturesDataVaild]) {
        self.cellHeight = 0;
        return;
    }
    
    CGFloat horizontalOutterMargin = self.props.horizontalOutterMargin;
    PicturesItem *item = [self.props.pictures firstObject];
//	w= 下发w/2
//	h=  （下发w/2*下发h）/下发w
	
	CGFloat picture_h = ((item.width/2)* item.height)/ item.width;
    self.cellHeight = self.cellHeight + picture_h + 12 + 4 + 16;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCCarouselPostCell class]);
}
@end

// ****************** Cell ******************
@interface DCCarouselPostCell()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *bannarView;
@property (nonatomic, strong) EllipsePageControl *pageControl;

@end
@implementation DCCarouselPostCell

// cellModel 为改变，只调用一次。在TableView Delegate中判断了
- (void)bindCellModel:(DCCarouselPostCellModel *)cellModel {
    if(![cellModel checkPicturesDataVaild])  return;
    [super bindCellModel:cellModel];
    
    [_pageControl removeFromSuperview];
    [_bannarView removeFromSuperview];
    
    _bannarView = nil;
    _pageControl = nil;
    
    if(cellModel.props.immersive) {
        [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsZero);
        }];
    }
	
	PicturesItem *item = [cellModel.props.pictures firstObject];
	CGFloat picture_h = ((item.width/2)* item.height)/ item.width;
	
    [self.baseContainer addSubview:self.bannarView];
    [self.bannarView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.bottom.top.equalTo(@0);
		make.leading.trailing.top.equalTo(@0);
		make.height.mas_equalTo(picture_h);
    }];
    
    [self.baseContainer addSubview:self.pageControl];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.bottom.equalTo(self.baseContainer).offset(-16);
        make.centerX.equalTo(self.baseContainer.mas_centerX);
        make.width.equalTo(@200);
    }];
    
    self.pageControl.contentSize = CGSizeMake(200, 10);
    
    NSArray *items = cellModel.props.pictures;
    NSMutableArray *imags = [NSMutableArray new];
    [items enumerateObjectsUsingBlock:^(PicturesItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imags addObject:obj.src];
    }];
        
    self.bannarView.imageURLStringsGroup = imags;
    self.pageControl.numberOfPages = imags.count == 1 ? 0 : imags.count;
}

- (void)actionAtIndex:(NSInteger)index {
    PicturesItem *item = self.cellModel.props.pictures[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.type = self.cellModel.contentModel.type;
    model.link = item.link;
    model.linkType = item.linkType;
    model.name = item.iconName;
    model.needLogin = item.needLogin;
    model.picIndex = index;
    model.picCount = self.cellModel.props.pictures.count;
    model.floorId = self.cellModel.contentModel.ids;
    model.displayName = [NSString stringWithFormat:@"%@%ld",self.cellModel.contentModel.ids,self.cellModel.indexPath.row];
    [self hj_routerEventWith:model];
}


#pragma mark - Getter
- (SDCycleScrollView *)bannarView {
    if (!_bannarView) {
        __weak typeof(self) weakSelf = self;
        _bannarView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:nil];
        _bannarView.autoScrollTimeInterval = 3.0;
        _bannarView.showPageControl = NO;
        _bannarView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _bannarView.backgroundColor = [UIColor clearColor];
        _bannarView.clickItemOperationBlock = ^(NSInteger index) {
            [weakSelf actionAtIndex:index];
        };
        _bannarView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
            weakSelf.pageControl.currentPage = currentIndex;
        };
    }
    return _bannarView;
}
- (EllipsePageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[EllipsePageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pagecontrlStyle = EllipsePageControlStyleZoom;
        _pageControl.currentColor = DC_UIColorFromRGB(0xB5B5B5);
		_pageControl.otherColor = [DC_UIColorFromRGB(0xB5B5B5) colorWithAlphaComponent:0.3];
        _pageControl.controlSpacing = 5;
        
    }
    return _pageControl;
}

@end
