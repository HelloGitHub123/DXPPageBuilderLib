//
//  DCPageModel.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//

#import "DCPageModel.h"

@implementation DCPageModel
+(NSDictionary *)mj_objectClassInArray {
    return @{
        @"pageCompositionList" : [PageCompositionItem class],
    };
}
@end


@implementation PageCompositionItem

@end
