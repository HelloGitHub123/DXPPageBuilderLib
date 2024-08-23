//
//  DCMutiBalanceDashboardCell.m
//  DCPageBuilding
//
//  Created by 李标 on 2024/4/13.
//

#import "DCMutiBalanceDashboardCell.h"
#import "DCPB.h"
#import "YYLabel.h"
#import "YYText.h"
#import <DXPCategoryLib/UIColor+Category.h>
#import "HJDitoProgress.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <DXPManagerLib/HJTokenManager.h>
#import "CMPopTipView.h"
#import "DCSubsListModel.h"
#import "DCMainBalanceSummaryModel.h"

// ****************** Model ******************
@implementation DCMutiBalanceDashboardCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
	self = [super initWithComponentModel:componentModel];
	return self;
}

- (void)coustructCellHeight {
	[super coustructCellHeight];
	
	self.cellHeight = 0;
}

- (NSString *)cellClsName {
	return NSStringFromClass([DCMutiBalanceDashboardCell class]);
}

// 类型
- (void)setDbCellType:(DCMutiBalanceDashboardCellHeightType)dbCellType {
	_dbCellType = dbCellType;
	
	switch (dbCellType) {
		case DCMutiBalanceLikeDITO:
			self.cellHeight = 202+24+16;
			break;
		default:
			break;
	}
}

+ (CGFloat)getTMDBTopMargin {
	return  DCP_NAV_HEIGHT + 10;
}

@end


// ****************** Cell ******************
@interface DCMutiBalanceDashboardCell()

// Dashboard  容器
@property (nonatomic, strong) DCDBContainerDITOView *dbContainerDITOView;
@end


@implementation DCMutiBalanceDashboardCell

- (void)configView {
	// ============ 中间信息容器 container
	[self.contentView addSubview:self.dbContainerDITOView];
	[self.dbContainerDITOView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(16);
		make.trailing.bottom.leading.equalTo(@0);
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
}

- (void)bindCellModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	[super bindCellModel:cellModel];
	self.cellModel = cellModel;
	
	UIImageView *bgImgView = nil;
	[self.dbContainerDITOView bindWithModel:cellModel];
	bgImgView = nil;

	if (bgImgView && !DC_IsStrEmpty(cellModel.props.themeType)) {
		NSString *imgStr = [NSString stringWithFormat:@"db_bg_%@_top",cellModel.props.themeType];
		bgImgView.image = [UIImage imageNamed:imgStr];
	}
}

// MARK: LAzy
- (DCDBContainerDITOView *)dbContainerDITOView {
	if(!_dbContainerDITOView) {
		_dbContainerDITOView = [DCDBContainerDITOView new];
	}
	return _dbContainerDITOView;
}
@end


// ****************** DCDBContainerDITOView ******************
@interface DCDBContainerDITOView () <CMPopTipViewDelegate>

@property (nonatomic, strong) CMPopTipView *popTipView; // 展示的提示信息
@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@property (nonatomic, strong) UIView *bakView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *paddingContentView; // subview都add到这个view上
// 顶部
@property (nonatomic, strong) DCDBTopInfoView *topInfoView; // 头部view
// 下面球
@property (nonatomic, strong) UIView *bottomLeftView;
@property (nonatomic, strong) HJDitoProgress *progressView; // 球
//@property (nonatomic, strong) UIButton *detailBtn; // view detail 按钮
@property (nonatomic, strong) UIImageView *detailBtn;
// 右边
@property (nonatomic, strong) UIView *bottomRightView;
@property (nonatomic, strong) DCPrepaidRightTopInfoView *prepaidRightTopInfoView; // 预付费右上 有积分
@property (nonatomic, strong) DCPrepaidRightInfoView *prepaidRightInfoView; // 预付费无积分 包含有效期
@property (nonatomic, strong) DCRightPointInfoView *rightPointInfoView; // 积分view
@property (nonatomic, strong) DCPostpaidRightTopInfoView *postpaidRightTopInfoView; // 后付费有积分 右上view
@property (nonatomic, strong) DCPostpaidRightInfoView *postpaidRightInfoView; // 后付费无积分(看账单、支付账单)
@property (nonatomic, strong) DCPostpaidOutstandingBillRightTopInfoView *postpaidOutstandingBillRightTopInfoView;// 后付费无积分 (Outstanding Bill) 后付费无积分(看账单、支付账单)
// 展开箭头
@property (nonatomic, strong) UIView *arrowView; // 箭头圆view
@property (nonatomic, strong) UIImageView *arrowImgView;
// 数据
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelData;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelVoice;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelSMS;

