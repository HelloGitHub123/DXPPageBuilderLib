//
//  HJVideoView.h
//  DITOApp
//
//  Created by 李标 on 2023/4/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class HJVideoView;
@protocol SJVideoViewDelegate
- (void)coverItemWasTapped:(HJVideoView *)view;
@end

@interface HJVideoView : UIView

@property (strong, nonatomic) UIImageView *coverImageView;
@property (assign, nonatomic) id<SJVideoViewDelegate> delegate;

- (void)setVideoCoverImage:(NSString *)videoURL;
@end

NS_ASSUME_NONNULL_END
