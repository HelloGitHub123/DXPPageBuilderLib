//
//  DCGeneralSelectedCell.h
//  GaiaCLP
//
//  Created by Lee on 2022/5/16.
//

#import <UIKit/UIKit.h>
#import "DCSubsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCGeneralSelectedCell : UITableViewCell

@property (nonatomic, copy) void(^(cellSelectBlock))(DCPBSubsItemModel*);
@end

NS_ASSUME_NONNULL_END
