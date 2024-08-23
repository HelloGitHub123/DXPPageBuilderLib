//
//  HJRequestProtoclForVM.h
//  MPTCLPMall
//
//  Created by OO on 2020/9/16.
//  Copyright © 2020 OO. All rights reserved.
//

#ifndef HJRequestProtocolForVM_PB_h
#define HJRequestProtocolForVM_PB_h

@protocol HJVMRequestDelegate_PB <NSObject>
@optional
// 请求成功
- (void)requestSuccess:(NSObject *)vm;
// 请求失败
- (void)requestFailure:(NSObject *)vm;

// 请求开始
- (void)requestStart:(NSObject *)vm;
/// 请求开始
/// @param vm vm
/// @param methodFlag 方法标识
- (void)requestStart:(NSObject *)vm method:(NSString *)methodFlag;
/// 请求成功
/// @param vm vm
/// @param methodFlag 方法标识
- (void)requestSuccess:(NSObject *)vm method:(NSString *)methodFlag;
/// 请求失败
/// @param vm vm
/// @param methodFlag 方法标识
- (void)requestFailure:(NSObject *)vm method:(NSString *)methodFlag;

@end
#endif /* HJRequestProtocolForVM_h */
