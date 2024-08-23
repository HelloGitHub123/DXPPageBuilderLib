//
//  DCTMDBScrollView.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/3/6.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "DCPB.h"
#import "DCTMDashboardCell.h"
#import "DCMainBalanceSummaryModel.h"

// 点击事件类型
typedef NS_ENUM(NSInteger, DCTMDashboardCellType) {
    DCTMDashboardCellData = 0, // 数据
    DCTMDashboardCellSMS , // 短信
    DCTMDashboardCellVoice, // 语音
};


NS_ASSUME_NONNULL_BEGIN

// 滚动容器
@interface DCTMDBScrollView : UIView
- (void)bindWithModel:(DCTMDashboardCellModel*)cellModel;
@end


// 单独一个六边角View
@interface DCTMDBScrollCell : UIView


@property (nonatomic, assign) DCTMDashboardCellType cellType;
- (void)bindCellWithModel:(DCMainBalanceSummaryItemModel *)model;


- (void)setCompositionProps:(CompositionProps*)props;
@end

NS_ASSUME_NONNULL_END
