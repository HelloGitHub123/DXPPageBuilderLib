//
//  DCOrderHistoryModel.h
//  GaiaCLP
//
//  Created by Lee on 2022/6/15.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN
@interface DCTaxItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * acctItemTypeId;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * acctItemTypeName;
@property (nonatomic, copy) NSString * precision;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * orderItemId;
@property (nonatomic, copy) NSString * displayAmount;
@end

@interface DCFeeInfoModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * base;
@property (nonatomic, copy) NSString * totalBeforeTax;
@property (nonatomic, copy) NSString * totalDisplay;
@property (nonatomic, copy) NSString * baseDisplay;
@property (nonatomic, copy) NSString * shipping;
@property (nonatomic, copy) NSString * shippingDisplay;
@property (nonatomic, copy) NSString * promotionTotal;
@property (nonatomic, copy) NSString * total;
@property (nonatomic, copy) NSString * taxTotal;
@property (nonatomic, strong) NSArray <DCTaxItemModel *>* taxList;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * taxTotalDisplay;
@property (nonatomic, copy) NSString * totalBeforeTaxDisplay;
@property (nonatomic, copy) NSString * promotionTotalDisplay;
@end

@interface DCAttrValueListItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * attrId;
@property (nonatomic, copy) NSString * attrName;
@property (nonatomic, copy) NSString * attrCode;
@property (nonatomic, copy) NSString * valueName;
@property (nonatomic, copy) NSString * attrValueSort;
@property (nonatomic, copy) NSString * attrValueId;
@property (nonatomic, copy) NSString * value;
@property (nonatomic, copy) NSString * oldValue;
@property (nonatomic, copy) NSString * oldValueName;

@end

@interface DCOrderSkuListItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * weight;
@property (nonatomic, strong) NSArray <DCAttrValueListItemModel *>*attrValueList;
@property (nonatomic, copy) NSString * skuCode;

@property (nonatomic, copy) NSString * volume;

@property (nonatomic, copy) NSString * skuId;

@property (nonatomic, copy) NSString * skuName;

@property (nonatomic, copy) NSString * rentPriceDisplay;

@property (nonatomic, copy) NSString * brief;

@property (nonatomic, copy) NSString * productId;

@property (nonatomic, copy) NSString * productType;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * quantity;
@property (nonatomic, copy) NSString * priceDisplay;
@property (nonatomic, copy) NSString * rentPrice;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * channelCatgId;
@property (nonatomic, strong) NSDictionary * extData;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * orderId;

@end

@interface DCPromotionListItemModel : DMBaseObject_PB

@end

@interface DCDeliveryInfoModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * postCode;
@property (nonatomic, copy) NSString * contactName;
@property (nonatomic, copy) NSString * addrPathName;
@property (nonatomic, copy) NSString * addressId;
@property (nonatomic, copy) NSString * stdAddrId;
@property (nonatomic, copy) NSString * addrDetail;
@property (nonatomic, copy) NSString * contactMobile;
@property (nonatomic, copy) NSString * isDefault;
@property (nonatomic, copy) NSString * addrPath;
@property (nonatomic, copy) NSString * stdAddrString;
@end

@interface DCExrSubscriberItemModel:DMBaseObject_PB
@property (nonatomic, copy) NSString * iccid;
@property (nonatomic, copy) NSString * prefix;
@property (nonatomic, copy) NSString * accNbr;
@end

@interface DCExtDataInfoModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * orderImsi;
@property (nonatomic, copy) NSString * orderIccid;
@property (nonatomic, copy) NSString * oldImsi;
@property (nonatomic, copy) NSString * oldIccid;
@property (nonatomic, copy) NSString * orderReasonId;
@property (nonatomic, strong) NSArray <DCExrSubscriberItemModel *>*  subscriberList;

@end

@interface DCOrderHistoryItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * msisdn;
@property (nonatomic, strong) DCFeeInfoModel * feeInfo;
@property (nonatomic, copy) NSString * updateDate;
@property (nonatomic, copy) NSString * eventTypeId;
@property (nonatomic, copy) NSString * eventTypeName;
@property (nonatomic, strong) NSArray <DCOrderSkuListItemModel *>*orderSkuList;
@property (nonatomic, strong) NSArray <DCPromotionListItemModel *>*promotionList;

@property (nonatomic, copy) NSString * orderType;
@property (nonatomic, copy) NSString * pickupInfo;
@property (nonatomic, copy) NSString * orderSource;
@property (nonatomic, copy) NSString * accNbr;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * stateName;
@property (nonatomic, copy) NSString * deliveryType;
@property (nonatomic, strong) DCDeliveryInfoModel * deliveryInfo;

@property (nonatomic, copy) NSString * subsId;
@property (nonatomic, copy) NSString * prefix;
@property (nonatomic, copy) NSString * orderNbr;
@property (nonatomic, copy) NSString * createdDate;
@property (nonatomic, strong) NSDictionary * extData;
@property (nonatomic, copy) NSString * paymentMethod;
@property (nonatomic, copy) NSString * totalAmountDisplay;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * totalAmount;
@property (nonatomic, copy) NSString * expireTime;

@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, copy) NSString * userId;

@end




@interface DCOrderHistoryModel : DMBaseObject_PB
@property (nonatomic, strong) NSArray <DCOrderHistoryItemModel *>*orderList;


@end

NS_ASSUME_NONNULL_END
