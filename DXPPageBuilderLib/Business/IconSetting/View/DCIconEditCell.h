//
//  DCIconEditCell.h
//  Pods
//
//  Created by 孙全民 on 2023/2/13.
//

#import <UIKit/UIKit.h>
@class  DCPBMenuItemModel;
NS_ASSUME_NONNULL_BEGIN
@interface DCIconEditCellModel : NSObject
@property (nonatomic, assign) bool isEditing;
@property (nonatomic, assign) bool isShow;
@property (nonatomic, assign) bool isFixed; // 固定坑位(前提isShow == YES)
@property (nonatomic, strong) DCPBMenuItemModel *data; // iconModel
@property (nonatomic, strong) NSIndexPath *originIndexPath; // 原来坑位
@end

@interface DCIconEditCell : UICollectionViewCell
- (void)bindCellModel:(DCIconEditCellModel *)model;
@end

NS_ASSUME_NONNULL_END



