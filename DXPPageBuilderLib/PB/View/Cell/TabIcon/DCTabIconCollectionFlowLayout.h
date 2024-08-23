//
//  DCTabIconCollectionFlowLayout.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCTabIconCollectionFlowLayout : UICollectionViewFlowLayout
@property (nonatomic) NSUInteger itemCountPerRow; // 一行显示几个
@property (nonatomic) NSUInteger rowCount; // 一页显示多少行
@property (strong, nonatomic) NSMutableArray *allAttributes;
@end

NS_ASSUME_NONNULL_END
