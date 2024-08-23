//
//  HJDitoProgress.m
//  DITOApp
//
//  Created by 孙全民 on 2022/7/20.
//

#import "HJDitoProgress.h"
#import "UIResponder+DCFloorResponder.h"
#import <DXPCategoryLib/UIColor+Category.h>
#import <Masonry/Masonry.h>
#import "DCPB.h"
#import <DXPManagerLib/HJLanguageManager.h>

@implementation HJDitoProgressModel
- (instancetype)init {
    if (self = [super init]) {
        self.primaryColor = @"#E6E6E6";
        self.gross = @"";
        self.grossUnit = @"";
        self.balanceUnit = @"";
        self.balance = @"";
        self.des = @"";
        self.expire = @"";
        self.btnName = @"";
        self.progress = 0.0; // 默认值
    }
    return  self;
}
- (instancetype)initWithGross:(NSString*)gross
                    grossUnit:(NSString*)grossUnit
                      balance:(NSString*)balance
                  balanceUnit:(NSString*)balanceUnit
                         type:(NSString*)type
                       expire:(NSString*)expire  // key
                          des:(NSString*)des     // key7
                      btnName:(NSString*)btnName  // key8
                    noDataStr:(NSString*)noDataStr {
    HJDitoProgressModel *model  = [self initWithGross:gross grossUnit:grossUnit balance:balance balanceUnit:balanceUnit type:type expire:expire des:des btnName:btnName];
    model.noDataStr = noDataStr?:@"";
    return  model;
}


- (instancetype)initWithGross:(NSString*)gross  // Y 代表无限量
                    grossUnit:(NSString*)grossUnit
                      balance:(NSString*)balance
                  balanceUnit:(NSString*)balanceUnit
                         type:(NSString*)type
                       expire:(NSString*)expire
                          des:(NSString*)des
                      btnName:(NSString*)btnName{
    if (self = [super init]) {
        self.gross = gross ?: @"";
        self.grossUnit = grossUnit ?: @"";
        self.balanceUnit = balanceUnit ?: @"";
        self.balance = balance ?: @"";
        self.type = type ?: @"";
        self.des = des ?: @"";
        self.expire = expire ?: @"";
        self.btnName = btnName ?: @"";
//        self.progress = !isEmptyString(gross) && !isEmptyString(balance) && [gross floatValue] != 0.0 ?  [balance floatValue]  / [gross floatValue] : 1.0;
		if (!DC_IsStrEmpty(gross) && !DC_IsStrEmpty(balance) && [gross floatValue] > 0) {
			CGFloat progress = [balance floatValue]  / [gross floatValue];
			if (progress > 0) {
				self.progress = progress;
			} else {
				self.progress = 0;
			}
		} else {
			self.progress = 0;
		}
    }
    return self;
}

- (instancetype)initWithGross:(NSString*)gross  // Y 代表无限量
					grossUnit:(NSString*)grossUnit
					  balance:(NSString*)balance
				  balanceUnit:(NSString*)balanceUnit
						 type:(NSString*)type
					   expire:(NSString*)expire
						  des:(NSString*)des
					  btnName:(NSString*)btnName
				  realBalance:(NSString *)realBalance
				 grossBalance:(NSString *)grossBalance {
	if (self = [super init]) {
		self.gross = gross ?: @"";
		self.grossUnit = grossUnit ?: @"";
		self.balanceUnit = balanceUnit ?: @"";
		self.balance = balance ?: @"";
		self.type = type ?: @"";
		self.des = des ?: @"";
		self.expire = expire ?: @"";
		self.btnName = btnName ?: @"";
		self.realBalance = realBalance ?: @"";
		self.grossBalance = grossBalance ?: @"";
		
//		self.progress = !isEmptyString(grossBalance) && !isEmptyString(realBalance) && [grossBalance floatValue] != 0.0 ?  [realBalance floatValue]  / [grossBalance floatValue] : 1.0;
		
		if (!DC_IsStrEmpty(grossBalance) && !DC_IsStrEmpty(realBalance) && [grossBalance floatValue] > 0) {
			CGFloat progress = [realBalance floatValue]  / [grossBalance floatValue];
			if (progress > 0) {
				self.progress = progress;
			} else {
				self.progress = 0;
			}
		} else {
			self.progress = 0;
		}
		
//		self.progress = 0.8; // 先写死
	}
	return self;
}


@end



@interface HJDitoProgress()
@property (nonatomic, strong) CAShapeLayer *progressBgLayer; // 进度条背景
@property (nonatomic, strong) CAShapeLayer *progressLayer;  // 进度条值

//@property (nonatomic, strong) UIView *circleView;
@property (nonatomic, strong) UILabel *totalLbl;
@property (nonatomic, strong) UILabel *useageLbl;

