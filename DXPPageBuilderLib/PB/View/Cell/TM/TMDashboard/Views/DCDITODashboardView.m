//
//  DCDITODashboardView.m
//  DCPageBuilding
//
//  Created by 李标 on 2024/4/14.
//

#import "DCDITODashboardView.h"
#import "UIResponder+DCFloorResponder.h"
#import "HJDitoProgress.h"
#import <DXPManagerLib/HJTokenManager.h>
#import "CMPopTipView.h"
#import "DCSubsListModel.h"
#import "DCMainBalanceSummaryModel.h"

@interface DCDITODashboardView ()<UIScrollViewDelegate,CMPopTipViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *baseContiner;
@property (nonatomic, strong) UIView *paddingContentView;
// 顶部
@property (nonatomic, strong) DCDBTopInfoView *topInfoView; // 头部view
// 左边
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) UIScrollView *progressScrollView; // 流量球view
@property (nonatomic, strong) HJDitoProgress *progressView1;
@property (nonatomic, strong) HJDitoProgress *progressView2;
@property (nonatomic, strong) HJDitoProgress *progressView3;
@property (nonatomic, strong) UIImageView *detailBtn; // view detail 按钮
// 右上
@property (nonatomic, strong) UIView *bottomRightView;
@property (nonatomic, strong) DCPrepaidRightTopInfoView *prepaidRightTopInfoView; // 预付费右上
@property (nonatomic, strong) DCPrepaidRightInfoView *prepaidRightInfoView; // 预付费无积分
@property (nonatomic, strong) DCRightPointInfoView *rightPointInfoView; // 积分view
@property (nonatomic, strong) DCPostpaidRightTopInfoView *postpaidRightTopInfoView; // 后付费有积分 右上view
@property (nonatomic, strong) DCPostpaidRightInfoView *postpaidRightInfoView; // 后付费无积分(看账单、支付账单)
@property (nonatomic, strong) DCPostpaidOutstandingBillRightTopInfoView *postpaidOutstandingBillRightTopInfoView;// 后付费无积分 (Outstanding Bill)
// 右下按钮 1~4 个按钮
@property (nonatomic, strong) UIView *picsView;
// 数据
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) PageCompositionItem *model;
@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelData;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelVoice;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelSMS;
@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
// 展开箭头
@property (nonatomic, strong) UIView *arrowView; // 箭头圆view
@property (nonatomic, strong) UIImageView *arrowImgView;
@end


@implementation DCDITODashboardView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self configView];
	}
	return self;
}

