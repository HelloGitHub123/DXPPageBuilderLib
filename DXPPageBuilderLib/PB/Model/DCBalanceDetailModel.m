//
//  DCBalanceDetailModel.m
//  GaiaCLP
//
//  Created by Lee on 2022/7/28.
//

#import "DCBalanceDetailModel.h"

@implementation DCBalanceDetailItemModel

@end
@implementation DCBalanceDetailModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"balanceDetailList" : [DCBalanceDetailItemModel class],
    };
}

@end
