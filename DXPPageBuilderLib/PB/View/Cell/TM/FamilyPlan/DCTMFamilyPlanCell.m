//
//  DCTMFamilyPlanCell.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/3/17.
//

#import "DCTMFamilyPlanCell.h"

CGFloat itemH = 62;
CGFloat marginH = 4;

// ****************** Model ******************
@implementation DCTMFamilyPlanCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    self.selectIndex = 0;
    return self;
}

- (void)coustructCellHeight {
    NSArray *bundleSubsList = self.customData;
    if(!bundleSubsList || DC_IsArrEmpty(bundleSubsList)) {
        self.cellHeight = 0;
    }else {
        [super coustructCellHeight];
        self.cellHeight = self.cellHeight + bundleSubsList.count * (itemH + marginH) + 12 + (self.contentModel.props.topMargin > 0 ? self.contentModel.props.topMargin : 16);
    }
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCTMFamilyPlanCell class]);
}
@end



// ****************** Cell ******************
@interface DCTMFamilyPlanCell()
@end

@implementation DCTMFamilyPlanCell
- (void)configView {
    
}


- (void)bindCellModel:(DCFloorBaseCellModel *)cellModel {
    [super bindCellModel:cellModel];
    if (!DC_IsArrEmpty(self.baseContainer.subviews)) {
        [self.baseContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    }
    if(self.cellModel.cellHeight <=0) {
        return;
    }
    self.contentView.backgroundColor = [UIColor hjp_colorWithHex:@"#F6F7FF"];
    
    // 在添加数据
    NSArray *bundleSubsList = self.cellModel.customData;
    
    for (int i = 0; i< bundleSubsList.count; i++) {
        // 创建view
        DCTMFamilyPlanItem *itemView = [[DCTMFamilyPlanItem alloc]init];
        DCPBBundleSubsList *subModel = bundleSubsList[i];
        [itemView bindViewWith:subModel];
        [self.baseContainer addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(itemH));
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(@(i * (itemH + marginH)));
        }];
    }
}



@end

// ****************** 内容View ******************
@interface DCTMFamilyPlanItem()
@property (nonatomic, strong) UIImageView *tagImgView;
@property (nonatomic, strong) UILabel *phoneLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *dataUsedLbl;




@end

@implementation DCTMFamilyPlanItem
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    self.layer.cornerRadius = 8;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.tagImgView];
    [self addSubview:self.phoneLbl];
    [self addSubview:self.typeLbl];
    [self addSubview:self.dataUsedLbl];
    
    
    [_tagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@10);
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.equalTo(@34);
    }];
    
    [_phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tagImgView.mas_trailing).offset(4);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.phoneLbl.mas_trailing).offset(6);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@22);
    }];
    
    
    // 添加一个Data Used
    UILabel *dsdLbl = [UILabel new];
    [self addSubview:dsdLbl];
    dsdLbl.textColor = [UIColor hjp_colorWithHex:@"#858585"];
    dsdLbl.text = @"Data Used";
    dsdLbl.font = FONT_S(12);
    [dsdLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.top.equalTo(@10);
    }];
    
    [_dataUsedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-16);
        make.bottom.equalTo(@-10);
    }];
}


- (void)bindViewWith:(DCPBBundleSubsList *)subModel {
    self.phoneLbl.text = subModel.accNbr;
    self.tagImgView.image = [UIImage imageNamed: [subModel.primaryFlag isEqualToString:@"Y"]  ?  @"family_plan_principal" : @"family_plan_secondary" ];
    self.typeLbl.text =  [subModel.primaryFlag isEqualToString:@"Y"]  ?  @"  Principal  " : @"  Supplementary  ";
    [subModel.balSummaryList enumerateObjectsUsingBlock:^(DCPBBalSummaryList * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(1== obj.unitTypeId){
            self.dataUsedLbl.text = [NSString stringWithFormat:@"%@%@",obj.formatConsumeBalance,obj.formatConsumeBalanceUnitName];
            *stop = YES;
        }
    }];
}


// MARK: LAZY
- (UIImageView *)tagImgView {
    if(!_tagImgView) {
        _tagImgView = [UIImageView new];
        _tagImgView.image = [UIImage imageNamed:@"family_plan_principal"];
    }
    return _tagImgView;
}

- (UILabel *)phoneLbl {
    if(!_phoneLbl) {
        _phoneLbl = [UILabel new];
        _phoneLbl.font = FONT_BS(14);
    }
    return _phoneLbl;
}

- (UILabel *)typeLbl {
    if(!_typeLbl) {
        _typeLbl = [UILabel new];
        _typeLbl.font = FONT_S(12);
        _typeLbl.backgroundColor = [UIColor hjp_colorWithHex:@"#EBEBEB"];
        _typeLbl.textColor = [UIColor hjp_colorWithHex:@"#545454"];
        _typeLbl.text = @"  Principal  " ;
        _typeLbl.layer.cornerRadius = 11;
        _typeLbl.clipsToBounds = YES;
    }
    return _typeLbl;
}

- (UILabel *)dataUsedLbl {
    if(!_dataUsedLbl) {
        _dataUsedLbl = [UILabel new];
        _dataUsedLbl.font = FONT_BS(14);
        _dataUsedLbl.textColor = [UIColor hjp_colorWithHex:@"#242424"];
        _dataUsedLbl.text = @"5GB";
    }
    
    return _dataUsedLbl;
}
@end


