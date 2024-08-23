//
//  HJVideoPlayerViewController.m
//  DITOApp
//
//  Created by 李标 on 2023/4/11.
//

#import "HJVideoPlayerViewController.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import <SJUIKit/NSAttributedString+SJMake.h>
#import "HJVideoView.h"
#import "DCSuspensionButton.h"
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>
#import "Masonry.h"
#import "DCPB.h"

static SJEdgeControlButtonItemTag const SJTestCustomItemTagVoice = 1001;
static SJEdgeControlButtonItemTag const SJTestCustomItemTag = 103;

@interface HJVideoPlayerViewController ()<SJVideoViewDelegate> {
    BOOL __isMuted; // 是否静音
    NSString *videoUrl; // video 地址
}

@property (nonatomic, strong) SJVideoPlayer *player;
@property (nonatomic, strong) HJVideoView *videoView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YYLabel *tipsLab;
@property (nonatomic, strong) UIButton *operBtn;
@property (nonatomic, strong) DCSuspensionButton *suspensionButton;
@end

@implementation HJVideoPlayerViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_player vc_viewDidAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_player vc_viewWillDisappear];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_player vc_viewDidDisappear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    
    [self initUI];
    
    [self initPlayer];
}

- (void)initData {
    // 默认是禁音
    __isMuted = YES;
}

- (void)initUI {
    [self.view addSubview:self.videoView];
    [self.view addSubview:self.titleLab];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.tipsLab];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.top.mas_equalTo(self.videoView.mas_bottom).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.height.mas_greaterThanOrEqualTo(26);
    }];
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.right.mas_equalTo(self.view.mas_right).offset(0);
        make.height.equalTo(@72);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(0);;
    }];
    
    [bottomView addSubview:self.operBtn];
    [self.operBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bottomView.mas_centerY);
        make.centerX.mas_equalTo(bottomView.mas_centerX);
        make.height.equalTo(@40);
        make.left.mas_equalTo(bottomView.mas_left).offset(16);
        make.right.mas_equalTo(bottomView.mas_right).offset(-16);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(16);
        make.bottom.mas_equalTo(bottomView.mas_top).offset(-16);
    }];
    
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

