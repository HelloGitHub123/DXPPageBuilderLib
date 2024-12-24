//
//  DCSelectSubsListView.h
//  GaiaCLP
//
//  Created by mac on 2022/7/13.
//

#import <UIKit/UIKit.h>
#import "DCSubsBundleModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^SwitchSubsBlock)(id model);

@interface DCSelectSubsListView : UIView


@property (nonatomic, strong) NSString *titleStr; // 设置标题

- (id)initWithBlock:(SwitchSubsBlock)block;
- (void)show;

@property (nonatomic, copy) void (^switchBundleBlock)(DCSubsBundleModel *switchBundleModel);

@end

NS_ASSUME_NONNULL_END
