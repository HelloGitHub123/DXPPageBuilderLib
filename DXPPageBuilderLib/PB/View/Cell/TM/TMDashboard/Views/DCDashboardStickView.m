//
//  DCDashboardStickView.m
//  DCPageBuilding
//
//  Created by 李标 on 2024/4/15.
//

#import "DCDashboardStickView.h"
#import "DCPB.h"
#import <YYText/YYLabel.h>
#import <YYText/YYText.h>
#import <DXPCategoryLib/UIColor+Category.h>
#import <SDWebImage/UIButton+WebCache.h>


#import <DXPManagerLib/HJTokenManager.h>
#import "DCSubsListModel.h"

@interface DCDashboardStickView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) DCDBTopInfoView *topInfoView;
@property (nonatomic, strong) DCPrepaidNoPointStickView *prepaidNoPointStickView; // 预付费 无积分
@property (nonatomic, strong) DCPrepaidStickView *prepaidStickView; // 预付费 有积分
@property (nonatomic, strong) DCPostpaidStickView *postpaidStickView; // 后付费 有积分
@property (nonatomic, strong) DCPostpaidNoPointStickView *postpaidNoPointStickView; // 后付费 无积分
@property (nonatomic, strong) DCPostpaidNoOutstandingBillsStickView *postpaidNoOutstandingBillsStickView; // 后付费 No Outstanding Bills
@property (nonatomic, strong) DCRightPointView *rightPointView; // 积分
// 数据
@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
// 展开箭头
@property (nonatomic, strong) UIView *arrowView; // 箭头圆view
@property (nonatomic, strong) UIImageView *arrowImgView;
@end

@implementation DCDashboardStickView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		
		self.backgroundColor = [UIColor clearColor];
		
		[self configView];
	}
	return self;
}

