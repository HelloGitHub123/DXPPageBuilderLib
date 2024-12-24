//
//  DCMainBalanceSummaryViewModel.h
//  GaiaCLP
//
//  Created by Lee on 2022/7/28.
//

#import "DMBaseObject_PB.h"
#import "DCMainBalanceSummaryModel.h"

static NSString * _Nullable const DCBalanceSummary = @"DCBalanceSummary";

NS_ASSUME_NONNULL_BEGIN

@interface DCMainBalanceSummaryViewModel : DMBaseObject_PB
@property (nonatomic, copy) NSString * errorMsg;

@property (nonatomic, weak) id<HJVMRequestDelegate_PB> delegate;

@property (nonatomic, strong)  DCMainBalanceSummaryModel * balanceSummaryModel;

//- (void)getMainBalanceSummaryListWithPrefix:(NSString *)prefix accNbr:(NSString *)accNbr subsId:(NSString *)subsId;

// defaultAcctId 传 [HJGlobalDataManager shareInstance].selectedSubsModel.defaultAcctId
// defaultAcctNbr 传 [HJGlobalDataManager shareInstance].selectedSubsModel.defaultAcctNbr
- (void)getMainBalanceSummaryListWithPrefix:(NSString *)prefix accNbr:(NSString *)accNbr subsId:(NSString *)subsId defaultAcctId:(NSString *)defaultAcctId defaultAcctNbr:(NSString *)defaultAcctNbr;




// defaultAcctId 传 [HJGlobalDataManager shareInstance].selectedSubsModel.defaultAcctId
// defaultAcctNbr 传 [HJGlobalDataManager shareInstance].selectedSubsModel.defaultAcctNbr
+ (void)getMainBalanceSummaryListWithPrefix:(NSString *)prefix
									 accNbr:(NSString *)accNbr
									 subsId:(NSString *)subsId
							  defaultAcctId:(NSString *)defaultAcctId
							 defaultAcctNbr:(NSString *)defaultAcctNbr
							  completeBlock:(void (^)(bool success, DCMainBalanceSummaryModel *balanceSummaryModel))completeBlock;

//+ (void)getMainBalanceSummaryListWithPrefix:(NSString *)prefix
//                                     accNbr:(NSString *)accNbr
//                                     subsId:(NSString *)subsId
//                              completeBlock:(void (^)(bool success, DCMainBalanceSummaryModel *balanceSummaryModel))completeBlock;

@end

NS_ASSUME_NONNULL_END
