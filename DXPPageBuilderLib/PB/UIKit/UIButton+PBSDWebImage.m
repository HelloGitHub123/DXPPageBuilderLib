//
//  UIButton+PBSDWebImage.m
//  TMCLP
//
//  Created by 蒙 on 2024/11/4.
//

#import "UIButton+PBSDWebImage.h"

#define IS_Product  0  // 是否生产(目前用于 非生产情况下UIButton 、UIImageView 在https TLS非法的情况下，图片请求加载不了的问题)  1: 用于生产  0:非生产

@implementation UIButton (PBSDWebImage)

/*
 *  最全模式:自定义参数
 */
- (void)dc_setImageWithURLString:(NSString *)urlString
                        forState:(UIControlState)state
                placeholderImage:(nullable UIImage *)placeholder
                         options:(SDWebImageOptions)options
                       completed:(nullable SDExternalCompletionBlock)completedBlock {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                    forState:state
            placeholderImage:placeholder
                     options:options
                   completed:completedBlock];

}

/*
 *  简便模式:urlString+默认图片
 */
- (void)dc_setImageWithURL:(NSString *)urlString forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (IS_Product) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                        forState:state
                       placeholderImage:placeholder];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                        forState:state
                       placeholderImage:placeholder
                         options:SDWebImageAllowInvalidSSLCertificates];
    }
}

/*
 *  最简便模式:urlString
 */
- (void)dc_setImageWithURLString:(NSString *)urlString forState:(UIControlState)state {
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (IS_Product) {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                        forState:state];
    } else {
        [self sd_setImageWithURL:[NSURL URLWithString:urlString]
                        forState:state
                placeholderImage:nil
                         options:SDWebImageAllowInvalidSSLCertificates];
    }
}

@end
