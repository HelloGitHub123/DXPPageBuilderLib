//
//  UIColor+DCPCategory.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2022/10/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DCPCategory)

/**
 16进制的颜色值转换
 
 @param hex 16进制颜色值
 @return color
 */
+ (UIColor *)hjp_colorWithRGBHex:(NSString *)hex;

/**
 16进制的颜色值转换 带透明度

 @param hex 16进制颜色值 带透明度
 @return color
 */
+ (UIColor *)hjp_colorWithARGBHex:(NSString *)hex;

/**
  16进制的颜色值转换 带透明度

 @param hex 16进制颜色值
 @param alpha 透明度
 @return color
 */
+ (UIColor *)hjp_colorWithHex:(NSString *)hex alpha:(float)alpha;

/**
 16进制的颜色值转换
@param hex 16进制颜色值
@return color
*/
+ (UIColor *)hjp_colorWithHex:(NSString *)hex;

// 十进制的UIColor转化
+ (UIColor *)hjp_colorWithIntString:(NSString *)colorString;

/**
 转化rgb格式字符串的颜色

 @param str 255,255,255
 @return color
 */
+ (UIColor *)hjp_colorWithRGBStrig:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
