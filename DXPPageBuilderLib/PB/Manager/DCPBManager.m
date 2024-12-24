//
//  DCPBManager.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/8.
//

#import "DCPBManager.h"
#import "DCPB.h"

static DCPBManager *manager = nil;

@interface DCPBManager ()
@end


@implementation DCPBManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DCPBManager alloc] init];
    });
    return manager;
}



// 千分位格式转换
+ (NSString *)stringFormatToThreeBit:(NSString *)string {
    if (DC_IsStrEmpty(string)) {
        return @"";
    }
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    return stringM;
}



// MARK: LAZY
- (NSMutableArray *)iconMenuListData {
    if(!_iconMenuListData){
        _iconMenuListData = [NSMutableArray new];
    }
    return _iconMenuListData;
}
@end
