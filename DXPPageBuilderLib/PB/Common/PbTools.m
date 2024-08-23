//
//  PbTools.m
//  PageBuilding
//
//  Created by 李标 on 2024/7/2.
//

#import "PbTools.h"
#import "DCPB.h"
#import <DXPManagerLib/HJTokenManager.h>

@implementation PbTools

+ (NSString *)numberFormatWithString:(NSString *)numberStr rule:(NSString *)serviceNbrBreakRule {
	if (DC_IsStrEmpty(numberStr)) {
		return numberStr;
	}
	if (DC_IsStrEmpty(serviceNbrBreakRule)) {
		return numberStr;
	}
	
	
	numberStr = [numberStr stringByReplacingOccurrencesOfString:@" " withString:@""];
//	NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//	NSDictionary *globalDic = json[@"global"];
//	NSString *serviceNbrBreakRule = globalDic[@"serviceNbrBreakRule"];//3,3,3
//	if (isNull(serviceNbrBreakRule)) return numberStr;

	NSArray *cutArray = [serviceNbrBreakRule componentsSeparatedByString:@","];
	
	if (cutArray.count > 0) {
		NSInteger newLength = 0;
		NSMutableString *newString = [[NSMutableString alloc] initWithString:numberStr];
		for (int i=0; i<cutArray.count-1; i++) {
			newLength = newLength + [cutArray[i] integerValue];
			if (newLength > newString.length-1) {
				break;
			} else {
				[newString insertString:@" " atIndex:newLength];
				newLength = newLength + 1;
			}
		}
		return [NSString stringWithFormat:@"%@", newString];
	}
	return numberStr;
}

