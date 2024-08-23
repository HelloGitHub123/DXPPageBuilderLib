//
//  DCFloorBaseVC.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/27.
//

#import "DCFloorBaseVC.h"
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFIJKPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import <ZFPlayer/UIView+ZFFrame.h>
#import <ZFPlayer/ZFPlayerConst.h>
#import "HJZFCustomControlView.h"
#import "DCPB.h"

@interface DCFloorBaseVC ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *content;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) HJZFCustomControlView *controlView;
@property (nonatomic, strong) NSIndexPath *videoPlayIndexPath; // video展示的对应indexpath
@property (nonatomic, assign) Boolean needPlayVideo; // 需要播放视频

@property (nonatomic, strong) UIImageView *backgroundImgView;
@end

@implementation DCFloorBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	[self.view addSubview:self.backgroundImgView];
	[self.backgroundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.bottom.leading.trailing.offset(0);
	}];
	
	
    // 添加消息订阅，
    [self initPlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFloorWithoutContent:) name:@"updateFloorWithoutContent" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(self.needPlayVideo) {
        self.needPlayVideo = NO;
        [self.player.currentPlayerManager replay];
    }
}


- (void)updateFloorContent:(DCPageModel *) model {
    // 添加顶部自定义view
    self.viewModel.dataSource = self.dataSource;
    [self.viewModel constructComponentListWithContent:model];
    
    /**
        modelList数组里面可能存在需要外部添加的自定义组件
        在这里让datasource去获取数据，并进行回调(同步或者异步)
     */
	__weak typeof(self)weakSelf = self;
    [self.viewModel.modelList enumerateObjectsUsingBlock:^(DCFloorBaseCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.cellType == DCFloorCellType_Need_Data
            || obj.cellType == DCFloorCellType_Need_Data_View
            || obj.cellType == DCFloorCellType_Need_View )
        {
            [weakSelf.dataSource componentModelViewWithData:obj index:idx callback:^(id  _Nullable data, NSInteger index) {
                [weakSelf.viewModel.modelList replaceObjectAtIndex:idx withObject:obj];
                [weakSelf.tableView reloadData];
            }];
        }
    }];
    
    // 设置bgImage && bgColor
    if (!DC_IsStrEmpty(model.backgroundColor)) {
        self.view.backgroundColor = [UIColor hjp_colorWithHex:model.backgroundColor];
    }
    NSString *bgImage = model.backgroundImage;
    
    if (!DC_IsStrEmpty(bgImage)) {
		[self.backgroundImgView sd_setImageWithURL:[NSURL URLWithString:bgImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
			CGSize imgSize = image.size;
			if (imgSize.width > 0 && imgSize.height > 0) {
				self.backgroundImgView.frame = CGRectMake(0, 0, self.tableView.frame.size.width,  self.tableView.frame.size.width / imgSize.width * imgSize.height);
			}
		}];
        //这里判断背景图片是否添加过，如果添加过改变高度和url即可，解决下拉刷新后背景图片突然指定的体验
//        if (self.bgImageView && self.bgView) {
//            self.bgView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height);
//            [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:bgImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//                CGSize imgSize = image.size;
//                if (imgSize.width > 0 && imgSize.height > 0) {
//                    self.bgImageView.frame = CGRectMake(0, 0, self.tableView.frame.size.width,  self.tableView.frame.size.width / imgSize.width * imgSize.height);
//                }
////				self.backgroundImgView.image = image;
//            }];
//			 self.tableView.backgroundView = self.bgView;
//        } else {
//            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//            bgImageView.contentMode = UIViewContentModeScaleToFill;
//            [bgImageView sd_setImageWithURL:[NSURL URLWithString:bgImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//                CGSize imgSize = image.size;
//                if (imgSize.width > 0 && imgSize.height > 0) {
//                    bgImageView.frame = CGRectMake(0, 0, self.tableView.frame.size.width,  self.tableView.frame.size.width / imgSize.width * imgSize.height);
//                }
//
////				self.backgroundImgView.image = image;
//            }];
//            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, self.tableView.frame.size.height)];
//
//            [bgView addSubview:bgImageView];
//            self.tableView.backgroundView = bgView;
//            self.bgImageView = bgImageView;
//            self.bgView = bgView;
//
////			self.backgroundImgView = bgImageView;
//        }
    } else {
//        self.tableView.backgroundView = [UIView new];
//        [_bgView removeFromSuperview];
//        _bgImageView = nil;
//        _bgView = nil;
    }
    
    // 刷新数据
    if (self.viewModel.modelList && self.viewModel.modelList.count > 0) {
        [self.tableView reloadData];
    }
}

