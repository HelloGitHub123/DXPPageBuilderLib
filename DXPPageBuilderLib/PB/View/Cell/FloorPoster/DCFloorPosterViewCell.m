//
//  DCFloorPosterViewCell.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/21.
//  楼层

#import "DCFloorPosterViewCell.h"
#import "XHPageControl.h"
#import "EllipsePageControl.h"
#import "UIImage+pbImgSize.h"
#import "HJSDCycleScrollView.h"
#import "HJMultiCountdownPostIndicatorView.h"

#define BtnMoreWidth    100  // more 按钮宽度
#define MidIntervalSpace  10 // 控件之间的间隔
#define MidIntervalSpace_TitleAndImageView  10 // 标题和图片之间的上下高度间隔

// ****************** Model ******************
@implementation DCFloorPosterViewModel

- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    if ([componentModel.props.floorStyle isEqualToString:@"R1C1"]) {
        self.floorStyle = ComponentFloorStyle_R1C1;
    }
    if ([componentModel.props.floorStyle isEqualToString:@"R1C2"]) {
        self.floorStyle = ComponentFloorStyle_R1C2;
    }
    if ([componentModel.props.floorStyle isEqualToString:@"R1C3"]) {
        self.floorStyle = ComponentFloorStyle_R1C3;
    }
    if ([componentModel.props.floorStyle isEqualToString:@"L1R2"]) {
        self.floorStyle = ComponentFloorStyle_L1R2;
    }
    if ([componentModel.props.floorStyle isEqualToString:@"L2R1"]) {
        self.floorStyle = ComponentFloorStyle_L2R1;
    }
    if ([componentModel.props.floorStyle isEqualToString:@"INF"]) {
        self.floorStyle = ComponentFloorStyle_INF;
    }
    return self;
}

- (void)coustructCellHeight {
    if(![self checkPicturesDataVaild]) {
        self.cellHeight = 0;
        return;
    }
    [super coustructCellHeight];
  
    CGFloat height = 0;
    int elementNumber = 0; // 元素个数

    if ([self.props.floorStyle isEqualToString:@"MCCM"]) {
        __block PicturesItem *item;
        __block CGFloat height= 0 ;
        [self.props.pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj.height > height ){
                height = obj.height;
                item = obj;
            }
        }];

        self.cellHeight = (DC_DCP_SCREEN_WIDTH - 2*self.props.horizontalOutterMargin)/item.width * item.height+(30+20+10);

    }
    
    // INF 类型
    if ([self.props.floorStyle isEqualToString:@"INF"]) {
        if (!DC_IsArrEmpty(self.props.pictures)) {
            PicturesItem *picItem = [self.props.pictures objectAtIndex:0];
            CGFloat ww = picItem.width > 0  ? picItem.width : 750.0; // 下发高度
			// 计算高度
			height = ((picItem.width / 2) * picItem.height) / ww;
            // height = height +  ((DC_DCP_SCREEN_WIDTH - 2*self.props.horizontalOutterMargin) / ww  * picItem.height) ;
            // elementNumber = elementNumber + 1;
        }
		//        CGFloat pageH = 0;
		//        if (self.props.pictures.count > 1) {
		//            pageH = 32;
		//        }
        self.cellHeight  = self.cellHeight  + 20 + height + elementNumber * MidIntervalSpace  + 1;
    }
	
    // R1C1 || R1C2
    if ([self.props.floorStyle isEqualToString:@"R1C1"] || [self.props.floorStyle isEqualToString:@"R1C2"]) {
        if (!DC_IsArrEmpty(self.props.pictures)) {
            PicturesItem *picItem = [self.props.pictures objectAtIndex:0];
            CGFloat picHeight = (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin*2) / 750 * picItem.height; // 按比例计算高度
            height = height + picHeight;
            elementNumber = elementNumber + 1;
        }
        self.cellHeight  = self.cellHeight   +  height + elementNumber * MidIntervalSpace  + 1;
    }
    
    // R1C3
    if ([self.props.floorStyle isEqualToString:@"R1C3"]) {
        if (!DC_IsArrEmpty(self.props.pictures)) {
            PicturesItem *picItem = [self.props.pictures objectAtIndex:0];
            CGFloat picHeight = (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin*3) / 750 * picItem.height; // 按比例计算高度
            height = height + picHeight;
            //            elementNumber = elementNumber + 1;
        }
        self.cellHeight  = self.cellHeight   +  height + elementNumber * MidIntervalSpace  + 1;
    }
    
    // L1R2
    if ([self.props.floorStyle isEqualToString:@"L1R2"]) {
        if (!DC_IsArrEmpty(self.props.pictures)) {
            PicturesItem *picItem = [self.props.pictures objectAtIndex:0];
            CGFloat picHeight = (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin*3 ) / 750 * picItem.height; // 按比例计算高度
            height = height + picHeight;
            elementNumber = elementNumber + 1;
        }
        self.cellHeight  = self.cellHeight   +  height + elementNumber * MidIntervalSpace  + 1;
    }
    
    // L2R1
    if ([self.props.floorStyle isEqualToString:@"L2R1"]) {
        if (!DC_IsArrEmpty(self.props.pictures)) {
            PicturesItem *picItem = [self.props.pictures objectAtIndex:0];
            CGFloat picHeight = (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin*3) / 750 * picItem.height; // 按比例计算高度
            height = height + picHeight;
            //            elementNumber = elementNumber + 1;
        }
        self.cellHeight  = self.cellHeight   +  height + elementNumber * MidIntervalSpace  + 1;
    }
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCFloorPosterViewCell class]);
}

