//
//  DCDitoVideoCell.m
//  DITOApp
//
//  Created by 孙全民 on 2023/4/6.
//

#import <UIKit/UIKit.h>

CGFloat DCDitoVideoCell_indicatorH = 6.0;
CGFloat DCDitoVideoCell_IndicatorMarginTop = 15.0;
NSInteger DCDitoVideoCell_Video_Detail_tag = 9999;
//NSInteger DCDitoVideoCell_LearnMore_tag = 880;
#import "DCDitoVideoCell.h"
#import "EllipsePageControl.h"
#import "HJMultiCountdownPostIndicatorView.h"
#import "DCFloorBaseVC.h"
// ****************** Model ******************
@implementation DCDitoVideoCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
   
    CGFloat videoTopMargin = 12;
    CGFloat videmoBottom = 16;
    CGFloat height = 0;
    
    
    // 描述信息高度
    if(!DC_IsStrEmpty(self.contentModel.props.desc)){
        CGSize maxSize = CGSizeMake(DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin , MAXFLOAT);
        NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
        titleParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        height = [self.contentModel.props.desc boundingRectWithSize:maxSize
                                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                                    attributes:@{NSFontAttributeName: FONT_BS(14) ,
                                                                                      NSParagraphStyleAttributeName: titleParagraphStyle}
                                                                            context:nil].size.height;
    }
   
    // 看看到底是几个视频
    if([@"single" isEqualToString:self.contentModel.props.floorStyle]) { //
        // 单视频
        if (!DC_IsArrEmpty(self.props.pictures)) {
            height = height  +  (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin * 2)  / self.contentModel.props.adRatio ;
        }
        self.cellHeight  = self.cellHeight  + videoTopMargin + height + videmoBottom;
    }else if([@"double" isEqualToString:self.contentModel.props.floorStyle] ){
        if (!DC_IsArrEmpty(self.props.pictures)) {
            height = height  +  (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin * 2 - 10) / 2  / self.contentModel.props.adRatio ;
        }
        self.cellHeight  = self.cellHeight  + videoTopMargin + height + videmoBottom;
    }else if([@"multi" isEqualToString:self.contentModel.props.floorStyle] ){
  
        if (!DC_IsArrEmpty(self.props.pictures)) {
            height = height  +  (DC_DCP_SCREEN_WIDTH - self.props.horizontalOutterMargin * 2 - 10) / 2.3  / self.contentModel.props.adRatio ;
        }
        CGFloat indicatorH = 26;
        self.cellHeight  = self.cellHeight  + videoTopMargin + height + videmoBottom + indicatorH;
    }
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCDitoVideoCell class]);
}

@end

// ****************** Cell ******************
@interface DCDitoVideoCell() <UIScrollViewDelegate>
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIScrollView *mediaScrollView;

@property (nonatomic, strong) UIView *indicatorBGView;

@property (nonatomic, strong) UIImageView *videoView;
//@property (nonatomic, strong) EllipsePageControl *pageControl;
@property (nonatomic, strong) UIImageView *playBtnImg;

@property (nonatomic, strong) NSMutableArray *infWidthArr;

@property (nonatomic, strong) HJMultiCountdownPostIndicatorView *indicatorView;
@end

@implementation DCDitoVideoCell

