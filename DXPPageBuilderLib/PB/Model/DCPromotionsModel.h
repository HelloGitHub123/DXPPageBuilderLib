//
//  DCPromotionsModel.h
//  DXPPageBuilderLib
//
//  Created by 李标 on 2024/11/29.
//

#import <Foundation/Foundation.h>
#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN
@class DCDataItemModel;
@class RecommendedWordsItem;
@class OfferItem;
@class DescriptionItem;
@class PredictionRewardItem;
@class TagItem;
@class OfferGroupItem;
@class OfferGroupSubItem;
@class LimitedPayMethodItem;
@class LimitedThirdPayMethodItem;
@class PaymentMethodItem;

@interface DCDataItemModel : DMBaseObject_PB

@property (nonatomic, strong) NSString *subsId;
@property (nonatomic, strong) NSString *serviceNumber;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *adSlot;
@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *batchId;
@property (nonatomic, strong) NSString *batchCode;
@property (nonatomic, strong) NSString *campaignCode;
@property (nonatomic, strong) NSString *campaignName;
@property (nonatomic, strong) NSString *campaignDescription;
@property (nonatomic, strong) NSString *campaignPriority;
@property (nonatomic, strong) NSString *projectCode;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSArray <RecommendedWordsItem *>*recommendedWordsList;
@property (nonatomic, strong) NSArray <OfferItem *>*offerList;
@property (nonatomic, strong) NSArray <OfferGroupItem *>*offerGroupList;
@property (nonatomic, strong) NSArray <LimitedPayMethodItem *>*limitedPayMethodList;
@end

@interface RecommendedWordsItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *recommendedWordsType;
@property (nonatomic, strong) NSString *recommendedTitle;
@property (nonatomic, strong) NSString *recommendedSubTitle;
@property (nonatomic, strong) NSString *recommendedWords;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *clickAction;
@property (nonatomic, strong) NSString *jumpLink;
@property (nonatomic, strong) NSString *linkType;
@property (nonatomic, strong) NSString *creativeCode;
@property (nonatomic, strong) NSString *creativeType;
@property (nonatomic, strong) NSString *serverUrl;
@property (nonatomic, strong) NSString *showCloseButton;
@end

@interface OfferItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *rewardId;
@property (nonatomic, strong) NSString *rewardName;
@property (nonatomic, strong) NSString *rewardDescription;
@property (nonatomic, strong) NSString *rewardUrl;
@property (nonatomic, strong) NSString *rewardType;
@property (nonatomic, strong) NSString *offerType;
@property (nonatomic, strong) NSString *offerNbr;
@property (nonatomic, strong) NSString *offerName;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *validityPeriod;
@property (nonatomic, strong) NSString *validityPeriodUnitType;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *rentPrice;
@property (nonatomic, strong) NSString *rentPriceInt;
@property (nonatomic, strong) NSString *rentDuration;
@property (nonatomic, strong) NSString *rentUnitType;
@property (nonatomic, strong) NSString *contactId;
@property (nonatomic, strong) NSString *salesPrice;
@property (nonatomic, strong) NSString *salesPriceInt;
@property (nonatomic, strong) NSString *discountPrice;
@property (nonatomic, strong) NSString *discountPriceInt;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, strong) NSString *discountValueInt;
@property (nonatomic, strong) NSString *remainQuantity;
@property (nonatomic, strong) NSString *expDate;
@property (nonatomic, strong) NSString *recommendOffer;
@property (nonatomic, strong) NSArray <DescriptionItem *>*descriptionList;
@property (nonatomic, strong) NSArray <PredictionRewardItem *>*predictionRewardList;


@end

@interface DescriptionItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSArray <TagItem *>*tagList;
@end

@interface TagItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *tagCode;
@property (nonatomic, strong) NSString *tagName;
@end


@interface PredictionRewardItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *rewardType;
@property (nonatomic, strong) NSString *acctType;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSString *valueUnitDisplay;
@end


@interface OfferGroupItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *offerGroupName;
@property (nonatomic, strong) NSString *offerGroupDescription;
@property (nonatomic, strong) NSString *offerGroupUrl;
@property (nonatomic, strong) NSString *offerGroupImgTips;
@property (nonatomic, strong) NSArray <OfferGroupSubItem *>*offerList;
@end

@interface OfferGroupSubItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *rewardId;
@property (nonatomic, strong) NSString *rewardName;
@property (nonatomic, strong) NSString *rewardDescription;
@property (nonatomic, strong) NSString *rewardUrl;
@property (nonatomic, strong) NSString *rewardType;
@property (nonatomic, strong) NSString *offerType;
@property (nonatomic, strong) NSString *offerNbr;
@property (nonatomic, strong) NSString *offerName;
@property (nonatomic, strong) NSString *brief;
@property (nonatomic, strong) NSString *validityPeriod;
@property (nonatomic, strong) NSString *validityPeriodUnitType;
@property (nonatomic, strong) NSString *thumbnail;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *rentPrice;
@property (nonatomic, strong) NSString *rentPriceInt;
@property (nonatomic, strong) NSString *rentDuration;
@property (nonatomic, strong) NSString *rentUnitType;

@property (nonatomic, strong) NSString *salesPrice;
@property (nonatomic, strong) NSString *salesPriceInt;
@property (nonatomic, strong) NSString *discountPrice;
@property (nonatomic, strong) NSString *discountPriceInt;
@property (nonatomic, strong) NSString *discountType;
@property (nonatomic, strong) NSString *discountValueInt;
@property (nonatomic, strong) NSString *remainQuantity;
@property (nonatomic, strong) NSString *expDate;
@property (nonatomic, strong) NSString *recommendOffer;
@property (nonatomic, strong) NSArray <DescriptionItem *>*descriptionList;
@property (nonatomic, strong) NSArray <PredictionRewardItem *>*predictionRewardList;
@end


@interface LimitedPayMethodItem : DMBaseObject_PB

@property (nonatomic, strong) NSArray <PaymentMethodItem *>*paymentMethodList;
@property (nonatomic, strong) NSArray <LimitedThirdPayMethodItem *>*thirdPayMethodList;
@end


@interface PaymentMethodItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *paymentMethodId;
@end


@interface LimitedThirdPayMethodItem : DMBaseObject_PB

@property (nonatomic, strong) NSString *thirdPayMethodId;
@property (nonatomic, strong) NSString *thirdPayChannelId;
@end


@interface DCPromotionsModel : DMBaseObject_PB

@property (nonatomic, strong) NSArray <DCDataItemModel *>*data;
@end

NS_ASSUME_NONNULL_END