@property (nonatomic, strong) UIButton *buyBtn;
//@property (nonatomic, strong) UILabel *midTipLbl; // 无限量文本  或者没有用了提示，中间文本区域(与totalLbl ， totalLbl 显示互斥)
@property (nonatomic, strong) UIView *bottomView; // 底部感叹号图标和类型文字
@property (nonatomic, copy) NSString *primaryColorStr;

@property (nonatomic, strong) HJDitoProgressModel *g_model;

@property (nonatomic, strong) NSDictionary *propsDic;
@end

@implementation HJDitoProgress
- (instancetype)initWithFrame:(CGRect)frame primaryColor:(NSString*)primaryColorStr{
    if (self = [super initWithFrame:frame]) {
        self.primaryColorStr = primaryColorStr;
        if (DC_IsStrEmpty(primaryColorStr)) {self.primaryColorStr = @"#E6E6E6";}
        [self configView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        if (DC_IsStrEmpty(self.primaryColorStr)) {self.primaryColorStr = @"#E6E6E6";}
        [self configView];
    }
    return self;
}

- (void)configView {
	
    // BG
    CGFloat width = self.frame.size.width > 0 ?  self.frame.size.width : HJDitoProgressW;
    CGFloat height = self.frame.size.height > 0 ?  self.frame.size.height : HJDitoProgressH;
    UIBezierPath *bgPath = [UIBezierPath  bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:height/2 - 5 startAngle:0.25*M_PI endAngle: 0.75* M_PI clockwise:NO];
    self.progressBgLayer.path = bgPath.CGPath;
    self.progressBgLayer.strokeColor = [UIColor colorWithHexString:self.primaryColorStr alpha:0.3].CGColor;
    [self.layer addSublayer:self.progressBgLayer];
    
    
    [self addSubview:self.totalLbl];
    [self addSubview:self.useageLbl];
   
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@75);
        make.centerY.equalTo(self.mas_centerY).offset(7);
    }];
	
	[self addSubview:self.buyBtn];
	[self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(self.mas_centerX);
		make.width.equalTo(@75);
		make.centerY.equalTo(self.mas_centerY).offset(7);
		make.height.equalTo(@14);
	}];

    [self.useageLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@75);
        make.bottom.equalTo(self.totalLbl.mas_top);
    }];
	

    
//    [self addSubview:self.midTipLbl];
//    [self.midTipLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.mas_centerX);
//        make.width.equalTo(@90);
//        make.centerY.equalTo(self.mas_centerY).offset(-5);
//    }];
    
    
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY).offset(35);
        make.height.equalTo(@14);
    }];
    
    

}

