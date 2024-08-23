//
//  DCFloorBaseCell.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/17.
//

#import <UIKit/UIKit.h>
#import "DCPMacroHeader.h"
#import <SDWebImage/SDWebImage.h>
#import "DCPageCompositionContentModel.h"
#import "DCPageModel.h"
#import "NSString+DCSize.h"
#import "UIColor+DCPCategory.h"
#import "UIResponder+DCFloorResponder.h"
#import <Masonry/Masonry.h>
#import "DCPB.h"

#define PAGE_H_M 12
#define PAGE_TOP_M 10.0
#define MarginSize   10
#define MoreWidth    100  // more 按钮宽度
#define Title_H  24.0
@class PageCompositionItem;
NS_ASSUME_NONNULL_BEGIN


// 对应原数据 组件中的 type
typedef NS_ENUM(NSUInteger,DCFloorCellType) {
    /* 对应产品组件 */
    DCFloorCellType_Default = 0, // none
    /**
     非正常组件应该有三种类型
     1、自定义组件 ( 页面需要外面提供)
        A: pb提供数据，由于页面特殊性，不考虑组件放sdk中
        B: pb不提供数据，只有一个坑位(外部组装数据，放在 customData中)
     2、数据由外面构造，(页面内部提供)（需要根据pb CompositionProps  Model进行组装，因为是内部组件）这个部分也有两种类型
        A:  pb 不提供数据,只有一个坑位 （数据外面组装CompositionProps *props; ）
     */
    DCFloorCellType_Need_View, // pb提供数据，外部提供页面
    DCFloorCellType_Need_Data_View, // 一个坑位，pb不提供数据，外部提供页面和数据
    DCFloorCellType_Need_Data, // 一个坑位，pb内置组件，数据由外部构造(构造方式为 CompositionProps *props)
};

// ****************** BaseModel ******************
@interface  DCFloorBaseCellModel : NSObject

@property (nonatomic, copy) NSString *cellClsName; // 对应的cell Name
@property (nonatomic, assign) NSInteger cellHeight; // Cell 高度

@property (nonatomic, assign) bool isBinded; // 是否绑定(cell再次渲染需要设置为NO)
@property (nonatomic) UIEdgeInsets contentPadding; // 内容内边距
@property (nonatomic) UIEdgeInsets contentMargin; // 内容外边距

//@property (nonatomic, assign) CGFloat contentWidth; // 组件内容宽度
//@property (nonatomic, assign) BOOL updateIfNeeded;

@property (nonatomic, assign) DCFloorCellType cellType; // 组件type
@property (nonatomic, copy) NSString *floorId; // pb楼层id
@property (nonatomic, copy) NSString *code; // 类型
@property (nonatomic, strong) DCPageCompositionContentModel *contentModel; //pb楼层Model. props上级
@property (nonatomic, strong) NSIndexPath *indexPath; // 楼层indexPath
/** 数据源
 1. CompositionProps * props 内部组件直接使用
 2. id customData                    外部组件使用
 组件保存内部还是外部由开发者自行规划：
 ？？？ 如果需求强制放内部
 ！！！ 属性props不能使用，可以自行添加model<目前只有props&customData>； 最好使用继承，baseModel中不要添加太多子类组件特定的属性
 */
@property (nonatomic, strong) CompositionProps *props;  // 接口数据据
@property (nonatomic, strong) id customData;            // 自定义数据
@property (nonatomic, strong) NSDictionary *innerComponentDataDic; // 内部组件数据字典  --> 对应类型 HJFloorCellType_Need_Data



//是否异步请求过数据

@property (nonatomic,assign) BOOL isAsync;
/**
 计算高度，每个子类都要进行一次计算复制
 */
- (void)coustructCellHeight;

/** 统一组件初始化方法
 ！！！ 如果子类有特殊的组件初始化方法，子类自行实现
 */
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel*)item;


// 子组件需要图片，图片数组不能为空
- (BOOL)checkPicturesDataVaild;

@end

// ****************** BaseCell ******************
@interface DCFloorBaseCell : UITableViewCell
@property (nonatomic, strong) UIView *baseContainer; // 内边距容器(内容容器)
@property (nonatomic, strong) UIView *borderView; // 外边距容器
@property (nonatomic, strong) UILabel *baseTitleLab; // 全局标题
@property (nonatomic, strong) UIButton *baseBtnMore; // 右边按钮
@property (nonatomic, strong) DCFloorBaseCellModel *cellModel;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^reloadTableBlock)(void);

//增加一个需要刷cell内部的
@property (nonatomic, copy) void (^reloadTableWidthCellBlock)(DCFloorBaseCellModel *cellModel);

- (void)bindCellModel:(DCFloorBaseCellModel *)cellModel;
- (void)resetViewborder;
- (void)configView; // 子类初始化视图
- (void)moreClickAction;
@end

NS_ASSUME_NONNULL_END
