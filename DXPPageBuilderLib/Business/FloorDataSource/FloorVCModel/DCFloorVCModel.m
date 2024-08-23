//
//  DCFloorVCModel.m
//  DITOApp
//
//  Created by 孙全民 on 2022/8/26.
//

#import "DCFloorVCModel.h"


@implementation DCFloorVCModel


// 信控信息
//+(void)floorVCBillInfoCallback:(void(^)(NSDictionary *dic))callback {
//    NSString *acctId = [DCAppDataManager sharedInstance].userInfo.acctId?:@"";
//    if (DC_IsStrEmpty(acctId)) {
//        return;
//    }
//    DCHttpRequest *request = [[DCHttpRequest alloc] init];
//    request.requestUrl = kWebsbillinfo;
//    request.httpMethod = DCHttpMethodPOST;
//    request.requestParams = @{@"acctId":acctId};
//    [[DCHttpSessionManager sharedInstance]  sendRequest:request complete:^(DCHttpReponse * _Nonnull response) {
//        if (!response.serverError) {
//            NSDictionary *dic =   response.responseObject[@"data"];
//            if (dic && callback) {
//                callback(dic);
//            }
//            
//        }
//    }];
//}
@end