- (void)configView {
	
	[self addSubview:self.bgView];
	[self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(STATUS_BAR_HEIGHT);
		make.bottom.mas_equalTo(-24);
	}];
	
	[self.bgView addSubview:self.arrowView];
	[self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(self.mas_bottom).offset(-30);
		make.width.height.mas_equalTo(60);
	}];
	
	[self.arrowView addSubview:self.arrowImgView];
	[self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(self.arrowView.mas_centerY).offset(15);
		make.width.mas_equalTo(21);
		make.height.mas_equalTo(14);
	}];
	
	[self.bgView addSubview:self.paddingContentView];
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(10);
		make.trailing.bottom.mas_equalTo(-10);
	}];
	
	
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.isUpdateData = YES;
	
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	self.prepaidNoPointStickView.hidden = YES;
	self.prepaidStickView.hidden = YES;
	self.postpaidStickView.hidden = YES;
	self.postpaidNoPointStickView.hidden = YES;
	self.postpaidNoOutstandingBillsStickView.hidden = YES;
	self.rightPointView.hidden = YES;
	
	// 判断
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	if ([paidFlag isEqualToString:@"1"]) {
		// 后付费
		NSString *usablePoint = [dic objectForKey:@"usablePoint"];
		if (!DC_IsStrEmpty(usablePoint) && [usablePoint floatValue] > 0) {
			// 有积分
			CGFloat itemW = (DC_DCP_SCREEN_WIDTH - 10*2 - 8) / 2;
			NSString *money = [dic objectForKey:@"money"];
			if (DC_IsStrEmpty(money) || [money isEqualToString:@"0"]) {
				// No Outstanding Bills
				self.postpaidNoOutstandingBillsStickView.hidden = NO;
				self.rightPointView.hidden = NO;
				[self.paddingContentView addSubview:self.topInfoView];
				[self.paddingContentView addSubview:self.postpaidNoOutstandingBillsStickView];
				[self.paddingContentView addSubview:self.rightPointView];
				[self.topInfoView bindWithModel:cellModel];
				[self.postpaidNoOutstandingBillsStickView bindWithModel:cellModel];
				[self.rightPointView bindWithModel:cellModel];
				
				[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.trailing.top.mas_equalTo(0);
					make.height.mas_equalTo(32);
					make.width.mas_equalTo(171);
				}];
				[self.rightPointView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.width.mas_equalTo(171);
					make.trailing.mas_equalTo(0);
					make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
					make.height.mas_equalTo(40);
				}];
				
				[self.postpaidNoOutstandingBillsStickView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.top.bottom.mas_equalTo(0);
					make.trailing.mas_equalTo(self.topInfoView.mas_leading).offset(-8);
				}];
				
			} else {
				self.postpaidStickView.hidden = NO;
				self.rightPointView.hidden = NO;
				[self.paddingContentView addSubview:self.topInfoView];
				[self.paddingContentView addSubview:self.postpaidStickView];
				[self.paddingContentView addSubview:self.rightPointView];
				[self.topInfoView bindWithModel:cellModel];
				[self.postpaidStickView bindWithModel:cellModel];
				[self.rightPointView bindWithModel:cellModel];
				
				[self.postpaidStickView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.top.bottom.mas_equalTo(0);
					make.width.mas_equalTo(itemW);
				}];
				[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.width.mas_equalTo(itemW);
					make.trailing.top.mas_equalTo(0);
					make.height.mas_equalTo(32);
				}];
				[self.rightPointView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.width.mas_equalTo(itemW);
					make.trailing.mas_equalTo(0);
					make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
                    make.height.mas_equalTo(40);
				}];
			}
		} else {
			// 无积分
			NSString *money = [dic objectForKey:@"money"];
			if (DC_IsStrEmpty(money) || [money isEqualToString:@"0"]) {
				// No Outstanding Bills
				self.postpaidNoOutstandingBillsStickView.hidden = NO;
				[self.paddingContentView addSubview:self.topInfoView];
				[self.paddingContentView addSubview:self.postpaidNoOutstandingBillsStickView];
				[self.topInfoView bindWithModel:cellModel];
				[self.postpaidNoOutstandingBillsStickView bindWithModel:cellModel];
				
				[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.top.trailing.mas_equalTo(0);
					make.height.mas_equalTo(32);
				}];
				[self.postpaidNoOutstandingBillsStickView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.trailing.mas_equalTo(0);
					make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
					make.bottom.mas_equalTo(self.paddingContentView.mas_bottom).offset(-12);
				}];
			} else {
				self.postpaidNoPointStickView.hidden = NO;
				[self.paddingContentView addSubview:self.topInfoView];
				[self.paddingContentView addSubview:self.postpaidNoPointStickView];
				[self.topInfoView bindWithModel:cellModel];
				[self.postpaidNoPointStickView bindWithModel:cellModel];
				
				[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.top.trailing.mas_equalTo(0);
					make.height.mas_equalTo(32);
				}];
				[self.postpaidNoPointStickView mas_makeConstraints:^(MASConstraintMaker *make) {
					make.leading.trailing.mas_equalTo(0);
					make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
					make.bottom.mas_equalTo(self.paddingContentView.mas_bottom).offset(-12);
				}];
			}
		}
	} else {
		// 预付费
		NSString *usablePoint = [dic objectForKey:@"usablePoint"];
		if (!DC_IsStrEmpty(usablePoint) && [usablePoint floatValue] > 0) {
			// 有积分
			CGFloat itemW = (DC_DCP_SCREEN_WIDTH - 10*2 - 8) / 2;
			self.prepaidStickView.hidden = NO;
			self.rightPointView.hidden = NO;
			[self.paddingContentView addSubview:self.prepaidStickView];
			[self.paddingContentView addSubview:self.topInfoView];
			[self.paddingContentView addSubview:self.rightPointView];
			[self.topInfoView bindWithModel:cellModel];
			[self.prepaidStickView bindWithModel:cellModel];
			[self.rightPointView bindWithModel:cellModel];
			
			[self.prepaidStickView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.top.bottom.mas_equalTo(0);
				make.width.mas_equalTo(itemW);
			}];
			[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.width.mas_equalTo(itemW);
				make.trailing.top.mas_equalTo(0);
				make.height.mas_equalTo(32);
			}];
			[self.rightPointView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.width.mas_equalTo(itemW);
				make.trailing.mas_equalTo(0);
				make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
			}];
			
		} else {
			// 无积分
			self.prepaidNoPointStickView.hidden = NO;
			[self.paddingContentView addSubview:self.prepaidNoPointStickView];
			[self.paddingContentView addSubview:self.topInfoView];
			[self.topInfoView bindWithModel:cellModel];
			[self.prepaidNoPointStickView bindWithModel:cellModel];
			
			[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.top.trailing.mas_equalTo(0);
				make.height.mas_equalTo(32);
			}];
			[self.prepaidNoPointStickView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.leading.trailing.mas_equalTo(0);
				make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
				make.bottom.mas_equalTo(0);
			}];
		}
	}
}

