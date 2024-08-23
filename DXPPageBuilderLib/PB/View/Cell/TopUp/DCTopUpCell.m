//
//  DCTopUpCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/28.
//

#import "DCTopUpCell.h"
// ****************** Model ******************
@implementation DCTopUpCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    componentModel.props.showMore = NO;
    componentModel.props.showTitle = NO;
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    self.cellHeight = self.cellHeight + 100;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCTopUpCell class]);
}
@end

// ****************** Cell ******************
@interface DCTopUpCell()
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *titleBGView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *payBtn;
@end
@implementation DCTopUpCell

- (void)bindCellModel:(DCTopUpCellModel *)cellModel {
    [super bindCellModel:cellModel];
    
    // 移除控件
    [_textField removeFromSuperview];
    [_titleLbl removeFromSuperview];
    [_payBtn removeFromSuperview];
    _textField = nil;
    _titleLbl = nil;
    _payBtn = nil;
    
    // 添加控件
    self.baseContainer.backgroundColor = [UIColor whiteColor];
    self.baseContainer.layer.cornerRadius = 8;
    [self.baseContainer addSubview:self.textField];
    [self.baseContainer addSubview:self.titleLbl];
    [self.baseContainer addSubview:self.payBtn];
    
    // 设置属性
    self.titleLbl.text = cellModel.props.title;
    self.textField.placeholder = cellModel.props.msgName;
        
    CGFloat titleW = [cellModel.props.title hj_sizeContraintToSize:CGSizeMake(MAXFLOAT, 10) font:[UIFont systemFontOfSize:14]].width + 16;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, titleW, 24) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = CGRectMake(0, 0, titleW, 24);
    maskLayer.path = maskPath.CGPath;
    _titleLbl.layer.mask = maskLayer;
    
    // 设置约束
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.width.equalTo(@(titleW));
        make.height.equalTo(@24);
        make.centerX.equalTo(self.baseContainer.mas_centerX);
    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(12);
        make.trailing.equalTo(self.payBtn.mas_leading).offset(-12);
        make.height.equalTo(@44);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-12);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(12);
        make.width.equalTo(@50);
        make.height.equalTo(@44);
    }];
}

- (void)payBtnAction{
    NSLog(@"textfield text %@   ",self.textField.text);
}


// MARK: LAZY
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc]init];
        _textField.layer.borderWidth = 1.0f;
        _textField.layer.borderColor = [[UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:171.0/255.0 alpha:1.0] CGColor];
        _textField.layer.cornerRadius = 5;
        _textField.clipsToBounds      = YES;
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 5)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
       
    }
    return _textField;
}

- (UIView *)titleBGView {
    if (!_titleBGView) {
        _titleBGView = [[UIView alloc]init];
        _titleBGView.backgroundColor = [UIColor colorWithRed:64 green:79 blue:118 alpha:1];
    }
    return _titleBGView;
}

- (UILabel *)titleLbl {
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc]init];
        _titleLbl.numberOfLines = 0;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        _titleLbl.font = FONT_S(14);
        _titleLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.backgroundColor = [UIColor purpleColor];
    }
    return _titleLbl;
}

- (UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setBackgroundColor:[UIColor blueColor]];
        [_payBtn setTitle:@"pay" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _payBtn.layer.cornerRadius = 8;
        [_payBtn addTarget:self action:@selector(payBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}
@end
