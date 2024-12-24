//
//  PBBaseTableViewCell.m
//  MPTCLPMall
//
//  Created by OO on 2020/10/19.
//  Copyright © 2020 OO. All rights reserved.
//

#import "PBBaseTableViewCell.h"

@implementation PBBaseTableViewCell

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
	[super awakeFromNib];
	// Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (id)init {
	if (self = [super init]) {
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
	}
	return self;
}

- (void)ExChangeAppLanguage {
	//由子类各自实现
}

- (void)bindWithModel:(id)model {
	/** 子类实现*/
}

- (UIImage *)imageWithColor:(UIColor *)color {
	CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

@end
