//
//  DCPBSMSVerificationPopView.m
//  BOL
//
//  Created by 李标 on 2023/7/23.
//

#import "DCPBSMSVerificationPopView.h"
#import <Masonry/Masonry.h>
#import <DXPToolsLib/HJMBProgressHUD+Category.h>
#import <DXPToolsLib/SNAlertMessage.h>
#import "DCSendEmailOtpViewModel.h"
#import <DXPManagerLib/HJLanguageManager.h>
#import <DXPManagerLib/HJTokenManager.h>
#import "DXPPBConfigManager.h"
#import "DCPB.h"
#import "DCSendOtpViewModel.h"

@interface DCPBSMSVerificationPopView  ()<UITextFieldDelegate, HJVMRequestDelegate_PB> {
    CGFloat buttonWidth;
    SMSVerificationBlock _SMSVerificationBlock;
    NSString *_contactNbr;
    NSString *_switchedAccNbr;
    NSString *_switchedServiceType;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIView *serviceNumberView;
@property (nonatomic, strong) UILabel *serviceNumberLab;
@property (nonatomic, strong) UILabel *accNbrLab;
@property (nonatomic, strong) UILabel *descLab; // 验证码发送提示语
@property (nonatomic, strong) UIView *bgCodeView;
@property (nonatomic, strong) UITextField *codeTextField;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UILabel *errorLab;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *nextBtn;

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) DCSendOtpViewModel *sendOTPVM;

@end

@implementation DCPBSMSVerificationPopView

- (id)initWithSwitchedAccNbr:(NSString *)switchedAccNbr switchedServiceType:(NSString *)type block:(SMSVerificationBlock)block {
    self = [super init];
    if (self) {
        _SMSVerificationBlock = block;
        _switchedAccNbr = switchedAccNbr;
        _switchedServiceType = type;
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.frame = CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, DC_SCREEN_HEIGHT);
    CGFloat alertWidth = DC_DCP_SCREEN_WIDTH - 64;
    buttonWidth = (alertWidth-24*2-12)/2;
    
    [self addSubview:self.bgView];
    [self animationAlert:self.alertView];
    [self addSubview:self.alertView];
    [self.alertView addSubview:self.titleLab];
    [self.alertView addSubview:self.serviceNumberView];
    [self.serviceNumberView addSubview:self.serviceNumberLab];
    [self.serviceNumberView addSubview:self.accNbrLab];
    [self.alertView addSubview:self.descLab];
    [self.alertView addSubview:self.bgCodeView];
    [self.bgCodeView addSubview:self.codeTextField];
    [self.bgCodeView addSubview:self.getBtn];
    [self.alertView addSubview:self.errorLab];
    [self.alertView addSubview:self.cancelBtn];
    [self.alertView addSubview:self.nextBtn];

    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.alertView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(32);
        make.trailing.mas_equalTo(-32);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24);
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        make.height.mas_equalTo(26);
    }];
    
    [self.serviceNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        make.height.mas_equalTo(42);;
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
    }];
    
    [self.serviceNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(12);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    [self.accNbrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-12);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(22);
        make.width.greaterThanOrEqualTo(@20);
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serviceNumberView.mas_bottom).offset(16);
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        make.height.greaterThanOrEqualTo(@22);
    }];
    
    [self.bgCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLab.mas_bottom).offset(8);
        make.leading.mas_equalTo(24);
        make.trailing.mas_equalTo(-24);
        make.height.mas_equalTo(44);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(11);
        make.leading.mas_equalTo(16);
        make.trailing.equalTo(self.getBtn.mas_leading).offset(-16);
        make.height.mas_equalTo(22);
    }];
    
    [self.getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.trailing.mas_equalTo(-16);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(22);
    }];
    
    [self.errorLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgCodeView.mas_bottom).offset(3);
        make.leading.mas_equalTo(self.bgCodeView.mas_leading);
        make.trailing.mas_equalTo(self.bgCodeView.mas_trailing);
        make.height.equalTo(@0);
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.errorLab.mas_bottom).offset(16);
        make.leading.mas_equalTo(24);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(-24);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cancelBtn.mas_centerY);
        make.trailing.mas_equalTo(-24);
        make.width.mas_equalTo(buttonWidth);
        make.height.mas_equalTo(40);
    }];
}

- (void)show {
    UIWindow *shareWindow = [UIApplication sharedApplication].delegate.window;
    [shareWindow addSubview:self];
}

- (void)dismiss {
    [self stopTimer];
    [self removeFromSuperview];
    _SMSVerificationBlock(@"", kActionType_Cancel, @"");
}

