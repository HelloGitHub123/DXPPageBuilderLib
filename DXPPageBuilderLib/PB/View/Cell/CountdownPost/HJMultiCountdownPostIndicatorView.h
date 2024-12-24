//
//  HJMultiCountdownPostIndicatorView.h
//  DITOApp
//
//  Created by 严贵敏 on 2022/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HJMultiCountdownPostIndicatorView : UIView
@property (nonatomic,strong) UIColor *selectColor;
@property (nonatomic,strong) UIColor *defaulColer;
@property (nonatomic,assign) NSInteger count;//数量
@property (nonatomic,assign) NSInteger selectIndex;//选中
@end

NS_ASSUME_NONNULL_END
