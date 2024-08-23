//
//  DCRouterManager.m
//  DCControls
//
//  Created by Lee on 2022/10/24.
//

#import "DCRouterManager.h"
#import <objc/runtime.h>
#import "PBBaseViewController.h"
#import "DCPBCurrentInfoModel.h"
#import "DCSubsListModel.h"
#import "DCPageBuildingViewController.h"
#import <SafariServices/SafariServices.h>
#import <DXPToolsLib/HJTool.h>
#import "DCPB.h"

static DCRouterManager *manager = nil;
@interface DCRouterManager () <SFSafariViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *routers;
@property (nonatomic, strong) NSMutableDictionary *routeAfterLoginParam;  // 需要登录后在跳转的参数
@end

@implementation DCRouterManager
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DCRouterManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadRouterFromPlist:[[NSBundle mainBundle] pathForResource:@"router" ofType:@"plist"]];
        
    }
    return self;
}

- (void)loadRouterFromPlist:(NSString *)path {
    
    NSArray *routes = [[NSArray alloc] initWithContentsOfFile:path];
    [self.routers addObjectsFromArray:routes];
}

- (UIViewController *)getViewController:(NSString *)code{
    NSString *className = nil;
    for (NSDictionary *dict in self.routers) {
        NSString *classCode = dict[@"classCode"];
        if ([code containsString:classCode]) {
            className = dict[@"className"];
        }
    }
    if (className) {
        Class class = NSClassFromString(className);
        return [[class alloc] init];
    }
    return nil;
}

