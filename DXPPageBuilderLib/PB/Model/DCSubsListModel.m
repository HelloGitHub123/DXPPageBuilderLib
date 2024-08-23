//
//  DCSubsListModel.m
//  MOC
//
//  Created by Lee on 2022/3/7.
//

#import "DCSubsListModel.h"
@implementation DCPBSubsItemModel


@end
@implementation DCSubsBundleListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"subsList" : [DCPBSubsItemModel class]
    };
}
@end

@implementation DCSubsListModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    
    return @{
        @"subsList" : [DCPBSubsItemModel class],
        @"bundleSubsList": [DCSubsBundleListModel class]
    };
}
@end