#pragma mark - 获取验证码
- (void)getOTPCode {
    [self.sendOTPVM sendSwitchSubsOtpWithSwitchedAccNbr:_switchedAccNbr switchedServiceType:_switchedServiceType]; // 发送获取订户切换OTP
}

- (void)startTimer {
    __block int timeout = [DXPPBConfigManager shareInstance].countDown == 0?60:[DXPPBConfigManager shareInstance].countDown;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer , dispatch_walltime(nil, 0), 1000*NSEC_PER_MSEC, 0);
    dispatch_source_set_event_handler(self.timer , ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getBtn.userInteractionEnabled = YES;
                [self.getBtn setTitle:[[HJLanguageManager shareInstance] getTextByKey:@"btn_get"] forState:UIControlStateNormal];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.getBtn.userInteractionEnabled = NO;
                [self.getBtn setTitle:[NSString stringWithFormat:@"%ds", timeout] forState:UIControlStateNormal];
                timeout -= 1;
            });
        }
    });
    dispatch_resume(self.timer);
}

- (void)stopTimer {
    if (self.timer) dispatch_source_cancel(self.timer);
}

#pragma mark - 点击confirm
-(void)nextBtnClick {
    [self endEditing:YES];
    if (_SMSVerificationBlock) {
        if (!DC_IsStrEmpty(self.codeTextField.text)) {
            //            [self stopTimer];
            //            [self removeFromSuperview];
            //            _SMSVerificationBlock(self.codeTextField.text, kActionType_OK, self.sendOTPVM.contactNbr);
            _SMSVerificationBlock(self.codeTextField.text, kActionType_OK, _switchedAccNbr);
        }
    }
}

- (void)setContentVal:(NSString *)errorStr {
    if (!DC_IsStrEmpty(errorStr)) {
        self.errorLab.text = [NSString stringWithFormat:@"ꔷ %@",errorStr];
        self.bgCodeView.layer.borderColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-stokeColor-error"].CGColor;
        self.bgCodeView.layer.borderWidth = 1;
        
        [self.errorLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgCodeView.mas_bottom).offset(3);
            make.leading.mas_equalTo(self.bgCodeView.mas_leading);
            make.trailing.mas_equalTo(self.bgCodeView.mas_trailing);
            make.height.greaterThanOrEqualTo(@22);
        }];
    }
}

#pragma mark - HJVMRequestDelegate_PB
- (void)requestStart:(NSObject *)vm method:(NSString *)methodFlag {
    [HJMBProgressHUD showLoading];
}

- (void)requestSuccess:(NSObject *)vm method:(NSString *)methodFlag {
    [HJMBProgressHUD hideLoading];
    if ([methodFlag isEqualToString:sendSwitchSubsOtp]) {
        [self startTimer];
    }
}

