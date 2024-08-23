//
//  DCSinglePostCell.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/17.
//

#import "DCSinglePostCell.h"
#import "DCPageModel.h"

//#define LeftRightMarginSize  10  // 左右两侧距离屏幕的边距
#define BtnMoreWidth    100  // more 按钮宽度
#define MidIntervalSpace  10 // 控件之间的间隔

// ****************** Model ******************
@implementation DCSinglePostCellModel

- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

// 计算cell的高度
- (void)coustructCellHeight {
    if(![self checkPicturesDataVaild]) {
        self.cellHeight = 0;
        return;
    }
    [super coustructCellHeight];
    CGFloat height = 0;
    if (!DC_IsArrEmpty(self.props.pictures)) {
        PicturesItem *picItem = [self.props.pictures objectAtIndex:0];
        CGFloat hm = self.props.immersive ? 0 : self.props.horizontalOutterMargin;
		height = ((picItem.width/2) * picItem.height)/ picItem.width;
		// height = height + (DCP_SCREEN_WIDTH -  hm * 2) / 750 * picItem.height ;
    }
    self.cellHeight  = self.cellHeight + height + self.props.topMargin;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCSinglePostCell class]);
}

// 计算字符串高度
- (CGFloat)calculateHeightWithString:(NSString *)str width:(CGFloat)nWidth {
    if (str.length < 1) {
        return 0;
    }
    CGRect rect = [str boundingRectWithSize:CGSizeMake(nWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    CGFloat height = rect.size.height + 1;
    return height;
}
@end



// ****************** Cell ******************
@interface DCSinglePostCell()
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation DCSinglePostCell

- (void)bindCellModel:(DCSinglePostCellModel *)cellModel {
    if(![cellModel checkPicturesDataVaild] || cellModel.cellHeight <= 0) return;
    [super bindCellModel:cellModel];
    self.cellModel = cellModel;
    
    [self.imgView removeFromSuperview];
    self.imgView = nil;
    [self.baseContainer addSubview:self.imgView];
    
    
    CGFloat horizontalOutterMargin = cellModel.props.horizontalOutterMargin;

    if (!DC_IsArrEmpty(cellModel.props.pictures)) {
        self.imgView.userInteractionEnabled = YES;
        self.imgView.multipleTouchEnabled = YES;
        PicturesItem *picItem = [cellModel.props.pictures objectAtIndex:0];
        NSString *audioUrl = [picItem.src  stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:audioUrl];
        [self.imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"nadata"]];
//        CGFloat height = (DCP_SCREEN_WIDTH - horizontalOutterMargin*2) / 750 * picItem.height;
		
		CGFloat height = ((picItem.width/2) * picItem.height)/ picItem.width;
		
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(@0);
//			make.top.equalTo(@(cellModel.props.topMargin));
            make.height.equalTo(@(height));
        }];
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        [self.imgView addGestureRecognizer:tap];
    } else {
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(@0);
            make.width.equalTo(@0);
            make.height.equalTo(@0);
        }];
    }
}

#pragma mark -- 方法
// 点击图片
- (void)imageClick:(UIGestureRecognizer *)tap {
    PicturesItem *picItem = [self.cellModel.props.pictures objectAtIndex:0];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = picItem.link;
    model.linkType = picItem.linkType;
    model.name = picItem.iconName;
    model.floorEventType = DCFloorEventFloor;
    model.code = self.cellModel.code;
    model.displayName = self.cellModel.contentModel.displayName;
    model.floorId = self.cellModel.contentModel.ids;
    model.floorTitle = self.cellModel.props.title; // 这个是标题
    model.picCount = self.cellModel.props.pictures.count;
    model.picId = picItem.ids;
    [self hj_routerEventWith:model];

}

// more 点击跳转
- (void)moreClickAction:(id)sender {
    if (!DC_IsStrEmpty(self.cellModel.props.moreLink)) {
        if (_delegate && [_delegate conformsToProtocol:@protocol(SinglePostViewEventDelegate)]) {
            if (_delegate && [_delegate respondsToSelector:@selector(SinglePostMoreClickByLink:targetId:)]) {
                [_delegate SinglePostMoreClickByLink:self.cellModel.props.moreLink targetId:self];
            }
        }
    }
}


- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}
@end
