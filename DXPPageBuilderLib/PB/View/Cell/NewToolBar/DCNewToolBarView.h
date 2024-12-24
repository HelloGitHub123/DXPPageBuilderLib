//
//  DCNewToolBarCell.h
//  AFNetworking
//
//  Created by 孙全民 on 2023/6/12.
//


#import <UIKit/UIKit.h>
#import "DCFloorBaseCell.h"

NS_ASSUME_NONNULL_BEGIN
//// 点击事件类型
typedef NS_ENUM(NSInteger, DCNewToolBarViewActionType) {
    DCPBToolBarActionMenu = 0,
    DCPBToolBarActionLogo , //logo
    DCPBToolBarActionBtns , //导航栏可点击按钮
};

@interface DCNewToolBarView : UIView
@property (nonatomic, assign) CGFloat bgAlpha;
@property (nonatomic, assign) BOOL redViewShow; // 展示红点



// 点击事件
@property (nonatomic, copy) void(^toolBarActionBlock) (DCNewToolBarViewActionType type, PicturesItem*  _Nullable  item);


// 返回事件
@property (nonatomic, copy) void(^toolBarBackAction) ();

// MARK: 绑定数据
- (void)bindCellModel:(PageCompositionItem *)model;



@end



NS_ASSUME_NONNULL_END
