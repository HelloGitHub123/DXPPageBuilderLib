//
//  DCSignInResponseModel.m
//  MOC
//
//  Created by Lee on 2022/2/17.
//

#import "DCSignInResponseModel.h"

@implementation DCSignInUserInfoModel

@end

@implementation DCSignInResponseModel

@end


@implementation DCMenuItemModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"children" : [DCMenuItemModel class]
    };
}

- (id)copyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}
@end

