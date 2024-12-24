//
//  HJDitoProgress.h
//  DITOApp
//
//  Created by 孙全民 on 2022/7/20.
//

#import <UIKit/UIKit.h>
#import "DCFloorEventModel.h"
#import "DCPageCompositionContentModel.h"


NS_ASSUME_NONNULL_BEGIN
@interface HJDitoProgressModel : NSObject
@property (nonatomic, copy) NSString *primaryColor; // 主色调

@property (nonatomic, copy) NSString *type; //DATA SMS  VOICE

@property (nonatomic, copy) NSString *gross; // 进度条
@property (nonatomic, copy) NSString *grossUnit; //GB

@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *balanceUnit; // GB
@property (nonatomic, copy) NSString *expire; // Available Data

@property (nonatomic, copy) NSString *des;
@property (nonatomic, copy) NSString *btnName; // 统计name
@property (nonatomic, assign) CGFloat progress; // Available Data
@property (nonatomic, copy) NSString *noDataStr; // 没有流量统计

@property (nonatomic, assign) bool statusActive; // 是否是激活状态,非激活状态颜色权威黑色

@property (nonatomic, copy) NSString *realBalance;
@property (nonatomic, copy) NSString *grossBalance;

// 默认初始化
- (instancetype)initWithGross:(NSString*)gross
                    grossUnit:(NSString*)grossUnit
                      balance:(NSString*)balance
                  balanceUnit:(NSString*)balanceUnit
                         type:(NSString*)type
                       expire:(NSString*)expire  // key
                          des:(NSString*)des     // key7
                      btnName:(NSString*)btnName;  // key8

// 添加 noDataStr
- (instancetype)initWithGross:(NSString*)gross
                    grossUnit:(NSString*)grossUnit
                      balance:(NSString*)balance
                  balanceUnit:(NSString*)balanceUnit
                         type:(NSString*)type
                       expire:(NSString*)expire  // key
                          des:(NSString*)des     // key7
                      btnName:(NSString*)btnName  // key8
                    noDataStr:(NSString*)noDataStr;

- (instancetype)initWithGross:(NSString*)gross  // Y 代表无限量
					grossUnit:(NSString*)grossUnit
					  balance:(NSString*)balance
				  balanceUnit:(NSString*)balanceUnit
						 type:(NSString*)type
					   expire:(NSString*)expire
						  des:(NSString*)des
					  btnName:(NSString*)btnName
				  realBalance:(NSString *)realBalance
				 grossBalance:(NSString *)grossBalance;
@end

// 固定宽高
//static CGFloat HJDitoProgressW = 130.0;
//static CGFloat HJDitoProgressH = 110.0;

static CGFloat HJDitoProgressW = 130;
static CGFloat HJDitoProgressH = 92.0;

@interface HJDitoProgress : UIView
- (instancetype)initWithFrame:(CGRect)frame primaryColor:(NSString*)primaryColorStr;
- (void)updateWithModel:(HJDitoProgressModel*)model props:(NSDictionary *)propsDic;


// 点击事件
@property (nonatomic, copy) void(^tapInfoAction)(UIView *tapView, NSString *desc);
@property (nonatomic, copy) void(^buyPromoAction)(DCFloorEventModel *eventModel);

@end

NS_ASSUME_NONNULL_END
