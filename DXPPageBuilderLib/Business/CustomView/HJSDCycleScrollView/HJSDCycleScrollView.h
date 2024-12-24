//
//  HJSDCycleScrollView.h
//  DITOApp
//
//  Created by 严贵敏 on 2023/2/23.
//

#import <UIKit/UIKit.h>
#import "HJSDCycleModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HJSDCycleScrollView : UIView

- (instancetype)initWithFrame:(CGRect)frame imgMargin:(CGFloat)imgMargin imgWidth:(CGFloat)imgWidth collectionInset:(CGFloat)collectionInset;

@property(nonatomic,assign)NSInteger currentIndex;
/**
 *  模型数组
 */
@property (nonatomic, strong) NSArray<HJSDCycleModel *> *models;

/**
 *  每一页停留时间，默认为3s，最少1s
 *  当设置的值小于1s时，则为默认值
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

@property (nonatomic, assign) BOOL isRepeat;//是否重复显示

@property (nonatomic, assign) BOOL isAutomatic;//是否隔几秒自动变换

@property (nonatomic, assign) CGFloat imgMargin;

@property (nonatomic, assign) CGFloat imgWidth;

@property (nonatomic, assign) CGFloat collectionInset;

/** block方式监听点击 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/** block方式监听滚动 */
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);


@end

NS_ASSUME_NONNULL_END
