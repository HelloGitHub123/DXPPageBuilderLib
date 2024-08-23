//
//  DCFloorCustomView.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/4.
//

#import <UIKit/UIKit.h>
#import "DCPageCompositionContentModel.h"
#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCFloorCustomBaseView : UIView
// 数页渲染据源
@property (nonatomic, strong) DCFloorBaseCellModel *cellModel;

// 数据源赋值，子类实现
- (void)setupComponent:(DCFloorBaseCellModel *)cellModel;

// 返回当前组件的高度
+ (CGFloat)viewHeight;

/**
 * tableOffsetY：TableView的Y偏移量，顶部悬浮组件使用
 * @return 默认返回viewHeight，指定需要在子类在实现
 */
+ (CGFloat)tableOffsetY;

// 更新页面数据
- (void)updateViewData:(id)data;
@end

NS_ASSUME_NONNULL_END
