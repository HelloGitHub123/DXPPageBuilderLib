//
//  DCPageContentModel.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//

#import "DCPageContentModel.h"

@implementation DCPageContentModel

+(NSDictionary *)mj_objectClassInArray{
    return @{
        @"children" : [ChildrenItem class],
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ids":@"id",
    };
}
@end



@implementation Props

@end



@implementation ChildrenItem

+(NSDictionary *)mj_objectClassInArray{
    return @{
        @"children" : [SubChildrenItem class],
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ids":@"id",
    };
}
@end



@implementation SubProps

+(NSDictionary *)mj_objectClassInArray{
    return @{
        @"pictures" : [Pictures class],
        @"dataSource": [DataSource class],
        @"sheet1Pictures": [Sheet1Pictures class],
        @"sheet2Pictures": [Sheet2Pictures class],
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"autos":@"auto",
    };
}
@end



@implementation Sheet1Pictures

@end



@implementation Sheet2Pictures

@end




@implementation DataSource


@end




@implementation SubChildrenItem

@end




@implementation Pictures

@end