// 隐藏当前DB弹框
- (void)hiddenPopDashboardView:(UIGestureRecognizer *)tap {
	if (self.showActionBlock) {
		self.showActionBlock();
	}
}

#pragma mark -- lazy load
- (UIView *)bgView {
	if (!_bgView) {
		_bgView = [[UIView alloc] init];
		_bgView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
		_bgView.layer.masksToBounds = NO; // 允许阴影效果
		// 设置投影
		_bgView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
		_bgView.layer.shadowOpacity = 1; // 投影透明度，范围0.0~1.0
		_bgView.layer.shadowRadius = 10.0; // 投影模糊半径
		_bgView.layer.shadowOffset = CGSizeMake(0, 5); // 投影偏移量
	}
	return _bgView;
}

- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
	}
	return _paddingContentView;
}

- (DCDBTopInfoView *)topInfoView {
	if (!_topInfoView) {
		_topInfoView = [[DCDBTopInfoView alloc] init];
		_topInfoView.isStickView = YES;
		_topInfoView.layer.cornerRadius = 8.f;
		_topInfoView.backgroundColor = DC_UIColorFromRGB(0x002641);
	}
	return _topInfoView;
}

- (DCPrepaidNoPointStickView *)prepaidNoPointStickView {
	if (!_prepaidNoPointStickView) {
		_prepaidNoPointStickView = [[DCPrepaidNoPointStickView alloc] init];
		_prepaidNoPointStickView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
		_prepaidNoPointStickView.layer.borderWidth = 1.f;
		_prepaidNoPointStickView.layer.cornerRadius = 8.f;
	}
	return _prepaidNoPointStickView;
}

- (DCPrepaidStickView *)prepaidStickView {
	if (!_prepaidStickView) {
		_prepaidStickView = [[DCPrepaidStickView alloc] init];
		_prepaidStickView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
		_prepaidStickView.layer.borderWidth = 1.f;
		_prepaidStickView.layer.cornerRadius = 8.f;
	}
	return _prepaidStickView;
}

- (DCPostpaidStickView *)postpaidStickView {
	if (!_postpaidStickView) {
		_postpaidStickView = [[DCPostpaidStickView alloc] init];
		_postpaidStickView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
		_postpaidStickView.layer.borderWidth = 1.f;
		_postpaidStickView.layer.cornerRadius = 8.f;
	}
	return _postpaidStickView;
}

- (DCPostpaidNoPointStickView *)postpaidNoPointStickView {
	if (!_postpaidNoPointStickView) {
		_postpaidNoPointStickView = [[DCPostpaidNoPointStickView alloc] init];
		_postpaidNoPointStickView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
		_postpaidNoPointStickView.layer.borderWidth = 1.f;
		_postpaidNoPointStickView.layer.cornerRadius = 8.f;
	}
	return _postpaidNoPointStickView;
}

- (DCPostpaidNoOutstandingBillsStickView *)postpaidNoOutstandingBillsStickView {
	if (!_postpaidNoOutstandingBillsStickView) {
		_postpaidNoOutstandingBillsStickView = [[DCPostpaidNoOutstandingBillsStickView alloc] init];
		_postpaidNoOutstandingBillsStickView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
		_postpaidNoOutstandingBillsStickView.layer.borderWidth = 1.f;
		_postpaidNoOutstandingBillsStickView.layer.cornerRadius = 8.f;
	}
	return _postpaidNoOutstandingBillsStickView;
}

- (DCRightPointView *)rightPointView {
	if (!_rightPointView) {
		_rightPointView = [[DCRightPointView alloc] init];
		_rightPointView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
		_rightPointView.layer.borderWidth = 1.f;
		_rightPointView.layer.cornerRadius = 8.f;
	}
	return _rightPointView;
}

- (UIView *)arrowView {
	if (!_arrowView) {
		_arrowView = [[UIView alloc] init];
		_arrowView.layer.cornerRadius = 30.f;
		_arrowView.backgroundColor = [UIColor whiteColor];
		_arrowView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPopDashboardView:)];
		[_arrowView addGestureRecognizer:tap];
	}
	return _arrowView;
}

- (UIImageView *)arrowImgView {
	if (!_arrowImgView) {
		_arrowImgView = [[UIImageView alloc] init];
		_arrowImgView.userInteractionEnabled = YES;
		_arrowImgView.image = DC_image(@"ic_arrow_Img");
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPopDashboardView:)];
        [_arrowImgView addGestureRecognizer:tap];
	}
	return _arrowImgView;
}

