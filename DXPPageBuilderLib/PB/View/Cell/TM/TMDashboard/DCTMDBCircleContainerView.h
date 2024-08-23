//
//  DCTMDBCircleContainerView.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/8/25.
//

#import <UIKit/UIKit.h>
#import "DCTMDashboardCell.h"
#import "DCTMDBScrollView.h"
#import "DCPB.h"
#import "YYLabel.h"
#import "YYText.h"
#import <DXPCategoryLib/UIColor+Category.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTMDBCircleContainerView : UIView
- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END
