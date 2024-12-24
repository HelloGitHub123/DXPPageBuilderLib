//
//  DCBroadbandView.h
//  AFNetworking
//
//  Created by Lee on 28.2.24.
//

#import <UIKit/UIKit.h>

@class DCBroadbandAccountCellModel;
NS_ASSUME_NONNULL_BEGIN

@interface DCBroadbandView : UIView
- (instancetype)initWithFrame:(CGRect)frame withModel:(DCBroadbandAccountCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END
