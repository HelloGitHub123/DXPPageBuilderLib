//
//  DCSendEmailOtpViewModel.h
//  MOC
//
//  Created by Lee on 2022/4/14.
//

#import <Foundation/Foundation.h>
#import "DMBaseObject_PB.h"

static NSString * _Nullable const userSendEmailOtp = @"userSendEmailOtp";


NS_ASSUME_NONNULL_BEGIN

@interface DCSendEmailOtpViewModel : DMBaseObject_PB
@property (nonatomic, weak) id<HJVMRequestDelegate_PB> delegate;

@property (nonatomic, copy) NSString * errorMsg;

//@property (nonatomic, strong) DCSubsListModel * subsListModel;

- (void)userSendEmailOtpRequest:(NSString *)email businessType:(NSString *)businessType;
@end

NS_ASSUME_NONNULL_END
