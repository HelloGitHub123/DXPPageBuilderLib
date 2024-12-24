//
//  DCFloorEventModel.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/11.
//  楼层事件model，统一处理事件

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    DCFloorEventFloor, // 楼层事件
    DCFloorEventCustome, // 需要自己处理，自定义事件
    DCFloorEventMCCM, // 需要自己处理，自定义事件
} DCFloorEventType;

NS_ASSUME_NONNULL_BEGIN

// 这里可以按需添加属性
@interface DCFloorEventModel : NSObject
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *link; // 路由url
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) DCFloorEventType floorEventType;
@property (nonatomic, copy) NSString *customKey; // 路由url
@property (nonatomic, assign) NSInteger picIndex; // pic下标
@property (nonatomic, assign) NSInteger picCount; // pic  个数
@property (nonatomic, copy) NSString * picId;

@property (nonatomic, copy) NSString *code; // 楼层字符串code
@property (nonatomic, copy) NSString *displayName; // 楼层字符串dispalyName
@property (nonatomic, copy) NSString *floorId; //pb楼层ID
@property (nonatomic, copy) NSString *floorTitle; //pb楼层ID
@property (nonatomic, assign) NSInteger floorStyle; //神策埋点一行两列类型banner
@property (nonatomic, copy) NSString * needLogin;

/**
 *  eg: 临时字典变量，可用于临时存储数据
 *  目前用于神策埋点存储临时数据
 */
@property (nonatomic, strong) NSDictionary *tempDic;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *idFloor;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *sourceFromWhere; // 标记从哪里点击进去路由管理的。

// 自定义数据
@property (nonatomic, strong) id coustomData;
@end

NS_ASSUME_NONNULL_END
