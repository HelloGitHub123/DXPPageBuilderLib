//
//  UIResponder+DCFloorResponder.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/27.
//

#import <UIKit/UIKit.h>
#import "DCFloorEventModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (DCFloorResponder)
/**
 @abstract      发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 @discussion    发送事件
 @param         eventName 发生的事件名称
 @param         userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
*/
- (void)hj_routerEventWithName:(NSString *)eventName userInfo:(id)userInfo;



/**
 @abstract      发送一个路由器消息,  根据事件模型对消息进行处理
 @discussion    发送事件
 @param         eventModel 事件模型
 */
- (void)hj_routerEventWith:(DCFloorEventModel *)eventModel;

@end

NS_ASSUME_NONNULL_END