@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
@end


@implementation DCDBContainerDITOView

- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]){
		[self configView];
	}
	return self;
}

- (void)configView {
	// 大背景
	[self addSubview:self.bakView];
	[self.bakView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@16);
		make.trailing.equalTo(@-16);
		make.top.equalTo(@0);
		make.bottom.equalTo(@0);
	}];
    
    [self.bakView addSubview:self.arrowView];
	// 内容背景
	[self.bakView addSubview:self.contentView];
	[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.top.equalTo(@0);
		make.bottom.equalTo(@-20);
	}];
	
	
	[self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(self.contentView.mas_bottom).offset(-10);
		make.width.height.mas_equalTo(60);
	}];
	
	[self.arrowView addSubview:self.arrowImgView];
	[self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(0);
		make.centerY.mas_equalTo(self.arrowView.mas_centerY).offset(15);
		make.width.mas_equalTo(21);
		make.height.mas_equalTo(14);
	}];
	
	// padding view
	[self.contentView addSubview:self.paddingContentView];
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.equalTo(@10);
		make.bottom.trailing.equalTo(@-10);
	}];
	
	// 顶部view
	[self.paddingContentView addSubview:self.topInfoView];
	[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.top.mas_equalTo(0);
		make.height.mas_equalTo(32);
	}];
	
	// 下面左边
	[self.paddingContentView addSubview:self.bottomLeftView];
	[self.bottomLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
		make.width.mas_equalTo(151);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
	}];
	// 球
	[self.bottomLeftView addSubview:self.progressView];
	[self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.mas_equalTo(self.bottomLeftView.mas_centerX);
		make.top.mas_equalTo(0);
		make.width.mas_equalTo(100);
		make.height.mas_equalTo(120);
	}];
	// view detail
	[self.bottomLeftView addSubview:self.detailBtn];
	[self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(34);
		make.top.mas_equalTo(self.progressView.mas_bottom).offset(-11);
		// make.leading.trailing.mas_equalTo(0);
		make.leading.mas_equalTo(5);
		make.trailing.mas_equalTo(-5);
	}];
	
	// 右边
	[self.paddingContentView addSubview:self.bottomRightView];
	[self.bottomRightView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.topInfoView.mas_bottom).offset(8);
		// make.leading.mas_equalTo(self.bottomLeftView.mas_trailing).offset(16);
		make.width.mas_equalTo(172);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
	}];
	
	[self.bottomRightView addSubview:self.prepaidRightTopInfoView];// 预付费
	[self.prepaidRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.bottomRightView.mas_top).offset(0);
		make.height.mas_equalTo(82);
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
	[self.bottomRightView addSubview:self.postpaidRightInfoView]; // 后付费无积分(看账单、支付账单)
	[self.postpaidRightInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.bottom.mas_equalTo(0);
	}];
	[self.bottomRightView addSubview:self.prepaidRightInfoView]; // 预付费无积分
	[self.prepaidRightInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.bottom.mas_equalTo(0);
	}];
	[self.bottomRightView addSubview:self.postpaidOutstandingBillRightTopInfoView]; // 后付费无积分 (Outstanding Bill) 后付费无积分(看账单、支付账单)
	[self.postpaidOutstandingBillRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.bottom.mas_equalTo(0);
	}];
	
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
	NSString *progressUpdate = [dic objectForKey:@"progressUpdate"];
	if ([progressUpdate boolValue]) {
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
		NSDictionary *propDic = [propsList objectAtIndex:0];
		
		// 构建数据 progressModel1
		HJDitoProgressModel *progressModel1 = [[HJDitoProgressModel alloc]initWithGross:model1.formatGrossBalance grossUnit:model1.formatGrossBalanceUnitName balance:model1.formatRealBalance balanceUnit:@"" type:model1.temp expire:@"" des:@"" btnName:@"" realBalance:model1.realBalance grossBalance:model1.grossBalance];
		[self.progressView updateWithModel:progressModel1 props:propDic];
		
		// view detail
		NSDictionary *dic = [propsDic.viewDetailPic firstObject];
		NSString *src = [dic objectForKey:@"src"];
		[self.detailBtn sd_setImageWithURL:[NSURL URLWithString:src] placeholderImage:DC_image(@"")];
	}
}

