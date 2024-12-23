//
//  UIImageView+PBSDWebImage.h
//  TMCLP
//
//  Created by 蒙 on 2024/11/1.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (PBSDWebImage)

/*
 *  最全模式:自定义参数
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                placeholderImage:(UIImage *)placeholder
                         options:(SDWebImageOptions)options
                       completed:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL))completed;

/*
 *  简便模式:urlString+默认图片
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                placeholderImage:(UIImage *)placeholder;

/*
 *  最简便模式:urlString
 */
- (void)dc_setImageWithURLString:(NSString *)urlString;

- (void)dc_setImageWithURLString:(NSString *)urlString
					placeholderImage:(nullable UIImage *)placeholder
					   completed:(nullable SDExternalCompletionBlock)completedBlock;

@end

NS_ASSUME_NONNULL_END
