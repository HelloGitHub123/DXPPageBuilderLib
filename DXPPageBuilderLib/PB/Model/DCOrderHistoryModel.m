//
//  DCOrderHistoryModel.m
//  GaiaCLP
//
//  Created by Lee on 2022/6/15.
//

#import "DCOrderHistoryModel.h"

@implementation DCTaxItemModel

@end
@implementation DCExrSubscriberItemModel

@end

@implementation DCExtDataInfoModel

+ (NSDictionary *)modelCustomPropertyMapper {
   // 将personId映射到key为id的数据字段
    return @{@"orderImsi":@"newImsi",
             @"orderIccid":@"newIccid"
    };
   // 映射可以设定多个映射字段
   //  return @{@"personId":@[@"id",@"uid",@"ID"]};
}

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"subscriberList" : [DCExrSubscriberItemModel class],
    };
}
@end



@implementation DCFeeInfoModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"taxList" : [DCTaxItemModel class],
    };
}
@end

@implementation DCAttrValueListItemModel

@end

@implementation DCOrderSkuListItemModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"attrValueList" : [DCAttrValueListItemModel class],
    };
}


@end

@implementation DCPromotionListItemModel

@end

@implementation DCDeliveryInfoModel

@end

@implementation DCOrderHistoryItemModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"orderSkuList" : [DCOrderSkuListItemModel class],
        @"promotionList" : [DCPromotionListItemModel class],
        @"orderSkuList" : [DCOrderSkuListItemModel class],
    };
}

@end


@implementation DCOrderHistoryModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"orderList" : [DCOrderHistoryItemModel class],
    };
}
@end
