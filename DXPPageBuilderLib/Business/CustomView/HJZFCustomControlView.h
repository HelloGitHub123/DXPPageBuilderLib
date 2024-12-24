//
//  HJZFCustomControlView.h
//  DITOApp
//
//  Created by 孙全民 on 2023/4/18.
//
#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>
#import "ZFSpeedLoadingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJZFCustomControlView : UIView <ZFPlayerMediaControl>
/// 静音按钮
@property (nonatomic, strong) UIButton *mutedBtn;

@property (nonatomic, strong) dispatch_block_t tapBlock;

/// 控制层自动隐藏的时间，默认2.5秒
@property (nonatomic, assign) NSTimeInterval autoHiddenTimeInterval;

/// 控制层显示、隐藏动画的时长，默认0.25秒
@property (nonatomic, assign) NSTimeInterval autoFadeTimeInterval;

/**
 设置标题、封面、全屏模式
 
 @param title 视频的标题
 @param coverUrl 视频的封面，占位图默认是灰色的
 @param fullScreenMode 全屏模式
 */
- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl fullScreenMode:(ZFFullScreenMode)fullScreenMode;

- (void)playOrPause;
@end

NS_ASSUME_NONNULL_END