- (void)configView {
	// 背景色
	self.backgroundColor = [UIColor hjp_colorWithHex:@"#000000" alpha:0.6];
	//
	[self addSubview:self.bgView];
	[self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(DCP_NAV_HEIGHT);
		make.leading.mas_equalTo(16);
		make.trailing.mas_equalTo(-16);
		make.height.mas_equalTo(440+26);
	}];
    
    [self.bgView addSubview:self.arrowView];
    
	[self.bgView addSubview:self.baseContiner];
    
	[self.baseContiner mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.mas_equalTo(0);
		make.bottom.mas_equalTo(-26);
	}];
	
	
	[self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(self.baseContiner.mas_bottom).offset(-10);
		make.width.height.mas_equalTo(60);
	}];
	
	[self.arrowView addSubview:self.arrowImgView];
	[self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(self.arrowView.mas_centerY).offset(15);
		make.width.mas_equalTo(21);
		make.height.mas_equalTo(14);
	}];
	
	[self.baseContiner addSubview:self.paddingContentView];
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.mas_equalTo(10);
		make.trailing.mas_equalTo(-10);
		make.bottom.mas_equalTo(-16);
	}];
	// top
	[self.paddingContentView addSubview:self.topInfoView];
	[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(32);
		make.leading.top.trailing.mas_equalTo(0);
	}];
	
	// 下面左边
	[self.paddingContentView addSubview:self.bottomLeftView];
	[self.bottomLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
		make.width.mas_equalTo(150);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
	}];
	// 球
	[self.bottomLeftView addSubview:self.progressView1];
	[self.progressView1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.bottomLeftView.mas_centerX);
		make.top.mas_equalTo(0);
		make.width.mas_equalTo(100);
		make.height.mas_equalTo(120);
	}];
	[self.bottomLeftView addSubview:self.progressView2];
	[self.progressView2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.bottomLeftView.mas_centerX);
		make.top.mas_equalTo(self.progressView1.mas_bottom).offset(-7);
		make.width.mas_equalTo(100);
		make.height.mas_equalTo(120);
	}];
	[self.bottomLeftView addSubview:self.progressView3];
	[self.progressView3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.bottomLeftView.mas_centerX);
		make.top.mas_equalTo(self.progressView2.mas_bottom).offset(-7);
		make.width.mas_equalTo(100);
		make.height.mas_equalTo(120);
	}];
	// view detail
	[self.bottomLeftView addSubview:self.detailBtn];
	[self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(34);
		make.top.mas_equalTo(self.progressView3.mas_bottom).offset(-7);
		make.leading.mas_equalTo(5);
		make.trailing.mas_equalTo(-5);
	}];
	
	// 右边
	[self.paddingContentView addSubview:self.bottomRightView];
	[self.bottomRightView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
//		make.leading.mas_equalTo(self.bottomLeftView.mas_trailing).offset(16);
		make.width.mas_equalTo(176);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
	}];
	
	[self.bottomRightView addSubview:self.prepaidRightTopInfoView];// 预付费
	[self.prepaidRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.bottomRightView.mas_top).offset(0);
		make.height.mas_equalTo(82);
	}];
	
	[self.bottomRightView addSubview:self.prepaidRightInfoView]; // 预付费无积分
	[self.prepaidRightInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(142);
	}];
	
	[self.bottomRightView addSubview:self.rightPointInfoView]; // 积分
	[self.rightPointInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.prepaidRightTopInfoView.mas_bottom).offset(8);
		make.height.mas_equalTo(58);
	}];
	[self.bottomRightView addSubview:self.postpaidRightTopInfoView]; // 后付费有积分 右上view
	[self.postpaidRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.bottomRightView.mas_top).offset(0);
		make.height.mas_equalTo(82);
	}];
	[self.bottomRightView addSubview:self.postpaidRightInfoView]; // 后付费无积分
	[self.postpaidRightInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(142);
	}];
	[self.bottomRightView addSubview:self.postpaidOutstandingBillRightTopInfoView]; // 后付费无积分 (Outstanding Bill) 后付费无积分(看账单、支付账单)
	[self.postpaidOutstandingBillRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(142);
	}];
	
	// 4宫格
	[self.bottomRightView addSubview:self.picsView];
	[self.picsView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(106*2+10);
		make.bottom.mas_equalTo(0);
		make.leading.trailing.mas_equalTo(0);
	}];
}

// 卡片点击跳转
- (void)picTapAction:(UITapGestureRecognizer *)genstureRecongnizer {
	CompositionProps *propsDic = self.cellModel.props;
	
	NSInteger index = genstureRecongnizer.view.tag - 1000;
	NSDictionary *dic = [propsDic.floorPictures objectAtIndex:index];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = DC_IsStrEmpty([dic objectForKey:@"linkType"])?@"":[dic objectForKey:@"linkType"];
	model.link = DC_IsStrEmpty([dic objectForKey:@"link"])?@"":[dic objectForKey:@"link"];
	model.floorEventType = DCFloorEventFloor;
	if (self.dbEventBlack) {
		self.dbEventBlack(model);
	}
}

