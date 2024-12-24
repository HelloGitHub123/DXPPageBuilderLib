//
//  DCGeneralSelectPopView.h
//  GaiaCLP
//
//  Created by Lee on 2022/5/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^SwitchSubsBlock)(id model);

@interface DCGeneralSelectPopView : UIView

- (id)initWithBlock:(SwitchSubsBlock)block;

- (void)show;

@end

NS_ASSUME_NONNULL_END