- (UIViewController *)getViewController:(NSString *)code type:(NSInteger)type loadUrl:(NSString *)url serviceName:(NSString *)serviceName{
    if (type == 2) {
        Class class = NSClassFromString(@"ZteThirdWebviewViewController");
        id classVC = [[class alloc] init];
        Ivar ivar1 = class_getInstanceVariable([classVC class], "_loadUrl");
        Ivar ivar2 = class_getInstanceVariable([classVC class], "_titleStr");
        object_setIvar(classVC,ivar1,url);
        object_setIvar(classVC,ivar2,serviceName);
        return classVC;
    }else if (type == 3){
        Class class = NSClassFromString(@"HJWebViewController");
        id classVC = [[class alloc] init];
        Ivar ivar = class_getInstanceVariable([classVC class], "_loadUrl");
        if([url containsString:@"name={name}&contactno={contactno}&serviceNumber={serviceNumber}&category=IN"]) {
            NSString *userName = DC_IsStrEmpty( [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName)?@"": [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName;
            NSString *phoneNumber = DC_IsStrEmpty([DXPPBDataManager shareInstance].signInResponseModel.userInfo.mobile)?@"":[DXPPBDataManager shareInstance].signInResponseModel.userInfo.mobile;
            NSString *accNbr = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
            NSString *contactno = DC_IsStrEmpty(phoneNumber) ? accNbr: phoneNumber;
            
            NSString *newUrl = [url stringByReplacingOccurrencesOfString:@"{name}" withString:userName];
            newUrl = [newUrl stringByReplacingOccurrencesOfString:@"{contactno}" withString:contactno];
            newUrl = [newUrl stringByReplacingOccurrencesOfString:@"{serviceNumber}" withString:accNbr];
            object_setIvar(classVC,ivar,newUrl);
        }else {
            object_setIvar(classVC,ivar,url);
        }
        return classVC;
    }else{
        NSString *className = nil;
        for (NSDictionary *dict in self.routers) {
            NSString *classCode = dict[@"classCode"];
            if ([code isEqualToString:classCode]) {
                className = dict[@"className"];
            }
        }
        if (className) {
            Class class = NSClassFromString(className);
            return [[class alloc] init];
        }
        return nil;
    }
}

- (void)dealAfterLogin  {
    //routeAfterLoginParam 有数据说明要进行跳转 && 并且用户已经登录了
    if(!DC_IsArrEmpty(self.routeAfterLoginParam.allKeys) && !DC_IsStrEmpty([DXPPBDataManager shareInstance].signInResponseModel.token)) {
        [self dealWithViewNameWithUrl:self.routeAfterLoginParam[@"urlStr"]?:@"" type:[self.routeAfterLoginParam[@"type"] intValue] ?: 1 fromVc:[self topViewController] serviceName:self.routeAfterLoginParam[@"serviceName"]?:@""];
        [self.routeAfterLoginParam removeAllObjects];
    }
}
- (void)dealWithViewNameWithUrl:(NSString *)urlStr
                           type:(NSInteger)type
                         fromVc:(UIViewController *)fromVC
                    serviceName:(NSString *)serviceName
                      needLogin:(NSString *)needLogin {
    
    [self.routeAfterLoginParam removeAllObjects];
    
    if ([needLogin isEqualToString:@"Y"] && DC_IsStrEmpty([DXPPBDataManager shareInstance].signInResponseModel.token)) {
        self.routeAfterLoginParam = [[NSMutableDictionary alloc]initWithDictionary:@{@"urlStr":urlStr?:@"",@"type":@(type)?:@(1),@"serviceName":serviceName?:@""}];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoLoginVCNotification" object:nil userInfo:@{@"loginType":@""}];
        return;
    }
    [self dealWithViewNameWithUrl:urlStr type:type fromVc:fromVC serviceName:serviceName];
}

- (void)dealWithViewNameWithUrl:(NSString *)urlStr type:(NSInteger)type fromVc:(UIViewController *)fromVC serviceName:(NSString *)serviceName{
    if (type == 1) {
        UIViewController * toVC = [self getViewController:urlStr];
        toVC.hidesBottomBarWhenPushed = YES;
        if ([urlStr containsString:@"projectuniversal/terms_and_conditions?tcCode"]) {
//            DCBannerViewController *bannerVC = [[DCBannerViewController alloc] init];
//            bannerVC.url = urlStr;
//            [fromVC.navigationController pushViewController:bannerVC animated:YES];
            Class class = NSClassFromString(@"DCBannerViewController");
            id classVC = [[class alloc] init];
            Ivar ivar1 = class_getInstanceVariable([classVC class], "_url");
            
            object_setIvar(classVC,ivar1,urlStr);
            
            [fromVC.navigationController pushViewController:classVC animated:YES];
            
        } else if ([urlStr containsString:@"/clp_purchase/index"]) {
			PBBaseViewController *vc = (PBBaseViewController *)[self getViewController:@"/clp_purchase/index"];
            vc.hidesBottomBarWhenPushed = YES;
            NSDictionary *dic = [HJTool getParamsWithUrlString:urlStr];
            NSString *tab = dic && !DC_IsStrEmpty([dic objectForKey:@"tab"])?[dic objectForKey:@"tab"]:@"";
            NSString *fromofferid = dic && !DC_IsStrEmpty([dic objectForKey:@"fromofferid"])?[dic objectForKey:@"fromofferid"]:@"";
            [vc.paramsDic setValue:tab forKey:@"tab"];
            [vc.paramsDic setValue:fromofferid forKey:@"fromofferid"];
            [fromVC.navigationController pushViewController:vc animated:YES];
        } else if ([urlStr containsString:@"/cmspager/index"]) {
            NSDictionary *dic = [HJTool getParamsWithUrlString:urlStr];
            NSString * pageCode = dic && !DC_IsStrEmpty( [dic objectForKey:@"pageCode"]) ?  [dic objectForKey:@"pageCode"] : @"HOME_PAGE";
            DCPageBuildingViewController * next = [[DCPageBuildingViewController alloc] init];
            next.pageCode = pageCode;
            next.floorNavType = DCFloorNavType_CLP;
            [fromVC.navigationController pushViewController:next animated:YES];
        } else {
            [fromVC.navigationController pushViewController:toVC animated:YES];
        }
        return;
    } else if(type == 4) {//调用Safari浏览器打开
        NSString *newUrl = [PbTools getFormattingUrl:urlStr];
        NSString *url = [newUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else if(type == 2) {//调用第三方界面
        NSString *newUrl = [PbTools getFormattingUrl:urlStr];
        if ([PbTools isContainSafariUrl:urlStr]) {
            NSString *url = [newUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
            safariVC.delegate = self;
            if ([fromVC isKindOfClass:[UINavigationController class]]) {
                [((UINavigationController *)fromVC) presentViewController:safariVC animated:YES completion:nil];
            } else {
                [fromVC.navigationController presentViewController:safariVC animated:YES completion:nil];
            }
        } else {
            Class class = NSClassFromString(@"HJWebViewController");
            id classVC = [[class alloc] init];
            Ivar ivar = class_getInstanceVariable([classVC class], "_loadUrl");
            Ivar ivar2 = class_getInstanceVariable([classVC class], "_schemeType");
			Ivar ivar3 = class_getInstanceVariable([classVC class], "_navTitle");
			
            object_setIvar(classVC,ivar,newUrl);
            object_setIvar(classVC,ivar2,DC_stringFormat(@"%ld", (long)type));
			object_setIvar(classVC,ivar3,serviceName);

            ((UIViewController *)classVC).hidesBottomBarWhenPushed = YES;
            if ([fromVC isKindOfClass:[UINavigationController class]]) {
                [((UINavigationController *)fromVC) pushViewController:classVC animated:YES];
            } else {
                [fromVC.navigationController pushViewController:classVC animated:YES];
            }
        }
    } else if(type == 3) {//调用wsc界面
        NSString *newUrl = [PbTools getFormattingUrl:urlStr];
        if ([PbTools isContainSafariUrl:urlStr]) {
            NSString *url = [newUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
            safariVC.delegate = self;
            if ([fromVC isKindOfClass:[UINavigationController class]]) {
                [((UINavigationController *)fromVC) presentViewController:safariVC animated:YES completion:nil];
            } else {
                [fromVC.navigationController presentViewController:safariVC animated:YES completion:nil];
            }
        } else {
            Class class = NSClassFromString(@"HJWebViewController");
            id classVC = [[class alloc] init];
            Ivar ivar = class_getInstanceVariable([classVC class], "_loadUrl");
            object_setIvar(classVC,ivar,newUrl);
            
            ((UIViewController *)classVC).hidesBottomBarWhenPushed = YES;
            if ([fromVC isKindOfClass:[UINavigationController class]]) {
                [((UINavigationController *)fromVC) pushViewController:classVC animated:YES];
            } else {
                [fromVC.navigationController pushViewController:classVC animated:YES];
            }
        }
    } else if(type == 6) {//调用小程序界面
        

    } else if(type == 8) {//Safari内置界面
        NSString *newUrl = [PbTools getFormattingUrl:urlStr];
        NSString *url = [newUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        safariVC.delegate = self;
        if ([fromVC isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)fromVC) presentViewController:safariVC animated:YES completion:nil];
        } else {
            [fromVC.navigationController presentViewController:safariVC animated:YES completion:nil];
        }
    } else {//默认调用Safari打开

        Class class = NSClassFromString(@"ZteThirdWebviewViewController");
        id classVC = [[class alloc] init];
        Ivar ivar = class_getInstanceVariable([classVC class], "_loadUrl");
        
        object_setIvar(classVC,ivar,urlStr);
        
        Ivar ivar1 = class_getInstanceVariable([classVC class], "_titleStr");
        
        object_setIvar(classVC,ivar1,serviceName);
        
//        ZteThirdWebviewViewController * next = [[ZteThirdWebviewViewController alloc] init];
//        next.hidesBottomBarWhenPushed = YES;
//        next.loadUrl = urlStr;
//        next.titleStr = serviceName;
        ((UIViewController *)classVC).hidesBottomBarWhenPushed = YES;
        if ([fromVC isKindOfClass:[UINavigationController class]]) {
            [((UINavigationController *)fromVC) pushViewController:classVC animated:YES];
        }
        else
        {
            [fromVC.navigationController pushViewController:classVC animated:YES];
        }
    }
    
    
}

#pragma mark -- SFSafariViewControllerDelegate 方法，处理视图控制器关闭事件
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 获取当前栈顶控制器
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[self keyWindow] rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

// 获取当前window
- (UIWindow *)keyWindow {
    return [UIApplication sharedApplication].keyWindow;
}

#pragma mark -- lazy load
- (NSMutableDictionary *)routeAfterLoginParam {
    if(!_routeAfterLoginParam){
        _routeAfterLoginParam = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return _routeAfterLoginParam;
}
- (NSMutableArray *)routers {
    if (!_routers) {
        _routers = [NSMutableArray array];
       
    }
    return _routers;
}

@end