@end



// ****************** 预付费 无积分 ******************
#pragma mark - 预付费 无积分
@interface DCPrepaidNoPointStickView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *viewDetailLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCPrepaidNoPointStickView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.paddingContentView];
	[self.paddingContentView addSubview:self.titleLab];
	[self.paddingContentView addSubview:self.moneyLab];
	[self.paddingContentView addSubview:self.viewDetailLab];
	[self.paddingContentView addSubview:self.dateLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	CGFloat itemW = (DC_DCP_SCREEN_WIDTH - 10*2 - 12*2) / 2;
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.width.mas_equalTo(itemW);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
		make.height.mas_equalTo(30);
		make.width.mas_equalTo(itemW);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.width.mas_equalTo(itemW);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.dateLab.mas_bottom).offset(0);
	}];
	
	[self.viewDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.toViewBtn.mas_centerY);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-12);
		make.height.mas_equalTo(18);
	}];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	// 金额
	NSString *money = [dic objectForKey:@"money"];
	self.moneyLab.text = [NSString stringWithFormat:@"%@%@", [DXPPBConfigManager shareInstance].currencySymbol,money];
	// 日期
	NSString *effDate = [dic objectForKey:@"effDate"];
	if (DC_IsStrEmpty(effDate)) {
		self.dateLab.hidden = YES;
	} else {
		self.dateLab.hidden = NO;
		self.dateLab.text = [NSString stringWithFormat:@"%@ %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_valid_until"] ,!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	}
	// 按钮
	NSDictionary *balIconDic = [propsDic.balIcon firstObject];
	NSString *balIconSrc = [balIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:balIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_add")];
}

- (void)toViewAction:(id)sender {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *billIconDic = [propsDic.balIcon firstObject];
	NSString *linkType = [billIconDic objectForKey:@"linkType"];
	NSString *link = [billIconDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

#pragma mark - lazy load
- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
	}
	return _paddingContentView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_your_load_balance"];
		_titleLab.font = FONT_S(12);
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.textAlignment = NSTextAlignmentLeft;
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.font = FONT_S(22);
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.font = FONT_S(12);
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.textAlignment = NSTextAlignmentRight;
	}
	return _dateLab;
}

- (UILabel *)viewDetailLab {
	if (!_viewDetailLab) {
		_viewDetailLab = [[UILabel alloc] init];
		_viewDetailLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_top_up"];
		_viewDetailLab.font = FONT_S(12);
		_viewDetailLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_viewDetailLab.textAlignment = NSTextAlignmentRight;
	}
	return _viewDetailLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

@end


// ****************** 预付费 有积分 ******************
#pragma mark - 预付费 有积分
@interface DCPrepaidStickView ()
@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCPrepaidStickView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.paddingContentView];
	[self.paddingContentView addSubview:self.titleLab];
	[self.paddingContentView addSubview:self.moneyLab];
	[self.paddingContentView addSubview:self.dateLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.trailing.bottom.mas_equalTo(-12);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.centerY.mas_equalTo(0);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(4);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
		make.height.mas_equalTo(30);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(4);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(0);
		make.height.mas_equalTo(18);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(4);
	}];
	
}

- (void)toViewAction:(id)sender {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *billIconDic = [propsDic.balIcon firstObject];
	NSString *linkType = [billIconDic objectForKey:@"linkType"];
	NSString *link = [billIconDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	// 金额
	NSString *money = [dic objectForKey:@"money"];
	self.moneyLab.text = [NSString stringWithFormat:@"%@%@",money,[DXPPBConfigManager shareInstance].currencySymbol];
	// 日期
	NSString *effDate = [dic objectForKey:@"effDate"];
	self.dateLab.text = [NSString stringWithFormat:@"%@ %@" , [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_valid_until"],!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	// 按钮
	NSDictionary *balIconDic = [propsDic.balIcon firstObject];
	NSString *balIconSrc = [balIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:balIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_add")];
}

#pragma mark - lazy load
- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
	}
	return _paddingContentView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_your_load_balance"];
		_titleLab.font = FONT_S(12);
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.textAlignment = NSTextAlignmentLeft;
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.font = FONT_S(22);
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.font = FONT_S(22);
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.textAlignment = NSTextAlignmentRight;
	}
	return _dateLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

@end


// ****************** 后付费 有积分 ******************
#pragma mark - 后付费 有积分
@interface DCPostpaidStickView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;

@end

@implementation DCPostpaidStickView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.paddingContentView];
	[self.paddingContentView addSubview:self.titleLab];
	[self.paddingContentView addSubview:self.moneyLab];
	[self.paddingContentView addSubview:self.dateLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.trailing.bottom.mas_equalTo(-12);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.centerY.mas_equalTo(0);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(4);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
		make.height.mas_equalTo(30);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(4);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(0);
		make.height.mas_equalTo(18);
//		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(4);
	}];
}

