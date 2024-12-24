//
//  NSTimer+HJBlocksSupport.h
//  DITOApp
//
//  Created by 严贵敏 on 2023/1/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (HJBlocksSupport)
//解决NSTimer 循环引用问题
+ (NSTimer *)hj_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats;
@end

NS_ASSUME_NONNULL_END