// 计算字符串高度
- (CGFloat)calculateHeightWithString:(NSString *)str width:(CGFloat)nWidth {
    if (str.length < 1) {
        return 0;
    }
    CGRect rect = [str boundingRectWithSize:CGSizeMake(nWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height + 1;
    return height;
}
@end

// ****************** Cell ******************
@interface DCFloorPosterViewCell()<XHPageControlDelegate,UIScrollViewDelegate>
// INF
@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) XHPageControl *pageControl;
@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *infWidthArr;
@property (nonatomic, strong) HJMultiCountdownPostIndicatorView *indicatorView;
@end

@implementation DCFloorPosterViewCell

- (void)bindCellModel:(DCFloorPosterViewModel *)cellModel {
    [super bindCellModel:cellModel];
    if (cellModel.cellHeight <= 0) {
        return;
    }
    
    [_pageControl removeFromSuperview];
    _pageControl = nil;
    
    // 移除子控件，防止重复添加
    [self.baseContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView removeFromSuperview];
    self.scrollView = nil;
    [self.baseContainer addSubview:self.scrollView];
    

    /* 兜底代码：PB后台未完善导致添加，后续需要移除，统一在base中进行设置 */
//    [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
//        if (cellModel.props.showMore || cellModel.props.showTitle) {
//            if(cellModel.floorStyle == ComponentFloorStyle_INF) {
//                if (cellModel.props.pictures.count > 1) {
//                    make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( 12 , cellModel.props.horizontalOutterMargin, 32, cellModel.props.horizontalOutterMargin));
//                }else {
//                    make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( 12 , cellModel.props.horizontalOutterMargin, 18, cellModel.props.horizontalOutterMargin));
//                }
//            }else {
//                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( 12 , cellModel.props.horizontalOutterMargin, 5, cellModel.props.horizontalOutterMargin));
//            }
//        }else {
//            make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( 0 , cellModel.props.horizontalOutterMargin, 18, cellModel.props.horizontalOutterMargin));
//        }
//    }];
    
    switch (cellModel.floorStyle) {

        case ComponentFloorStyle_MCCM:{
            [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( 12 , 0, 0, 0));
            }];
            //更新位置
//            if(cellModel.props.showTitle){
//                [self.baseTitleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(@0);
//                    make.leading.equalTo(@16);
//                }];
//            }
//
//            if(cellModel.props.showMore){
//                [self.baseBtnMore mas_updateConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(@0);
//                    make.trailing.equalTo(@-16);
//                    make.height.equalTo(@20);
//                }];
//
//            }

            [self ConstructsViewForMCCM:cellModel];

        }
            break;
        case ComponentFloorStyle_INF: {
            [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.trailing.bottom.equalTo(@0);
            }];
            [self ConstructsViewForINF:cellModel];
        }
            break;
        case ComponentFloorStyle_R1C1: {
            [self ConstructsViewForR1C1:cellModel];
        }
            break;
        case ComponentFloorStyle_R1C2: {
            [self ConstructsViewForR1C2:cellModel];
        }
            break;
        case ComponentFloorStyle_R1C3: {
            [self ConstructsViewForR1C3:cellModel];
        }
            break;
        case ComponentFloorStyle_L1R2: {
            [self ConstructsViewForL1R2:cellModel];
        }
            break;
        case ComponentFloorStyle_L2R1: {
            [self ConstructsViewForL2R1:cellModel];
        }
            break;
        default:
            break;
    }
}

