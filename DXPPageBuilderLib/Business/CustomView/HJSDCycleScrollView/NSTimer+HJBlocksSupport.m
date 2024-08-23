//
//  NSTimer+HJBlocksSupport.m
//  DITOApp
//
//  Created by 严贵敏 on 2023/1/29.
//

#import "NSTimer+HJBlocksSupport.h"

@implementation NSTimer (HJBlocksSupport)
+ (NSTimer *)hj_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                         block:(void(^)(void))block
                                       repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(hj_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)hj_blockInvoke:(NSTimer *)timer {
    void (^block)(void) = timer.userInfo;
    if(block) {
        block();
    }
    }
@end
