//
//  DCPageViewModel.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//
#import <UIKit/UIKit.h>
#import "DCPageViewModel.h"
#import "YYModel.h"
#import <DXPNetWorkingManagerLib/DCNetAPIClient.h>
#import "MJExtension.h"
#import <DXPToolsLib/HJMBProgressHUD.h>
#import "DCPBMenuItemModel.h"
#import "DCPBManager.h"

@implementation DCPageViewModel

// 请求页面配置信息
- (void)requestCMSPageDetailByPageCode:(NSString *)pageCode complete:(void(^)(DCPageModel* model,bool success))complete {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:0];
    [params setValue:pageCode forKey:@"pageCode"];

    [[DCNetAPIClient sharedClient] POST:kCMSPageDetailUrl paramaters:params CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSDictionary *dict = (NSDictionary *)res;
            NSDictionary * data = [dict objectForKey:@"data"];
            if ([[dict objectForKey:@"code"] isEqualToString:@"200"]) {
                DCPageModel *pageModel = [DCPageModel mj_objectWithKeyValues:data];
                complete(pageModel,YES);
            } else {
                complete(nil,NO);
            }
        } else {
            complete(nil,NO);
        }
    }];
}

- (void)requestMenuListComplete:(nonnull void (^)(NSMutableArray *homeDashboardArr))completeBlock {
    [[DCNetAPIClient sharedClient] POST:@"/ecare/menu/list" paramaters:@{@"menuType": @"11"} CompleteBlock:^(id res, NSError *error) {
        if (!error) {
            NSMutableArray *homeDashboardArr = [NSMutableArray new];
            if ([DC_HTTP_Code isEqualToString:DC_HTTP_Success] && !DC_IsStrEmpty(DC_HTTP_Code)) {
                NSArray *menuListArr = (NSArray *)[DC_HTTP_Data objectForKey:@"menuList"];
                for (NSDictionary *dic in menuListArr) {
					DCPBMenuItemModel *model = [DCPBMenuItemModel yy_modelWithDictionary:dic];
                    [homeDashboardArr addObject:model];
                }
            }
            // 设置接口数据
            [DCPBManager sharedInstance].iconMenuListData = homeDashboardArr;
            completeBlock(homeDashboardArr);
        }else {
            completeBlock(nil);
        }
    }];
}

@end
