//
//  TLVerticalScrollItem.h
//  TalentsLadder
//
//  Created by goviewtech on 2020/6/17.
//  Copyright © 2020 dude. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+DCPCategory.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NoticeViewEventDelegate <NSObject>

/// 公告点击事件
/// @param index 点击的索引
/// @param target 当前对象
- (void)NoticeViewClickByIndex:(NSInteger)index targetId:(id)target;
@end


@interface TLVerticalScrollItem : UIView

@property (nonatomic, strong) id<NoticeViewEventDelegate> delegate;
/**
 建议开发者将自定义的控件都写在contentview中
 */
@property (nonatomic,strong,readonly)UIView *contentView;
// icon 图片
@property (nonatomic, strong) UIImageView *imgView;
// 文本
@property (nonatomic,strong,readonly)UILabel *textLabel;
///点击事件用到的
@property (nonatomic,strong,readonly)UIButton *coverBtn;

/**
 用于item重用标记用的 请误修改
 */
@property (nonatomic,assign)NSInteger rowIndex;

@end

NS_ASSUME_NONNULL_END
