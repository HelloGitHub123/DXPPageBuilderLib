//
//  DCBalanceModel.h
//  GaiaCLP
//
//  Created by mac on 2022/7/14.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCBalanceModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * acctId;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * formatBalance;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * effDate;
@property (nonatomic, copy) NSString * expDate;
@property (nonatomic, copy) NSString * lastUseDate;
@property (nonatomic, copy) NSString * unitTypeId;
@property (nonatomic, copy) NSString * acctResID;
@property (nonatomic, copy) NSString * acctResName;

@end

NS_ASSUME_NONNULL_END
