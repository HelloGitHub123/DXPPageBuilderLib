//
//  DCSubsBundleModel.h
//  DCPageBuilding
//
//  Created by lishan on 2024/6/5.
//

#import "DMBaseObject_PB.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCSubsBundleModel : DMBaseObject_PB

@property (nonatomic, copy) NSString *bundleSubsId;
@property (nonatomic, copy) NSString *bundleAccNbr;
@property (nonatomic, copy) NSString *bundleOfferName;
@property (nonatomic, copy) NSString *bundleOfferNbr;
@property (nonatomic, assign) BOOL isFirstRow;

@end

NS_ASSUME_NONNULL_END