- (void)initPlayer {
    if ( !_player ) {
        _player = [SJVideoPlayer player];
        _player.muted = YES;
        _player.pausedToKeepAppearState = YES; // 暂停时是否保持控制层一直显示
        _player.defaultEdgeControlLayer.hiddenBottomProgressIndicator = NO;
        _player.controlLayerAppearManager.interval = 3; // 设置控制层隐藏间隔 单位:秒
        _player.defaultEdgeControlLayer.hiddenBackButtonWhenOrientationIsPortrait = YES;
        if (@available(iOS 14.0, *)) {
            _player.defaultEdgeControlLayer.automaticallyShowsPictureInPictureItem = NO;
        }
        _player.defaultEdgeControlLayer.showsMoreItem = NO;
        //        _player.rotationManager.autorotationSupportedOrientations = SJOrientationMaskLandscapeLeft | SJOrientationMaskLandscapeRight;
    }
    
    [self.videoView.coverImageView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.videoView.coverImageView);
    }];
    
    if (!DC_IsStrEmpty(self.picturesItem.standardVideoSrc)) {
        videoUrl = self.picturesItem.standardVideoSrc;
    } else if (!DC_IsStrEmpty(self.picturesItem.miniVideoSrc)) {
        videoUrl = self.picturesItem.miniVideoSrc;
    }
    
    if (!DC_IsStrEmpty(videoUrl)) {
        [self.videoView.coverImageView addSubview:_player.view];
        [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.videoView.coverImageView);
        }];
    
        NSURL *url = [NSURL URLWithString:[videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        //        _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:videoUrl]];
        _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
    }
	__weak __typeof(&*self)weakSelf = self;
       
    _player.playbackObserver.playbackDidFinishExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        [player.view removeFromSuperview];
    };
    
    // 监听播放状态
    _player.playbackObserver.timeControlStatusDidChangeExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull player) {
        if (player.isPaused) {
            NSLog(@"调用了暂停, 暂停播放");
        }
        else if (player.isPlaying){
            NSLog(@"调用了播放, 处于播放中");
        }
        else if (player.isBuffering){
            NSLog(@"调用了播放, 处于缓冲中(等待缓存足够时自动恢复播放, 建议显示loading视图)");
        }
        else if (player.isEvaluating){
            NSLog(@"调用了播放, 正在评估缓冲中(这个过程会进行的很快, 不需要显示loading视图)");
        }
        else if (player.isNoAssetToPlay){
            NSLog(@"< 调用了播放, 但未设置播放资源(设置资源后将会自动播放 )");
        }
        else if (player.isPlaybackFinished){
            NSLog(@"完成播放11");
        }
    };
    
    // 监听屏幕旋转
    _player.rotationObserver.onRotatingChanged = ^(id<SJRotationManager>  _Nonnull mgr, BOOL isRotating) {
        // 横屏
        if (!isRotating && (mgr.currentOrientation == UIDeviceOrientationLandscapeLeft || mgr.currentOrientation == UIDeviceOrientationLandscapeRight)) {
            [weakSelf.player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Full];
            [weakSelf.player.defaultEdgeControlLayer.bottomAdapter reload];
            [weakSelf.player controlLayerNeedAppear];
            // 添加全屏下浮层按钮
            [[weakSelf topViewController].view addSubview:weakSelf.suspensionButton];
        }
        // 竖屏
        if (!isRotating && mgr.currentOrientation == UIDeviceOrientationPortrait) {
            // 旋转到竖屏时候，添加全屏操作按钮
            SJEdgeControlButtonItem *subitem = [[SJEdgeControlButtonItem alloc]initWithTag:SJEdgeControlLayerBottomItem_Full ];
            [subitem addAction:[SJEdgeControlButtonItemAction actionWithTarget:weakSelf action:@selector(enterFullScreen:)]];
            // 将全屏按钮插入到声音按钮的前面
            [weakSelf.player.defaultEdgeControlLayer.bottomAdapter insertItem:subitem rearItem: SJTestCustomItemTagVoice];
            // 重新刷新操作界面
            [weakSelf.player.defaultEdgeControlLayer.bottomAdapter reload];
            [weakSelf.player controlLayerNeedAppear];
            // 移除全屏下浮层按钮
            if (weakSelf.suspensionButton) {
                [weakSelf.suspensionButton removeFromSuperview];
                weakSelf.suspensionButton = nil;
            }
        }
        //        if (!isRotating && mgr.currentOrientation != SJOrientation_Portrait) {
        //            UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 49)];
        //            view1.backgroundColor = [UIColor redColor];
        //            SJEdgeControlButtonItem *item = [[SJEdgeControlButtonItem alloc] initWithCustomView:view1 tag:SJTestCustomItemTag];
        //            [_player.defaultEdgeControlLayer.topAdapter addItem:item];
        //            [_player.defaultEdgeControlLayer.topAdapter reload];
        //        } else {
        //
        //        }
    };
    // 添加声音按钮
    SJEdgeControlButtonItem *item = [[SJEdgeControlButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_video_noVoice"] target:self action:@selector(changeVoiceState:) tag:SJTestCustomItemTagVoice];
    [_player.defaultEdgeControlLayer.bottomAdapter addItem:item];
    // 交换时间位置
    [_player.defaultEdgeControlLayer.bottomAdapter exchangeItemForTag:SJEdgeControlLayerBottomItem_DurationTime withItemForTag:SJEdgeControlLayerBottomItem_Progress];
    // 去掉时间分割符号/
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_Separator];
    // 去掉总时间
    [_player.defaultEdgeControlLayer.bottomAdapter removeItemForTag:SJEdgeControlLayerBottomItem_DurationTime];
    // 以下方法为显示控制层
    [_player.defaultEdgeControlLayer.bottomAdapter reload];
    [_player controlLayerNeedAppear];
    // 修改返回按钮的操作
    SJEdgeControlButtonItem *subitem = [_player.defaultEdgeControlLayer.topAdapter itemForTag:SJEdgeControlLayerTopItem_Back];
    [subitem removeAllActions];
    [subitem addAction:[SJEdgeControlButtonItemAction actionWithTarget:self action:@selector(backAction:)]];
}

// 返回
- (void)backAction:(id)sender {
    if (_player.currentOrientation == UIInterfaceOrientationPortrait || _player.currentOrientation ==  UIInterfaceOrientationPortraitUpsideDown) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [_player rotate:SJOrientation_Portrait animated:YES];
    }
}

// 全屏
- (void)enterFullScreen:(id)sender {
    [_player rotate];
}

// 禁音和声音
- (void)changeVoiceState:(id)sender {
    SJEdgeControlButtonItem *item = (SJEdgeControlButtonItem *)sender;
    if (__isMuted) {
        // 设置有声音的状态
        item.image = [UIImage imageNamed:@"ic_video_vioce"];
        _player.muted = NO;
    } else {
        // 设置静音的状态
        item.image = [UIImage imageNamed:@"ic_video_noVoice"];
        _player.muted = YES;
    }
    __isMuted = !__isMuted;
}

// 底部操作按钮
- (void)operBtnAction:(id)sender {
    if (DC_IsStrEmpty(self.picturesItem.videoBtnLink)) {
        return;
    }
    
    NSString *url = self.picturesItem.videoBtnLink;
    [self jumpURL:url];
}