// 隐藏当前DB弹框
- (void)hiddenPopDashboardView:(UIGestureRecognizer *)tap {
	if (self.showActionBlock) {
		self.showActionBlock(HJDITODashBoardActionTypeBottomArrow);
	}
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	self.prepaidRightTopInfoView.hidden = YES;
	self.prepaidRightInfoView.hidden = YES;
	self.rightPointInfoView.hidden = YES;
	self.postpaidRightTopInfoView.hidden = YES;
	self.postpaidRightInfoView.hidden = YES;
	self.postpaidOutstandingBillRightTopInfoView.hidden = YES;
	
	[self.topInfoView bindWithModel:cellModel];
	
	// 判断
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	if ([paidFlag isEqualToString:@"1"]) {
		// 后付费
		NSString *usablePoint = [dic objectForKey:@"usablePoint"];
		if (!DC_IsStrEmpty(usablePoint) && [usablePoint floatValue] > 0) {
			// 后付费有积分
			self.postpaidRightTopInfoView.hidden = NO;
			self.rightPointInfoView.hidden = NO;
			[self.postpaidRightTopInfoView bindWithModel:cellModel];
			[self.rightPointInfoView bindWithModel:cellModel];
		} else {
			// 后付费无积分
			NSString *money = [dic objectForKey:@"money"];
			if (DC_IsStrEmpty(money) || [money isEqualToString:@"0"]) {
				self.postpaidOutstandingBillRightTopInfoView.hidden = NO;
				[self.postpaidOutstandingBillRightTopInfoView bindWithModel:cellModel];
			} else if ([money floatValue] > 0) {
				self.postpaidRightInfoView.hidden = NO;
				[self.postpaidRightInfoView bindWithModel:cellModel];
			}
		}
	} else {
		// 是否展示points
		if ([@"y" isEqualToString:[cellModel.props.showPoints lowercaseString]] ) {
			// 预付费有积分
			self.prepaidRightTopInfoView.hidden = NO;
			[self.prepaidRightTopInfoView bindWithModel:cellModel];
			self.rightPointInfoView.hidden = NO;
			[self.rightPointInfoView bindWithModel:cellModel];
		} else {
			// 预付费无积分
			self.prepaidRightInfoView.hidden = NO;
			[self.prepaidRightInfoView bindWithModel:cellModel];
		}
	}
	
	
	// downView 流量球
//	NSString *progressUpdate = [dic objectForKey:@"progressUpdate"];
//	if ([progressUpdate boolValue]) {
		[dic setObject:@(NO) forKey:@"progressUpdate"];
		NSArray *arr = [dic objectForKey:@"progressData"] ?: @[];
		self.modelData = [[DCMainBalanceSummaryItemModel alloc] init];
		self.modelVoice = [[DCMainBalanceSummaryItemModel alloc] init];
		self.modelSMS = [[DCMainBalanceSummaryItemModel alloc] init];
		
		if ([arr isKindOfClass:[NSArray class]]) {
			for (DCMainBalanceSummaryItemModel * model in arr) {
				if ([model.unitTypeId intValue] == 1) {//data
					self.modelData  = model;
				}else if ([model.unitTypeId intValue] == 2) {//voice
					self.modelVoice  = model;
				}else if ([model.unitTypeId intValue] == 3) {//sms
					self.modelSMS = model;
				}
			}
		}
		
		// 排序
		NSMutableArray *list = [[NSMutableArray alloc] init];
	    NSMutableArray *propsList = [[NSMutableArray alloc] init];
		for (NSDictionary *dic in propsDic.infoList) {
			NSString *value = [dic objectForKey:@"value"];
			NSString *typeId = [dic objectForKey:@"typeId"];
			if ([typeId isEqualToString:@"1"]) {
				// data
				[list addObject:self.modelData];
				self.modelData.temp = value;
			}
			if ([typeId isEqualToString:@"2"]) {
				// Calls
				[list addObject:self.modelVoice];
				self.modelVoice.temp = value;
			}
			if ([typeId isEqualToString:@"3"]) {
				// SMS
				[list addObject:self.modelSMS];
				self.modelSMS.temp = value;
			}
			[propsList addObject:dic];
		}
		
	DCMainBalanceSummaryItemModel *model1 = [list objectAtIndex:0];
	    NSDictionary *propDic1 = [propsList objectAtIndex:0];
	DCMainBalanceSummaryItemModel *model2 = [list objectAtIndex:1];
	    NSDictionary *propDic2 = [propsList objectAtIndex:1];
	DCMainBalanceSummaryItemModel *model3 = [list objectAtIndex:2];
		NSDictionary *propDic3 = [propsList objectAtIndex:2];
		
		// 构建数据 progressModel1
		HJDitoProgressModel *progressModel1 = [[HJDitoProgressModel alloc]initWithGross:model1.formatGrossBalance grossUnit:model1.formatGrossBalanceUnitName balance:model1.formatRealBalance balanceUnit:@"" type:model1.temp expire:@"" des:@"" btnName:@"" realBalance:model1.realBalance grossBalance:model1.grossBalance];
		[self.progressView1 updateWithModel:progressModel1 props:propDic1];
		// 构建数据 progressModel2
		HJDitoProgressModel *progressModel2 = [[HJDitoProgressModel alloc]initWithGross:model2.formatGrossBalance grossUnit:model2.formatGrossBalanceUnitName balance:model2.formatRealBalance balanceUnit:@"" type:model2.temp expire:@"" des:@"" btnName:@"" realBalance:model2.realBalance grossBalance:model2.grossBalance];
		[self.progressView2 updateWithModel:progressModel2 props:propDic2];
		
		// 构建数据 progressModel3
		HJDitoProgressModel *progressModel3 = [[HJDitoProgressModel alloc]initWithGross:model3.formatGrossBalance grossUnit:model3.formatGrossBalanceUnitName balance:model3.formatRealBalance balanceUnit:@"" type:model3.temp expire:@"" des:@"" btnName:@"" realBalance:model3.realBalance grossBalance:model3.grossBalance];
		[self.progressView3 updateWithModel:progressModel3 props:propDic3];
//	}
	
	// 更新4宫格UI+数据
	CGFloat picsViewWidth = DC_DCP_SCREEN_WIDTH - 16*2 - 10*2 - 132 - 16;
	CGFloat onePicW = (picsViewWidth - 10) / 2;
	CGFloat onePicH = (440 - 10 - 16 - 32 - 8 - 142 - 10 - 10) / 2;
	
	for (int i = 0; i< [propsDic.floorPictures count] ;i++) {
		UIImageView *imgView = [[UIImageView alloc] init];
		imgView.layer.cornerRadius = 8.f;
		imgView.tag = 1000+i;
		imgView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tapImg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTapAction:)];
		[imgView addGestureRecognizer:tapImg];
		NSDictionary *dic = [propsDic.floorPictures objectAtIndex:i];
		NSString *src = [dic objectForKey:@"src"];
		[imgView sd_setImageWithURL:[NSURL URLWithString:src]];
		[self.picsView addSubview:imgView];
		// 计算出图片等比高度
		CGFloat p_w = [[dic objectForKey:@"width"] floatValue]; // 下发图片宽度
		CGFloat p_h = [[dic objectForKey:@"height"] floatValue]; // 下发图片高度
		CGFloat pic_w = p_w / 2;
		CGFloat pic_h = (pic_w * p_h) / p_w; // 等比后的图片高度
		
		[imgView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(pic_h);
			make.width.mas_equalTo(pic_w);
			make.top.mas_equalTo(self.picsView.mas_top).offset((i/2)*pic_h + (i/2)*10);
			if (i == 1 || i == 3) {
				make.leading.mas_equalTo(self.picsView.mas_leading).offset(pic_w + 10);
			} else {
				make.leading.mas_equalTo(self.picsView.mas_leading).offset(0);
			}
		}];
	}
	
	// view detail
	NSDictionary *dic1 = [propsDic.viewDetailPic firstObject];
	NSString *src = [dic1 objectForKey:@"src"];
	[self.detailBtn sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:DC_image(@"")];
}