// 详情跳转
//- (void)viewDetailAction:(id)sender {
//	NSLog(@"=== viewDetailAction ====");
//}

- (void)viewDetailAction:(UIGestureRecognizer *)tap {
	NSMutableDictionary *dic = self.cellModel.customData;
	CompositionProps *propsDic = self.cellModel.props;
	
	NSDictionary *viewDetailPicDic = [propsDic.viewDetailPic firstObject];
	NSString *linkType = [viewDetailPicDic objectForKey:@"linkType"];
	NSString *link = [viewDetailPicDic objectForKey:@"link"];
	
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.linkType = linkType;
	model.link = DC_IsStrEmpty(link)?@"":link;
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

- (void)showPopDashboardView:(UIGestureRecognizer *)tap {
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.link = @"DitoDashboardCell_ARROW";
	model.floorEventType = DCFloorEventCustome;
	[self hj_routerEventWith:model];
}

#pragma mark -- lazy load
- (UIView *)bakView {
	if (!_bakView) {
		_bakView = [[UIView alloc] init];
		_bakView.layer.cornerRadius = 8;
		_bakView.userInteractionEnabled = YES;
		_bakView.backgroundColor = [UIColor clearColor]; //UIColorFromRGB(0xFFFFFF);
	}
	return _bakView;
}

- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.layer.cornerRadius = 16.f;
		_contentView.userInteractionEnabled = YES;
		_contentView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
	}
	return _contentView;
}

- (UIView *)paddingContentView {
	if (!_paddingContentView) {
		_paddingContentView = [[UIView alloc] init];
		_paddingContentView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
	}
	return _paddingContentView;
}

- (DCDBTopInfoView *)topInfoView {
	if (!_topInfoView) {
		_topInfoView = [[DCDBTopInfoView alloc] init];
		_topInfoView.layer.cornerRadius = 8.f;
		_topInfoView.backgroundColor = DC_UIColorFromRGB(0x002641);
	}
	return _topInfoView;
}

- (UIView *)bottomLeftView {
	if (!_bottomLeftView) {
		_bottomLeftView = [[UIView alloc] init];
	}
	return _bottomLeftView;
}

- (HJDitoProgress *)progressView {
	if (!_progressView) {
		_progressView = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, 120, 100) primaryColor:@""];
		__weak typeof(self)weakSelf = self;
		_progressView.tapInfoAction = ^(UIView * _Nonnull tapView, NSString * _Nonnull desc) {
			// 构建文本
//			NSMutableParagraphStyle *ps = [NSMutableParagraphStyle new];
//			ps.alignment = NSTextAlignmentCenter;
//			NSString *fwaTip = desc;
//			NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:fwaTip attributes:@{NSFontAttributeName:systemFont(14),NSForegroundColorAttributeName:[UIColor hjp_colorWithHex:@"#242424"]}];
//			[attrString addAttributes:@{ NSParagraphStyleAttributeName:ps} range:NSMakeRange(0, fwaTip.length)];
			[weakSelf showTipViewWithMsg:desc toView:tapView];
		};
	}
	return _progressView;
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