+ (NSString *)getFormattingUrl:(NSString *)urlString {
	if ([urlString containsString:@"{name}"] || [urlString containsString:@"{contactno}"] || [urlString containsString:@"{serviceNumber}"]) {
		NSString *userName = DC_IsStrEmpty([DXPPBDataManager shareInstance].myProfileModel.custProfile.custName)?@"": [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName;
		NSString *phoneNumber = DC_IsStrEmpty([DXPPBDataManager shareInstance].signInResponseModel.userInfo.mobile)?@"":[DXPPBDataManager shareInstance].signInResponseModel.userInfo.mobile;
		NSString *accNbr = [DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
		NSString *contactno = DC_IsStrEmpty(phoneNumber) ? accNbr: phoneNumber;
		
		if ([urlString containsString:@"{name}"]) {
			if ([[[DXPPBDataManager shareInstance].currentInfoModel.currentRole uppercaseString] isEqualToString:@"INITIAL"]) {
				userName = @"";
			}
			if ([[[DXPPBDataManager shareInstance].currentInfoModel.currentRole uppercaseString] isEqualToString:@"NORMAL"]) {
				userName = @"";
			}
			urlString = [urlString stringByReplacingOccurrencesOfString:@"{name}" withString:userName];
		}
		if ([urlString containsString:@"{contactno}"]) {
			urlString = [urlString stringByReplacingOccurrencesOfString:@"{contactno}" withString:DC_IsStrEmpty(contactno)?@"":contactno];
		}
		if ([urlString containsString:@"{serviceNumber}"]) {
			urlString = [urlString stringByReplacingOccurrencesOfString:@"{serviceNumber}" withString:DC_IsStrEmpty(accNbr)?@"":accNbr];
		}
	}
	
	if ([urlString containsString:@"token="]) {
		NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
		NSArray<NSURLQueryItem *> *queryItems = [components queryItems];
		NSString *tokenValue;
		for (NSURLQueryItem *queryItem in queryItems) {
			if ([queryItem.name isEqualToString:@"token"]) {
				tokenValue = queryItem.value;
			}
			break;
		}
		
		if (DC_IsStrEmpty(tokenValue) && !DC_IsStrEmpty([DXPPBDataManager shareInstance].signInResponseModel.token)) {
			NSString *tokenString = DC_stringFormat(@"token=%@",[DXPPBDataManager shareInstance].signInResponseModel.token);
			urlString = [urlString stringByReplacingOccurrencesOfString:@"token=" withString:tokenString];
		}
	}
	return urlString;
}


+(NSString *)getDateFormatAppByProperty:(NSString *)dateStr {
	//设置时间显示格式
//	NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//	NSDictionary *globalDic = json[@"global"];
	NSString *dateFormatApp = [DXPPBConfigManager shareInstance].dateFormatApp;
	if (DC_isNull(dateFormatApp) || !dateFormatApp) return dateStr;
	
	NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
	[formatter setDateFormat:@"yyyyMMddHHmmss"];//输入的日期格式
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
	[dateFormat setDateFormat:dateFormatApp];//输出的日期格式
	
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"];
	[formatter setLocale:locale];
	[dateFormat setLocale:locale];
	
	NSDate *date = [formatter dateFromString:dateStr];
	
	NSString *timeString = [dateFormat stringFromDate:date];
	
	return timeString;
	
}

+ (NSString *)getAmountWithScaleAndUnit:(NSString *)amount {
	NSString *scale = DC_stringFormat(@"%@f", [DXPPBConfigManager shareInstance].displayScale);
	NSString *total = DC_stringFormat(@"%@%@%@",[DXPPBConfigManager shareInstance].currencySymbol,@"%.",scale);
	return DC_stringFormat(total, [amount floatValue]);
}


+ (NSString *)getStateNameWithstateName:(NSString *)stateName state:(NSString *)state paidFlag:(NSString *)paidFlag {
	/**
	 (1) TM 增加需求，状态根据预后付费展示不同的名称，因此优先根据 paidFlag 取，paidFlag=0 为预付费，取国际化 lb_subs_state_{接口返回的state}_PREPAID；paidFlag=1 为后付费，取国际化 lb_subs_state_{接口返回的state}_POSTPAID
	 (2) 如果 lb_subs_state_{接口返回的state}_PREPAID 或 lb_subs_state_{接口返回的state}_POSTPAID 没取到，则取国际化 lb_subs_state_{接口返回的state}；
	 (3) 如果 lb_subs_state_{接口返回的state} 国际化没取到，则直接取接口返回的 stateName。
	 (4) 2024.3.11 新增：如果接口返回的 stateName 为空，则订户状态标签隐藏
	 */
	NSString *stateKey = DC_stringFormat(@"lb_subs_state_%@", state);
	NSString *statePaidFlagKey = stateKey;
	if ([paidFlag isEqualToString:@"0"]) {
		statePaidFlagKey = DC_stringFormat(@"%@_PREPAID", stateKey);
	} else {
		statePaidFlagKey = DC_stringFormat(@"%@_POSTPAID", stateKey);
	}
	
	if (DC_IsStrEmpty([[HJLanguageManager shareInstance] getTextByKey:statePaidFlagKey])) {
		if (!DC_IsStrEmpty([[HJLanguageManager shareInstance] getTextByKey:stateKey])) {
			return [[HJLanguageManager shareInstance] getTextByKey:stateKey];
		}
	} else {
		return [[HJLanguageManager shareInstance] getTextByKey:statePaidFlagKey];
	}
	
	return stateName;
}

+ (UIColor *)getStateColorWithstate:(NSString *)state {
	
	if ([state isEqualToString:@"A"]) {
		return [[HJTokenManager shareInstance] getColorByToken:@"ref-subs-state-color-active"];
	} else if ([state isEqualToString:@"G"]) {
		return [[HJTokenManager shareInstance] getColorByToken:@"ref-subs-state-color-inactive"];
	} else if ([state isEqualToString:@"D"] || [state isEqualToString:@"E"]) {
		return [[HJTokenManager shareInstance] getColorByToken:@"ref-subs-state-color-blocked"];
	}
	return [[HJTokenManager shareInstance] getColorByToken:@"ref-subs-state-color-default"];
}

+ (BOOL)isContainSafariUrl:(NSString *)urlString {
//    NSString *urlString = @"https://maya.unifi.com.my/?noMinimize&platform=myunifi&name={name}";
	NSString *urlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
	NSURL *url = [NSURL URLWithString:urlStr];
	NSString *host = url.host; //获取主机
	if (DC_IsStrEmpty([DXPPBConfigManager shareInstance].safariUrl)) return NO;
	
	return [[DXPPBConfigManager shareInstance].safariUrl containsString:host];
}

@end
