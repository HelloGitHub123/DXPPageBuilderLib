//
//  PBBaseTableViewCell.h
//  MPTCLPMall
//
//  Created by OO on 2020/10/19.
//  Copyright © 2020 OO. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PBBaseTableViewCell : UITableViewCell

@property (nonatomic, strong) id dataModel;

- (void)ExChangeAppLanguage;
- (void)bindWithModel:(id)model;
- (UIImage *)imageWithColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
