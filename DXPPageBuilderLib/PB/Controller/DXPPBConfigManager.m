//
//  DXPPBConfigManager.m
//  DXPPageBuild
//
//  Created by 李标 on 2024/7/13.
//

#import "DXPPBConfigManager.h"

static DXPPBConfigManager *manager = nil;

@interface DXPPBConfigManager () {
}
@end



@implementation DXPPBConfigManager

+ (instancetype)shareInstance {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[DXPPBConfigManager alloc] init];
	});
	return manager;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		self.displayScale = @"0";
		self.countDown = 60;
		self.displayStyle = @"group";
		self.dateFormatApp = @"dd/MM/yyyy";
	}
	return self;
}

@end
