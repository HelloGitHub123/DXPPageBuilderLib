//
//  DCSelectSubsListCell.m
//  GaiaCLP
//
//  Created by mac on 2022/7/13.
//

#import "DCSelectSubsListCell.h"
#import <Masonry/Masonry.h>
#import "DCSubsListModel.h"
#import <DXPCategoryLib/UIView+UIRectCorner.h>
#import <DXPManagerLib/HJTokenManager.h>
#import <DXPManagerLib/HJImageManager.h>
#import <DXPManagerLib/HJLanguageManager.h>
#import "DCPB.h"

@interface DCSelectSubsListCell(){
    BOOL showStatusTag ;
    BOOL showPaidFlagTag;
}
@property (nonatomic, strong) UIView * bgView;

@property (nonatomic, strong) UIImageView * statusIV;

@property (nonatomic, strong) UIImageView * selectIV;

@property (nonatomic, strong) UILabel * numberLabel;

@property (nonatomic, strong) UILabel * statusLabel;

@property (nonatomic, strong) UILabel * paidFlagLabel;

@property (nonatomic, strong) UILabel * viewMyHouseLabel;

@property (nonatomic, strong) UILabel * bundleNameLabel;

@property (nonatomic, strong) DCPBSubsItemModel * subsItemModel;

@property (nonatomic, strong) DCSubsBundleModel * bundleModel;
@end

@implementation DCSelectSubsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-global-bgColor-secondary-app"];
        [[HJTokenManager shareInstance] setViewBackgroundColorWithToken:@"ref-global-bgColor-secondary-app" view:self size:CGSizeMake(DC_DCP_SCREEN_WIDTH, 1)];
       
//		NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//        NSDictionary *subsSwitchPopup = json[@"subsSwitchPopup"];
		showStatusTag = [DXPPBConfigManager shareInstance].showStatusTag;
		showPaidFlagTag = [DXPPBConfigManager shareInstance].showPaidFlagTag;
        
        if([reuseIdentifier isEqualToString:@"DCSelectSubsListCell"]){
            [self configCell];
        }else if([reuseIdentifier isEqualToString:@"HJSelectSubsGroupCell"]){
            [self configGroupCell];
        }else if ([reuseIdentifier isEqualToString:@"HJSelectViewMyHouseCell"]) {
            [self configViewMyHouseCell];
        }
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Make sure the contentView does a layout pass here so that its subviews have their frames set, which we
    // need to use to set the preferredMaxLayoutWidth below.
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    if (self.subsItemModel) {
        if(self.subsItemModel.isFirstRow&&self.subsItemModel.isLastRow){
            [self.bgView rounderWithCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:12];
        }else{
            if (self.subsItemModel.isFirstRow ) {
                [self.bgView rounderWithCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
            }else {
                if (self.subsItemModel.isLastRow) {
                    [self.bgView rounderWithCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:12];
                }else{
                    [self.bgView rounderWithCorners:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight radius:0];
                }
            }
        }
    }else{
        if (self.bundleModel.isFirstRow) {
            [self.bgView rounderWithCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:12];
        }else{
            [self.bgView rounderWithCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:0];
        }
    }
    
}

- (void)configCell{
    self.contentView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(30, 16, DC_DCP_SCREEN_WIDTH-100, 24)];
    _titleLab.font = FONT_S(16);
    _titleLab.textColor = DC_UIColorFromRGB(0x242424);
    [self.contentView addSubview:_titleLab];
    
    _arrowView = [[UIImageView alloc] initWithFrame:CGRectMake(DC_DCP_SCREEN_WIDTH-54, 16, 24, 24)];
    _arrowView.image = DC_image(@"ic_select_text");
    [self.contentView addSubview:_arrowView];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(16, 55, DC_DCP_SCREEN_WIDTH-32, 1)];
    _lineView.backgroundColor = DC_UIColorFromRGB(0xE8E8E8);
    [self.contentView addSubview:_lineView];
}

- (void)configGroupCell{
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.statusIV];
    [_bgView addSubview:self.selectIV];
    [_bgView addSubview:self.numberLabel];
    [_bgView addSubview:self.lineView];
        
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.top.mas_equalTo(12);
        make.leading.mas_equalTo(16);
    }];
    
    [_selectIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.trailing.mas_equalTo(-16);
    }];
    
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(32);
        make.top.mas_equalTo(12);
        make.leading.mas_equalTo(self.statusIV.mas_trailing).offset(8);
    }];
        
    
    if(showStatusTag){
        [_bgView addSubview:self.statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.numberLabel.mas_centerY).offset(0);
            make.leading.mas_equalTo(self.numberLabel.mas_trailing).offset(8);
            make.height.mas_equalTo(18);
        }];
    }
    
    if(showPaidFlagTag){
        [_bgView addSubview:self.paidFlagLabel];
        [_paidFlagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
            make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(5);
            make.leading.mas_equalTo(self.statusIV.mas_trailing).offset(8);
            make.bottom.mas_equalTo(self.lineView.mas_top).offset(-12);
        }];
    }else{
    }
    
}

