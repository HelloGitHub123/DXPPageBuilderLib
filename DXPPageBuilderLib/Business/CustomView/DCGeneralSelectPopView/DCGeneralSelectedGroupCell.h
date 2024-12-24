//
//  DCGeneralSelectedGroupCell.h
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/8/29.
//

#import <UIKit/UIKit.h>
#import "DCSubsListModel.h"
#import "PBBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCGeneralSelectedGroupCell : PBBaseTableViewCell
@property (nonatomic, copy) void(^(cellSelectBlock))(DCPBSubsItemModel*);

@end

NS_ASSUME_NONNULL_END