- (void)updateWithModel:(HJDitoProgressModel*)model props:(NSDictionary *)propsDic {
    self.g_model = model;
	self.propsDic = propsDic;
	
	NSString *progressHighlightColor; // 球进度主色调
	CGFloat progressHighlightColorOpacity = 0.0; // 球进度主色调透明度
	NSString *progressBgColor = @"#E6E6E6";   // 球进度底色
	CGFloat progressBgColorOpacity = 1.0;   // 球进度底色透明度
	NSString *titleColor; // 球中的字体颜色
	CGFloat titleColorOpacity = 0.0; // 球中的字体透明度
	
	NSString *buyColor;
	CGFloat buyColorOpacity = 0.0;
	
//	NSString *strData = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_data"];
//	NSString *strSMS = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_sms"];
//	NSString *strCalls = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_calls"];
	
	progressHighlightColor =  [propsDic objectForKey:@"highlightColor"];
	progressHighlightColorOpacity  = [[propsDic objectForKey:@"highlightColorOpacity"] floatValue] / 100.f;
	progressBgColor = [propsDic objectForKey:@"bottomColor"];
	progressBgColorOpacity = [[propsDic objectForKey:@"bottomColorOpacity"] floatValue] / 100.f;
	titleColor = [propsDic objectForKey:@"titleColor"];
	titleColorOpacity = [[propsDic objectForKey:@"titleColorOpacity"] floatValue] / 100.f;
	
//	if ([[self.g_model.type lowercaseString] isEqualToString:[strData lowercaseString]]) {
//		progressHighlightColor =  props.dataHighlightColor;
//		progressHighlightColorOpacity  = props.dataHighlightColorOpacity / 100.f;
//		progressBgColor = props.dataBottomColor;
//		progressBgColorOpacity = props.dataBottomColorOpacity / 100.f;
//		titleColor = props.dataTitleColor;
//		titleColorOpacity = props.dataTitleColorOpacity / 100.f;
//	}
//	if ([[self.g_model.type lowercaseString] isEqualToString:[strSMS lowercaseString]]) {
//		progressHighlightColor =  props.smsHighlightColor;
//		progressHighlightColorOpacity = props.smsHighlightColorOpacity / 100.f;
//		progressBgColor = props.smsBottomColor;
//		progressBgColorOpacity = props.smsBottomColorOpacity / 100.f;
//		titleColor = props.smsTitleColor;
//		titleColorOpacity = props.smsTitleColorOpacity / 100.f;
//	}
//	if ([[self.g_model.type lowercaseString] isEqualToString:[strCalls lowercaseString]]) {
//		progressHighlightColor =  props.callsHighlightColor;
//		progressHighlightColorOpacity = props.callsHighlightColorOpacity / 100.f;
//		progressBgColor = props.callsBottomColor;
//		progressBgColorOpacity = props.callsBottomColorOpacity / 100.f;
//		titleColor = props.callsTitleColor;
//		titleColorOpacity = props.callsTitleColorOpacity / 100.f;
//	}
	
	CGFloat width = self.frame.size.width > 0 ?  self.frame.size.width : HJDitoProgressW;
	CGFloat height = self.frame.size.height > 0 ?  self.frame.size.height : HJDitoProgressH;
	// 进度条颜色
	self.progressLayer.strokeColor = [UIColor colorWithHexString:progressHighlightColor alpha:progressHighlightColorOpacity].CGColor;
	// 进度条背景色
	UIBezierPath *bgPath = [UIBezierPath  bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:height/2 - 5 startAngle:0.25*M_PI endAngle: 0.75* M_PI clockwise:NO];
	self.progressBgLayer.path = bgPath.CGPath;
	self.progressBgLayer.strokeColor = [UIColor colorWithHexString:progressBgColor alpha:progressBgColorOpacity].CGColor;
	[self.layer addSublayer:self.progressBgLayer];

	// 设置流量球百分比
	void(^updateProgress)(CGFloat v) =  ^(CGFloat v){
		if (v > 0) {
			UIBezierPath *progressPath = [UIBezierPath  bezierPathWithArcCenter:CGPointMake(width/2, height/2) radius:height/2 - 5 startAngle:0.25*M_PI endAngle: 0.75 * M_PI clockwise:NO];
			self.progressLayer.strokeColor = [UIColor colorWithHexString:progressHighlightColor].CGColor;
			self.progressLayer.path = progressPath.CGPath;
			[self.layer addSublayer:self.progressLayer];
			self.progressLayer.strokeEnd = v;
			
			// 动画效果
			CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
			animation.duration = 1.5; // 动画时长
			animation.fromValue = @(0.0);
			animation.toValue = @(model.progress);
			animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			// 添加动画到shapeLayer
			[self.progressLayer addAnimation:animation forKey:@"strokeEndAnimation"];
		}
	};
	
	// 设置progressValue值
	updateProgress(model.progress);
	
	// 判断buy now
	if (DC_IsStrEmpty(model.realBalance) || [model.realBalance doubleValue]  <=0) {
		self.buyBtn.hidden = NO;
		self.useageLbl.text = @"None";
		buyColor = titleColor;
		[self setBuyBtnTitle:buyColor];
		
		[self.useageLbl mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.buyBtn.mas_top);
		}];
		
	} else {
		self.buyBtn.hidden = YES;
		// 文本字体设置
		self.useageLbl.text = [NSString stringWithFormat:@"%@%@",model.balance ,model.balanceUnit];
		self.totalLbl.text = [NSString stringWithFormat:@"of %@%@",model.gross,model.grossUnit];
		
		self.useageLbl.textColor = [UIColor colorWithHexString:progressHighlightColor alpha:progressHighlightColorOpacity];
		self.totalLbl.textColor = DC_UIColorFromRGB(0x979797); //[UIColor colorWithHexString:titleColor alpha:titleColorOpacity];
		
		self.useageLbl.adjustsFontSizeToFitWidth = true; //注：只会让文字变小，不会使文字变大
		self.useageLbl.minimumScaleFactor = 0.3;
		self.totalLbl.adjustsFontSizeToFitWidth = true; //注：只会让文字变小，不会使文字变大
		self.totalLbl.minimumScaleFactor = 0.3;
		
		[self.useageLbl mas_updateConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(self.totalLbl.mas_top);
		}];
	}
	
	// 底部球类型文本
	UILabel *botLbl = [self.bottomView viewWithTag:1];
	botLbl.text = model.type;
	botLbl.font = FONT_S(10);
	botLbl.textColor = [UIColor colorWithHexString:titleColor alpha:titleColorOpacity];
	
	CGFloat val = 0;
	NSString *hasDesc = [propsDic objectForKey:@"hasDesc"];
	if ([hasDesc isEqualToString:@"Y"]) {
		val = 17;
	}
	UIImageView *image = [self.bottomView viewWithTag:1000];
	[image mas_updateConstraints:^(MASConstraintMaker *make) {
		make.width.height.equalTo(@(val));
	}];
}