#pragma mark - MCCM
- (void)ConstructsViewForMCCM:(DCFloorPosterViewModel *)cellModel {

    HJSDCycleScrollView *cycleScrollView = [[HJSDCycleScrollView alloc] initWithFrame:CGRectMake(-11, 0, DC_DCP_SCREEN_WIDTH-22, cellModel.cellHeight-(30+20+10))];
    cycleScrollView.isRepeat = [cellModel.props.repeat isEqualToString:@"Y"] ? YES:NO;;
    cycleScrollView.isAutomatic = [cellModel.props.Autos isEqualToString:@"Y"] ? YES:NO;;
    cycleScrollView.timeInterval = cellModel.props.speed ?cellModel.props.speed.intValue : 3;
//    self.contentView.backgroundColor =  rgba(9, 56, 164, 1);
    [self.baseContainer addSubview:cycleScrollView];
    NSMutableArray *tempArr =[NSMutableArray new];
    [cellModel.props.pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HJSDCycleModel *item = [HJSDCycleModel new];
        item.urlStr = obj.src;
        item.index = idx;
        [tempArr addObject:item];
    }];
    
    //谦容单张的来轮播
    if(tempArr.count <= 1){
        //居中
        [cycleScrollView setFrame:CGRectMake(11+12, 0, DC_DCP_SCREEN_WIDTH, cellModel.cellHeight-(30+20+10))];
        cycleScrollView.isRepeat = NO;
        cycleScrollView.isAutomatic = NO;
    }
    
    cycleScrollView.models = tempArr;
    cycleScrollView.currentIndex = 0;

    __weak typeof(self) weakSelf = self;
    if(cellModel.props.pictures.count >1){
        [self.baseContainer addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.baseContainer.mas_centerX);
            make.top.equalTo(cycleScrollView.mas_bottom).offset(5);
            make.height.mas_offset(3);
        }];
        self.indicatorView.count = cellModel.props.pictures.count;
        cycleScrollView.itemDidScrollOperationBlock = ^(NSInteger currentIndex) {
            NSLog(@"滚动-----%ld",currentIndex);
            weakSelf.indicatorView.selectIndex = currentIndex;
        };
    }

    cycleScrollView.clickItemOperationBlock = ^(NSInteger currentIndex) {
        NSLog(@"点击了-----%ld",currentIndex);
        [weakSelf clickWithIndex:currentIndex];
    };

}