- (void)requestFailure:(NSObject *)vm method:(NSString *)methodFlag {
    [HJMBProgressHUD hideLoading];
    if ([methodFlag isEqualToString:sendSwitchSubsOtp]) {
        [SNAlertMessage displayMessageInView:[UIApplication sharedApplication].delegate.window Message:self.sendOTPVM.errorMsg];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "]) return NO;
    NSString *indexString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (indexString.length > 6 || ![self validateNumber:indexString]) {
        return NO;
    }
    return YES;
}
    
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (DC_IsStrEmpty(textField.text)) {
        [self.nextBtn setTitleColor:[[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-textColor-disable"] forState:UIControlStateNormal];
        self.nextBtn.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-fillColor-disable"];
        self.nextBtn.userInteractionEnabled = NO;
    } else {
        [self.nextBtn setTitleColor:[[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-textColor-active"] forState:UIControlStateNormal];
        self.nextBtn.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-fillColor-active"];
        self.nextBtn.userInteractionEnabled = YES;
    }
}

#pragma mark -- lazy load
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [DC_UIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    }
    return _bgView;
}

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.layer.backgroundColor = DC_UIColorFromRGB(0xFFFFFF).CGColor;
        _alertView.layer.cornerRadius = 16;
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.position = CGPointMake(self.center.x, self.center.y+50);
    }
    return _alertView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_BS(18);
        _titleLab.textColor = DC_UIColorFromRGB(0x242424);
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_authentication"];
    }
    return _titleLab;
}

- (UIView *)serviceNumberView {
    if (!_serviceNumberView) {
        _serviceNumberView = [[UIView alloc] init];
        _serviceNumberView.layer.cornerRadius = 8.f;
        _serviceNumberView.backgroundColor = [[[HJTokenManager shareInstance] getColorByToken:@"ref-global-bg-color-primary"] colorWithAlphaComponent:0.5];
    }
    return _serviceNumberView;
}

- (UILabel *)serviceNumberLab {
    if (!_serviceNumberLab) {
        _serviceNumberLab = [[UILabel alloc] init];
        _serviceNumberLab.font = FONT_S(14);
        _serviceNumberLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_number_to_switch"];
        _serviceNumberLab.textColor = DC_UIColorFromRGB(0x858585);
        _serviceNumberLab.textAlignment = NSTextAlignmentLeft;
    }
    return _serviceNumberLab;
}

- (UILabel *)accNbrLab {
    if (!_accNbrLab) {
        _accNbrLab = [[UILabel alloc] init];
        _accNbrLab.font = FONT_S(14);
        _accNbrLab.textColor = [DC_UIColorFromRGB(0x242424) colorWithAlphaComponent:0.85];
        _accNbrLab.textAlignment = NSTextAlignmentRight;
        _accNbrLab.text = _switchedAccNbr;
    }
    return _accNbrLab;
}

- (UILabel *)descLab {
    if (!_descLab) {
        _descLab = [[UILabel alloc] init];
        _descLab.textColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-tipBlock-info-textColor"];
        _descLab.text = DC_stringFormat(@"ꔷ%@", [NSString stringWithFormat:@"%@", [[HJLanguageManager shareInstance] getTextByKey:@"tip_subs_authentication_required_sent_code"]]);
        _descLab.font= FONT_S(14);
        _descLab.numberOfLines = 0;
    }
    return _descLab;
}

- (UIView *)bgCodeView {
    if (!_bgCodeView) {
        _bgCodeView = [UIView new];
        _bgCodeView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
        _bgCodeView.layer.cornerRadius = 12;
        _bgCodeView.layer.borderWidth = 1;
        _bgCodeView.layer.borderColor = DC_UIColorFromRGB(0xD5D5D5).CGColor;
    }
    return _bgCodeView;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        _codeTextField.font = FONT_S(14);
        _codeTextField.backgroundColor = DC_UIColorFromRGB(0xFFFFFFF);
        _codeTextField.textColor = DC_UIColorFromRGB(0x242424);
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _codeTextField.delegate = self;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.placeholder = [[HJLanguageManager shareInstance] getTextByKey:@"tip_verification_code"];
        _codeTextField.secureTextEntry = NO;
        [_codeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        if (@available(iOS 12.0, *)) {
            _codeTextField.textContentType = UITextContentTypeOneTimeCode;
        }
    }
    return _codeTextField;
}

- (UIButton *)getBtn {
    if (!_getBtn) {
        _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getBtn setTitle:[[HJLanguageManager shareInstance] getTextByKey:@"btn_get"] forState:UIControlStateNormal];
        [_getBtn setTitleColor:[[HJTokenManager shareInstance] getColorByToken:@"ref-textButton-textColor-active"] forState:UIControlStateNormal];
        _getBtn.titleLabel.font = FONT_S(14);
        _getBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_getBtn addTarget:self action:@selector(getOTPCode) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getBtn;
}

- (UILabel *)errorLab {
    if (!_errorLab) {
        _errorLab = [[UILabel alloc] init];
        _errorLab.textColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-form-stokeColor-error"];
        _errorLab.font= FONT_S(14);
        _errorLab.numberOfLines = 0;
        _errorLab.textAlignment = NSTextAlignmentLeft;
        _errorLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _errorLab;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.titleLabel.font = FONT_BS(14);
        _cancelBtn.layer.borderColor = DC_UIColorFromRGB(0xD5D5D5).CGColor;
        _cancelBtn.layer.borderWidth = 1.0;
        _cancelBtn.layer.cornerRadius = 12;
        _cancelBtn.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
        [_cancelBtn setTitleColor:[[HJTokenManager shareInstance] getColorByToken:@"ref-secondaryButton-textColor"] forState:UIControlStateNormal];
        [_cancelBtn setTitle:[[HJLanguageManager shareInstance] getTextByKey:@"btn_cancel"] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextBtn.titleLabel.font = FONT_BS(14);
        _nextBtn.layer.cornerRadius = 12;
        [_nextBtn setTitleColor:[[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-textColor-disable"] forState:UIControlStateNormal];
        _nextBtn.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-fillColor-disable"];
        [_nextBtn setTitle:[[HJLanguageManager shareInstance] getTextByKey:@"btn_confirm"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.userInteractionEnabled = NO;
    }
    return _nextBtn;
}

- (DCSendOtpViewModel *)sendOTPVM {
    if (!_sendOTPVM) {
        _sendOTPVM = [[DCSendOtpViewModel alloc] init];
        _sendOTPVM.delegate = self;
    }
    return _sendOTPVM;
}

- (void)animationAlert:(UIView *)view {
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];

}

#pragma mark -- other
// 限制输入框只能输入数字
- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

@end
