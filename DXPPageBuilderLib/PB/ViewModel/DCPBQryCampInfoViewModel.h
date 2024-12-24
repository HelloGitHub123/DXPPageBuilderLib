//
//  DCPBQryCampInfoViewModel.h
//  TMCLP
//
//  Created by Lee on 27.1.24.
//

#import "DMBaseObject_PB.h"

@class DCPBCampInfoItemModel;

#define kQryCampInfoUrl  @"/mccm-outerfront/dmc/mccm/market/MccMarketingController/qryCampInfo"
NS_ASSUME_NONNULL_BEGIN
static NSString * _Nullable const QryCampInfoStr = @"kQryCampInfoUrl";

@interface DCPBQryCampInfoViewModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * errorMsg;

@property (nonatomic, copy) NSString * resultCode;

@property (nonatomic, weak) id<HJVMRequestDelegate_PB> delegate;

@property (nonatomic, strong) NSMutableArray * campInfoArr;


/***
 *"adviceCode":"", //固定APP_POPUP
 *"identityType":"", //固定传2
 *"identityId":"", //传当前登录的订户id，
 *"channelCode":"APP",
 */
- (void)qryCampInfoWithAdviceCode:(NSString *)adviceCode identityType:(NSString *)identityType identityId:(NSString *)identityId channelCode:(NSString *)channelCode;


@end

@interface DCPBCampInfoItemModel : NSObject
@property (nonatomic, copy) NSString *accNbr;
@property (nonatomic, copy) NSString *batchId;
@property (nonatomic, copy) NSString *campaignCode;
@property (nonatomic, copy) NSString *campaignId;
@property (nonatomic, copy) NSString *campaignName;
@property (nonatomic, copy) NSString *clickAction;
@property (nonatomic, copy) NSString *creativeCode;
@property (nonatomic, copy) NSString *creativeType;
@property (nonatomic, copy) NSString *jumpLink;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *subsId;
@property (nonatomic, copy) NSString *thumbURL;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *showCloseButton;
@property (nonatomic, assign) float imgWidth;
@property (nonatomic, assign) float imgHeight;
@end

@interface DCPBCampInfoModel : NSObject


@end

NS_ASSUME_NONNULL_END