- (void)toViewAction:(id)sender {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *linkType = [billIconDic objectForKey:@"linkType"];
	NSString *link = [billIconDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 金额
	NSString *money = [dic objectForKey:@"money"];
	self.moneyLab.text = [NSString stringWithFormat:@"%@%@", [DXPPBConfigManager shareInstance].currencySymbol,money];
	// 日期
	NSString *effDate = [dic objectForKey:@"effDate"];
	if (DC_IsStrEmpty(effDate)) {
		self.dateLab.hidden = YES;
	} else {
		self.dateLab.hidden = NO;
		self.dateLab.text = [NSString stringWithFormat:@"%@ %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_due_by"] ,!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	}
	// 按钮
	NSDictionary *balIconDic = [propsDic.billIcon firstObject];
	NSString *balIconSrc = [balIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:balIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_add")];
	
}

#pragma mark - lazy load
- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
	}
	return _paddingContentView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
		_titleLab.font = FONT_S(12);
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.textAlignment = NSTextAlignmentLeft;
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.font = FONT_S(22);
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.font = FONT_S(12);
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.textAlignment = NSTextAlignmentRight;
	}
	return _dateLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

@end


// ****************** 后付费 无积分 ******************
#pragma mark - 后付费 无积分
@interface DCPostpaidNoPointStickView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *viewDetailLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCPostpaidNoPointStickView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.paddingContentView];
	[self.paddingContentView addSubview:self.titleLab];
	[self.paddingContentView addSubview:self.moneyLab];
	[self.paddingContentView addSubview:self.viewDetailLab];
	[self.paddingContentView addSubview:self.dateLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	CGFloat itemW = (DC_DCP_SCREEN_WIDTH - 10*2 - 12*2) / 2;
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.width.mas_equalTo(itemW);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(10);
		make.height.mas_equalTo(30);
		make.width.mas_equalTo(itemW);
		make.bottom.mas_equalTo(0);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.width.mas_equalTo(itemW);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.dateLab.mas_bottom).offset(0);
	}];
	
	[self.viewDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.toViewBtn.mas_centerY);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-12);
		make.height.mas_equalTo(18);
	}];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 金额
	NSString *money = [dic objectForKey:@"money"];
	self.moneyLab.text = [NSString stringWithFormat:@"%@%@", [DXPPBConfigManager shareInstance].currencySymbol,money];
	// 日期
	NSString *effDate = [dic objectForKey:@"effDate"];
	self.dateLab.text = [NSString stringWithFormat:@"%@ %@" , [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_due_by"],!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	// 按钮
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:billIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
	// 当showPoints为N时，渲染balOrBillLinkColor，为Y渲染pointsColor
	if ([propsDic.showPoints isEqualToString:@"Y"]) {
		self.viewDetailLab.textColor = [UIColor hjp_colorWithHex:propsDic.pointsColor];
	} else {
		self.viewDetailLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
	}
}

- (void)toViewAction:(id)sender {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *linkType = [billIconDic objectForKey:@"linkType"];
	NSString *link = [billIconDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

#pragma mark - lazy load
- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
	}
	return _paddingContentView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
		_titleLab.font = FONT_S(12);
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.textAlignment = NSTextAlignmentLeft;
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.font = FONT_S(22);
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.font = FONT_S(12);
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.textAlignment = NSTextAlignmentRight;
	}
	return _dateLab;
}

- (UILabel *)viewDetailLab {
	if (!_viewDetailLab) {
		_viewDetailLab = [[UILabel alloc] init];
		_viewDetailLab.text = @"Pay My Bills";
		_viewDetailLab.font = FONT_S(12);
		_viewDetailLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_viewDetailLab.textAlignment = NSTextAlignmentRight;
	}
	return _viewDetailLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}
@end


