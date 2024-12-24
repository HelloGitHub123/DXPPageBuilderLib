//
//  DCFloorVCModel.h
//  DITOApp
//
//  Created by 孙全民 on 2022/8/26.
//  为DCFloorVCDataSource 的接口调用类，为各个组件服务

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCFloorVCModel : NSObject


// 后付费的 Dashboard组件服务接口
+(void)floorVCBillInfoCallback:(void(^)(NSDictionary *dic))callback;

@end

NS_ASSUME_NONNULL_END
