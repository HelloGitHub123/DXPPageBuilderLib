//
//  DCSubsDetailModel.m
//  GaiaCLP
//
//  Created by Lee on 2022/7/14.
//

#import "DCSubsDetailModel.h"
@implementation PBInternetInfo

@end

@implementation PBOfferInsItemModel

@end

@implementation PBProdInstsItemModel

@end

@implementation PBAttrItem

@end

@implementation DCInstallationAddrInfo

@end

@implementation DCSubsDetailModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"offerInsList" : [PBOfferInsItemModel class],
        @"prodInstsList" : [PBProdInstsItemModel class],
        @"orderedPackageList" : [PBOfferInsItemModel class],
        @"orderedServiceList" : [PBProdInstsItemModel class],
        @"attrList":[PBAttrItem class]
    };
}

@end


@implementation DCPBOrderedPackageModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"orderedPackageList" : [PBOfferInsItemModel class],
    };
}

@end

@implementation DCPBOrderedServiceModel
+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass {
    return @{
        @"orderedServiceList" : [PBProdInstsItemModel class],
    };
}

@end


