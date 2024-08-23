//
//  DCNewToolBarMaskView.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/6/15.
//

#import <UIKit/UIKit.h>
#import "DCPageCompositionContentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DCNewToolBarMaskView : UIView
@property (nonatomic, copy) void(^didSeletedItem)(NSInteger index);

- (void)showVithView:(UIView*)view  pictures:(NSArray*)picItem;
@end

@interface DCNewToolBarMaskItemCell : UITableViewCell

- (void)bindWithCellModel:(PicturesItem*)item;
@end

NS_ASSUME_NONNULL_END
