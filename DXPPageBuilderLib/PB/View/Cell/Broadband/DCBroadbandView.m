//
//  DCBroadbandView.m
//  AFNetworking
//
//  Created by Lee on 28.2.24.
//

#import "DCBroadbandView.h"
#import <Masonry/Masonry.h>
#import "DCBroadbandAccountCellModel.h"
#import "DCPBDownUploadBtnView.h"
#import <DXPCategoryLib/UIImage+Category.h>
#import <DXPCategoryLib/UIColor+Category.h>
#import "DCSubsDetailModel.h"
#import "DCPB.h"
#import "DCSubsListModel.h"

@interface DCBroadbandView()
@property (nonatomic, strong) UIImageView * iconIV;

@property (nonatomic, strong) UILabel * nameLabel;

@property (nonatomic, strong) UIButton * switchUserBtn;

@property (nonatomic, strong) UIImageView * dotIV;

@property (nonatomic, strong) UILabel * stateLabel;

@property (nonatomic, strong) UILabel * lineLabel;

@property (nonatomic, strong) UILabel * accountNoLabel;

@property (nonatomic, strong) UILabel * accountNoValueLabel;

@property (nonatomic, strong) UILabel * mainPlanLabel;

@property (nonatomic, strong) UILabel * mainPlanValueLabel;

@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) UILabel * addressValueLabel;

@property (nonatomic, strong) DCPBDownUploadBtnView * downloadBtn;

@property (nonatomic, strong) DCPBDownUploadBtnView * uploadBtn;

@property (nonatomic, strong) DCBroadbandAccountCellModel * accountCellModel;
@end

@implementation DCBroadbandView

