//
//  DCBundleInfoModel.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/3/17.
//  BundleInfo  模型数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DCPBBalSummaryList,DCPBBundleSubsList;

typedef void(^DCBLMCompleteBlock)(id res, NSError *error);



@interface DCBundleInfoModel : NSObject
@property (nonatomic, copy) NSString *bundleType;
@property (nonatomic, strong) NSArray<DCPBBundleSubsList *> *bundleSubsList;


// 接口请求
+ (void)getBundleInfoComplete:(DCBLMCompleteBlock)complete;

// 设置权限
+ (void)setPurchasePrivSubsId:(NSString *)subsId principalSubsId:(NSString*)principalSubsId specialPurchaseFlag:(NSString *)specialPurchaseFlag  complete:(DCBLMCompleteBlock)complete;
@end


@interface DCPBBundleSubsList : NSObject
@property (nonatomic, copy) NSString *subsId;
@property (nonatomic, copy) NSString *prefix;
@property (nonatomic, copy) NSString *accNbr;
@property (nonatomic, copy) NSString *primaryFlag;
@property (nonatomic, copy) NSString *serviceType;
@property (nonatomic, copy) NSString *specialPurchaseFlag;
@property (nonatomic, strong) NSArray<DCPBBalSummaryList *> *balSummaryList;
@end


@interface DCPBBalSummaryList : NSObject

@property (nonatomic, copy) NSString *acctId;
@property (nonatomic, copy) NSString *balId;
@property (nonatomic, copy) NSString *consumeBalance;
@property (nonatomic, copy) NSString *currencySymbol;
@property (nonatomic, copy) NSString *formatConsumeBalance;
@property (nonatomic, copy) NSString *formatConsumeBalanceUnitName;
@property (nonatomic, copy) NSString *formatGrossBalance;
@property (nonatomic, copy) NSString *formatGrossBalanceUnitName;
@property (nonatomic, copy) NSString *formatRealBalance;
@property (nonatomic, copy) NSString *formatRealBalanceUnitName;
@property (nonatomic, copy) NSString *grossBalance;
@property (nonatomic, copy) NSString *precision;
@property (nonatomic, assign) NSInteger realBalance;
@property (nonatomic, copy) NSString *unitTypeCode;
@property (nonatomic, assign) NSInteger unitTypeId;
@end




NS_ASSUME_NONNULL_END
