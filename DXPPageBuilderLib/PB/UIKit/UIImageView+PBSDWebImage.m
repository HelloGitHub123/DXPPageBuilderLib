//
//  UIImageView+PBSDWebImage.m
//  TMCLP
//
//  Created by 蒙 on 2024/11/1.
//

#import "UIImageView+PBSDWebImage.h"

#define IS_Product  0  // 是否生产(目前用于 非生产情况下UIButton 、UIImageView 在https TLS非法的情况下，图片请求加载不了的问题)  1: 用于生产  0:非生产

@implementation UIImageView (PBSDWebImage)

/*
 *  最全模式:自定义参数
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                placeholderImage:(UIImage *)placeholder
						 options:(SDWebImageOptions)options
                      completed:(void (^)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL))completed {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                placeholderImage:placeholder
                         options:options
                       completed:completed];
}

/*
 *  简便模式:urlString+默认图片
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                placeholderImage:(UIImage *)placeholder {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (IS_Product) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                placeholderImage:placeholder];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                placeholderImage:placeholder
                         options:SDWebImageAllowInvalidSSLCertificates];
    }
}

/*
 *  最简便模式:urlString
 */
- (void)dc_setImageWithURLString:(NSString *)urlString{
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (IS_Product) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                placeholderImage:nil
                        options:SDWebImageAllowInvalidSSLCertificates];
    }
}

- (void)dc_setImageWithURLString:(NSString *)urlString
					placeholderImage:(nullable UIImage *)placeholder
					   completed:(nullable SDExternalCompletionBlock)completedBlock {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	if (IS_Product) {
		[self sd_setImageWithURL:[NSURL URLWithString:urlString] 
				placeholderImage:placeholder
					   completed:completedBlock];
	} else {
		[self sd_setImageWithURL:[NSURL URLWithString:urlString]
				placeholderImage:placeholder
						 options:SDWebImageAllowInvalidSSLCertificates
					   completed:completedBlock];

	}
}

@end
