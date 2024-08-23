//
//  DCHotNewsViewCell.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/18.
//

#import "DCHotNewsViewCell.h"
#import "DCPageModel.h"
#import "TLVerticalScrollView.h"

#define HotNewsViewHeight  36  // 整个 hotview 的高度
#define LeftRightMarginSize  16  // 左右两侧距离屏幕的边距
#define MidIntervalSpace_LeftIcon  16 // 背景容器和icon之间的宽度间隔
#define Icon_width     20
#define Icon_height    20

@implementation DCHotNewsViewModel

- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

// 计算cell的高度
- (void)coustructCellHeight {
    [super coustructCellHeight];
    self.cellHeight =  self.cellHeight + HotNewsViewHeight;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCHotNewsViewCell class]);
}

@end




// ****************** Cell ******************
@interface DCHotNewsViewCell ()<TLVerticalScrollViewDelegate,NoticeViewEventDelegate> {
    NSInteger _itemIndex;
}

@property (nonatomic, strong) UIImageView *noticeImgView; // 公告图片
@property (nonatomic, strong) TLVerticalScrollView *scrollView;
@end

@implementation DCHotNewsViewCell

- (void)configView {
    
    _itemIndex = 0;
    
    UIView *bakView = [[UIView alloc] init];
    bakView.layer.cornerRadius = 16;
    bakView.backgroundColor = [UIColor whiteColor];
    [self.baseContainer addSubview:bakView];
    [bakView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(@0);
        make.height.equalTo(@HotNewsViewHeight);
    }];
    
    self.noticeImgView = [[UIImageView alloc] init];
    
    self.noticeImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeImgAction)];
    [self.noticeImgView addGestureRecognizer:tap];
    [bakView addSubview:self.noticeImgView];
    
    TLVerticalScrollView *scrollView = [[TLVerticalScrollView alloc]init];
    self.scrollView = scrollView;
    self.scrollView.delegate = self;
    [bakView addSubview:self.scrollView];
}

- (void)noticeImgAction {
    PicturesItem *item = [self.cellModel.props.pictures objectAtIndex:0];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = item.link;
    model.linkType = item.linkType;
    model.name = item.iconName;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

- (void)bindCellModel:(DCHotNewsViewModel *)cellModel {
    [super bindCellModel:cellModel];
    self.cellModel = cellModel;
    
    // 下载图片
    PicturesItem *picItem = [cellModel.props.pictures objectAtIndex:0];
    CGFloat width = picItem.height  > 0 ? HotNewsViewHeight /  picItem.height *  picItem.width : HotNewsViewHeight;
    NSURL *url = [NSURL URLWithString:picItem.src?:@""];
    [self.noticeImgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"news"]];
    
   
   [self.noticeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.leading.equalTo(@0);
       make.height.equalTo(@HotNewsViewHeight);
       make.width.equalTo(@(width));
   }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.noticeImgView.mas_trailing).offset(4);
        make.top.equalTo(@0);
        make.height.equalTo(@HotNewsViewHeight);
        make.trailing.mas_equalTo(0);
    }];
    
    [self.scrollView reloadData];
}

#pragma mark -- NoticeViewEventDelegate
/// 公告点击事件
- (void)NoticeViewClickByIndex:(NSInteger)index targetId:(id)target {
    PicturesItem *picItem = [self.cellModel.props.pictures objectAtIndex:index];
    if (!DC_IsStrEmpty(picItem.link)) {
        if (_delegate && [_delegate conformsToProtocol:@protocol(HotNewsEventDelegate)]) {
            if (_delegate && [_delegate respondsToSelector:@selector(HotNewsViewClickByIndex:link:targetId:)]) {
                [_delegate HotNewsViewClickByIndex:index link:picItem.link targetId:self];
            }
        }
    }
}

#pragma mark - TLVerticalScrollViewDelegate
/**item的总个数*/
- (NSInteger)scrollTotalItemCount:(TLVerticalScrollView*)scrollView {
    return 2;
}

/**
 初始化位置显示的item
 */
- (TLVerticalScrollItem*)scrollViewItemView:(TLVerticalScrollView*)scrollView {
    TLVerticalScrollItem *itemView = [[TLVerticalScrollItem alloc]initWithFrame:CGRectMake(0, 0, DCP_SCREEN_WIDTH-LeftRightMarginSize*2, HotNewsViewHeight)];
    itemView.delegate = self;
    return itemView;
}

- (NSInteger)scrollItemDisplayCount:(TLVerticalScrollView*)scrollView {
    return 1;
}

/**
 每个需要展现的数据，在这个代理中完成
 */
- (void)scrollView:(TLVerticalScrollView*)scrollView itemView:(TLVerticalScrollItem*)itemView index:(NSInteger)index {
//    TLVerticalScrollDemoData *demoData = self.dataArray[index];
//    itemView.textLabel.text = demoData.title;
    NewsDataSource *dataItem = [self.cellModel.props.dataSource objectAtIndex:0];
    PicturesItem *picItem = [self.cellModel.props.pictures objectAtIndex:0];
    itemView.textLabel.text = dataItem.text;
    NSURL *url = [NSURL URLWithString:picItem.src];
    [itemView.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
    itemView.rowIndex = index;
}

@end
