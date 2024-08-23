//
//  DCPBMenuItemModel.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2022/12/15.
//

#import "DCPBMenuItemModel.h"
@implementation DCPBMenuItemModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"children" : [DCPBMenuItemModel class]
    };
}

- (id)copyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}
@end
