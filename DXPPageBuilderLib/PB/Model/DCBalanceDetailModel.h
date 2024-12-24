//
//  HJBalanceDetailModel.h
//  GaiaCLP
//
//  Created by Lee on 2022/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface DCBalanceDetailItemModel : NSObject
@property (nonatomic, copy) NSString * balId;
@property (nonatomic, copy) NSString * consumeBalance;
@property (nonatomic, copy) NSString * acctResId;
@property (nonatomic, copy) NSString * unitName;
@property (nonatomic, copy) NSString * formatRealBalanceUnitName;
@property (nonatomic, copy) NSString * formatConsumeBalance;
@property (nonatomic, copy) NSString * effDate;
@property (nonatomic, copy) NSString * acctResCode;
@property (nonatomic, copy) NSString * formatGrossBalance;
@property (nonatomic, copy) NSString * balType;
@property (nonatomic, copy) NSString * offerInstId;
@property (nonatomic, copy) NSString * unlimitedFlag;
@property (nonatomic, copy) NSString * unitTypeCode;
@property (nonatomic, copy) NSString * glName;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * glId;
@property (nonatomic, copy) NSString * prodInstId;
@property (nonatomic, copy) NSString * realBalance;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * unitTypeId;
@property (nonatomic, copy) NSString * formatConsumeBalanceUnitName;
@property (nonatomic, copy) NSString * grossBalance;
@property (nonatomic, copy) NSString * acctId;
@property (nonatomic, copy) NSString * formatGrossBalanceUnitName;
@property (nonatomic, copy) NSString * expDate;
@property (nonatomic, copy) NSString * precision;
@property (nonatomic, copy) NSString * formatRealBalance;
@property (nonatomic, copy) NSString * acctResName;

@property (nonatomic, copy) NSString * formatRealBalanceWithUnit;
@property (nonatomic, copy) NSString * formatGrossBalanceWithUnit;
@property (nonatomic, copy) NSString * formatConsumeBalanceWithUnit;


@end

@interface DCBalanceDetailModel : NSObject

@property (nonatomic, strong) NSArray <DCBalanceDetailItemModel *>*balanceDetailList;
@end

NS_ASSUME_NONNULL_END
