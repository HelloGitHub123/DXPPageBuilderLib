//
//  DCBundleDashboardCell.m
//  DCPageBuilding
//
//  Created by lishan on 2024/5/28.
//

#import "DCBundleDashboardCell.h"
#import <DXPCategoryLib/UIColor+Category.h>

// ****************** Model ******************
@implementation DCBundleDashboardCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    
    NSMutableDictionary *dic = self.customData;
    NSString *mainPlan = [dic objectForKey:@"mainPlan"];
    NSString *addressStr = [dic objectForKey:@"Address"];
    
    float mainPlanheight = [HJTool textHeightByWidth:DC_DCP_SCREEN_WIDTH-24-16-82-16*2 withFont:FONT_BS(14) string:mainPlan lineHeightMultiple:1.31];
    if (DC_IsStrEmpty(mainPlan)) mainPlanheight = 22;
    float addressHeight = [HJTool textHeightByWidth:DC_DCP_SCREEN_WIDTH-24-16-82-16*2 withFont:FONT_BS(14) string:addressStr lineHeightMultiple:1.31];
    if (DC_IsStrEmpty(addressStr)) addressHeight = 22;
     
    self.cellHeight = 16+32+22+17+22+16+12+44+mainPlanheight+addressHeight;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCBundleDashboardCell class]);
}

+ (CGFloat)getTMDBTopMargin {
    return  DCP_NAV_HEIGHT + 10;
}

@end


// ****************** Cell ******************
@interface DCBundleDashboardCell()

// Dashboard  容器
@property (nonatomic, strong) DCBundleDashboardView *bundleDashboardView;
@end

@implementation DCBundleDashboardCell

-(void)configView {
   // ============ 中间信息容器 container
   [self.contentView addSubview:self.bundleDashboardView];
   [self.bundleDashboardView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.mas_equalTo(16);
       make.leading.mas_equalTo(16);
       make.trailing.mas_equalTo(-16);
       make.bottom.mas_equalTo(0);
   }];
   
   [self setUpUI];
}

- (void)setUpUI {
    // 设置投影
    self.layer.masksToBounds = NO; // 允许阴影效果
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
    self.layer.shadowOpacity = 1; // 投影透明度，范围0.0~1.0
    self.layer.shadowRadius = 10.0; // 投影模糊半径
    self.layer.shadowOffset = CGSizeMake(0, 5); // 投影偏移量
    self.borderView.layer.cornerRadius = 16;
}

- (void)bindCellModel:(DCBundleDashboardCellModel *)cellModel {
   [super bindCellModel:cellModel];
   self.cellModel = cellModel;
   
   [self.bundleDashboardView bindWithModel:cellModel];
}

// MARK: LAzy
- (DCBundleDashboardView *)bundleDashboardView {
   if(!_bundleDashboardView) {
       _bundleDashboardView = [DCBundleDashboardView new];
   }
   return _bundleDashboardView;
}

@end

// ****************** DCBundleDashboardView ******************
@interface DCBundleDashboardView ()

// 顶部
@property (nonatomic, strong) UIImageView *houseImageView;
@property (nonatomic, strong) UILabel *houseLabel;
@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UILabel *line1Label;
@property (nonatomic, strong) UILabel *dotLabel;
@property (nonatomic, strong) UILabel *stateLabel;

// 中间部分
@property (nonatomic, strong) UILabel *line2Label;
@property (nonatomic, strong) UILabel *accountLabel;
@property (nonatomic, strong) UILabel *accountValueLabel;
@property (nonatomic, strong) UILabel *mainPlanLabel;
@property (nonatomic, strong) UILabel *mainPlanValueLabel;
@property (nonatomic, strong) UILabel *addressLabel;
@property (nonatomic, strong) UILabel *addressValueLabel;

// 底部按钮
@property (nonatomic, strong) UIButton *myBundleBtn;
@property (nonatomic, strong) UIButton *myBillBtn;