- (instancetype)initWithFrame:(CGRect)frame withModel:(DCBroadbandAccountCellModel *)cellModel{
    
    if(self = [super initWithFrame:frame]){
        _accountCellModel = cellModel;
        NSMutableDictionary *dic = cellModel.customData;
        NSMutableDictionary *subsData = [cellModel.customData objectForKey:@"subsDetail"];
		DCSubsDetailModel *subDetailModel = [DCSubsDetailModel yy_modelWithDictionary:subsData];
        CompositionProps *propsDic = cellModel.props;
        self.backgroundColor = [UIColor colorWithHexString:propsDic.bgColor];
        NSString *upLoadVal = @"";
        NSString *downLoadVal = @"";
        
        @try {
            NSString *mainPlanVal = [dic objectForKey:@"MainPlan"];
            upLoadVal = [dic objectForKey:@"upLoadVal"];
            downLoadVal = [dic objectForKey:@"downLoadVal"];
            NSString * addressStr = [dic objectForKey:@"Address"];
            self.nameLabel.text = DC_IsStrEmpty(subDetailModel.accNbr)?@" ":subDetailModel.accNbr;
            
            if (DC_IsStrEmpty(subDetailModel.state)) {
                self.stateLabel.text = @" ";
                self.dotIV.backgroundColor = [UIColor clearColor];
            } else {
                self.stateLabel.text = [PbTools getStateNameWithstateName:subDetailModel.stateName
                                                                state:subDetailModel.state
                                                             paidFlag:subDetailModel.paidFlag];

                self.stateLabel.textColor = [PbTools getStateColorWithstate:subDetailModel.state];
                self.dotIV.backgroundColor = self.stateLabel.textColor;
            }
            
            self.accountNoValueLabel.text = DC_IsStrEmpty(subDetailModel.defaultAcctNbr)?@" ":subDetailModel.defaultAcctNbr;
            self.mainPlanValueLabel.text = DC_IsStrEmpty(mainPlanVal)?@" ":mainPlanVal;
            self.addressValueLabel.text = DC_IsStrEmpty(addressStr)?@" ":addressStr;
            
        } @catch (NSException *exception) {
            
        }
        
        UIColor * mainIconColor = [UIColor colorWithHexString:propsDic.mainIconColor];
        
        UIColor *switchBtnColor = [UIColor colorWithHexString:propsDic.mainIconColor];
        UIColor *switchBtnBgColor = [UIColor colorWithHexString:propsDic.mainIconColor alpha:0.2];
        UIImage *iconImage = [UIImage svgImageNamed:@"switch" tintColor:switchBtnColor];
        [self.switchUserBtn setBackgroundColor:switchBtnBgColor];
        [self.switchUserBtn setImage:iconImage forState:UIControlStateNormal];
        
        if ([[DXPPBDataManager shareInstance].selectedSubsModel.serviceTypeCode isEqualToString:@"BROADBAND"]) {
            [self configAllView];
            ///如果是BROADBAND
            _iconIV.image = [UIImage svgImageNamed:@"Broadband" tintColor:mainIconColor];
            
            UIColor *color = [UIColor colorWithHexString:propsDic.downloadIconColor];
            UIImage *iconBtnImage = [UIImage svgNamed:@"download" cgColor:color.CGColor];
            [self.downloadBtn.iconBtn setImage:iconBtnImage forState:UIControlStateNormal];
            [self.downloadBtn.iconBtn setBackgroundColor:[UIColor colorWithHexString:propsDic.downloadIconBgColor]];
            
			self.downloadBtn.titleLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"btn_fixed_download"];
            _downloadBtn.backgroundColor =  [UIColor colorWithHexString:propsDic.downloadBgColor];
            self.downloadBtn.speedLabel.text = DC_IsStrEmpty(downLoadVal)?@"":downLoadVal;
            
            
            UIColor *uploadcolor = [UIColor colorWithHexString:propsDic.uploadIconColor];
            [self.uploadBtn.iconBtn setBackgroundColor:[UIColor colorWithHexString:propsDic.uploadIconBgColor]];
            [self.uploadBtn.iconBtn setImage:[UIImage svgImageNamed:@"upload" tintColor:uploadcolor] forState:UIControlStateNormal];
			self.uploadBtn.titleLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"btn_fixed_upload"];
            _uploadBtn.backgroundColor =  [UIColor colorWithHexString:propsDic.uploadBgColor];
            self.uploadBtn.speedLabel.text = DC_IsStrEmpty(upLoadVal)?@"":upLoadVal;
            
            BOOL isSpeed = ([upLoadVal floatValue] > 0 && [downLoadVal floatValue] > 0);
            if (isSpeed) {
                self.uploadBtn.hidden = NO;
                self.downloadBtn.hidden = NO;
                
                [self.addressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(-16);
                    make.top.mas_equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
                    make.leading.mas_equalTo(self.addressLabel.mas_trailing).offset(2);
                }];
                
                [self.downloadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.leading.mas_equalTo(16);
                    make.top.mas_equalTo(self.addressValueLabel.mas_bottom).offset(16);
                    make.height.mas_equalTo(56);
                    make.width.mas_equalTo(DC_DCP_SCREEN_WIDTH/2.0-40);
                    make.bottom.mas_equalTo(-16);
                }];
                
            } else {
                self.uploadBtn.hidden = YES;
                self.downloadBtn.hidden = YES;
                
                [self.addressValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.trailing.mas_equalTo(-16);
                    make.top.mas_equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
                    make.leading.mas_equalTo(self.addressLabel.mas_trailing).offset(2);
                    make.bottom.mas_equalTo(-16);
                }];
            }
            
        }else{
            [self configView];
            if ([[DXPPBDataManager shareInstance].selectedSubsModel.serviceTypeCode isEqualToString:@"IPTV"]){
                _iconIV.image = [UIImage svgImageNamed:@"IPTV" tintColor:mainIconColor];
            }else  if ([[DXPPBDataManager shareInstance].selectedSubsModel.serviceTypeCode isEqualToString:@"FIXED_LINE"]){
                _iconIV.image = [UIImage svgImageNamed:@"VOBB" tintColor:mainIconColor];
            }else{
                _iconIV.image = [UIImage svgImageNamed:@"Mobile" tintColor:mainIconColor];
            }
        }
        
        
        //
        if ([DXPPBDataManager shareInstance].totalSubsArr.count <= 1) {
            self.switchUserBtn.hidden = YES;
            [self.dotIV mas_updateConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(15);
            }];
        } else {
            self.switchUserBtn.hidden = NO;
        }
        
        [self initData];
        
    }
    return self;
}