#pragma mark - INF
- (void)ConstructsViewForINF:(DCFloorPosterViewModel *)cellModel {
    CGFloat iwidth = 0;
    
    // 添加PageController
    [self.infWidthArr removeAllObjects];
    
    if (cellModel.props.pictures.count > 1) {
		[self.contentView addSubview:self.pageControl];
		self.pageControl.hidden = YES;
        [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.bottom.equalTo(@-14);
            make.leading.trailing.equalTo(@0);
        }];
        self.pageControl.currentPage = 0;
        self.pageControl.numberOfPages = cellModel.props.pictures.count == 1 ? 0 : cellModel.props.pictures.count;
        self.pageControl.contentSize = CGSizeMake(DC_DCP_SCREEN_WIDTH - 2* self.cellModel.props.horizontalOutterMargin, 10);
    }
    CGFloat horizontalOutterMargin = cellModel.props.horizontalOutterMargin ;
	
	
	
	MASViewAttribute *lastAttribute = self.scrollView.mas_left;
	
    for (int i = 0; i< [cellModel.props.pictures count]; i++) {
        PicturesItem *item = [cellModel.props.pictures objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.accessibilityIdentifier = [NSString stringWithFormat:@"%@---tag%ld", item.src, (long)imgView.tag];
        imgView.tag = i;
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];

        CGFloat hVal = (DC_DCP_SCREEN_WIDTH - 2*self.cellModel.props.horizontalOutterMargin) / item.width *  item.height;
        CGFloat wVal = (DC_DCP_SCREEN_WIDTH - 2*self.cellModel.props.horizontalOutterMargin) ;


        NSURL *url = [NSURL URLWithString:[item.src stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];;
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
        [self.scrollView addSubview:imgView];
        CGFloat xVal = (i == 0) ? 0: i*(wVal) + MidIntervalSpace*i;
        iwidth = iwidth + wVal;
	
        [self.infWidthArr addObject:@(xVal)];
		// 计算高度
		CGFloat height = ((item.width / 2) * item.height) / (item.width);
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastAttribute).offset(16);
            make.top.equalTo(@0);
			make.width.equalTo(@(item.width/2));
            make.height.equalTo(@(height));
			if (i == cellModel.props.pictures.count - 1) {
				make.right.equalTo(self.scrollView.mas_right).offset(-16);
			}
        }];
		
		lastAttribute = imgView.mas_right;
		
		
    }
    //如果只想水平滚动，则可以告诉srcollview图片的高度为0,上下滚动则宽度为0
//    CGFloat twidth = iwidth + [cellModel.props.pictures count]*10;
//    self.scrollView.contentSize = CGSizeMake(twidth, 0);
    //设置滚动条样式，如白色
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
}

#pragma mark -- R1C1
- (void)ConstructsViewForR1C1:(DCFloorPosterViewModel *)cellModel {
    PicturesItem *item = [cellModel.props.pictures objectAtIndex:0];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.accessibilityIdentifier = [NSString stringWithFormat:@"%@", item.src];
    imgView.tag = 0;
    // 添加单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:tap];
    NSURL *url = [NSURL URLWithString:item.src];
    [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
    [self.baseContainer addSubview:imgView];
    CGFloat height = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2) / 750 * item.height; // 按比例计算高度
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@(0));
        make.top.mas_equalTo(0);
        make.width.equalTo(@((DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2)));
        make.height.equalTo(@(height));
    }];
}

#pragma mark -- R1C2
- (void)ConstructsViewForR1C2:(DCFloorPosterViewModel *)cellModel {
    for (int i = 0; i< [cellModel.props.pictures count]; i++) {
        PicturesItem *item = [cellModel.props.pictures objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.accessibilityIdentifier = [NSString stringWithFormat:@"%@", item.src];
        imgView.tag = i;
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];
        NSURL *url = [NSURL URLWithString:item.src];
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
        [self.baseContainer addSubview:imgView];
        CGFloat height = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2) / 750 * item.height; // 按比例计算高度
        CGFloat xVal = i * ((DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2 - MidIntervalSpace)/2  + MidIntervalSpace);
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(xVal));
            make.top.mas_equalTo(0);
            make.width.equalTo(@((DC_DCP_SCREEN_WIDTH - MidIntervalSpace - self.cellModel.props.horizontalOutterMargin*2)/2)); // 多一个图片中间的间隙值
            make.height.equalTo(@(height));
        }];
    }
}

#pragma mark -- R1C3
- (void)ConstructsViewForR1C3:(DCFloorPosterViewModel *)cellModel {
    for (int i = 0; i< [cellModel.props.pictures count]; i++) {
        PicturesItem *item = [cellModel.props.pictures objectAtIndex:i];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.accessibilityIdentifier = [NSString stringWithFormat:@"%@", item.src];
        imgView.tag = i;
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        imgView.userInteractionEnabled = YES;
        [imgView addGestureRecognizer:tap];
        NSURL *url = [NSURL URLWithString:item.src];
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
        [self.baseContainer addSubview:imgView];
        CGFloat height = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2) / 750 * item.height; // 按比例计算高度
        CGFloat xVal = i * (DC_DCP_SCREEN_WIDTH - MidIntervalSpace*3)/3 + MidIntervalSpace * (i+1);
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(xVal));
            make.top.mas_equalTo(0);
            make.width.equalTo(@((DC_DCP_SCREEN_WIDTH - MidIntervalSpace*3)/3)); // 多一个图片中间的间隙值
            make.height.equalTo(@(height));
        }];
    }
}