- (DCRightPointInfoView *)rightPointInfoView {
	if (!_rightPointInfoView) {
		_rightPointInfoView = [[DCRightPointInfoView alloc] init];
		_rightPointInfoView.layer.cornerRadius = 4.f;
		_rightPointInfoView.layer.borderWidth = 1.f;
		_rightPointInfoView.layer.borderColor = DC_UIColorFromRGB(0xEAEAEA).CGColor;
	}
	return _rightPointInfoView;
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

- (UIView *)arrowView {
	if (!_arrowView) {
		_arrowView = [[UIView alloc] init];
		_arrowView.layer.cornerRadius = 30.f;
		_arrowView.backgroundColor = [UIColor whiteColor];
		_arrowView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopDashboardView:)];
		[_arrowView addGestureRecognizer:tap];
	}
	return _arrowView;
}

- (UIImageView *)arrowImgView {
	if (!_arrowImgView) {
		_arrowImgView = [[UIImageView alloc] init];
		_arrowImgView.userInteractionEnabled = YES;
		_arrowImgView.image = DC_image(@"ic_arrow_Img");
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPopDashboardView:)];
        [_arrowImgView addGestureRecognizer:tap];
	}
	return _arrowImgView;
}

@end


// ****************** DCDBTopInfoView ******************
#pragma mark - DCDBTopInfoView
@interface DCDBTopInfoView ()

@property (nonatomic, strong) UIImageView *phoneImgView;
@property (nonatomic, strong) UILabel *phoneNumberLab;
@property (nonatomic, strong) UIButton *exchangeBtn;
@end

@implementation DCDBTopInfoView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.phoneImgView];
	[self addSubview:self.phoneNumberLab];
	[self addSubview:self.exchangeBtn];
}

