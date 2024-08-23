//
//  DCPBManager.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface DCPBManager : NSObject
+ (instancetype)sharedInstance;


// 每一个属性添加都要明确具体含义
@property (nonatomic, strong) NSMutableArray *iconMenuListData; // 首页icon 采单数据，展示首页金刚区和jicon编辑页面


+ (NSString *)stringFormatToThreeBit:(NSString *)string;

@property (nonatomic, copy) NSString *parentSubsId;
@property (nonatomic, strong) NSArray *bundleSubsList;


@end

NS_ASSUME_NONNULL_END
