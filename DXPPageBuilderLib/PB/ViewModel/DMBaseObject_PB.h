//
//  DMBaseObject_PB.h
//  MPTCLPMall
//
//  Created by OO on 2020/9/2.
//  Copyright © 2020 OO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HJRequestProtocolForVM_PB.h"
NS_ASSUME_NONNULL_BEGIN

@interface DMBaseObject_PB : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *code;
//将后台字典数据转化为对象
- (instancetype)initWithJSON:(NSDictionary *)json;
//拼装字典数据
- (NSDictionary *)jsonRepresentation;
//将字典数据转化为字符串
- (NSString *)jsonString;

- (id)checkForNull:(id)value;

- (id)checkNumForNull:(id)value;
@end

NS_ASSUME_NONNULL_END