- (void)jumpURL:(NSString *)url {
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    NSString *urlStr = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [dic setObject:urlStr forKey:@"schemaUrl"];

    if ([url containsString:@"tmapp://"]) {
        dic[@"schemaType"] = @"1";
    }else if ([url containsString:@"http://"] || [url containsString:@"https://"]) {
        dic[@"schemaType"] = @"2";
    }
        
//    [HJUtils jumpWithURLParamer:dic source:JumpFromSource_Home];
}

- (void)suspensionButtonClick:(id)sender {
    if (DC_IsStrEmpty(self.picturesItem.videoCTALink)) {
        return;
    }
    
    NSString *url = self.picturesItem.videoCTALink;
    [self jumpURL:url];
}

#pragma mark -- SJVideoTableViewCellDelegate
- (void)coverItemWasTapped:(HJVideoView *)view {
    if ( !_player ) {
        _player = [SJVideoPlayer player];
    }

    [view.coverImageView addSubview:_player.view];
    [_player.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view.coverImageView);
    }];

    NSURL *url = [NSURL URLWithString:[videoUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:url];
//    _player.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:@"https://vd2.bdstatic.com/mda-jjawnrrmw89xdq0q/sc/mda-jjawnrrmw89xdq0q.mp4"]];
    //    _player.URLAsset.title = @"天长地久";
}

#pragma mark -- lazy load
- (HJVideoView *)videoView {
    if (!_videoView) {
        _videoView = [[HJVideoView alloc] initWithFrame:CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, 211)];
        _videoView.delegate = self;
        [_videoView setVideoCoverImage:self.picturesItem.videoPosterSrc];
    }
    return _videoView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
		_titleLab.font = FONT_BS(18);
        _titleLab.textColor = DC_UIColorFromRGB(0x3E3E3E);
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLab.text = DC_IsStrEmpty(self.picturesItem.videoTitle)?@"":self.picturesItem.videoTitle;
    }
    return _titleLab;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (YYLabel *)tipsLab {
    if (!_tipsLab) {
        _tipsLab = [[YYLabel alloc] init];
        _tipsLab.numberOfLines = 0;
        _tipsLab.lineBreakMode = NSLineBreakByWordWrapping;
        _tipsLab.textAlignment = NSTextAlignmentLeft;
        
        NSMutableAttributedString *attri_str = [[NSMutableAttributedString alloc] initWithString:self.picturesItem.videoDesc];
        [attri_str setYy_font:FONT_S(14)];
        [attri_str setYy_color:DC_UIColorFromRGB(0x3E3E3E)];
        [attri_str setYy_lineSpacing:7];
        _tipsLab.attributedText = attri_str;
        _tipsLab.preferredMaxLayoutWidth = DC_DCP_SCREEN_WIDTH-16*2;
    }
    return _tipsLab;
}

- (UIButton *)operBtn {
    if (!_operBtn) {
        _operBtn = [[UIButton alloc] init];
        [_operBtn setTitle:self.picturesItem.videoBtnName forState:UIControlStateNormal];
        [_operBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _operBtn.backgroundColor = DC_UIColorFromRGB(0xCE1126);
		_operBtn.titleLabel.font = FONT_S(14);
        _operBtn.layer.cornerRadius = 4;
        [_operBtn addTarget:self action:@selector(operBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _operBtn;
}

- (DCSuspensionButton *)suspensionButton {
    if(_suspensionButton == nil) {
        _suspensionButton = [DCSuspensionButton buttonWithType:UIButtonTypeCustom];
        _suspensionButton.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
        _suspensionButton.layer.masksToBounds = YES;
        _suspensionButton.MoveEnable = YES;
        _suspensionButton.layer.cornerRadius = 10;
		_suspensionButton.titleLabel.font = FONT_BS(14);
        [_suspensionButton setTitleColor:DC_UIColorFromRGB(0x3e3e3e) forState:UIControlStateNormal];
        [_suspensionButton addTarget:self action:@selector(suspensionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_suspensionButton setImage:[UIImage imageNamed:@"ic_video_arrow"] forState:UIControlStateNormal];
    
        CGSize size = [self.picturesItem.videoCTAName sizeWithAttributes:@{NSFontAttributeName:FONT_BS(14)}];
        [_suspensionButton setTitle:self.picturesItem.videoCTAName forState:UIControlStateNormal];
//        [_suspensionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -10 ,0, 10)];
//        [_suspensionButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 8, 0, - size.width)];
        // 计算横屏下的按钮坐标
        [_suspensionButton setFrame:CGRectMake(DC_DCP_SCREEN_WIDTH - (10 + size.width + 8*2) - 16, DC_SCREEN_HEIGHT-98,  10 + size.width + 8*2, 32)];
    }
    return _suspensionButton;
}

#pragma mark -- 获取当前栈顶控制器
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[self keyWindow] rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

// 获取当前栈顶控制器
- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#pragma mark -- 获取当前window
- (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

@end
 
