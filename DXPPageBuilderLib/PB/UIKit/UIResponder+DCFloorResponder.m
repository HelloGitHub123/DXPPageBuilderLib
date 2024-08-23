//
//  UIResponder+DCFloorResponder.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/27.
//

#import "UIResponder+DCFloorResponder.h"

@implementation UIResponder (DCFloorResponder)
- (void)hj_routerEventWithName:(NSString *)eventName userInfo:(id)userInfo {
    [[self nextResponder] hj_routerEventWithName:eventName userInfo:userInfo];
}


- (void)hj_routerEventWith:(DCFloorEventModel *)eventModel {
    [[self nextResponder] hj_routerEventWith:eventModel];
}
@end
