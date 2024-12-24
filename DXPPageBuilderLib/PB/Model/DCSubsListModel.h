//
//  DCSubsListModel.h
//  MOC
//
//  Created by Lee on 2022/3/7.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN
@interface DCPBSubsItemModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * accNbr;
@property (nonatomic, copy) NSString * activeDate;
@property (nonatomic, copy) NSString * blockReason;
@property (nonatomic, copy) NSString * blockReasonName;
@property (nonatomic, copy) NSString * custId;
@property (nonatomic, copy) NSString * defaultAcctId;
@property (nonatomic, copy) NSString * defaultAcctNbr;
@property (nonatomic, copy) NSString * hasChild;
@property (nonatomic, copy) NSString * offerCode;
@property (nonatomic, copy) NSString * offerId;
@property (nonatomic, copy) NSString * offerInstId;
@property (nonatomic, copy) NSString * offerName;
@property (nonatomic, copy) NSString * offerNbr;
@property (nonatomic, copy) NSString * paidFlag;
@property (nonatomic, copy) NSString * parentSubsId;
@property (nonatomic, copy) NSString * prefix;
@property (nonatomic, copy) NSString * prodId;
@property (nonatomic, copy) NSString * prodName;
@property (nonatomic, copy) NSString * serviceType;
@property (nonatomic, copy) NSString * serviceTypeName;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * stateDate;
@property (nonatomic, copy) NSString * stateName;
@property (nonatomic, copy) NSString * subsExtMap;
@property (nonatomic, copy) NSString * subsId;
@property (nonatomic, copy) NSString * useCustId;
@property (nonatomic, copy) NSString * serviceTypeCode;
@property (nonatomic, copy) NSString *primaryFlag;
@property (nonatomic, copy) NSString *relatedOfferCode;
@property (nonatomic, copy) NSString *fixedFlag;


@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL isLastRow;
@property (nonatomic, assign) BOOL isFirstRow;
@property (nonatomic,copy) NSString *iccid;
@property (nonatomic,copy) NSString *mainOfferCode;
@end

@interface DCSubsBundleListModel : DMBaseObject_PB
@property (nonatomic, strong) NSArray <DCPBSubsItemModel *>* subsList;
@property (nonatomic, copy) NSString *bundleSubsId;
@property (nonatomic, copy) NSString *bundleAccNbr;
@property (nonatomic, copy) NSString *bundleOfferName;
@property (nonatomic, copy) NSString *bundleOfferNbr;

@end


@interface DCSubsListModel : DMBaseObject_PB
@property (nonatomic, strong) NSArray <DCPBSubsItemModel *>* subsList;
@property (nonatomic, strong) NSArray <DCSubsBundleListModel *>* bundleSubsList;

@end

NS_ASSUME_NONNULL_END