#pragma mark -- L1R2
- (void)ConstructsViewForL1R2:(DCFloorPosterViewModel *)cellModel {
    
    if(!DC_IsArrEmpty(cellModel.props.pictures)) {
        PicturesItem *itemOne = [cellModel.props.pictures firstObject];
        CGFloat Lheight = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2) / 750 * itemOne.height; // 按比例计算高度 左一
        CGFloat rheight = (Lheight - MidIntervalSpace) /2; // 右二个
        CGFloat iWidth = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2 - MidIntervalSpace)/2; // 图片宽度
        
        for (int i = 0; i< [cellModel.props.pictures count]; i++) {
            PicturesItem *item = [cellModel.props.pictures objectAtIndex:i];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.accessibilityIdentifier = [NSString stringWithFormat:@"%@", item.src];
            imgView.tag = i;
            // 添加单击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            NSURL *url = [NSURL URLWithString:item.src];
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
            [self.baseContainer addSubview:imgView];
            
            if (i == 0) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(0));
                    make.top.mas_equalTo(0);
                    make.width.equalTo(@(iWidth));
                    make.height.equalTo(@(Lheight));
                }];
            }
            if (i == 1) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(MidIntervalSpace + iWidth));
                    make.top.mas_equalTo(0);
                    make.width.equalTo(@(iWidth));
                    make.height.equalTo(@(rheight));
                }];
            }
            if (i == 2) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(MidIntervalSpace + iWidth));
                    make.top.equalTo(@(MidIntervalSpace + rheight));
                    make.width.equalTo(@(iWidth));
                    make.height.equalTo(@(rheight));
                }];
            }
        }
    }
}

#pragma mark -- L2R1
- (void)ConstructsViewForL2R1:(DCFloorPosterViewModel *)cellModel {

        
    if(!DC_IsArrEmpty(cellModel.props.pictures)) {
        PicturesItem *itemOne = [cellModel.props.pictures firstObject];
        CGFloat Lheight = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2) / 750 * itemOne.height; // 按比例计算高度 左一
        CGFloat rheight = (Lheight - MidIntervalSpace) /2; // 右二个
        CGFloat iWidth = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin*2 - MidIntervalSpace)/2; // 图片宽度
        
        for (int i = 0; i< [cellModel.props.pictures count]; i++) {
            PicturesItem *item = [cellModel.props.pictures objectAtIndex:i];
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.accessibilityIdentifier = [NSString stringWithFormat:@"%@", item.src];
            imgView.tag = i;
            // 添加单击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            NSURL *url = [NSURL URLWithString:item.src];
            [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
            [self.baseContainer addSubview:imgView];
            
            if (i == 0) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(MidIntervalSpace));
                    make.top.mas_equalTo(0);
                    make.width.equalTo(@(iWidth));
                    make.height.equalTo(@(rheight));
                }];
            }
            if (i == 1) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(MidIntervalSpace));
                    make.top.mas_equalTo(0);
                    make.width.equalTo(@(iWidth));
                    make.height.equalTo(@(rheight));
                }];
            }
            if (i == 2) {
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(@(MidIntervalSpace + iWidth));
                    make.top.mas_equalTo(0);
                    make.width.equalTo(@(iWidth));
                    make.height.equalTo(@(Lheight));
                }];
            }
        }
    }
}

