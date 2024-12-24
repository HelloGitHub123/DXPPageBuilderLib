//
//  DCFloorBaseViewDataSource.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/4.
//

#import <UIKit/UIKit.h>

@class DCPageCompositionContentModel,DCFloorBaseCellModel,CompositionProps;

NS_ASSUME_NONNULL_BEGIN

// 自定义组件获取对应数据模型
typedef void (^DCFloorBaseViewDataCallback)(id _Nullable data,NSInteger  index);


@protocol DCFloorBaseViewDataSource <NSObject>


/**
 * 返回一个自定义组件Model
 * @param cellModel  自定义组件所需数据模型
 * @param index  对应下标
 */
- (void)componentModelViewWithData:(DCFloorBaseCellModel *)cellModel index:(NSInteger)index callback:(DCFloorBaseViewDataCallback)callback;


/**
 * 返回一个自定义组件view
 * @param cellModel  自定义组件所需数据模型
 */
- (UIView *)componentViewWithData:(DCFloorBaseCellModel *)cellModel;

/**
 * 返回一个自定义组件高度
 * @param cellModel  自定义组件所需数据模型
*/
- (CGFloat)heightForComponentWithData:(DCFloorBaseCellModel *)cellModel;

/**
 * 返回自定义组件的code，用于判断自定义组件是否需要悬浮
*/
- (NSArray<NSString*> *)whiteListForCustomTopView;

/**
 * 返回一个顶部自定义组件View
 * @param componentModel  自定义组件所需数据模型
 * @param offsetYBlcok  回调，告知tableView下移
*/
- (void)customTopViewForFloor:(UIView*)floorView
                componentData:(DCPageCompositionContentModel *)componentModel
                   setYOffset:(void(^)(CGFloat offsetY))offsetYBlcok;


/**
 * 返回一个自定义组件View，不限楼层
 * @param componentModel  自定义组件所需数据模型
 * @param offsetYBlcok  回调，告知tableView下移
*/
- (void)customTopViewForFloor:(UIView*)floorView
                componentData:(DCPageCompositionContentModel *)componentModel
                   setYOffset:(void(^)(CGFloat offsetY))offsetYBlcok;

@end

NS_ASSUME_NONNULL_END