- (void)layoutUI {
	[self.phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(24);
		make.centerY.mas_equalTo(self.mas_centerY);
		make.leading.mas_equalTo(self.mas_leading).offset(12);
	}];

	[self.phoneNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.mas_centerY);
		make.leading.mas_equalTo(self.phoneImgView.mas_trailing).offset(12);
		make.height.mas_equalTo(14);
	}];

	[self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(24);
		make.centerY.mas_equalTo(self.mas_centerY);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
	}];
}

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

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 图标
	PicturesItem *picItem = [propsDic.circlePhoneIcon firstObject];
	[self.phoneImgView sd_setImageWithURL:[NSURL URLWithString:picItem.src] placeholderImage:DC_image(@"ic_phonenumber_icon")];
	// 切换号码图标
	PicturesItem *picItem1 = [propsDic.circleChangeIcon firstObject];
	[self.exchangeBtn sd_setImageWithURL:[NSURL URLWithString:picItem1.src] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_change_phonenumber")];
	// 手机号码以及预后付费 名称
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	NSString *strPhone = @"";
	if ([paidFlag isEqualToString:@"1"]) {
		// 后付费
		if (self.isStickView) {
			strPhone = [NSString stringWithFormat:@"%@", [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
		} else {
			strPhone = [NSString stringWithFormat:@"%@ |  %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_mobile_postpaid"] ,[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
		}
		
	} else {
		// 预付费
		if (self.isStickView) {
			strPhone = [NSString stringWithFormat:@"%@", [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
		} else {
			strPhone = [NSString stringWithFormat:@"%@ | %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_mobile_prepaid"],[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
		}
	}
	self.phoneNumberLab.text = strPhone;
	self.phoneNumberLab.textColor =  [UIColor colorWithHexString:propsDic.phoneNumberColor];
}

#pragma mark - lazy load
- (UIImageView *)phoneImgView {
	if (!_phoneImgView) {
		_phoneImgView = [[UIImageView alloc] init];
		_phoneImgView.image = DC_image(@"ic_mobilePhone");
	}
	return _phoneImgView;
}

- (UILabel *)phoneNumberLab {
	if (!_phoneNumberLab) {
		_phoneNumberLab = [[UILabel alloc] init];
		//_phoneNumberLab.text = @"Mobile Prepaid |  0991 002 1086";
		_phoneNumberLab.textColor = DC_UIColorFromRGB(0x3868FF);
		_phoneNumberLab.font = FONT_S(12);
	}
	return _phoneNumberLab;
}

- (UIButton *)exchangeBtn {
	if (!_exchangeBtn) {
		_exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_exchangeBtn setImage:[UIImage imageNamed:@"ic_change_phonenumber"] forState:UIControlStateNormal];
		[_exchangeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _exchangeBtn;
}

@end

// ****************** 右边 预付费上面 ******************
#pragma mark - 右边 预付费上面
@interface DCPrepaidRightTopInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIButton *loadBalanceBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCPrepaidRightTopInfoView

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
	[self.paddingContentView addSubview:self.loadBalanceBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	[self.loadBalanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(0);
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(30);
		make.top.mas_equalTo(self.titleLab.mas_bottom);
		make.trailing.mas_equalTo(self.loadBalanceBtn.mas_leading).offset(-2);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.moneyLab.mas_bottom);
	}];
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
	self.dateLab.text = [NSString stringWithFormat:@"%@ %@" , [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_valid_until"] ,!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	// 按钮
	NSDictionary *balIconDic = [propsDic.balIcon firstObject];
	NSString *balIconSrc = [balIconDic objectForKey:@"src"];
	[self.loadBalanceBtn sd_setImageWithURL:[NSURL URLWithString:balIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_add")];
}

- (void)loadBalanceAction:(id)sender {
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
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_your_load_balance"];
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = FONT_S(22);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = FONT_S(12);
		_dateLab.textAlignment = NSTextAlignmentLeft;
	}
	return _dateLab;
}

- (UIButton *)loadBalanceBtn {
	if (!_loadBalanceBtn) {
		_loadBalanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_loadBalanceBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
		_loadBalanceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_loadBalanceBtn addTarget:self action:@selector(loadBalanceAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _loadBalanceBtn;
}
@end



// ****************** 右边 预付费无积分 有有效期 ******************
#pragma mark -  右边 预付费无积分 有有效期
@interface DCPrepaidRightInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *topUpLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end


@implementation DCPrepaidRightInfoView

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
	[self.paddingContentView addSubview:self.topUpLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.mas_equalTo(12);
		make.trailing.bottom.mas_equalTo(-12);
	}];

	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(30);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(4);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(4);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.dateLab.mas_bottom).offset(4);
	}];
	
	[self.topUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.centerY.mas_equalTo(self.toViewBtn.mas_centerY);
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

- (void)loadBalanceAction:(id)sender {
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
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = @"Your Load Balance"; //[[HJLanguageManager shareInstance] getTextByKey:@"lb_bill_to_be_paid"];
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = FONT_S(22);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = FONT_S(12);
		_dateLab.textAlignment = NSTextAlignmentLeft;
	}
	return _dateLab;
}

- (UILabel *)topUpLab {
	if (!_topUpLab) {
		_topUpLab = [[UILabel alloc] init];
		_topUpLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_topUpLab.font = FONT_S(12);
		_topUpLab.textAlignment = NSTextAlignmentLeft;
	}
	return _topUpLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(loadBalanceAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

@end



// ****************** 右边 后付费上面 ******************
#pragma mark - 右边 后付费上面
@interface DCPostpaidRightTopInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end


@implementation DCPostpaidRightTopInfoView

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
	[self.paddingContentView addSubview:self.moneyLab];
	[self.paddingContentView addSubview:self.dateLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(0);
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-5);
	}];
	
	[self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-5);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(30);
		make.top.mas_equalTo(self.titleLab.mas_bottom);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-2);
	}];

	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.moneyLab.mas_bottom);
	}];
}


- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;

	// 金额
	NSString *money = [dic objectForKey:@"money"];
    if (DC_IsStrEmpty(money) || [money isEqualToString:@"0"]) {
        _subTitleLab.hidden = NO;
        _moneyLab.hidden = YES;
        _dateLab.hidden = YES;
    } else {
        // 日期
        NSString *effDate = [dic objectForKey:@"effDate"];
        
        _subTitleLab.hidden = YES;
        _moneyLab.hidden = NO;
        _dateLab.hidden = NO;
		
		_moneyLab.text = [NSString stringWithFormat:@"%@%@", [DXPPBConfigManager shareInstance].currencySymbol,money];
        _dateLab.text = [NSString stringWithFormat:@"%@ %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_due_by"] ,!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
    }
	
	// 按钮
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
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
	}
	return _titleLab;
}

- (UILabel *)subTitleLab {
	if (!_subTitleLab) {
		_subTitleLab = [[UILabel alloc] init];
		_subTitleLab.numberOfLines = 0;
		_subTitleLab.lineBreakMode = NSLineBreakByWordWrapping;
		_subTitleLab.textColor = DC_UIColorFromRGB(0x242424);
		_subTitleLab.font = FONT_S(14);
		_subTitleLab.textAlignment = NSTextAlignmentLeft;
		_subTitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_no_outstanding_bills"];
        _subTitleLab.hidden = YES;
	}
	return _subTitleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = FONT_S(22);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
        _moneyLab.hidden = YES;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = FONT_S(12);
		_dateLab.textAlignment = NSTextAlignmentLeft;
        _dateLab.hidden = YES;
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


// ****************** 右边 后付费无积分 ******************
#pragma mark - 右边 后付费无积分
@interface DCPostpaidRightInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *viewBillLab;
@property (nonatomic, strong) UIButton *toViewBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end


@implementation DCPostpaidRightInfoView

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
	[self.paddingContentView addSubview:self.viewBillLab];
	[self.paddingContentView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(30);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(4);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(4);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.dateLab.mas_bottom).offset(4);
	}];
	
	[self.viewBillLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.centerY.mas_equalTo(self.toViewBtn.mas_centerY).offset(0);
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
	self.dateLab.text = [NSString stringWithFormat:@"%@ %@" , [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_due_by"] ,!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	// 按钮
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:billIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
	// 当showPoints为N时，渲染balOrBillLinkColor，为Y渲染pointsColor
	if ([propsDic.showPoints isEqualToString:@"Y"]) {
		self.viewBillLab.textColor = [UIColor hjp_colorWithHex:propsDic.pointsColor];
	} else {
		self.viewBillLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
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
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = FONT_S(22);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = FONT_S(12);
		_dateLab.textAlignment = NSTextAlignmentLeft;
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

- (UILabel *)viewBillLab {
	if (!_viewBillLab) {
		_viewBillLab = [[UILabel alloc] init];
		_viewBillLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_viewBillLab.font = FONT_S(12);
		_viewBillLab.textAlignment = NSTextAlignmentLeft;
		_viewBillLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_view_my_bills"];
	}
	return _viewBillLab;
}
@end


// ****************** 右边 后付费无积分 (Outstanding Bill) ******************
#pragma mark - 右边 后付费无积分 (Outstanding Bill)
@interface DCPostpaidOutstandingBillRightTopInfoView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIButton *toViewBtn;
@property (nonatomic, strong) UILabel *viewBillLab;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCPostpaidOutstandingBillRightTopInfoView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.titleLab];
	[self addSubview:self.subTitleLab];
	[self addSubview:self.toViewBtn];
	[self addSubview:self.viewBillLab];
}

- (void)layoutUI {
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.top.mas_equalTo(21);
		make.height.mas_equalTo(18);
		make.trailing.mas_equalTo(-12);
	}];
	
	[self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.trailing.mas_equalTo(-12);
		make.height.mas_equalTo(22);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(8);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(-12);
		make.top.mas_equalTo(self.subTitleLab.mas_bottom).offset(21);
	}];
	
	[self.viewBillLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.height.mas_equalTo(18);
		make.centerY.mas_equalTo(self.toViewBtn.mas_centerY).offset(0);
		make.trailing.mas_equalTo(self.toViewBtn.mas_leading).offset(-20);
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
	
	// 按钮
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
	[self.toViewBtn sd_setImageWithURL:[NSURL URLWithString:billIconSrc] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
}

#pragma mark - lazy load
- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
	}
	return _titleLab;
}

