//
//  DCFloorViewModel.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/27.
//

#import "DCFloorViewModel.h"
#import "MJExtension.h"
#import "DCCarouselPostCell.h"
#import "DCSinglePostCell.h"
#import "DCHotNewsViewCell.h"
#import "DCFloorPosterViewCell.h"
#import "DCDitoIconCell.h"
#import "DCTabIconCell.h"
#import "DCGraphicPostCell.h"
#import "DCTopUpCell.h"
#import "DCCountdownPostcell.h"
#import "DCMeetingCell.h"
#import "DCTMDashboardCell.h"
#import "DCMutiBalanceDashboardCell.h"
//
typedef NS_ENUM(NSUInteger,DCFloorCellDataType) {
    DCFloorCellData_Default_Dic = 0,  //
    DCFloorCellData_Data_Dic,
    DCFloorCellData_Data_View_Arr,
    DCFloorCellData_View_Arr,
   
};


@interface DCFloorViewModel()
@property (nonatomic, strong) NSDictionary *typeToClassDic; // 根据类型初始化组件model
@end

@implementation DCFloorViewModel


/**
 * 构造数据源
 * @param model  数据源
 */
- (void)constructComponentListWithContent:(DCPageModel*)model {
    self.pageModel = model;
    if (self.pageModel && self.pageModel.pageCompositionList && !DC_IsArrEmpty(self.pageModel.pageCompositionList)) {
        self.modelList = [[self constructBaseInfoComponentList:self.pageModel.pageCompositionList] mutableCopy];
    }
}

/**
 * 构造cell数据源
 * @param components 组件数据源数组
 */
- (NSMutableArray<DCFloorBaseCellModel*> *)constructBaseInfoComponentList:(NSArray*)components {
    
    NSMutableArray *dataArr = [NSMutableArray new];
    [components enumerateObjectsUsingBlock:^(PageCompositionItem *componentModel, NSUInteger idx, BOOL * _Nonnull stop) {
        // 2、初始化数据源
        DCFloorBaseCellModel *cellModel;
        NSString *type = componentModel.content.type;
        // 获取相应的映射
        Class defaultClss = [self isInnerComponentWithType:DCFloorCellData_Default_Dic andTypeStr:type];
        Class needDataClss = [self isInnerComponentWithType:DCFloorCellData_Data_Dic andTypeStr:type];

        // 外部提供View组件和构造数据源 || DCFloorCellType_Need_Data_View
        if (defaultClss) {
            cellModel = [[defaultClss alloc]initWithComponentModel:componentModel.content];
            cellModel.cellType = DCFloorCellType_Default; // 具体类型可以在子类中设置

        }else if(needDataClss) {
            cellModel = [[needDataClss alloc]initWithComponentModel:componentModel.content];
            cellModel.cellType = DCFloorCellType_Need_Data;
        }else  if ([self isInnerComponentWithType:DCFloorCellData_View_Arr andTypeStr:type]) {
            cellModel = [[DCFloorBaseCellModel alloc]initWithComponentModel:componentModel.content];
            cellModel.cellType = DCFloorCellType_Need_View;
        }else if ([self isInnerComponentWithType:DCFloorCellData_Data_View_Arr andTypeStr:type]) {
            cellModel = [[DCFloorBaseCellModel alloc]initWithComponentModel:componentModel.content];
            cellModel.cellType = DCFloorCellType_Need_Data_View;
        }else {/**未命名组件不做处理*/}
        
        if (cellModel) {
            cellModel.code =  componentModel.content.type;
            [dataArr addObject:cellModel];
        }
    }];

    return dataArr;
}

/**
  获取外部view组件类型
 */
- (BOOL)isOuterComponentWithType:(DCFloorCellDataType)dataType andTypeStr:(NSString*)type{
    if (dataType != DCFloorCellData_View_Arr &&  dataType != DCFloorCellData_Data_View_Arr) {return NO;}
    
    NSArray *arr = [self mapDataWithType:dataType];
    if (DC_IsArrEmpty(arr) || [arr containsObject:type] == NSNotFound) {return NO;}
    return YES;
}

- (Class)isInnerComponentWithType:(DCFloorCellDataType)dataType andTypeStr:(NSString*)type{
    if (dataType != DCFloorCellData_Data_Dic &&  dataType != DCFloorCellData_Default_Dic) {return nil;}
    NSString *clsStr = [[self mapDataWithType:dataType] objectForKey:type];
    if (DC_IsStrEmpty(clsStr) ) {return nil; }
    return NSClassFromString(clsStr);;
}


/**
 组件类型映射map
 */
- (id)mapDataWithType:(DCFloorCellDataType)dataType {
    // 普通组件
    NSDictionary *defaultDic = @{
        @"SinglePost":@"DCSinglePostCellModel",
        @"CarouselPost":@"DCCarouselPostCellModel",
        @"DITOCountdownPost":@"DCDitoCountdownPostCellModel",
        @"DITOMultiCountdownPosts":@"DCMultiCountdownPostCellModel",
        @"HotNews":@"DCHotNewsViewModel",
        @"FloorPoster":@"DCFloorPosterViewModel",
        @"Icon":@"DCIconCellModel",
        @"CountdownPost":@"DCCountdownPostCellModel",
        @"GraphicPost":@"DCGraphicPostCellModel",
        @"TopUp":@"DCTopUpCellModel",
        @"EnhancedVideos":@"DCDitoVideoCellModel",
       
    };
    
    // 外部构建数据，内部提供组件（需要字典进行  [类型 ：组件]）
    NSDictionary *needDataDic = @{@"MeetingDashboard":@"DCMeetingCellModel",
                                  @"GAIAIcon": @"DCGaiaIconCellModel",
                                  @"Dashboard": @"DCTMDashboardCellModel",
                                  @"TmFamilyPlanDetails":@"DCTMFamilyPlanCellModel",
                                  @"DITOMCCMCarouselPost":@"DCFloorPosterViewModel",
                                  @"BroadbandAccount":@"DCBroadbandAccountCellModel",
								  @"MutiBalanceDashboard":@"DCMutiBalanceDashboardCellModel",
                                  @"BundleDashboard":@"DCBundleDashboardCellModel",
    };
    
    
    // 内部不需要处理view， 所以不需要进行字典映射
    NSArray *needDataViewArr = @[];
    NSArray *needViewArr = @[];
    
    switch (dataType) {
        case DCFloorCellData_Default_Dic:  // 内部组件内部数据PB
            return defaultDic;
            break;
        case DCFloorCellData_Data_Dic:   // 内部组件外部提供数据
            return needDataDic;
            break;
        case DCFloorCellData_View_Arr:  // 外部组件内部数据
            return needViewArr;
            break;
        case DCFloorCellData_Data_View_Arr: // 外部组件外部数据
            return needDataViewArr;
            break;
        default:
            return nil;
            break;
    }
}

@end