// 详情跳转
- (void)viewDetailAction:(UIGestureRecognizer *)tap {
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *dic = [propsDic.viewDetailPic objectAtIndex:0];
	NSString *link = [dic objectForKey:@"link"];
	NSString *linkType = [dic objectForKey:@"linkType"];
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	if (self.dbEventBlack) {
		self.dbEventBlack(model);
	}
}

#pragma mark - lazy load
- (UIView *)bgView {
	if (!_bgView) {
		_bgView = [[UIView alloc] init];
		_bgView.backgroundColor = [UIColor clearColor];
	}
	return _bgView;
}

- (UIView *)baseContiner {
	if (!_baseContiner) {
		_baseContiner = [[UIView alloc] init];
		_baseContiner.backgroundColor = [UIColor whiteColor];
		_baseContiner.layer.cornerRadius = 16.f;
	}
	return _baseContiner;
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
		_topInfoView.layer.cornerRadius = 8.f;
		_topInfoView.backgroundColor = DC_UIColorFromRGB(0x002641);
		__weak __typeof(&*self)weakSelf = self;
		_topInfoView.dbEventBlack = ^(DCFloorEventModel * _Nonnull model) {
			if (weakSelf.dbEventBlack) {
				weakSelf.dbEventBlack(model);
			}
		};
	}
	return _topInfoView;
}