- (void)bindCellModel:(DCDitoVideoCellModel *)cellModel {
    if (!cellModel.props.pictures) return;
    if([cellModel.props.pictures isKindOfClass:[NSArray class]] && DC_IsArrEmpty(cellModel.props.pictures))return;
    if([cellModel.props.pictures isKindOfClass:[NSString class]])return;
    [super bindCellModel:cellModel];
    
    // ==============================
    [_videoView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _videoView = nil;
    [_contentLbl removeFromSuperview];
    _contentLbl = nil;
    [_mediaScrollView.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)]; 
    [_mediaScrollView removeFromSuperview];
    _mediaScrollView = nil;
    [_indicatorView removeFromSuperview];
    _indicatorView = nil;
    [self.baseContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    CGFloat titleH = cellModel.props.showTitle || cellModel.props.showMore ? Title_H  : 0 ;
//    [self.baseContainer mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.borderView).with.insets(UIEdgeInsetsMake( titleH , 0, 0, 0));
//    }];
    
    [self.baseContainer addSubview:self.contentLbl];
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.leading.equalTo(@0);
    }];
    
	self.contentLbl.text = cellModel.props.showDesc ?  cellModel.props.desc?:@"" : @"";
    
    [self.baseContainer addSubview:self.mediaScrollView];
    // 看看到底是几个视频
    if([@"single" isEqualToString:cellModel.props.floorStyle]) { //
        // 单视频
        PicturesItem *obj = [cellModel.props.pictures firstObject];
        CGFloat videoH =  (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin * 2)  / self.cellModel.props.adRatio;
        [self.baseContainer addSubview:self.videoView];
        [self.videoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@(videoH));
            make.top.equalTo(self.contentLbl.mas_bottom).offset(12);
        }];
        [self.videoView sd_setImageWithURL:[NSURL URLWithString:obj.videoPosterSrc]];
        
        // LearnMore
        UILabel *learnMore  = [UILabel new];
        learnMore.text      = !DC_IsStrEmpty(obj.moreBtnName) ? obj.moreBtnName : @"Leam More";
        learnMore.font      = FONT_BS(14);
        learnMore.textColor = [UIColor whiteColor];
        learnMore.userInteractionEnabled = YES;
        learnMore.tag = DCDitoVideoCell_Video_Detail_tag;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goVideoDetail:)];
        [learnMore addGestureRecognizer:tapG];
        [self.baseContainer  addSubview:learnMore];
        [learnMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-8);
            make.top.equalTo(self.contentLbl.mas_bottom).offset(26);
        }];
    }else if([@"double" isEqualToString:cellModel.props.floorStyle] ){
        // 添加两个视频
        [cellModel.props.pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *videoView = [self getVideoView:obj index:idx];
            [self.baseContainer addSubview:videoView];
            CGFloat w = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin * 2 - 10) /2;
            CGFloat videoH = w / self.cellModel.props.adRatio;
            [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@( self.cellModel.props.horizontalOutterMargin + (10 + w) * idx ));
                make.height.equalTo(@(videoH));
                make.width.equalTo(@(w));
                make.top.equalTo(self.contentLbl.mas_bottom).offset(12);
            }];
            if(idx >=1){
                *stop = YES;
            }
        }];
    }else if([@"multi" isEqualToString:cellModel.props.floorStyle] ){
        [self.infWidthArr removeAllObjects];

        CGFloat w = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin * 2 - 10) /2.3;
        CGFloat videoH = w / self.cellModel.props.adRatio;

        [self.mediaScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.height.equalTo(@(videoH));
            make.top.equalTo(self.contentLbl.mas_bottom).offset(12);
        }];

        __block CGFloat mediaScrollViewW = 0;
        [cellModel.props.pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            UIImageView *videoView = [self getVideoView:obj index:idx];
            [self.mediaScrollView addSubview:videoView];
            [videoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@((10 + w) * idx ));
                make.height.equalTo(@(videoH));
                make.width.equalTo(@(w));
                make.top.equalTo(self.contentLbl.mas_bottom).offset(12);
            }];
            CGFloat xVal = (10 + w) * idx * 0.7 + w/3;
            [self.infWidthArr addObject:@(xVal)];
            mediaScrollViewW = (10 + w) * idx + w;
        }];

        self.mediaScrollView.contentSize = CGSizeMake(mediaScrollViewW, 0);

        // 添加指示器
        [self.baseContainer addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.baseContainer.mas_centerX);
            make.bottom.equalTo(@-14);
            make.height.mas_offset(3);
        }];
        self.indicatorView.count = cellModel.props.pictures.count;


    }
}

- (UIImageView *)getVideoView:(PicturesItem*)item index:(NSInteger)index  {
    UIImageView *videoView = [[UIImageView alloc] init];
    videoView.userInteractionEnabled = YES;
    videoView.clipsToBounds = YES;
    videoView.contentMode   = UIViewContentModeScaleAspectFit;
    videoView.userInteractionEnabled = YES;
    videoView.tag = DCDitoVideoCell_Video_Detail_tag + index;
   
    
    
    if([@"image" isEqualToString:item.source]){
        [videoView sd_setImageWithURL:[NSURL URLWithString:item.src]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
        [videoView addGestureRecognizer:tap];
    }else {
        UIImageView *playBtnImg = [UIImageView new];
        [playBtnImg setImage:[UIImage imageNamed:@"video-play"]];
        [videoView addSubview:playBtnImg];
        [playBtnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.centerX.equalTo(videoView.mas_centerX);
            make.centerY.equalTo(videoView.mas_centerY);
        }];
        [videoView sd_setImageWithURL:[NSURL URLWithString:item.videoPosterSrc]];
        UITapGestureRecognizer *tapVideo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goVideoDetail:)];
        [videoView addGestureRecognizer:tapVideo];
        // LearnMore
        UILabel *learnMore  = [UILabel new];
        learnMore.text      = !DC_IsStrEmpty(item.moreBtnName) ? item.moreBtnName : @"Leam More";
        learnMore.font      = FONT_BS(12);
        learnMore.textColor = [UIColor whiteColor];
        [videoView addSubview:learnMore];
        [learnMore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-8);
            make.top.equalTo(@8);
        }];
        learnMore.tag = DCDitoVideoCell_Video_Detail_tag + index;
        learnMore.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goVideoDetail:)];
        [learnMore addGestureRecognizer:tapG];
    }
    
    return videoView;
}

// 去详情页面
- (void)goVideoDetail:(UITapGestureRecognizer*)gestureRecognizer {
    NSInteger index = gestureRecognizer.view.tag - DCDitoVideoCell_Video_Detail_tag;
    PicturesItem *item = self.cellModel.props.pictures[index];
    
    if([@"Y" isEqualToString:item.showDetailPage]){
        DCFloorEventModel *model = [DCFloorEventModel new];
        model.link = @"DitoDashboardCell_VIDEO_DETAIL";
        model.linkType = @"1";
        model.floorEventType = DCFloorEventCustome;
        model.coustomData = @{
            @"props": self.cellModel.props,
            @"index": [NSString stringWithFormat:@"%ld",index]
        };
        [self hj_routerEventWith:model];
    }
}

