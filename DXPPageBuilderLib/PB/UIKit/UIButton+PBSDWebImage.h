//
//  UIButton+PBSDWebImage.h
//  TMCLP
//
//  Created by 蒙 on 2024/11/4.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (PBSDWebImage)

/*
 *  最全模式:自定义参数
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                        forState:(UIControlState)state
                placeholderImage:(nullable UIImage *)placeholder
                         options:(SDWebImageOptions)options
                       completed:(nullable SDExternalCompletionBlock)completedBlock;

/*
 *  简便模式:urlString+默认图片
 */
- (void)dc_setImageWithURL:(NSString *)urlString
                  forState:(UIControlState)state
          placeholderImage:(UIImage *)placeholder;


/*
 *  最简便模式:urlString
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                        forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
