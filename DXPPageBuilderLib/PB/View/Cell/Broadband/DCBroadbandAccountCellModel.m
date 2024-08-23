//
//  DCBroadbandAccountCellModel.m
//  DCPageBuilding
//
//  Created by Lee on 1.3.24.
//

#import "DCBroadbandAccountCellModel.h"
#import "DCBroadbandAccountCell.h"
#import "DCSubsListModel.h"

// ****************** Model ******************
@implementation DCBroadbandAccountCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];

    //    PicturesItem *item = [self.props.pictures firstObject];
//    self.cellHeight = self.cellHeight + (DCP_SCREEN_WIDTH - 2*horizontalOutterMargin) / item.width * item.height + 30;
    ///设置Cell 的高度
    NSMutableDictionary *dic = self.customData;
    NSString *mainPlanVal = [dic objectForKey:@"MainPlan"];
    NSString *addressStr = [dic objectForKey:@"Address"];
    NSString *upLoadVal = [dic objectForKey:@"upLoadVal"];
    NSString *downLoadVal = [dic objectForKey:@"downLoadVal"];
    
    float mainheight = [HJTool textHeightByWidth:DC_DCP_SCREEN_WIDTH-32-32-80-2 withFont:FONT_BS(14) string:mainPlanVal];
    if (mainheight == 0) mainheight = 16.4;
    float addressHeight = [HJTool textHeightByWidth:DC_DCP_SCREEN_WIDTH-32-32-80-2 withFont:FONT_BS(14) string:addressStr];
    if (addressHeight == 0) addressHeight = 16.4;

    BOOL isSpeed = ([upLoadVal floatValue] > 0 && [downLoadVal floatValue] > 0);
    if ([[DXPPBDataManager shareInstance].selectedSubsModel.serviceTypeCode isEqualToString:@"BROADBAND"]){
        if (isSpeed) {
            self.cellHeight = 275-87+mainheight+addressHeight;
        } else {
            self.cellHeight = 205-87+mainheight+addressHeight;
        }
    }else{
        self.cellHeight = 205-87+mainheight+addressHeight;
    }
    
    
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCBroadbandAccountCell class]);
}
@end