- (UIView *)bottomLeftView {
	if (!_bottomLeftView) {
		_bottomLeftView = [[UIView alloc] init];
	}
	return _bottomLeftView;
}

- (HJDitoProgress *)progressView1 {
	if (!_progressView1) {
		_progressView1 = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, 120, 100) primaryColor:@""];
		__weak typeof(self)weakSelf = self;
		_progressView1.tapInfoAction = ^(UIView * _Nonnull tapView, NSString * _Nonnull desc) {
			[weakSelf showTipViewWithMsg:desc toView:tapView];
		};
	}
	return _progressView1;
}

- (HJDitoProgress *)progressView2 {
	if (!_progressView2) {
		_progressView2 = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, 120, 100) primaryColor:@""];
		__weak typeof(self)weakSelf = self;
		_progressView2.tapInfoAction = ^(UIView * _Nonnull tapView, NSString * _Nonnull desc) {
			[weakSelf showTipViewWithMsg:desc toView:tapView];
		};
	}
	return _progressView2;
}

- (HJDitoProgress *)progressView3 {
	if (!_progressView3) {
		_progressView3 = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, 120, 100) primaryColor:@""];
		__weak typeof(self)weakSelf = self;
		_progressView3.tapInfoAction = ^(UIView * _Nonnull tapView, NSString * _Nonnull desc) {
			[weakSelf showTipViewWithMsg:desc toView:tapView];
		};
	}
	return _progressView3;
}

#pragma mark - CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
	[self.visiblePopTipViews removeObject:popTipView];
}

- (void)showTipViewWithMsg:(NSString *)msg toView:(UIView *)toView {
	
	CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:msg];
	popTipView.delegate = self;
	popTipView.disableTapToDismiss = YES; // 点击本身是否关闭
	popTipView.dismissTapAnywhere = YES; // 点击任何空白处是否关闭
	popTipView.animation = CMPopTipAnimationPop;
	popTipView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
	popTipView.borderColor = DC_UIColorFromRGB(0xFFFFFF);
	popTipView.has3DStyle = NO;
	popTipView.hasShadow = YES;
	popTipView.cornerRadius = 4;
	popTipView.sidePadding = 16;
	popTipView.textFont = FONT_S(14);
	popTipView.textColor = DC_UIColorFromRGB(0x242424);
	popTipView.preferredPointDirection = PointDirectionUp;
	[popTipView presentPointingAtView:toView inView:[UIApplication sharedApplication].keyWindow animated:YES];
	
	[self.visiblePopTipViews addObject:popTipView];
}