// 色值按钮颜色
- (void)setBuyBtnTitle:(NSString*)primaryColorStr{
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:[[HJLanguageManager shareInstance] getTextByKey:@"lb_buy_now"]];
    NSRange titleRange = {0,[title length]};
    [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:primaryColorStr] range:titleRange];
    [_buyBtn setAttributedTitle:title forState:UIControlStateNormal];
}

// MARK: Action
- (void)buyAction {
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = @"1";
	model.link = @"/clp_purchase/index";
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

#pragma mark - LAZY Load
- (UILabel *)totalLbl {
    if (!_totalLbl) {
        // 中间标题
        UILabel *totalLbl = [[UILabel alloc]init];
        _totalLbl = totalLbl;
        _totalLbl.textAlignment = NSTextAlignmentCenter;
        totalLbl.font = FONT_S(12);
        totalLbl.textColor = [UIColor colorWithHexString:@"#979797"];
    }
    return _totalLbl;
}

- (UILabel *)useageLbl {
    if (!_useageLbl) {
        _useageLbl = [[UILabel alloc]init];
        _useageLbl.textAlignment = NSTextAlignmentCenter;
        _useageLbl.font = FONT_BS(16);
        _useageLbl.textColor = [UIColor colorWithHexString:@"#242424"];
    }
    return _useageLbl;
}

- (CAShapeLayer *)progressBgLayer {
    if (!_progressBgLayer) {
        _progressBgLayer = [CAShapeLayer layer];
        _progressBgLayer.lineWidth = 9;
        _progressBgLayer.lineJoin = kCALineJoinRound;
        _progressBgLayer.lineCap = kCALineCapRound;
        _progressBgLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _progressBgLayer;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.lineWidth = 9;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeStart = 0.0;
        _progressLayer.lineJoin = kCALineJoinRound;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.strokeEnd = 0.0;
        _progressLayer.lineCap = kCALineCapRound;
    }
    return _progressLayer;
}

//- (UILabel *)midTipLbl {
//    if (!_midTipLbl) {
//        _midTipLbl = [[UILabel alloc] init];
//        _midTipLbl.text = @"Unlimited";
//        _midTipLbl.numberOfLines = 0;
//        _midTipLbl.textAlignment = NSTextAlignmentCenter;
//		_midTipLbl.textColor = [UIColor colorWithHexString:@"#929292"];
//        _midTipLbl.font = BoldSystemFont(18);
//        _midTipLbl.hidden = YES;
//    }
//    return _midTipLbl;
//}

- (void)infoTapAction:(UITapGestureRecognizer*)gesture {
	UIView *view = [gesture.view viewWithTag:1000];
	NSString *desc = [self.propsDic objectForKey:@"desc"];
	if (self.tapInfoAction && !DC_IsStrEmpty(desc)) {
		self.tapInfoAction(view, desc);
	}
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
//        _bottomView.hidden = YES;
        _bottomView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(infoTapAction:)];
        [_bottomView addGestureRecognizer:tap];
        
        UIImage *img = [UIImage imageNamed:@"pb_db_warn"];
        //img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImageView *image = [[UIImageView alloc]initWithImage:img];
        image.tag = 1000;
       
        [_bottomView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@17);
            make.centerY.equalTo(_bottomView.mas_centerY);
            make.leading.equalTo(@0);
        }];
        
        // 底部文字和图标
        UILabel *bottomLbl = [[UILabel alloc]init];
		bottomLbl.adjustsFontSizeToFitWidth = true;
		bottomLbl.minimumScaleFactor = 0.5; // 设置文本缩放的最小比例，可根据需要调整
        bottomLbl.numberOfLines = 0;
        bottomLbl.textAlignment = NSTextAlignmentCenter;
        bottomLbl.tag = 1;
		bottomLbl.textColor = [UIColor colorWithHexString:@"#242424"];
        bottomLbl.font = FONT_S(10);
        [_bottomView addSubview:bottomLbl];
        [bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
			
			make.centerY.equalTo(_bottomView.mas_centerY).offset(0);
			make.leading.equalTo(image.mas_trailing).offset(2);
			make.trailing.equalTo(@0);
			
//            make.centerY.equalTo(_bottomView.mas_centerY).offset(-5);
//			make.centerX.equalTo(_bottomView.mas_centerX);
        }];
    }
    return _bottomView;
}

- (UIButton *)buyBtn {
    if (!_buyBtn) {
        _buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBtn.hidden = YES;
        [_buyBtn.titleLabel setFont:FONT_S(12)];
        [_buyBtn addTarget:self action:@selector(buyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}
@end
