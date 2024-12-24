//
//  DCUserSubsDetailViewModel.h
//  GaiaCLP
//
//  Created by Lee on 2022/7/14.
//

#import "DMBaseObject_PB.h"
#import "DCSubsDetailModel.h"

static NSString * _Nullable const HJUserSubsDetail = @"HJUserSubsDetail";

NS_ASSUME_NONNULL_BEGIN

@interface DCUserSubsDetailViewModel : DMBaseObject_PB

@property (nonatomic, copy) NSString * errorMsg;

@property (nonatomic, weak) id<HJVMRequestDelegate_PB> delegate;

@property (nonatomic, strong) DCSubsDetailModel * subDetailModel;


- (void)getUserSubsDetailWithAccNbr:(NSString *)accNbr subsId:(NSString *)subsId prefix:(NSString *)prefix;

@end

NS_ASSUME_NONNULL_END
