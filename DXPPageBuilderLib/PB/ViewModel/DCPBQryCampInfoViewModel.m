//
//  DCPBQryCampInfoViewModel.m
//  BOL
//
//  Created by Lee on 27.1.24.
//

#import "DCPBQryCampInfoViewModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import <YYModel/YYModel.h>
#import <ImageIO/ImageIO.h>
#import "DCPB.h"

@implementation DCPBQryCampInfoViewModel
- (void)qryCampInfoWithAdviceCode:(NSString *)adviceCode identityType:(NSString *)identityType identityId:(NSString *)identityId channelCode:(NSString *)channelCode {
    
	__weak __typeof(&*self)weakSelf = self;
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestStart:method:)]) {
        [self.delegate requestStart:self method:QryCampInfoStr];
    }

    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    [parmas setValue:adviceCode forKey:@"adviceCode"];
    [parmas setValue:identityType forKey:@"identityType"];
    
    [parmas setValue:identityId forKey:@"identityId"];
    [parmas setValue:channelCode forKey:@"channelCode"];
    
    [[DCNetAPIClient sharedClient] POST:kQryCampInfoUrl paramaters:parmas CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            @try {
                NSArray *arr = [dict objectForKey:@"subsMrkContactDtos"];
                [self.campInfoArr removeAllObjects];
                NSMutableArray *arrImg = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
					DCPBCampInfoItemModel * model = [DCPBCampInfoItemModel yy_modelWithDictionary:dic];
                    NSString *src = model.thumbURL;
                    if (!DC_IsStrEmpty(src)) {
                     
                        CGSize size = [self getImageSizeWithURL:[NSURL URLWithString:src]];
                        model.imgWidth = DC_DCP_SCREEN_WIDTH;
                        if (size.width > 0) {
                            model.imgHeight = size.height  / size.width * DC_DCP_SCREEN_WIDTH;
                        }else{
                            model.imgHeight = 0;
                        }
                    }
                    [self.campInfoArr addObject:model];
                }
                
            } @catch (NSException *exception) {
                
            }
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestSuccess:method:)]) {
                [weakSelf.delegate requestSuccess:weakSelf method:QryCampInfoStr];
            }
            
        } else {
            weakSelf.errorMsg = [res objectForKey:@"resultMsg"];
            weakSelf.resultCode = [res objectForKey:@"resultCode"];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(requestFailure:method:)]) {
                [weakSelf.delegate requestFailure:weakSelf method:QryCampInfoStr];
            }
        }
    }];
    
}


- (NSMutableArray *)campInfoArr{
    if (!_campInfoArr) {
        _campInfoArr = [NSMutableArray new];
    }
    return _campInfoArr;
}


/**
 *  根据图片url获取网络图片尺寸
 */
- (CGSize)getImageSizeWithURL:(id)URL{
	NSURL * url = nil;
	if ([URL isKindOfClass:[NSURL class]]) {
		url = URL;
	}
	if ([URL isKindOfClass:[NSString class]]) {
		url = [NSURL URLWithString:URL];
	}
	if (!URL) {
		return CGSizeZero;
	}
	CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
	CGFloat width = 0, height = 0;
	
	if (imageSourceRef) {
		
		// 获取图像属性
		CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
		
		//以下是对手机32位、64位的处理
		if (imageProperties != NULL) {
			
			CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
			
#if defined(__LP64__) && __LP64__
			if (widthNumberRef != NULL) {
				CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
			}
			
			CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
			
			if (heightNumberRef != NULL) {
				CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
			}
#else
			if (widthNumberRef != NULL) {
				CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
			}
			
			CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
			
			if (heightNumberRef != NULL) {
				CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
			}
#endif
			/********************** 此处解决返回图片宽高相反问题 **********************/
			// 图像旋转的方向属性
			NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
			CGFloat temp = 0;
			switch (orientation) {
				case UIImageOrientationLeft: // 向左逆时针旋转90度
				case UIImageOrientationRight: // 向右顺时针旋转90度
				case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
				case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
					temp = width;
					width = height;
					height = temp;
				}
					break;
				default:
					break;
			}
			/********************** 此处解决返回图片宽高相反问题 **********************/
			
			CFRelease(imageProperties);
		}
		CFRelease(imageSourceRef);
	}
	return CGSizeMake(width, height);
}


@end


@implementation DCPBCampInfoItemModel

@end

@implementation DCPBCampInfoModel

@end