// ****************** 后付费 No Outstanding Bills ******************
#pragma mark -- 后付费 No Outstanding Bills
@interface DCPostpaidNoOutstandingBillsStickView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCPostpaidNoOutstandingBillsStickView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.paddingContentView];
	[self.paddingContentView addSubview:self.titleLab];
	[self.paddingContentView addSubview:self.subTitleLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.mas_equalTo(12);
		make.trailing.bottom.mas_equalTo(-12);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(-12);
		make.width.height.mas_equalTo(40);
		make.centerY.mas_equalTo(0);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-4);
	}];
	
	[self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.leading.mas_equalTo(0);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-4);
	}];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:billIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
	
}

- (void)toViewAction:(id)sender {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *linkType = [billIconDic objectForKey:@"linkType"];
	NSString *link = [billIconDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

#pragma mark - lazy load
- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
	}
	return _paddingContentView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
	}
	return _titleLab;
}

- (UILabel *)subTitleLab {
	if (!_subTitleLab) {
		_subTitleLab = [[UILabel alloc] init];
		_subTitleLab.numberOfLines = 0;
		_subTitleLab.lineBreakMode = NSLineBreakByWordWrapping;
		_subTitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_no_outstanding_bills"];
		_subTitleLab.textAlignment = NSTextAlignmentLeft;
		_subTitleLab.textColor = DC_UIColorFromRGB(0x242424);
		_subTitleLab.font = FONT_S(14);
	}
	return _subTitleLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction:) forControlEvents:UIControlEventTouchUpInside];
		_toViewBtn.hidden = YES;
	}
	return _toViewBtn;
}
@end



// ****************************** 积分 **********************************
#pragma mark -- 积分
@interface DCRightPointView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UIImageView *moneyImgView;
@property (nonatomic, strong) UILabel *pointLab;
@property (nonatomic, strong) UIButton *toViewBtn;
@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCRightPointView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
    [self addSubview:self.paddingContentView];
	[self.paddingContentView addSubview:self.moneyImgView];
	[self.paddingContentView addSubview:self.pointLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
    [self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.mas_equalTo(12);
        make.trailing.bottom.mas_equalTo(-12);
    }];
    
	[self.moneyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(14);
		make.leading.mas_equalTo(0);
		make.centerY.mas_equalTo(0);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
		make.centerY.mas_equalTo(0);
	}];
	
	[self.pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(24);
		make.leading.mas_equalTo(self.moneyImgView.mas_trailing).offset(4);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-4);
		make.centerY.mas_equalTo(0);
	}];
	
}

- (void)toViewAction:(id)sender {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *pointsIconDic = [propsDic.pointsIcon firstObject];
	NSString *linkType = [pointsIconDic objectForKey:@"linkType"];
	NSString *link = [pointsIconDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 跳转按钮
	NSDictionary *pointsIconDic = [propsDic.pointsIcon firstObject];
	NSString *pointsIconSrc = [pointsIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:pointsIconSrc] forState:UIControlStateNormal];
	// 金币按钮
	NSDictionary *pointsAmountIconDic = [propsDic.pointsAmountIcon firstObject];
	NSString *pointsAmountIconSrc = [pointsAmountIconDic objectForKey:@"src"];
	[self.moneyImgView sd_setImageWithURL:[NSURL URLWithString:pointsAmountIconSrc] placeholderImage:DC_image(@"ic_money_icon")];
	// point值
	NSString *pointVal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usablePoint"]];
	self.pointLab.text = DC_IsStrEmpty(pointVal)?@"":pointVal;
	self.pointLab.textColor = [UIColor colorWithHexString:propsDic.pointsColor];
}

#pragma mark -- lazy load
- (UIView *)paddingContentView {
    if (!_paddingContentView) {
        _paddingContentView = [[UIView alloc] init];
    }
    return _paddingContentView;
}

- (UIImageView *)moneyImgView {
	if (!_moneyImgView) {
		_moneyImgView = [[UIImageView alloc] init];
		_moneyImgView.image = DC_image(@"ic_money_icon");
	}
	return _moneyImgView;
}

- (UILabel *)pointLab {
	if (!_pointLab) {
		_pointLab = [[UILabel alloc] init];
		_pointLab.textAlignment = NSTextAlignmentLeft;
		_pointLab.font = FONT_S(16);
		_pointLab.textColor = DC_UIColorFromRGB(0x242424);
	}
	return _pointLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

@end