// 数据
@property (nonatomic, strong) DCBundleDashboardCellModel *cellModel;

@end


@implementation DCBundleDashboardView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self addSubview:self.houseImageView];
    [self addSubview:self.houseLabel];
    [self addSubview:self.changeBtn];
    [self addSubview:self.line1Label];
    [self addSubview:self.dotLabel];
    [self addSubview:self.stateLabel];
    
    [self addSubview:self.line2Label];
    [self addSubview:self.accountLabel];
    [self addSubview:self.accountValueLabel];
    [self addSubview:self.mainPlanLabel];
    [self addSubview:self.mainPlanValueLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.addressValueLabel];
    
    [self addSubview:self.myBundleBtn];
    [self addSubview:self.myBillBtn];
    
    [self configLayout];
}

- (void)configLayout {
    [self.houseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.mas_equalTo(12);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.houseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.equalTo(self.houseImageView.mas_trailing).offset(8);
        make.height.mas_equalTo(22);
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.equalTo(self.houseLabel.mas_trailing).offset(8);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.line1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.equalTo(self.changeBtn.mas_trailing).offset(8);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(1);
    }];
    
    [self.dotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLabel.mas_centerY).offset(0);
        make.leading.equalTo(self.line1Label.mas_trailing).offset(8);
        make.height.width.mas_equalTo(4);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.equalTo(self.dotLabel.mas_trailing).offset(4);
        make.height.mas_equalTo(22);
    }];
    
    [self.line2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.houseImageView.mas_bottom).offset(8);
        make.leading.mas_equalTo(12);
        make.trailing.mas_equalTo(-12);
        make.height.mas_equalTo(1);
    }];
    
    [self.accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2Label.mas_bottom).offset(8);
        make.leading.mas_equalTo(12);
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(22);
    }];
    
    [self.accountValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2Label.mas_bottom).offset(8);
        make.leading.equalTo(self.accountLabel.mas_trailing).offset(16);
        make.trailing.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    [self.mainPlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountValueLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(12);
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(22);
    }];
    
    [self.mainPlanValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountValueLabel.mas_bottom).offset(8);
        make.leading.equalTo(self.mainPlanLabel.mas_trailing).offset(16);
        make.trailing.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(12);
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(22);
    }];
    
    [self.addressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
        make.leading.equalTo(self.addressLabel.mas_trailing).offset(16);
        make.trailing.mas_equalTo(-12);
        make.height.mas_equalTo(22);
    }];
    
    float width = (DC_DCP_SCREEN_WIDTH - 16*2 - 12*3)/2;
    
    [self.myBundleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressValueLabel.mas_bottom).offset(12);
        make.leading.mas_equalTo(12);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(44);
    }];
    
    [self.myBillBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressValueLabel.mas_bottom).offset(12);
        make.leading.equalTo(self.myBundleBtn.mas_trailing).offset(12);
        make.trailing.mas_equalTo(-12);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(44);
    }];
}

