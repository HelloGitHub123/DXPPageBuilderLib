//
//  DCSubsSelect.m
//  HJControls
//
//  Created by mac on 2022/10/9.
//

#import "DCSubsSelect.h"
#import "DCSelectSubsListView.h"
#import <Masonry/Masonry.h>
#import <DXPManagerLib/HJLanguageManager.h>

#import "DCSubsListModel.h"
#import <DXPToolsLib/HJTool.h>
#import <DXPManagerLib/HJTokenManager.h>
#import <DXPManagerLib/HJImageManager.h>
#import "DCPB.h"

@interface DCSubsSelect ()

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIView *accountView;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) UIImageView *downArrow;

@end

@implementation DCSubsSelect

- (id)init {
    self = [super init];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)initData {
    //默认值
    _showLabel = YES;
    _label = @"";
    _placeholder = [[HJLanguageManager shareInstance] getTextByKey:@"tip_please_select"];
    _isRequired = YES;
}

- (void)initUI {
    [self addSubview:self.titleLab];
    [self addSubview:self.accountView];
    [self.accountView addSubview:self.accountTF];
    [self.accountView addSubview:self.downArrow];
    [self.accountView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSubsList)]];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(0);
    }];
    
    //
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLab.mas_bottom);
        make.leading.trailing.mas_equalTo(0).priorityHigh();
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0).priorityHigh();
    }];
    
    [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(self.downArrow.mas_leading).offset(-8);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.downArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountTF.mas_centerY);
        make.trailing.mas_equalTo(-16);
        make.width.height.mas_equalTo(24);
    }];
}

#pragma mark - 展示订户列表
- (void)showSubsList {
	DCSelectSubsListView *view = [[DCSelectSubsListView alloc] initWithBlock:^(id _Nonnull model) {
        [DXPPBDataManager shareInstance].selectedSubsModel = (DCPBSubsItemModel *)model;
        self.accountTF.text = [PbTools numberFormatWithString:[DXPPBDataManager shareInstance].selectedSubsModel.accNbr rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule];
    }];
    [view show];
}

#pragma mark - setter
- (void)setShowLabel:(BOOL)showLabel {
    _showLabel = showLabel;
    self.titleLab.hidden = !_showLabel;
    
    if (_showLabel) {
        [self.accountView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom);
        }];
    } else {
        [self.accountView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.leading.trailing.mas_equalTo(0).priorityHigh();
            make.height.mas_equalTo(50);
            make.bottom.mas_equalTo(0).priorityHigh();
        }];
    }
}

- (void)setLabel:(NSString *)label {
    _label = label;
    
    if (label.length != 0 && _showLabel) {
        NSString *string = _isRequired?[NSString stringWithFormat:@"%@ *", _label]:_label;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
        [attr addAttributes:@{NSForegroundColorAttributeName:[[HJTokenManager shareInstance] getColorByToken:@"ref-form-labelColor"],
                        NSFontAttributeName:FONT_S(14)} range:NSMakeRange(0, label.length)];
        [attr addAttributes:@{NSForegroundColorAttributeName:[[HJTokenManager shareInstance] getColorByToken:@"ref-form-tipsColor-error"],
                        NSFontAttributeName:FONT_S(14)} range:[string rangeOfString:@"*"]];
        self.titleLab.attributedText = attr;
        
        [self.accountView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLab.mas_bottom).offset(8);
        }];
    } else {
        [self.accountView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
    }
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.accountTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placeholder attributes:@{NSForegroundColorAttributeName: [[HJTokenManager shareInstance] getColorByToken:@"ref-form-textColor-placeholder"]}];
}

- (void)setIsRequired:(BOOL)isRequired {
    _isRequired = isRequired;
    if (_label.length > 0) {
        self.label = _label;
    }
}

- (void)setIsDisable:(BOOL)isDisable {
    if (isDisable) {
//        self.accountView.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-fillColor-disable"];
        [[HJTokenManager shareInstance] setViewBackgroundColorWithToken:@"ref-form-fillColor-disable" view:self.accountView size:self.accountView.frame.size];
    } else {
//        self.accountView.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-fillColor"];
        [[HJTokenManager shareInstance] setViewBackgroundColorWithToken:@"ref-form-fillColor" view:self.accountView size:self.accountView.frame.size];
    }
}

#pragma mark - 获取输入框的值
- (NSString *)getInputValue {
    return self.accountTF.text;
}

#pragma mark -赋值输入框的内容
- (void)setInputValue:(NSString *)text {
    self.accountTF.text = text;
}

#pragma mark - 清空输入框的值
- (void)cleanInputValue {
    self.accountTF.text = @"";
}


#pragma mark - lazy
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 0;
    }
    return _titleLab;
}

- (UIView *)accountView {
    if (!_accountView) {
        _accountView = [[UIView alloc] init];
        _accountView.layer.cornerRadius = 12;
        _accountView.layer.borderColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-strokeColor"].CGColor;
        _accountView.layer.borderWidth = 1;
//        _accountView.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-fillColor"];
        [[HJTokenManager shareInstance] setViewBackgroundColorWithToken:@"ref-form-fillColor" view:_accountView size:_accountView.frame.size];
    }
    return _accountView;
}

- (UITextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [[UITextField alloc] init];
        _accountTF.textColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-textColor"];
        _accountTF.font = FONT_S(14);
        _accountTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placeholder attributes:@{NSForegroundColorAttributeName: [[HJTokenManager shareInstance] getColorByToken:@"ref-form-textColor-placeholder"]}];
        _accountTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTF.keyboardType = UIKeyboardTypeASCIICapable;
        [_accountTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [_accountTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        _accountTF.userInteractionEnabled = NO;
        _accountTF.text = [PbTools numberFormatWithString:[DXPPBDataManager shareInstance].selectedSubsModel.accNbr rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule];
    }
    return _accountTF;
}

- (UIImageView *)downArrow {
    if (!_downArrow) {
        _downArrow = [[UIImageView alloc] init];
        _downArrow.image = [[HJImageManager shareInstance] getImageByName:@"ic_drop_down"];
    }
    return _downArrow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