- (void)configViewMyHouseCell {
    [self.contentView addSubview:self.bgView];
    [_bgView addSubview:self.statusIV];
    [_bgView addSubview:self.viewMyHouseLabel];
    [_bgView addSubview:self.lineView];
    [_bgView addSubview:self.bundleNameLabel];
        
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.bottom.mas_equalTo(0);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [_statusIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.bundleNameLabel.mas_centerY);
        make.leading.mas_equalTo(16);
    }];
    
    [_bundleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.leading.mas_equalTo(self.statusIV.mas_trailing).offset(8);
        make.centerY.mas_equalTo(self.bgView.mas_centerY);
        make.bottom.mas_equalTo(-12);
    }];
    
    [_viewMyHouseLabel mas_makeConstraints:^(MASConstraintMaker *make) {        make.centerY.mas_equalTo(self.bundleNameLabel.mas_centerY);
        make.trailing.mas_equalTo(-16);
        make.width.mas_equalTo(99);
        make.leading.equalTo(self.bundleNameLabel.mas_trailing).offset(16);
    }];
}


- (void)setContentWithIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray * arr = [DXPPBDataManager shareInstance].totalSubsListArr[indexPath.section];
	DCPBSubsItemModel *model = [arr objectAtIndex:indexPath.row];
    self.titleLab.text = [PbTools numberFormatWithString:model.accNbr rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule];
    
    if ([model.accNbr isEqualToString:[DXPPBDataManager shareInstance].selectedSubsModel.accNbr]) {
        self.arrowView.hidden = NO;
        self.titleLab.textColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-global-color-primary"];
    } else {
        self.arrowView.hidden = YES;
        self.titleLab.textColor = DC_UIColorFromRGB(0x242424);
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

- (void)setContentWithBundleModel:(DCSubsBundleModel *)model {
    self.bundleModel = model;
    self.lineView.hidden = NO;
    self.bundleNameLabel.text = model.bundleOfferName;
    self.statusIV.image =  DC_image(@"family_plan_bundle");
    self.bgView.backgroundColor = DC_UIColorFromRGB(0xF2F8FB);
}

- (void)setContentWithModel:(DCPBSubsItemModel *)model {
    self.subsItemModel = model;
    self.lineView.hidden = model.isLastRow;
    self.numberLabel.text = [PbTools numberFormatWithString:model.accNbr rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule];
    
    if ([model.accNbr isEqualToString:[DXPPBDataManager shareInstance].selectedSubsModel.accNbr]) {
        _selectIV.image = [[HJImageManager shareInstance] getImageByName:@"radio_yes"];
    } else {
        _selectIV.image = [[HJImageManager shareInstance] getImageByName:@"radio_no"];
    }
    
    _statusIV.image =  [UIImage imageNamed: [model.primaryFlag isEqualToString:@"Y"]  ?  @"family_plan_principal" : @"family_plan_secondary"];
    
    if([model.serviceTypeCode isEqualToString:@"MOBILE"]){
        if([model.state isEqualToString:@"A"]){///active 状态
            if([model.primaryFlag isEqualToString:@"Y"]){///主卡
                _statusIV.image = DC_image(@"family_plan_principal");
            }else if([model.primaryFlag isEqualToString:@"N"]){///副卡
                _statusIV.image = DC_image(@"family_plan_secondary");
            }else{//独立卡
                _statusIV.image = DC_image(@"family_plan_principal");
            }
        }else{///非激活状态
            _statusIV.image = DC_image(@"ic_state_blocked");
        }
        
        _paidFlagLabel.backgroundColor = DC_UIColorFromRGB(0xebebeb);
        _paidFlagLabel.textColor = DC_UIColorFromRGB(0x545454);
        if(showPaidFlagTag){//展示预后付费
            bool isPrepaid = [model.paidFlag isEqualToString:@"0"];
            NSString * paidStr = isPrepaid ? [[HJLanguageManager shareInstance] getTextByKey:@"lb_prepaid"] : [[HJLanguageManager shareInstance] getTextByKey:@"lb_postpaid"];
            NSString * primaryStr ;
            if([model.primaryFlag isEqualToString:@"Y"]){
                primaryStr = [[HJLanguageManager shareInstance] getTextByKey:@"lb_principal"];
                _paidFlagLabel.text = [NSString stringWithFormat:@"  %@ / %@  ",paidStr,primaryStr];
            }else if([model.primaryFlag isEqualToString:@"N"]){
                primaryStr = [[HJLanguageManager shareInstance] getTextByKey:@"lb_supplementary"];
                _paidFlagLabel.text = [NSString stringWithFormat:@"  %@ / %@  ",paidStr,primaryStr];
            }else{
                _paidFlagLabel.text = [NSString stringWithFormat:@"  %@  ",paidStr];
            }
            [_paidFlagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(18);
            }];
            
        }else{//不展示预后付费，展示主副卡
            NSString * primaryStr ;
            if([model.primaryFlag isEqualToString:@"Y"]){//
                primaryStr = [[HJLanguageManager shareInstance] getTextByKey:@"lb_principal"];
                _paidFlagLabel.text = [NSString stringWithFormat:@"  %@  ",primaryStr];
                [_paidFlagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(18);
                }];
            }else if([model.primaryFlag isEqualToString:@"N"]){
                primaryStr = [[HJLanguageManager shareInstance] getTextByKey:@"lb_supplementary"];
                _paidFlagLabel.text = [NSString stringWithFormat:@"  %@  ",primaryStr];
                [_paidFlagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(18);
                }];
            }else{
                _paidFlagLabel.text = @"";
                [_paidFlagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
            }
        }
        
    }else if([model.serviceTypeCode isEqualToString:@"BROADBAND"]){
        _statusIV.image = DC_image(@"ic_broadband");
    }else if([model.serviceTypeCode isEqualToString:@"IPTV"]){
        _statusIV.image = DC_image(@"ic_iptv");
    }else if([model.serviceTypeCode isEqualToString:@"FWA"]){
        _statusIV.image = DC_image(@"family_plan_principal");
        
        NSString * paidStr = [[HJLanguageManager shareInstance] getTextByKey:@"lb_fwa"];
        if (showPaidFlagTag) {
            bool isPrepaid = [model.paidFlag isEqualToString:@"0"];
			paidStr = isPrepaid ? [[HJLanguageManager shareInstance] getTextByKey:@"lb_prepaid_fwa"] : [[HJLanguageManager shareInstance] getTextByKey:@"lb_postpaid_fwa"];
        }
        _paidFlagLabel.text = [NSString stringWithFormat:@"  %@  ",paidStr];
        _paidFlagLabel.backgroundColor = DC_UIColorFromRGB(0xebebeb);
        _paidFlagLabel.textColor = DC_UIColorFromRGB(0x545454);
        [_paidFlagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(18);
        }];
    }else if([model.serviceTypeCode isEqualToString:@"FIXED_LINE"]){
        _statusIV.image = DC_image(@"ic_fixed_line");
    }
    
    
    if (showStatusTag) {
        if (DC_IsStrEmpty(model.stateName)) {
            _statusLabel.text = @"";
        } else {
            NSString *interStatusStr = [PbTools getStateNameWithstateName:model.stateName
                                                                  state:model.state
                                                               paidFlag:model.paidFlag];
            
            _statusLabel.text = [NSString stringWithFormat:@"  %@  ", interStatusStr];
            
            _statusLabel.textColor = [PbTools getStateColorWithstate:model.state];
            _statusLabel.backgroundColor = [_statusLabel.textColor colorWithAlphaComponent:0.1];
        }
    }

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark -- lazy load
- (UIView *)bgView{
    if(!_bgView){
        _bgView = [[UIView alloc] init];
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = DC_UIColorFromRGB(0xffffff);
    }
    return _bgView;
}