- (void)itemClickAction:(UITapGestureRecognizer*)gestureRecognizer{
    NSInteger index = gestureRecognizer.view.tag - DCDitoVideoCell_Video_Detail_tag;
    PicturesItem *item = self.cellModel.props.pictures[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.type = self.cellModel.contentModel.type;
    model.floorId = self.cellModel.contentModel.ids;
    model.link = item.link;
    model.linkType = item.linkType;
    model.name = item.iconName;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

// 播放视频
- (void)playVideo {
    PicturesItem *item = [self.cellModel.props.pictures firstObject];
    if([@"Y" isEqualToString:item.showDetailPage]){
        DCFloorEventModel *model = [DCFloorEventModel new];
        model.link = @"DitoDashboardCell_VIDEO_DETAIL";
        model.linkType = @"1";
        model.floorEventType = DCFloorEventCustome;
        model.coustomData = @{
            @"props": self.cellModel.props,
            @"index": [NSString stringWithFormat:@"%d",0]
        };
        [self hj_routerEventWith:model];
    }else {
        DCFloorEventModel *model = [DCFloorEventModel new];
        model.link = @"DitoDashboardCell_VIDEO_PLAY";
        model.floorEventType = DCFloorEventCustome;
        [self hj_routerEventWith:model];
    }
}

#pragma mark -- ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([@"multi" isEqualToString:self.cellModel.props.floorStyle] &&  self.cellModel.props.pictures.count > 1) {
        CGFloat w = (DC_DCP_SCREEN_WIDTH - self.cellModel.props.horizontalOutterMargin * 2 - 10) /2.3;
        CGFloat offsetX = scrollView.contentOffset.x + w;
        CGFloat currentPageX = [self.infWidthArr[self.indicatorView.selectIndex] doubleValue];
        if (offsetX > currentPageX ) { // 右边
            if (self.indicatorView.selectIndex + 1 < self.infWidthArr.count) {
                CGFloat rightPageX = [self.infWidthArr[self.indicatorView.selectIndex + 1] doubleValue];
                if (offsetX > rightPageX) {
                    self.indicatorView.selectIndex = self.indicatorView.selectIndex + 1;
                }
            }
        }else {
            if (self.indicatorView.selectIndex>0) {
                CGFloat leftPageX = [self.infWidthArr[self.indicatorView.selectIndex - 1] doubleValue];
                if (leftPageX <= offsetX ) {
                    self.indicatorView.selectIndex = self.indicatorView.selectIndex - 1;
                }
            }
        }
    }
}

// MARK: LAZY
- (UIScrollView *)mediaScrollView {
    if (!_mediaScrollView) {
        _mediaScrollView = [UIScrollView new];
        _mediaScrollView.delegate = self;
        _mediaScrollView.showsHorizontalScrollIndicator = NO;
        _mediaScrollView.showsVerticalScrollIndicator = NO;
    }
    return _mediaScrollView;
}

- (UILabel *)contentLbl {
    if(!_contentLbl) {
        _contentLbl = [UILabel new];
        _contentLbl.textColor = [UIColor hjp_colorWithHex:@"#3E3E3E"];
        _contentLbl.font = FONT_BS(14);
        _contentLbl.numberOfLines = 0;
    }
    return _contentLbl;
}

- (UIImageView *)videoView {
    if (!_videoView) {
        _videoView = [[UIImageView alloc] init];
        _videoView.tag = kHJPBPlayerViewTag;
        _videoView.clipsToBounds = YES;
        _videoView.contentMode = UIViewContentModeScaleAspectFit;
        _videoView.userInteractionEnabled = YES;
        // 图片
        UIImageView *playBtnImg = [UIImageView new];
        playBtnImg.tag = DCDitoVideoCell_Video_Detail_tag;
        
        [playBtnImg setImage:[UIImage imageNamed:@"video-play"]];
        [_videoView addSubview:playBtnImg];
        [playBtnImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@44);
            make.centerX.equalTo(self.videoView.mas_centerX);
            make.centerY.equalTo(self.videoView.mas_centerY);
        }];
        
        // 点击进行播放
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
        [_videoView addGestureRecognizer:tapG];
        
    }
    return _videoView;
}

//- (EllipsePageControl *)pageControl {
//    if (!_pageControl) {
//        _pageControl = [[EllipsePageControl alloc] init];
//        _pageControl.backgroundColor = [UIColor clearColor];
//        _pageControl.pagecontrlStyle = EllipsePageControlStyleLine;
//        _pageControl.currentColor = [UIColor colorWithHexString:@"#CE1126"];
//        _pageControl.otherColor = [UIColor colorWithHexString:@"#C7C7C7"];
//        _pageControl.controlSpacing = 5;
//
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

- (NSMutableArray *)infWidthArr {
    if(!_infWidthArr){
        _infWidthArr = [NSMutableArray new];
    }
    return _infWidthArr;
}
@end
