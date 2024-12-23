//
//  DCPromotionsModel.m
//  DXPPageBuilderLib
//
//  Created by 李标 on 2024/11/29.
//

#import "DCPromotionsModel.h"

@implementation DCDataItemModel

+ (NSDictionary *)mj_objectClassInArray {
	return @{
		@"recommendedWordsList":@"RecommendedWordsItem",
		@"offerList":@"OfferItem",
	};
}
@end


@implementation RecommendedWordsItem


@end

@implementation OfferItem

+ (NSDictionary *)mj_objectClassInArray {
	return @{
		@"descriptionList":@"DescriptionItem",
		@"predictionRewardList":@"PredictionRewardItem",
	};
}

@end

@implementation DescriptionItem

+ (NSDictionary *)mj_objectClassInArray {
	return @{
		@"tagList":@"TagItem"
	};
}

@end

@implementation TagItem

@end

@implementation PredictionRewardItem


@end


@implementation OfferGroupItem

+ (NSDictionary *)mj_objectClassInArray {
	return @{
		@"offerList":@"OfferGroupSubItem"
	};
}

@end

@implementation OfferGroupSubItem

@end


@implementation LimitedPayMethodItem

+ (NSDictionary *)mj_objectClassInArray {
	return @{
		@"paymentMethodList":@"PaymentMethodItem",
		@"thirdPayMethodList":@"ThirdPayMethodItem"
	};
}

@end


@implementation LimitedThirdPayMethodItem

@end


@implementation PaymentMethodItem

@end

@implementation DCPromotionsModel

+ (NSDictionary *)mj_objectClassInArray {
	return @{
		@"data":@"DCDataItemModel",
	};
}


@end
