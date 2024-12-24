//
//  DCMenuModel.m
//  Product_CLP
//
//  Created by Lee on 2022/9/28.
//

#import "DCMenuModel.h"

@implementation DCMenuModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"children" : [DCMenuModel class]
    };
}

- (id)copyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}
@end
