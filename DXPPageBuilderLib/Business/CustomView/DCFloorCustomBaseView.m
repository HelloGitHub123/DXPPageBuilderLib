//
//  DCFloorCustomView.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/7/4.
//

#import "DCFloorCustomBaseView.h"

@implementation DCFloorCustomBaseView
- (void)setupComponent:(DCFloorBaseCellModel *)cellModel  {
    cellModel.isBinded = YES;
    self.cellModel = cellModel;
}

@end