//- (UIButton *)detailBtn {
//	if (!_detailBtn) {
//		_detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		_detailBtn.titleLabel.font = systemFont(14);
//		_detailBtn.layer.cornerRadius = 17;
//		[_detailBtn setTitleColor:[[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-textColor-active"] forState:UIControlStateNormal];
//		_detailBtn.backgroundColor = [[HJTokenManager shareInstance] getColorByToken:@"ref-primaryButton-fillColor-active"];
//		[_detailBtn setTitle:[[HJLanguageManager shareInstance] getTextByKey:@"lb_view_detail"] forState:UIControlStateNormal];
//		[_detailBtn addTarget:self action:@selector(viewDetailAction:) forControlEvents:UIControlEventTouchUpInside];
//	}
//	return _detailBtn;
//}

- (UIImageView *)detailBtn {
	if (!_detailBtn) {
		_detailBtn = [[UIImageView alloc] init];
		_detailBtn.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDetailAction:)];
		[_detailBtn addGestureRecognizer:tap];
	}
	return _detailBtn;
}

- (UIView *)bottomRightView {
	if (!_bottomRightView) {
		_bottomRightView = [[UIView alloc] init];
	}
	return _bottomRightView;
}

- (DCPrepaidRightTopInfoView *)prepaidRightTopInfoView {
	if (!_prepaidRightTopInfoView) {
		_prepaidRightTopInfoView = [[DCPrepaidRightTopInfoView alloc] init];
		_prepaidRightTopInfoView.layer.cornerRadius = 4.f;
		_prepaidRightTopInfoView.layer.borderWidth = 1.f;
		_prepaidRightTopInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _prepaidRightTopInfoView;
}

- (DCPrepaidRightInfoView *)prepaidRightInfoView {
	if (!_prepaidRightInfoView) {
		_prepaidRightInfoView = [[DCPrepaidRightInfoView alloc] init];
		_prepaidRightInfoView.layer.borderWidth = 1.f;
		_prepaidRightInfoView.layer.cornerRadius = 8.f;
		_prepaidRightInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _prepaidRightInfoView;
}

- (DCRightPointInfoView *)rightPointInfoView {
	if (!_rightPointInfoView) {
		_rightPointInfoView = [[DCRightPointInfoView alloc] init];
		_rightPointInfoView.layer.cornerRadius = 4.f;
		_rightPointInfoView.layer.borderWidth = 1.f;
		_rightPointInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _rightPointInfoView;
}

- (DCPostpaidRightInfoView *)postpaidRightInfoView {
	if (!_postpaidRightInfoView) {
		_postpaidRightInfoView = [[DCPostpaidRightInfoView alloc] init];
		_postpaidRightInfoView.layer.borderWidth = 1.f;
		_postpaidRightInfoView.layer.cornerRadius = 8.f;
		_postpaidRightInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _postpaidRightInfoView;
}

- (DCPostpaidRightTopInfoView *)postpaidRightTopInfoView {
	if (!_postpaidRightTopInfoView) {
		_postpaidRightTopInfoView = [[DCPostpaidRightTopInfoView alloc] init];
		_postpaidRightTopInfoView.layer.borderWidth = 1.f;
		_postpaidRightTopInfoView.layer.cornerRadius = 4.f;
		_postpaidRightTopInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _postpaidRightTopInfoView;
}

- (DCPostpaidOutstandingBillRightTopInfoView *)postpaidOutstandingBillRightTopInfoView {
	if (!_postpaidOutstandingBillRightTopInfoView) {
		_postpaidOutstandingBillRightTopInfoView = [[DCPostpaidOutstandingBillRightTopInfoView alloc] init];
		_postpaidOutstandingBillRightTopInfoView.layer.cornerRadius = 8.f;
		_postpaidOutstandingBillRightTopInfoView.layer.borderWidth = 1.f;
		_postpaidOutstandingBillRightTopInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _postpaidOutstandingBillRightTopInfoView;
}

- (UIView *)picsView {
	if (!_picsView) {
		_picsView = [[UIView alloc] init];
		// _picsView.backgroundColor = [UIColor redColor];
	}
	return _picsView;
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
		_arrowImgView.image = DC_image(@"ic_arrow_up_Img");
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPopDashboardView:)];
        [_arrowImgView addGestureRecognizer:tap];
	}
	return _arrowImgView;
}
@end
