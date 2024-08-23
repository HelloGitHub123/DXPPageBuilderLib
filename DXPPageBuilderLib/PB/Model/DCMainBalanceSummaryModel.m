//
//  DCMainBalanceSummaryModel.m
//  GaiaCLP
//
//  Created by Lee on 2022/7/28.
//

#import "DCMainBalanceSummaryModel.h"


@implementation DCMainBalanceSummaryItemModel

@end
@implementation DCMainBalanceSummaryModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"balanceSummaryList" : [DCMainBalanceSummaryItemModel class],
    };
}

@end
