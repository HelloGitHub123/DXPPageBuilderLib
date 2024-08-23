//
//  DCGraphicPostCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/28.
//

#import "DCGraphicPostCell.h"
// ****************** Model ******************
@implementation DCGraphicPostCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    PicturesItem *item = [self.props.pictures firstObject];

    CGFloat horizontalOutterMargin = self.props.horizontalOutterMargin;
    if ([@"T" isEqualToString:self.props.floorStyle]) {
        CGFloat imgH = (DCP_SCREEN_WIDTH - 2*self.props.horizontalOutterMargin) / item.width * item.height;
        CGFloat titleLblH = [item.desc hj_sizeContraintToSize:CGSizeMake((DCP_SCREEN_WIDTH - 2*self.props.horizontalOutterMargin) , MAXFLOAT) font:FONT_S(16)].height;
        self.cellHeight = self.cellHeight + imgH + 12 + titleLblH;
    }else {
        // 根据图片判断高度
      __block CGFloat picH = 0;
        CGFloat ww = 100;
        CGFloat margin = 20;
        [self.props.pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGFloat h = ww / obj.width * obj.height;
            picH = picH + h + margin;
        }];
        picH = picH > 0 ? picH - 20 : picH;
        self.cellHeight = self.cellHeight + picH;
    }
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCGraphicPostCell class]);
}
@end

// ****************** Cell ******************
@interface DCGraphicPostCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *imgTitleContent;


@end
@implementation DCGraphicPostCell

- (void)bindCellModel:(DCGraphicPostCellModel *)cellModel {
    [super bindCellModel:cellModel];
    
    // 移除控件
    [_imgView removeFromSuperview];
    [_titleLbl removeFromSuperview];
    _imgView = nil;
    _titleLbl = nil;
    
    
    [self.baseContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

   
    
    if ([@"T" isEqualToString:cellModel.props.floorStyle]) {
        // 添加控件
        [self.baseContainer addSubview:self.imgView];
        [self.baseContainer addSubview:self.titleLbl];
        PicturesItem *imgItem = [cellModel.props.pictures firstObject];
        // 图片
        NSURL *imgUrl = [NSURL URLWithString:imgItem.src];
        [self.imgView sd_setImageWithURL:imgUrl];
        // 文字
        self.titleLbl.text = imgItem.desc;
        
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(@0);
            make.height.equalTo(@((DCP_SCREEN_WIDTH - 2*cellModel.props.horizontalOutterMargin)/ imgItem.width * imgItem.height));
        }];
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(self.imgView.mas_bottom).offset(12);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
        
        UIView *tapView = [UIView new];
        tapView.userInteractionEnabled = YES;
        tapView.tag = 1000;
        [self.baseContainer addSubview:tapView];
        
        [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(self.imgView.mas_top);
            make.bottom.equalTo(self.titleLbl.mas_bottom);
        }];
        [tapView addGestureRecognizer:tap];
        
        
    }else  {
        __block CGFloat maxH = 0;
        bool isLeft = [@"L" isEqualToString:cellModel.props.floorStyle];
        [cellModel.props.pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImageView *imgV = [UIImageView new];
            [self.baseContainer addSubview:imgV];
            
            CGFloat h = 100 / obj.width * obj.height;
            [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                if(isLeft){
                    make.leading.equalTo(@0);
                }else{
                    make.trailing.equalTo(@0);
                }
             
                make.top.equalTo(@(maxH));
                make.width.equalTo(@100);
                make.height.equalTo(@(h));
            }];
            maxH = maxH + h + 20;
            [imgV sd_setImageWithURL:[NSURL URLWithString:obj.src]];
            
            UILabel *desLbl = [UILabel new];
            desLbl.font = FONT_S(16);
            desLbl.lineBreakMode = NSLineBreakByTruncatingTail;
            desLbl.numberOfLines = 0;
            desLbl.text = obj.desc;
            [self.baseContainer addSubview:desLbl];
            [desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.height.equalTo(@(h));
                if(isLeft){
                    make.leading.equalTo(imgV.mas_trailing).offset(20);
                    make.trailing.equalTo(@0);
                }else{
                    make.leading.equalTo(@0);
                    make.trailing.equalTo(imgV.mas_leading).offset(-20);
                }
                make.top.equalTo(imgV.mas_top);
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(itemClickAction:)];
            
            UIView *tapView = [UIView new];
            tapView.tag = 1000 + idx;
            tapView.userInteractionEnabled = YES;
            [self.baseContainer addSubview:tapView];
            
            [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(@0);
                make.top.equalTo(imgV.mas_top);
                make.bottom.equalTo(imgV.mas_bottom);
            }];
            
            [tapView addGestureRecognizer:tap];
        }];
    }
}

- (void)itemClickAction:(UITapGestureRecognizer*)gestureRecognizer{
    NSInteger index = gestureRecognizer.view.tag - 1000;
    PicturesItem *item = self.cellModel.props.pictures[index];
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = item.link;
    model.linkType = item.linkType;
    model.name = item.iconName;
    model.needLogin = item.needLogin;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}


// MARK: LAZY
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.numberOfLines = 0;
        _titleLbl.font = FONT_S(16);
        _titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLbl;
}
@end