#pragma mark -- ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.cellModel.props.pictures.count > 1) {
        CGFloat offsetX = scrollView.contentOffset.x + (DC_DCP_SCREEN_WIDTH - 32)/2;
        CGFloat currentPageX = [self.infWidthArr[self.pageControl.currentPage] doubleValue];
        if (offsetX > currentPageX    ) { // 右边
            if (self.pageControl.currentPage + 1 < self.infWidthArr.count) {
                CGFloat rightPageX = [self.infWidthArr[self.pageControl.currentPage + 1] doubleValue];
                if (offsetX > rightPageX) {
                    self.pageControl.currentPage = self.pageControl.currentPage + 1;
                }
            }
        }else {
            if (self.pageControl.currentPage>0) {
                CGFloat leftPageX = [self.infWidthArr[self.pageControl.currentPage - 1] doubleValue];
                if (leftPageX <= offsetX ) {
                    self.pageControl.currentPage = self.pageControl.currentPage - 1;
                }
            }
        }
    }
}

#pragma mark -- 方法
// more 点击跳转
- (void)moreClickAction:(id)sender {
    if (!DC_IsStrEmpty(self.cellModel.props.moreLink)) {
        if (_delegate && [_delegate conformsToProtocol:@protocol(FloorPosterViewEventDelegate)]) {
            if (_delegate && [_delegate respondsToSelector:@selector(FloorPosterMoreClickByLink:targetId:)]) {
                [_delegate FloorPosterMoreClickByLink:self.cellModel.props.moreLink targetId:self];
            }
        }
    }
}

// 图片点击事件
- (void)imageClick:(UIGestureRecognizer *)tap {
    UIImageView *imgView = (UIImageView *)tap.view;
    [self clickWithIndex:imgView.tag];
}

-(void)clickWithIndex:(NSInteger )index{
    
    PicturesItem *item = [self.cellModel.props.pictures objectAtIndex:index];

    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = item.link;
    model.linkType = item.linkType;
    if ([item.linkType isEqualToString:@"A"]) {
        model.linkType = @"1";
    }else if ([item.linkType isEqualToString:@"B"]) {
        model.linkType = @"3";
    }else if ([item.linkType isEqualToString:@"C"]) {
        model.linkType = @"4";
    }else if ([item.linkType isEqualToString:@"D"]) {
        model.linkType = @"2";
    }else if ([item.linkType isEqualToString:@"E"]) {
        model.linkType = @"1";
    }
    
    model.name = item.iconName;
    model.picIndex = index;
    model.needLogin = item.needLogin;
    model.floorId = self.cellModel.contentModel.ids;
    DCFloorPosterViewModel *cellModel = (DCFloorPosterViewModel*)self.cellModel;
    model.floorStyle = cellModel.floorStyle;
    model.floorTitle = cellModel.props.title; // 这个是标题
    model.floorEventType = cellModel.viewStyle == DCFloorPosterView_MCCM  ? DCFloorEventMCCM :DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.delegate = self;
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _scrollView;
}

//- (XHPageControl *)pageControl {
//    if (!_pageControl) {
//        _pageControl = [[XHPageControl alloc] initWithFrame:CGRectMake(0, kScreenHeight - (10 + kSafeBottom + 30), kScreenWidth, 30)];
//        _pageControl.currentPage = 0;
//        _pageControl.currentMultiple = 3;
//        _pageControl.controlSize = 8;
//        _pageControl.controlSpacing = 8;
//        _pageControl.delegate = self;
//        _pageControl.currentColor = [UIColor colorWithHexString:CE1126];
//        _pageControl.otherColor = [UIColor colorWithHexString:C7C7C7];
//    }
//    return _pageControl;
//}

- (HJMultiCountdownPostIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [HJMultiCountdownPostIndicatorView new];
        _indicatorView.defaulColer = [UIColor hjp_colorWithHex:@"#C7C7C7"];
        _indicatorView.selectColor = [UIColor hjp_colorWithHex:@"#CE1126"];
    }
    return _indicatorView;
}

- (EllipsePageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[EllipsePageControl alloc] init];
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.pagecontrlStyle = EllipsePageControlStyleLine;
        _pageControl.currentColor = [UIColor hjp_colorWithHex:@"#CE1126"];
        _pageControl.otherColor = [UIColor hjp_colorWithHex:@"#C7C7C7"];
        _pageControl.controlSpacing = 5;
        
    }
    return _pageControl;
}

- (NSMutableArray *)infWidthArr {
    if(!_infWidthArr){
        _infWidthArr = [NSMutableArray new];
    }
    return _infWidthArr;
}
@end
