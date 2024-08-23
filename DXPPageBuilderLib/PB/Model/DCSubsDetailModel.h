//
//  DCSubsDetailModel.h
//  GaiaCLP
//
//  Created by Lee on 2022/7/14.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN

@interface PBInternetInfo : DMBaseObject_PB
@property (nonatomic, copy) NSString *downlinkRate;
@property (nonatomic, copy) NSString *downlinkRateDisplay;
@property (nonatomic, copy) NSString *uplinkRate;
@property (nonatomic, copy) NSString *uplinkRateDisplay;
@end

@interface PBOfferInsItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * appointmentActivationDate;
@property (nonatomic, copy) NSString * offerName;
@property (nonatomic, copy) NSString * stateName;
@property (nonatomic, copy) NSString * effDate;
@property (nonatomic, copy) NSString * displayOtcPrice;
@property (nonatomic, copy) NSString * stateDate;
@property (nonatomic, copy) NSString * brief;
@property (nonatomic, copy) NSString * thumbImageUrl;
@property (nonatomic, copy) NSString * offerDesc;
@property (nonatomic, copy) NSString * otcPrice;
@property (nonatomic, copy) NSString * guidingPrice;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * displayRentPrice;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * nextRentCollectionDate;
@property (nonatomic, copy) NSString * subsId;
@property (nonatomic, copy) NSString * appointmentDeactivationDate;
@property (nonatomic, copy) NSString * rentPrice;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * offerType;
@property (nonatomic, copy) NSString * actType;
@property (nonatomic, copy) NSString * lastRentCollectionDate;
@property (nonatomic, copy) NSString * remarks;
@property (nonatomic, copy) NSString * offerId;
@property (nonatomic, copy) NSString * expDate;
@property (nonatomic, copy) NSString * offerCode;
@property (nonatomic, copy) NSString * displayGuidingPrice;
@property (nonatomic, copy) NSString * offerInstId;

@end

@interface PBProdInstsItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * stateName;
@property (nonatomic, copy) NSString * effDate;
@property (nonatomic, copy) NSString * prodCode;
@property (nonatomic, copy) NSString * displayOtcPrice;
@property (nonatomic, copy) NSString * stateDate;
@property (nonatomic, copy) NSString * prodName;
@property (nonatomic, copy) NSString * brief;
@property (nonatomic, copy) NSString * prodDesc;
@property (nonatomic, copy) NSString * thumbImageUrl;
@property (nonatomic, copy) NSString * itemRole;
@property (nonatomic, copy) NSString * otcPrice;
@property (nonatomic, copy) NSString * prodInstDesc;
@property (nonatomic, copy) NSString * prodId;
@property (nonatomic, copy) NSString * guidingPrice;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, copy) NSString * displayRentPrice;
@property (nonatomic, copy) NSString * prodInstId;
@property (nonatomic, copy) NSString * subsId;
@property (nonatomic, copy) NSString * rentPrice;
@property (nonatomic, copy) NSString * currencySymbol;
@property (nonatomic, copy) NSString * actType;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, copy) NSString * prodType;
@property (nonatomic, copy) NSString * expDate;
@property (nonatomic, copy) NSString * appointmentActivationDate;
@property (nonatomic, copy) NSString * displayGuidingPrice;
@end

@interface PBAttrItem : DMBaseObject_PB

@property (nonatomic, copy) NSString *attrCode;
@property (nonatomic, copy) NSString *attrId;
@property (nonatomic, copy) NSString *attrName;
@property (nonatomic, copy) NSString *attrValueId;
@property (nonatomic, copy) NSString *oldValue;
@property (nonatomic, copy) NSString *oldValueName;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *valueName;
@end

@interface DCInstallationAddrInfo : DMBaseObject_PB
@property (nonatomic, copy) NSString *addrDetail;
@property (nonatomic, copy) NSString *addrExtMap;
@property (nonatomic, copy) NSString *address1;
@property (nonatomic, copy) NSString *address2;
@property (nonatomic, copy) NSString *contactEmail;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactNbr;
@property (nonatomic, copy) NSString *custAddressId;
@property (nonatomic, copy) NSString *defaultFlag;
@property (nonatomic, copy) NSString *displayAddr;
@property (nonatomic, copy) NSString *landmark;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *stdAddrId;
@property (nonatomic, copy) NSString *stdAddrName;
@property (nonatomic, copy) NSString *stdAddrNbr;
@end

@interface DCSubsDetailModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * offerName;
@property (nonatomic, copy) NSString * paidFlag;
@property (nonatomic, copy) NSString * stateName;
@property (nonatomic, copy) NSString * imsi;
@property (nonatomic, copy) NSString * stateDate;
@property (nonatomic, copy) NSString * defaultAcctId;
@property (nonatomic, copy) NSString * custId;
@property (nonatomic, copy) NSString * activeDate;
@property (nonatomic, copy) NSString * prodId;
@property (nonatomic, copy) NSString * accNbr;
@property (nonatomic, copy) NSString * useCustId;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * defaultAcctNbr;
@property (nonatomic, copy) NSString * subsId;
@property (nonatomic, copy) NSString * blockReason;
@property (nonatomic, copy) NSString * prefix;
@property (nonatomic, copy) NSString * serviceType;
@property (nonatomic, copy) NSString * parentSubsId;
@property (nonatomic, copy) NSString * offerNbr;
@property (nonatomic, copy) NSString * primaryFlag;
@property (nonatomic, copy) NSString * blockReasonName;
@property (nonatomic, copy) NSString * offerId;
@property (nonatomic, copy) NSString * serviceTypeName;
@property (nonatomic, copy) NSString * offerCode;
@property (nonatomic, copy) NSString * iccid;
@property (nonatomic, copy) NSString * offerInstId;
@property (nonatomic, copy) NSString * offerExpDate;
@property (nonatomic, copy) NSString * agreementExpDate;

@property (nonatomic, strong) PBInternetInfo *internetInfo;
@property (nonatomic, strong) DCInstallationAddrInfo *installationAddrInfo;
@property (nonatomic, strong) NSArray <PBOfferInsItemModel *>*offerInsList;
@property (nonatomic, strong) NSArray <PBProdInstsItemModel *>*prodInstsList;
@property (nonatomic, strong) NSArray <PBOfferInsItemModel *>*orderedPackageList;
@property (nonatomic, strong) NSArray <PBOfferInsItemModel *>*orderedServiceList;
@property (nonatomic, strong) NSArray <PBAttrItem *>*attrList;
@end


@interface DCPBOrderedPackageModel : DMBaseObject_PB

@property (nonatomic, strong) NSArray <PBOfferInsItemModel *>*orderedPackageList;

@end

@interface DCPBOrderedServiceModel : DMBaseObject_PB

@property (nonatomic, strong) NSArray <PBOfferInsItemModel *>*orderedServiceList;
@end

NS_ASSUME_NONNULL_END