// 初始化播放器能力
- (void)initPlayer {
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:kHJPBPlayerViewTag];
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.disablePanMovingDirection = ZFPlayerDisablePanMovingDirectionAll;

    /// 0.4是消失40%时候
    self.player.playerDisapperaPercent = 0.4;
    /// 0.6是出现60%时候
    self.player.playerApperaPercent = 0.6;
    /// 移动网络依然自动播放
    self.player.WWANAutoPlay = YES;
    /// 续播
    self.player.resumePlayRecord = YES;
    @zf_weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @zf_strongify(self)
        [self.player stopCurrentPlayingCell];
    };
    
    /// 停止的时候找出最合适的播放
    self.player.zf_scrollViewDidEndScrollingCallback = ^(NSIndexPath * _Nonnull indexPath) {
        @zf_strongify(self)
        if (!self.player.playingIndexPath) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };
    
    /// 滑动中找到适合的就自动播放
    /// 如果是停止后再寻找播放可以忽略这个回调
    /// 如果在滑动中就要寻找到播放的indexPath，并且开始播放，那就要这样写
    self.player.zf_playerShouldPlayInScrollView = ^(NSIndexPath * _Nonnull indexPath) {
        @zf_strongify(self)
        if ([indexPath compare:self.player.playingIndexPath] != NSOrderedSame) {
            [self playTheVideoAtIndexPath:indexPath scrollAnimated:NO];
        }
    };
}


// MARK: 处理一些延时获取的楼层:需要比对楼层信息
- (void)updateFloorWithoutContent:(NSNotification*)notification{
    NSDictionary *dic = notification.object;
    NSString *indexStr = [dic objectForKey:@"index"];
    if (!DC_IsStrEmpty(indexStr)) {
        NSInteger row = [indexStr integerValue];
        if (row >=0 && self.viewModel.modelList.count > row) {
            DCFloorBaseCellModel *updateModel = self.viewModel.modelList[row];
            updateModel.isBinded = NO;
            [self.dataSource componentModelViewWithData:updateModel index:row callback:^(id  _Nullable data, NSInteger index) {
                [self.viewModel.modelList replaceObjectAtIndex:row withObject:data];
                [self.tableView reloadData];
            }];
        }
    }
}

// 更具code通知更新
- (void)updateFloorWithCode:(NSString*)code {
    if (DC_IsStrEmpty(code) || !self.viewModel.dataSource) return;
    
    [self.viewModel.modelList enumerateObjectsUsingBlock:^(DCFloorBaseCellModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([code isEqualToString:obj.code]) {
            obj.isBinded = NO;
            if (obj.cellType == DCFloorCellType_Need_Data
                || obj.cellType == DCFloorCellType_Need_Data_View
                || obj.cellType == DCFloorCellType_Need_View )
            {
                [self.dataSource componentModelViewWithData:obj index:idx  callback:^(id  _Nullable data, NSInteger index) {
                    [self.viewModel.modelList replaceObjectAtIndex:idx withObject:obj];
                    [self.tableView reloadData];
                }];
            }else{
                [self.tableView reloadData];
            }
            *stop = YES;
        }
    }];
}

