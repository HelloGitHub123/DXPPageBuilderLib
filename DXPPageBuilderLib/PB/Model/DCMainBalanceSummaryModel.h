//
//  DCMainBalanceSummaryModel.h
//  GaiaCLP
//
//  Created by Lee on 2022/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCMainBalanceSummaryItemModel : NSObject
@property (nonatomic, copy) NSString * formatConsumeBalanceUnitName;
@property (nonatomic, copy) NSString * consumeBalance;
@property (nonatomic, copy) NSString * unitTypeId;
@property (nonatomic, copy) NSString * unitTypeCode;
@property (nonatomic, copy) NSString * acctId;
@property (nonatomic, copy) NSString * formatGrossBalance;

@property (nonatomic, copy) NSString * formatRealBalanceUnitName;
@property (nonatomic, copy) NSString * balId;
@property (nonatomic, copy) NSString * realBalance;
@property (nonatomic, copy) NSString * formatConsumeBalance;
@property (nonatomic, copy) NSString * formatRealBalance;
@property (nonatomic, copy) NSString * formatGrossBalanceUnitName;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * precision;
@property (nonatomic, copy) NSString * grossBalance;
@property (nonatomic, copy) NSString * unlimitedFlag;


// 非接口数据，流量钱页面需要的字段
@property (nonatomic, copy) NSString *valueStr;
@property (nonatomic, copy) NSString *totalStr;

// 另
@property (nonatomic, copy) NSString *temp; // 备注
@end

@interface DCMainBalanceSummaryModel : NSObject

@property (nonatomic, strong) NSArray <DCMainBalanceSummaryItemModel *>*balanceSummaryList;


@end

NS_ASSUME_NONNULL_END
