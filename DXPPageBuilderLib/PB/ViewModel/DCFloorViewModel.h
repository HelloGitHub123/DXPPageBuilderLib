//
//  DCFloorViewModel.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/27.
//

#import <Foundation/Foundation.h>
#import "DCPageModel.h"
#import "DCFloorBaseCell.h"
#import "DCFloorBaseViewDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface DCFloorViewModel : NSObject

/// 数据源
@property (nonatomic, strong) NSDictionary *datasource;
@property (nonatomic, strong) DCPageModel *pageModel;

///  需要转换成页面model数组
@property (nonatomic, strong) NSMutableArray<DCFloorBaseCellModel *> *modelList; // 页面数据源
@property (nonatomic, weak) id<DCFloorBaseViewDataSource> dataSource; // 数据源代理

// 构造CellModel
- (void)constructComponentListWithContent:(DCPageModel*)model;
@end

NS_ASSUME_NONNULL_END