- (void)initData{
    
    
}

- (void)configView{
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLabel];
    [self addSubview:self.switchUserBtn];
    [self addSubview:self.dotIV];
    [self addSubview:self.stateLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.accountNoLabel];
    [self addSubview:self.accountNoValueLabel];
    [self addSubview:self.mainPlanLabel];
    [self addSubview:self.mainPlanValueLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.addressValueLabel];

    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIV.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
    }];
    
    [_switchUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_dotIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(45);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.dotIV.mas_trailing).offset(2);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.iconIV.mas_bottom).offset(7);
        make.height.mas_equalTo(1);
    }];
    
    [_accountNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
    }];
    
    [_accountNoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.accountNoLabel.mas_trailing).offset(2);
    }];
    
    [_mainPlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.accountNoValueLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
    }];
    
    [_mainPlanValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.accountNoValueLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.mainPlanLabel.mas_trailing).offset(2);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
    }];
    
    [_addressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.addressLabel.mas_trailing).offset(2);
        make.bottom.mas_equalTo(-16);
    }];
    
}

- (void)configAllView{
    [self addSubview:self.iconIV];
    [self addSubview:self.nameLabel];
    [self addSubview:self.switchUserBtn];
    [self addSubview:self.dotIV];
    [self addSubview:self.stateLabel];
    [self addSubview:self.lineLabel];
    [self addSubview:self.accountNoLabel];
    [self addSubview:self.accountNoValueLabel];
    [self addSubview:self.mainPlanLabel];
    [self addSubview:self.mainPlanValueLabel];
    [self addSubview:self.addressLabel];
    [self addSubview:self.addressValueLabel];

    [self addSubview:self.downloadBtn];
    [self addSubview:self.uploadBtn];
    
    [_iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.leading.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.iconIV.mas_trailing).offset(4);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
    }];
    
    [_switchUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [_dotIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.nameLabel.mas_trailing).offset(45);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(4, 4));
    }];
    
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.dotIV.mas_trailing).offset(2);
        make.centerY.mas_equalTo(self.iconIV.mas_centerY);
    }];
    
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.iconIV.mas_bottom).offset(7);
        make.height.mas_equalTo(1);
    }];
    
    
    [_accountNoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
    }];
    
    [_accountNoValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.lineLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.accountNoLabel.mas_trailing).offset(2);
    }];
    
    [_mainPlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.accountNoValueLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
    }];
    
    [_mainPlanValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.accountNoValueLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.mainPlanLabel.mas_trailing).offset(2);
    }];
    
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(80);
    }];
    
    [_addressValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.mainPlanValueLabel.mas_bottom).offset(8);
        make.leading.mas_equalTo(self.addressLabel.mas_trailing).offset(2);
    }];
    
    [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.top.mas_equalTo(self.addressValueLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(DC_DCP_SCREEN_WIDTH/2.0-40);
        make.bottom.mas_equalTo(-16);
    }];

    [_uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(self.addressValueLabel.mas_bottom).offset(16);
        make.height.mas_equalTo(56);
        make.width.mas_equalTo(DC_DCP_SCREEN_WIDTH/2.0-40);
    }];

}

// MARK: LAZY
- (void)exchageBtnAction {
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = @"EXCHANDE_NUM";
    model.floorEventType = DCFloorEventCustome;
    [self hj_routerEventWith:model];
}

#pragma mark -- lazy load
- (UIImageView *)iconIV{
    if(!_iconIV){
        _iconIV = [[UIImageView alloc] init];
    }
    return _iconIV;
}

