//
//  NSString+DCSize.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/28.
//

#import "NSString+DCSize.h"

@implementation NSString (DCSize)
- (CGSize)hj_sizeContraintToSize:(CGSize)maxSize font:(UIFont *)font
{
    CGSize size = CGSizeZero;
    if (self.length == 0)
    {
        return size;
    }
    
    CGRect frame = [self boundingRectWithSize:maxSize
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName:font}
                                      context:nil];
    size = frame.size;
    
    return size;
}

- (CGFloat)hj_fitHeightWithFont:(UIFont *)font width:(CGFloat)width
{
    if (self.length == 0)
    {
        return 0;
    }
    CGFloat oneRowHeight = font.pointSize + 3;
    
    CGSize size = CGSizeZero;
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        CGRect frame = [self boundingRectWithSize:maxSize
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:font}
                                          context:nil];
        size = frame.size;
    }
    
    return MAX(size.height+1, oneRowHeight);
}

@end
