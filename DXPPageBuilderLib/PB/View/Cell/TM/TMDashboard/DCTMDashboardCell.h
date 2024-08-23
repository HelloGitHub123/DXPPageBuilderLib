//
//  DCTMDashboardCell.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/21.
//

#import "DCFloorBaseCell.h"
NS_ASSUME_NONNULL_BEGIN


// 点击事件类型
typedef NS_ENUM(NSInteger, DCTMDashboardCellHeightType) {
    DCTMDashboardOpenAccount = 0, // 开户页面
    DCTMDashboardRegisterSim , // 激活卡
    DCTMDashboardProgress, // 有流量球的页面
	DCDashboardSIMDataVoice, // 有data\SMS\Voice
    DCFWBDashboard = 5,   // 无线接入
	
};

// ****************** Model ******************
@interface DCTMDashboardCellModel : DCFloorBaseCellModel

// 区别类型
@property (nonatomic, assign) DCTMDashboardCellHeightType dbCellType;

+ (CGFloat)getTMDBTopMargin;
@end

// ******************NoTab Cell ******************
@interface DCTMDashboardCell : DCFloorBaseCell
@end

// DB容器view
@interface DCTMDBContainerView : UIView
- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel;
@end

// 注册卡view
@interface DCTMDDBRegisterView : UIView
@end

// FWB View
@interface DCFWBView : UIView
- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel;
@end

@interface DCDashboardSIMDataVoiceView : UIView
- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel;
@end

NS_ASSUME_NONNULL_END