- (UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = DC_UIColorFromRGB(0x242424);
        _nameLabel.font = FONT_BS(14);
    }
    return _nameLabel;
}

- (UIButton *)switchUserBtn{
    if (!_switchUserBtn) {
        _switchUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchUserBtn.layer.masksToBounds = YES;
        _switchUserBtn.layer.cornerRadius = 10.f;
        [_switchUserBtn addTarget:self action:@selector(exchageBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchUserBtn;
}

- (UIImageView *)dotIV{
    if(!_dotIV){
        _dotIV = [[UIImageView alloc] init];
        _dotIV.layer.masksToBounds = YES;
        _dotIV.layer.cornerRadius = 2.f;
    }
    return _dotIV;
}

- (UILabel *)stateLabel{
    if(!_stateLabel){
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = FONT_S(14);
        _stateLabel.textColor = DC_UIColorFromRGB(0xD82E00);
    }
    return _stateLabel;
}
- (UILabel *)lineLabel{
    if(!_lineLabel){
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = DC_UIColorFromRGB(0xFFDFCC);
    }
    return _lineLabel;
}

- (UILabel *)accountNoLabel {
    if(!_accountNoLabel){
        _accountNoLabel = [[UILabel alloc] init];
        _accountNoLabel.font = FONT_S(14);
        _accountNoLabel.textColor = DC_UIColorFromRGB(0x545454);
		_accountNoLabel.text  = [[HJLanguageManager shareInstance] getTextByKey:@"lb_account_no"];
    }
    return _accountNoLabel;
}

- (UILabel *)accountNoValueLabel {
    if(!_accountNoValueLabel){
        _accountNoValueLabel = [[UILabel alloc] init];
        _accountNoValueLabel.font = FONT_BS(14);
        _accountNoValueLabel.textColor = DC_UIColorFromRGB(0x242424);
        _accountNoValueLabel.numberOfLines = 0;
        _accountNoValueLabel.text = @" ";
    }
    return _accountNoValueLabel;
}

- (UILabel *)mainPlanLabel{
    if(!_mainPlanLabel){
        _mainPlanLabel = [[UILabel alloc] init];
        _mainPlanLabel.font = FONT_S(14);
        _mainPlanLabel.textColor = DC_UIColorFromRGB(0x545454);
		_mainPlanLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_main_plan"];
    }
    return _mainPlanLabel;
}

- (UILabel *)mainPlanValueLabel {
    if(!_mainPlanValueLabel){
        _mainPlanValueLabel = [[UILabel alloc] init];
        _mainPlanValueLabel.font = FONT_BS(14);
        _mainPlanValueLabel.textColor = DC_UIColorFromRGB(0x242424);
        _mainPlanValueLabel.numberOfLines = 0;
        _mainPlanValueLabel.text = @" ";
    }
    return _mainPlanValueLabel;
}

- (UILabel *)addressLabel{
    if(!_addressLabel){
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = FONT_S(14);
        _addressLabel.textColor = DC_UIColorFromRGB(0x545454);
		_addressLabel.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_address"];
    }
    return _addressLabel;
}

- (UILabel *)addressValueLabel {
    if(!_addressValueLabel){
        _addressValueLabel = [[UILabel alloc] init];
        _addressValueLabel.font = FONT_BS(14);
        _addressValueLabel.textColor = DC_UIColorFromRGB(0x242424);
        _addressValueLabel.numberOfLines = 0;
        _addressValueLabel.text = @" ";
    }
    return _addressValueLabel;
}

- (DCPBDownUploadBtnView *)downloadBtn{
    if(!_downloadBtn){
        _downloadBtn = [[DCPBDownUploadBtnView alloc] init];
       
    }
    return _downloadBtn;
}

- (DCPBDownUploadBtnView *)uploadBtn{
    if(!_uploadBtn){
        _uploadBtn = [[DCPBDownUploadBtnView alloc] init];
    }
    return _uploadBtn;
}

@end
