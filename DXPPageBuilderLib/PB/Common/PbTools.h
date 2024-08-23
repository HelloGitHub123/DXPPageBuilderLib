//
//  PbTools.h
//  PageBuilding
//
//  Created by 李标 on 2024/7/2.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PbTools : NSObject

+ (NSString *)numberFormatWithString:(NSString *)numberStr rule:(NSString *)serviceNbrBreakRule;

+ (NSString *)getFormattingUrl:(NSString *)urlString;

+ (NSString *)getDateFormatAppByProperty:(NSString *)dateStr;

+ (NSString *)getAmountWithScaleAndUnit:(NSString *)amount;

+ (NSString *)getStateNameWithstateName:(NSString *)stateName state:(NSString *)state paidFlag:(NSString *)paidFlag;

+ (UIColor *)getStateColorWithstate:(NSString *)state;

+ (BOOL)isContainSafariUrl:(NSString *)urlString;
@end

NS_ASSUME_NONNULL_END