- (UIImageView *)statusIV{
    if(!_statusIV){
        _statusIV = [[UIImageView alloc] init];
    }
    return _statusIV;
}

- (UIImageView *)selectIV{
    if(!_selectIV){
        _selectIV = [[UIImageView alloc] initWithImage:[[HJImageManager shareInstance] getImageByName:@"radio_no"]];
    }
    return _selectIV;
}

- (UILabel *)numberLabel{
    if(!_numberLabel){
        _numberLabel = [[UILabel alloc] init];
        _numberLabel.textColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-textColor"];
        _numberLabel.font = FONT_BS(14);
    }
    return _numberLabel;
}

- (UIView *)lineView{
    
    if(!_lineView){
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DC_UIColorFromRGB(0xd5d5d5);
    }
    return _lineView;
}


- (UILabel *)statusLabel{
    if(!_statusLabel){
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = FONT_BS(12);
        _statusLabel.layer.masksToBounds = YES;
        _statusLabel.layer.cornerRadius = 9;
    }
    return _statusLabel;
}

- (UILabel *)paidFlagLabel{
    if(!_paidFlagLabel){
        _paidFlagLabel = [[UILabel alloc] init];
        _paidFlagLabel.font = FONT_S(12);
        _paidFlagLabel.layer.masksToBounds = YES;
        _paidFlagLabel.layer.cornerRadius = 9;
    }
    return _paidFlagLabel;
}

- (UILabel *)bundleNameLabel {
    if (!_bundleNameLabel) {
        _bundleNameLabel = [[UILabel alloc] init];
        _bundleNameLabel.textColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-textColor"];
        _bundleNameLabel.font = FONT_BS(14);
        _bundleNameLabel.numberOfLines = 0;
    }
    return _bundleNameLabel;
}

- (UILabel *)viewMyHouseLabel {
    if(!_viewMyHouseLabel){
        _viewMyHouseLabel = [[UILabel alloc] init];
        _viewMyHouseLabel.textColor = DC_UIColorFromRGB(0x0077A6);
        _viewMyHouseLabel.font = FONT_BS(14);
		_viewMyHouseLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_view_my_house"];
    }
    return _viewMyHouseLabel;
}

- (DCSubsBundleModel *)bundleModel {
    if (!_bundleModel) {
        _bundleModel = [[DCSubsBundleModel alloc] init];
    }
    return _bundleModel;
}

@end
