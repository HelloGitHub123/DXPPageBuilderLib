//
//  UIColor+DCPCategory.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2022/10/25.
//

#import "UIColor+DCPCategory.h"

@implementation UIColor (DCPCategory)

+ (UIColor *)hjp_colorWithRGBHex:(NSString *)hex{
    return [UIColor hjp_colorWithHex:hex alpha:1.0f];
}

+ (UIColor *)hjp_colorWithARGBHex:(NSString *)hex
{
    
    NSString *colorString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if (colorString.length == 9)
    {
        if ([colorString hasPrefix:@"#"])
        {
            colorString = [colorString substringFromIndex:1];
        }
        else
        {
            return [UIColor clearColor];
        }
    }
    else
    {
        return [UIColor clearColor];
    }
    // 获取透明度
    NSRange alphaRange = NSMakeRange(0, 2);
    NSString *alphaString = [colorString substringWithRange:alphaRange];
    unsigned int a;
    [[NSScanner scannerWithString:alphaString] scanHexInt:&a];
    return [UIColor hjp_colorWithHex:[colorString substringFromIndex:2] alpha:(a/255.0)];
}

+ (UIColor *)hjp_colorWithHex:(NSString *)hex {
    return [self hjp_colorWithHex:hex alpha:1];
}

// 可变透明度的Hex方法
+ (UIColor *)hjp_colorWithHex:(NSString *)hex alpha:(float)alpha
{
    NSString *colorString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // 十六进制色值必须是6-8位
    if (colorString.length >= 6  && colorString.length  <= 8)
    {
        if ([colorString hasPrefix:@"0x"] || [colorString hasPrefix:@"0X"])
            colorString = [colorString substringFromIndex:2];
        else if ([colorString hasPrefix:@"#"])
            colorString = [colorString substringFromIndex:1];
        if (colorString.length != 6)
            return [UIColor clearColor];
    }
    else
        return [UIColor clearColor];
    
    // 将6位十六进制色值分成R、G、B
    NSRange redRange    = NSMakeRange(0, 2);
    NSRange greenRange  = NSMakeRange(2, 2);
    NSRange blueRange   = NSMakeRange(4, 2);
    NSString *redString     = [colorString substringWithRange:redRange];
    NSString *greenString   = [colorString substringWithRange:greenRange];
    NSString *blueString    = [colorString substringWithRange:blueRange];
    
    // 将RGB对应的十六进制色值转化位十进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redString]    scanHexInt:&r];
    [[NSScanner scannerWithString:greenString]  scanHexInt:&g];
    [[NSScanner scannerWithString:blueString]   scanHexInt:&b];
    
    return [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:alpha];
}

+ (UIColor *)hjp_colorWithIntString:(NSString *)colorString
{
    int colorInt=[colorString intValue];
    if(colorInt<0)
        return [UIColor whiteColor];
    
    NSString *nLetterValue;
    NSString *colorString16 =@"";
    int ttmpig;
    for (int i = 0; i<9; i++)
    {
        ttmpig=colorInt%16;
        colorInt=colorInt/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        colorString16 = [nLetterValue stringByAppendingString:colorString16];
        if (colorInt == 0)
            break;
    }
    
    colorString16 = [[colorString16 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString]; //去掉前后空格换行符
    
    // strip 0X if it appears
    if ([colorString16 hasPrefix:@"0X"])
        colorString16 = [colorString16 substringFromIndex:2];
    if ([colorString16 hasPrefix:@"#"])
        colorString16 = [colorString16 substringFromIndex:1];
    // String should be 6 or 8 characters
    if ([colorString16 length] < 6)
    {
        int cc=6-[colorString16 length] ;
        for (int i=0; i<cc; i++)
            colorString16=[@"0" stringByAppendingString:colorString16];
    }
    if ([colorString16 length] != 6)
        return [UIColor whiteColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [colorString16 substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [colorString16 substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [colorString16 substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];  //扫描16进制到int
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)hjp_colorWithRGBStrig:(NSString *)str
{
    NSArray *arrColor = [str componentsSeparatedByString:@","];
    UIColor *color = nil;
    if (arrColor.count >= 3)
    {
        NSString *strRed;
        NSString *strGreen;
        NSString *strBlue;
        NSString *strAlpha;
        CGFloat red = 0.0;
        CGFloat green = 0.0;
        CGFloat blue = 0.0;
        CGFloat alpha = 1.0;
        strRed = arrColor[0]?:nil;
        red = strRed?[strRed floatValue]:0.0;
        
        strGreen = arrColor[1]?:nil;
        green = strGreen?[strGreen floatValue]:0.0;
        
        strBlue = arrColor[2]?:nil;
        blue = strBlue?[strBlue floatValue]:0.0;
        
        if (arrColor.count == 4)
        {
            strAlpha = arrColor[3]?:nil;
            alpha = strAlpha?[strAlpha floatValue]:1.0;
        }
        
        color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
    }
    return color;
}

@end
