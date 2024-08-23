//
//  NSString+DCSize.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/28.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DCSize)

/**
 *  求字符串占据的宽高
 *
 *  @param maxSize 设置默认的宽高
 *  @param font    字体
 *
 *  @return 实际宽高
 */
- (CGSize)hj_sizeContraintToSize:(CGSize)maxSize font:(UIFont *)font;

/**
 *  求字符串占据的宽高
 *
 *  @param maxSize    设置默认的宽高
 *  @param font       字体
 *  @param lineSpcing 行间距
 *  @param paragraphSpacing 段落间距
 *
 *  @return 实际宽高
 */
- (CGSize)hj_sizeContraintToSize:(CGSize)maxSize font:(UIFont *)font lineSpacing:(CGFloat)lineSpcing paragraphSpacing:(CGFloat)paragraphSpacing;

@end

NS_ASSUME_NONNULL_END