- (UILabel *)subTitleLab {
	if (!_subTitleLab) {
		_subTitleLab = [[UILabel alloc] init];
		_subTitleLab.textColor = DC_UIColorFromRGB(0x242424);
		_subTitleLab.font = FONT_S(14);
		_subTitleLab.textAlignment = NSTextAlignmentLeft;
		_subTitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_no_outstanding_bills"];
	}
	return _subTitleLab;
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

- (UILabel *)viewBillLab {
	if (!_viewBillLab) {
		_viewBillLab = [[UILabel alloc] init];
		_viewBillLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_viewBillLab.font = FONT_S(12);
		_viewBillLab.textAlignment = NSTextAlignmentLeft;
		_viewBillLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_view_my_bills"]; //@"View My Bills";
	}
	return _viewBillLab;
}

@end


// ****************** 积分 ******************
#pragma mark - 积分
@interface DCRightPointInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *moneyImgView;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UIButton *toPointBtn;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end


@implementation DCRightPointInfoView

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
	[self.paddingContentView addSubview:self.moneyImgView];
	[self.paddingContentView addSubview:self.toPointBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	[self.toPointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(0);
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
	}];
	
	[self.moneyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(14);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(4);
		make.leading.mas_equalTo(0);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(24);
		make.centerY.mas_equalTo(self.moneyImgView.mas_centerY);
		make.leading.mas_equalTo(self.moneyImgView.mas_trailing).offset(4);
	}];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 跳转按钮
	NSDictionary *pointsIconDic = [propsDic.pointsIcon firstObject];
	NSString *pointsIconSrc = [pointsIconDic objectForKey:@"src"];
	[self.toPointBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:pointsIconSrc] forState:UIControlStateNormal];
	// 金币按钮
	NSDictionary *pointsAmountIconDic = [propsDic.pointsAmountIcon firstObject];
	NSString *pointsAmountIconSrc = [pointsAmountIconDic objectForKey:@"src"];
	[self.moneyImgView sd_setImageWithURL:[NSURL URLWithString:pointsAmountIconSrc] placeholderImage:DC_image(@"ic_money_icon")];
	// point值
	NSString *pointVal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usablePoint"]];
	self.moneyLab.text = DC_IsStrEmpty(pointVal)?@"":pointVal;
	self.moneyLab.textColor = [UIColor colorWithHexString:propsDic.pointsColor];
}

- (void)toPointAction:(id)senderc{
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
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = FONT_S(12);
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_your_points"]; //@"Your POST Points";
	}
	return _titleLab;
}

- (UIImageView *)moneyImgView {
	if (!_moneyImgView) {
		_moneyImgView = [[UIImageView alloc] init];
	}
	return _moneyImgView;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = FONT_S(16);
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UIButton *)toPointBtn {
	if (!_toPointBtn) {
		_toPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toPointBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toPointBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toPointBtn addTarget:self action:@selector(toPointAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toPointBtn;
}

@end


