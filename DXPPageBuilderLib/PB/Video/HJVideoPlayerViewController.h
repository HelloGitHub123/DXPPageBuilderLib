//
//  HJVideoPlayerViewController.h
//  DITOApp
//
//  Created by 李标 on 2023/4/11.
//  视频播放器

#import <UIKit/UIKit.h>
#import "PBBaseViewController.h"
#import "DCPageCompositionContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HJVideoPlayerViewController : PBBaseViewController

@property (nonatomic, strong) CompositionProps *compositionPropsItem;
@property (nonatomic, strong) PicturesItem *picturesItem;
@end

NS_ASSUME_NONNULL_END