- (void)bindWithModel:(DCBundleDashboardCellModel *)cellModel {
    self.cellModel = cellModel;
    NSMutableDictionary *dic = cellModel.customData;
    CompositionProps *propsDic = cellModel.props;
    
    // 顶部
    PicturesItem *picItem = [propsDic.accountPictures firstObject];
    [_houseImageView sd_setImageWithURL:[NSURL URLWithString:picItem.src] placeholderImage:DC_image(@"ic_house_icon")];
    _houseLabel.text = DC_IsStrEmpty(picItem.iconName)?@"":picItem.iconName;
    
    PicturesItem *exchangeItem = [propsDic.accountChangePictures firstObject];
    [_changeBtn sd_setImageWithURL:[NSURL URLWithString:exchangeItem.src] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_change_number")];
    
    _line1Label.backgroundColor = [UIColor colorWithHexString:propsDic.lineColor];
    
    NSString *state = [dic objectForKey:@"state"];
    NSString *stateName = [dic objectForKey:@"stateName"];
    if (!DC_IsStrEmpty(state) && !DC_IsStrEmpty(stateName)) {
        _dotLabel.backgroundColor = [PbTools getStateColorWithstate:state];
        _stateLabel.textColor = [PbTools getStateColorWithstate:state];
        _stateLabel.text = stateName;
    }
    
    // 中间部分
    _line2Label.backgroundColor = [UIColor colorWithHexString:propsDic.lineColor];
    _accountLabel.textColor = [UIColor colorWithHexString:propsDic.dashTextColor];
    _mainPlanLabel.textColor = [UIColor colorWithHexString:propsDic.dashTextColor];
    _addressLabel.textColor = [UIColor colorWithHexString:propsDic.dashTextColor];
    
    _accountValueLabel.text = DC_IsStrEmpty([dic objectForKey:@"num"])?@"":[dic objectForKey:@"num"];
    _accountValueLabel.textColor = [UIColor colorWithHexString:propsDic.subInfoColor];
    
    NSString *mainPlan = [dic objectForKey:@"mainPlan"];
    NSString *addressStr = [dic objectForKey:@"Address"];
    if (!DC_IsStrEmpty(mainPlan)) {
        _mainPlanValueLabel.text = mainPlan;
        _mainPlanValueLabel.textColor = [UIColor colorWithHexString:propsDic.subInfoColor];
        
        [_mainPlanValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([HJTool textHeightByWidth:DC_DCP_SCREEN_WIDTH-24-16-82-16*2 withFont:FONT_BS(14) string:mainPlan lineHeightMultiple:1.31]);
        }];
    }
    
    if (!DC_IsStrEmpty(addressStr)) {
        _addressValueLabel.text = addressStr;
        _addressValueLabel.textColor = [UIColor colorWithHexString:propsDic.subInfoColor];
        
        [_addressValueLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo([HJTool textHeightByWidth:DC_DCP_SCREEN_WIDTH-24-16-82-16*2 withFont:FONT_BS(14) string:addressStr lineHeightMultiple:1.31]);
        }];
    }
    
    
    // 底部按钮
    PicturesItem *bundleItem = [propsDic.dashLeftPictures firstObject];
    PicturesItem *billItem = [propsDic.dashRightPictures firstObject];
    
    [_myBundleBtn sd_setImageWithURL:[NSURL URLWithString:bundleItem.src] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_mybundle_btn")];
    [_myBillBtn sd_setImageWithURL:[NSURL URLWithString:billItem.src] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_mybill_btn")];
}

#pragma mark - Click
// 切换订户
- (void)changeAction:(id)sender {
    
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = @"EXCHANDE_NUM";
    model.floorEventType = DCFloorEventCustome;
    
    if (self.dbEventBlack) {
        self.dbEventBlack(model);
    } else {
        [self hj_routerEventWith:model];
    }
}

- (void)myBundleAction:(id)sender {
    CompositionProps *propsDic = self.cellModel.props;
    PicturesItem *bundleItem = [propsDic.dashLeftPictures firstObject];
    
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.linkType = bundleItem.linkType;
    model.link = bundleItem.link;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

- (void)myBillAction:(id)sender {
    CompositionProps *propsDic = self.cellModel.props;
    PicturesItem *billItem = [propsDic.dashRightPictures firstObject];
    
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.linkType = billItem.linkType;
    model.link = billItem.link;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

#pragma mark - lazy load
- (UIImageView *)houseImageView {
    if (!_houseImageView) {
        _houseImageView = [[UIImageView alloc] init];
    }
    return _houseImageView;
}

- (UILabel *)houseLabel {
    if (!_houseLabel) {
        _houseLabel = [[UILabel alloc] init];
        _houseLabel.textColor = DC_UIColorFromRGB(0x242424);
        _houseLabel.font = FONT_BS(14);
    }
    return _houseLabel;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeBtn setImage:[UIImage imageNamed:@"ic_change_number"] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (UILabel *)line1Label {
    if (!_line1Label) {
        _line1Label = [[UILabel alloc] init];
        _line1Label.backgroundColor = [UIColor redColor];// UIColorFromRGB(0xE6E6E6);
    }
    return _line1Label;
}

- (UILabel *)dotLabel {
    if (!_dotLabel) {
        _dotLabel = [[UILabel alloc] init];
//        _dotLabel.backgroundColor = UIColorFromRGB(0xD82E00);
        _dotLabel.layer.cornerRadius = 2;
        _dotLabel.layer.masksToBounds = YES;
    }
    return _dotLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.textColor = DC_UIColorFromRGB(0xD82E00);
        _stateLabel.font = FONT_S(14);
    }
    return _stateLabel;
}

- (UILabel *)line2Label {
    if (!_line2Label) {
        _line2Label = [[UILabel alloc] init];
        _line2Label.backgroundColor = DC_UIColorFromRGB(0xE6E6E6);
    }
    return _line2Label;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.textColor = DC_UIColorFromRGB(0x545454);
        _accountLabel.font = FONT_S(14);
		_accountLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_account_to"];
    }
    return _accountLabel;
}

- (UILabel *)accountValueLabel {
    if (!_accountValueLabel) {
        _accountValueLabel = [[UILabel alloc] init];
        _accountValueLabel.textColor = DC_UIColorFromRGB(0x242424);
        _accountValueLabel.font = FONT_BS(14);
    }
    return _accountValueLabel;
}

- (UILabel *)mainPlanLabel {
    if (!_mainPlanLabel) {
        _mainPlanLabel = [[UILabel alloc] init];
        _mainPlanLabel.textColor = DC_UIColorFromRGB(0x545454);
        _mainPlanLabel.font = FONT_S(14);
		_mainPlanLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_main_plan"];
    }
    return _mainPlanLabel;
}

- (UILabel *)mainPlanValueLabel {
    if (!_mainPlanValueLabel) {
        _mainPlanValueLabel = [[UILabel alloc] init];
        _mainPlanValueLabel.textColor = DC_UIColorFromRGB(0x242424);
        _mainPlanValueLabel.font = FONT_BS(14);
        _mainPlanValueLabel.numberOfLines = 0;
    }
    return _mainPlanValueLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = DC_UIColorFromRGB(0x545454);
        _addressLabel.font = FONT_S(14);
		_addressLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_address"];
    }
    return _addressLabel;
}

- (UILabel *)addressValueLabel {
    if (!_addressValueLabel) {
        _addressValueLabel = [[UILabel alloc] init];
        _addressValueLabel.textColor = DC_UIColorFromRGB(0x242424);
        _addressValueLabel.font = FONT_BS(14);
        _addressValueLabel.numberOfLines = 0;
    }
    return _addressValueLabel;
}

- (UIButton *)myBundleBtn {
    if (!_myBundleBtn) {
        _myBundleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myBundleBtn.backgroundColor = DC_UIColorFromRGB(0xF2F9F5);
        _myBundleBtn.layer.borderColor = DC_UIColorFromRGB(0xE5F3EB).CGColor;
        _myBundleBtn.layer.borderWidth = 1;
        _myBundleBtn.layer.cornerRadius = 8;
        [_myBundleBtn addTarget:self action:@selector(myBundleAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _myBundleBtn;
}

- (UIButton *)myBillBtn {
    if (!_myBillBtn) {
        _myBillBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _myBillBtn.backgroundColor = DC_UIColorFromRGB(0xF2F9F5);
        _myBillBtn.layer.borderColor = DC_UIColorFromRGB(0xE5F3EB).CGColor;
        _myBillBtn.layer.borderWidth = 1;
        _myBillBtn.layer.cornerRadius = 8;
        [_myBillBtn addTarget:self action:@selector(myBillAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myBillBtn;
}


@end