#pragma mark - private method
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollAnimated:(BOOL)animated {
    DCFloorBaseCellModel *cellModel = self.viewModel.modelList[indexPath.row];
    if([cellModel.code isEqualToString:@"EnhancedVideos"]  ) {
        self.videoPlayIndexPath = indexPath;
        PicturesItem *item = [cellModel.props.pictures firstObject];
        self.player.currentPlayerManager.muted = YES;
        self.player.currentPlayerManager.volume = 0;
        
        NSURL *url = [NSURL URLWithString:[item.miniVideoSrc stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (animated) {
            [self.player playTheIndexPath:indexPath assetURL:url scrollPosition:ZFPlayerScrollViewScrollPositionCenteredVertically animated:YES];
        } else {
            [self.player playTheIndexPath:indexPath assetURL:url];
        }
       
        
        [self.controlView showTitle:@""
                     coverURLString:item.videoPosterSrc
                     fullScreenMode:ZFFullScreenModePortrait];
    }
}



// MARK: -- TableView  Data  & Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.modelList.count;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     DCFloorBaseCellModel *cellModel = [self.viewModel.modelList objectAtIndex:indexPath.row];
     return cellModel.cellHeight;
 }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
    
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     DCFloorBaseCellModel *cellModel = [self.viewModel.modelList objectAtIndex:indexPath.row];
     cellModel.indexPath = indexPath;
     if (nil == cellModel) {
         cellModel = [DCFloorBaseCellModel new];
     }
     
     NSString *identifier = [NSString stringWithFormat:@"%@%ld", cellModel.cellClsName, indexPath.row];
     DCFloorBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     if (!cell) {
         cell = [[NSClassFromString(cellModel.cellClsName) alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
         [self cellExposureTrackWtihCellModel:cellModel];
     }
     // 防止重复调用bindCellModel
     if (!cellModel.isBinded && cellModel.cellHeight > 0) {
         if (cellModel.cellType == DCFloorCellType_Need_Data_View) {
             if (cellModel.customData) {
                 [cell bindCellModel:cellModel];
                 [self customeContentForCell:cell cellModel:cellModel];
             }
         }else {
             __weak typeof(self) weakSelf = self;
             cell.reloadTableBlock = ^() {
                 [weakSelf.tableView reloadData];
             };
             [cell bindCellModel:cellModel];

             if (cellModel.cellType == DCFloorCellType_Need_View ) {
                 [self customeContentForCell:cell cellModel:cellModel];
             }
         }
     }
     return cell;
 }


- (void)cellExposureTrackWtihCellModel:(DCFloorBaseCellModel*)cellModel {
    /** 子类实现*/
}

// 添加customView 到cell
- (void)customeContentForCell:(DCFloorBaseCell*)cell cellModel:(DCFloorBaseCellModel *)cellModel {
    if ([self.dataSource respondsToSelector:@selector(componentViewWithData:)]) {
        UIView *component = [self.dataSource componentViewWithData:cellModel];
        [cell.baseContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        [cell.baseContainer addSubview:component];
        [component mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.bottom.equalTo(@0);
        }];
    }
}



- (void)hj_routerEventWith:(DCFloorEventModel *)eventModel {
     if([eventModel.link isEqualToString:@"DitoDashboardCell_VIDEO_PLAY"]) {
        // 点击视频播放
         [self playTheVideoAtIndexPath:eventModel.indexPath scrollAnimated:NO];
        
    }
}



#pragma mark - UIScrollViewDelegate 列表播放必须实现
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //处理背景滚动
//    if (self.bgImageView && [self.backgroundAttachment isEqualToString:@"scroll"]) {
//        CGFloat y = scrollView.contentOffset.y;
//        self.bgImageView.hn_y = -y;
//    }
    [self floorBasicScrollViewDidScroll:scrollView];
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self floorBasicScrollViewWillBeginDragging:scrollView];
    [scrollView zf_scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self floorBasicScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self floorBasicScrollViewDidEndDecelerating:scrollView];
    [scrollView zf_scrollViewDidEndDecelerating];
}



/**
 在该方法中- (void)scrollViewDidScroll:(UIScrollView *)scrollView调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewDidScroll:(UIScrollView *)scrollView {
    
}
/**
 在该方法中- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}
/**
 在该方法中- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}
/**
 在该方法中- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
// MARK: -- lazy load
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,DCP_NAV_HEIGHT,DCP_SCREEN_WIDTH,DCP_SCREEN_HEIGHT) style:UITableViewStylePlain];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
      
        float statusBarHeightX = 0;
        if (@available(iOS 13.0, *)) {
            UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
            statusBarHeightX = statusBarManager.statusBarFrame.size.height;
        }
        else {
            statusBarHeightX = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
//        _tableView.contentInset =  UIEdgeInsetsMake(-statusBarHeightX, 0, 0, 0);
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.automaticallyAdjustsScrollViewInsets = NO;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (DCFloorViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[DCFloorViewModel alloc] init];
    }
    return _viewModel;;
}

- (HJZFCustomControlView *)controlView {
    if (!_controlView) {
        _controlView = [HJZFCustomControlView new];
		__weak typeof(self)weakSelf = self;
        _controlView.tapBlock = ^{
            if(weakSelf.videoPlayIndexPath){
                if(weakSelf.videoPlayIndexPath){
                    DCFloorBaseCellModel *cellModel = weakSelf.viewModel.modelList[weakSelf.videoPlayIndexPath.row];
                    PicturesItem *item = [cellModel.props.pictures firstObject];
                    if([@"Y" isEqualToString:item.showDetailPage]){
                        weakSelf.controlView.mutedBtn.selected = NO;
                        weakSelf.player.currentPlayerManager.muted = YES;
                        weakSelf.needPlayVideo = YES;
                        [weakSelf.player.currentPlayerManager pause];
                        
                        DCFloorEventModel *model = [DCFloorEventModel new];
                        model.link = @"DitoDashboardCell_VIDEO_DETAIL";
                        model.linkType = @"1";
                        model.floorEventType = DCFloorEventCustome;
                        model.coustomData = @{
                            @"props": cellModel.props,
                            @"index": [NSString stringWithFormat:@"%d",0]
                        };
                        [weakSelf hj_routerEventWith:model];
                    }else {
                        [weakSelf.controlView playOrPause];
                    }
                   
                }
            }
        };
    }
    return _controlView;
}

- (UIImageView *)backgroundImgView {
	if (!_backgroundImgView) {
		_backgroundImgView = [[UIImageView alloc] init];
		// _backgroundImgView.backgroundColor = [UIColor redColor];
	}
	return _backgroundImgView;
}

@end
