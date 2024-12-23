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
#import "PBCMPopTipView.h"
#import "DCSubsListModel.h"
#import "DCMainBalanceSummaryModel.h"
#import <DXPFontManagerLib/FontManager.h>
#import <DXPManagerLib/HJPropertyManager.h>
#import "UIImageView+PBSDWebImage.h"
#import "UIButton+PBSDWebImage.h"
#import <DXPRTLHelperLib/RTLHelper.h>
#import <DXPFontManagerLib/FontManager.h>

// ****************** Model ******************
@implementation DCMutiBalanceDashboardCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
	self = [super initWithComponentModel:componentModel];
	// 获取props
	self.props = componentModel.props;
	
	return self;
}

- (void)coustructCellHeight {
	[super coustructCellHeight];
	
	switch (self.dbCellType) {
		case DCMutiBalanceLikeDITO:
			if ([self.props.enableVerification isEqualToString:@"Y"]) {
				// 新版top样式 判断是否实名过
				BOOL isRealName = [[self.customData valueForKey:@"isRealName"] boolValue];
				if (!isRealName) {
					// 未实名
					self.cellHeight = self.cellHeight + 255.f + 24.f;
				} else {
					// 已经实名
					self.cellHeight = self.cellHeight + 242.f + 24.f;
				}
			} else {
				self.cellHeight = self.cellHeight + 212+24;
			}
			break;
		default:
			break;
	}
}

- (NSString *)cellClsName {
	return NSStringFromClass([DCMutiBalanceDashboardCell class]);
}

// 类型
- (void)setDbCellType:(DCMutiBalanceDashboardCellHeightType)dbCellType {
	_dbCellType = dbCellType;
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
	[self.baseContainer addSubview:self.dbContainerDITOView];
	[self.dbContainerDITOView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
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

@property (nonatomic, strong) PBCMPopTipView *popTipView; // 展示的提示信息
@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@property (nonatomic, strong) UIView *bakView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *paddingContentView; // subview都add到这个view上
// 顶部（根据enableVerification 判断 如果 = N 显示旧样式，如果 = Y 显示新样式）
@property (nonatomic, strong) UIView *topSuperView; // 两种topview的容器
@property (nonatomic, strong) DCDBTopInfoView *topInfoView; // 头部view (旧样式)
@property (nonatomic, strong) DCNewDBTopInfoView *dcNewTopInfoView; // 头部view（新样式）
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
	[self addSubview:self.bakView];// bakview 包括下面透明箭头部分
	[self.bakView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.mas_equalTo(0);
	}];
    
    [self.bakView addSubview:self.arrowView];
	// 内容背景
	[self.bakView addSubview:self.contentView]; // contentView 不包含箭头部分
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
	[self.contentView addSubview:self.paddingContentView]; // paddingContentView 有内边距
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.equalTo(@10);
		make.bottom.trailing.equalTo(@-10);
	}];
	
	// topview的容器
	[self.paddingContentView addSubview:self.topSuperView];
	[self.topSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.top.mas_equalTo(0);
	}];

	// 下面左边
	[self.paddingContentView addSubview:self.bottomLeftView];
	[self.bottomLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.topSuperView.mas_bottom).offset(8);
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
//		make.top.mas_equalTo(self.progressView.mas_bottom).offset(-11);
		make.bottom.mas_equalTo(self.bottomLeftView.mas_bottom).offset(0);
		// make.leading.trailing.mas_equalTo(0);
		make.leading.mas_equalTo(0);
		make.trailing.mas_equalTo(0);
	}];
	
	// 右边
	[self.paddingContentView addSubview:self.bottomRightView];
	[self.bottomRightView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.topSuperView.mas_bottom).offset(8);
		 make.leading.mas_equalTo(self.bottomLeftView.mas_trailing).offset(16);
//		make.width.mas_equalTo(172);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
	}];
	
	[self.bottomRightView addSubview:self.prepaidRightTopInfoView];// 预付费
	[self.prepaidRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.bottomRightView.mas_top).offset(0);
		make.height.mas_equalTo(110);
	}];
	[self.bottomRightView addSubview:self.rightPointInfoView]; // 积分
	[self.rightPointInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
//		make.top.mas_equalTo(self.prepaidRightTopInfoView.mas_bottom).offset(10);
		make.bottom.mas_equalTo(self.bottomRightView.mas_bottom).offset(0);
		make.height.mas_equalTo(32);
	}];
	[self.bottomRightView addSubview:self.postpaidRightTopInfoView]; // 后付费有积分 右上view
	[self.postpaidRightTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.leading.mas_equalTo(0);
		make.top.mas_equalTo(self.bottomRightView.mas_top).offset(0);
		make.height.mas_equalTo(110);
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
	
	[self.topSuperView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj removeFromSuperview];
	}];
	// 判断顶部view是新版的还是旧版
	if ([propsDic.enableVerification isEqualToString:@"Y"]) {
		// 新版
		[self.dcNewTopInfoView bindWithModel:cellModel];
		// 顶部view
		[self.topSuperView addSubview:self.dcNewTopInfoView];
		[self.dcNewTopInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.trailing.top.mas_equalTo(0);
			make.bottom.mas_equalTo(self.topSuperView.mas_bottom).offset(0);//撑满
		}];
	} else {
		// 旧版
		[self.topInfoView bindWithModel:cellModel];
        NSString *bgColor = @"#FFFFFF";
        if (!DC_IsStrEmpty(propsDic.phoneNumberBgColor)) {
            bgColor = propsDic.phoneNumberBgColor;
            self.topInfoView.backgroundColor = [UIColor colorWithHexString:bgColor];
        }
		// 顶部view
		[self.topSuperView addSubview:self.topInfoView];
		[self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.trailing.top.mas_equalTo(0);
			make.bottom.mas_equalTo(self.topSuperView.mas_bottom).offset(0);//撑满
		}];
	}

	NSString *showPoints = propsDic.showPoints;
	// 判断
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	if ([paidFlag isEqualToString:@"1"]) {
		// 后付费
//		NSString *usablePoint = [dic objectForKey:@"usablePoint"];
//		if (!DC_IsStrEmpty(usablePoint) && [usablePoint floatValue] > 0) {
		if ([@"y" isEqualToString:[showPoints lowercaseString]]) {
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
		if ([@"y" isEqualToString:[showPoints lowercaseString]] ) {
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
		HJDitoProgressModel *progressModel1 = [[HJDitoProgressModel alloc]initWithGross:model1.formatGrossBalance grossUnit:model1.formatGrossBalanceUnitName balance:model1.formatRealBalance balanceUnit:model1.formatRealBalanceUnitName type:model1.temp expire:@"" des:@"" btnName:@"" realBalance:model1.realBalance grossBalance:model1.grossBalance];
		[self.progressView updateWithModel:progressModel1 props:propDic];
		
		// view detail
		NSDictionary *dic = [propsDic.viewDetailPic firstObject];
		NSString *src = [dic objectForKey:@"src"];
		[self.detailBtn dc_setImageWithURLString:src placeholderImage:DC_image(@"")];
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

// topview的容器view
- (UIView *)topSuperView {
	if (!_topSuperView) {
		_topSuperView = [[UIView alloc] init];
	}
	return _topSuperView;
}

// 旧版top
- (DCDBTopInfoView *)topInfoView {
	if (!_topInfoView) {
		_topInfoView = [[DCDBTopInfoView alloc] init];
		_topInfoView.layer.cornerRadius = 8.f;
		_topInfoView.backgroundColor = DC_UIColorFromRGB(0x002641);
	}
	return _topInfoView;
}

// 新版top
- (DCNewDBTopInfoView *)dcNewTopInfoView {
	if (!_dcNewTopInfoView) {
		_dcNewTopInfoView = [[DCNewDBTopInfoView alloc] init];
	}
	return _dcNewTopInfoView;
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
//			NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:fwaTip attributes:@{NSFontAttributeName:[FontManager setNormalFontSize:14],NSForegroundColorAttributeName:[UIColor hjp_colorWithHex:@"#242424"]}];
//			[attrString addAttributes:@{ NSParagraphStyleAttributeName:ps} range:NSMakeRange(0, fwaTip.length)];
			[weakSelf showTipViewWithMsg:desc toView:tapView];
		};
	}
	return _progressView;
}

#pragma mark - CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(PBCMPopTipView *)popTipView {
	[self.visiblePopTipViews removeObject:popTipView];
}

- (void)showTipViewWithMsg:(NSString *)msg toView:(UIView *)toView {
	
	PBCMPopTipView *popTipView = [[PBCMPopTipView alloc] initWithMessage:msg];
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
	popTipView.textFont = [FontManager setNormalFontSize:14];
	popTipView.textColor = DC_UIColorFromRGB(0x242424);
	popTipView.preferredPointDirection = PointDirectionUp;
	[popTipView presentPointingAtView:toView inView:[UIApplication sharedApplication].keyWindow animated:YES];
	
	[self.visiblePopTipViews addObject:popTipView];
}

//- (UIButton *)detailBtn {
//	if (!_detailBtn) {
//		_detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		_detailBtn.titleLabel.font = [FontManager setNormalFontSize:14];
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
		_prepaidRightTopInfoView.layer.cornerRadius = 12.f;
		_prepaidRightTopInfoView.layer.borderWidth = 1.f;
		_prepaidRightTopInfoView.layer.borderColor = DC_UIColorFromRGB(0xE6E6E6).CGColor;
	}
	return _prepaidRightTopInfoView;
}

- (DCRightPointInfoView *)rightPointInfoView {
	if (!_rightPointInfoView) {
		_rightPointInfoView = [[DCRightPointInfoView alloc] init];
		_rightPointInfoView.layer.cornerRadius = 8.f;
		_rightPointInfoView.layer.borderWidth = 1.f;
		_rightPointInfoView.layer.borderColor = DC_UIColorFromRGB(0xE6E6E6).CGColor;
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
		_postpaidRightTopInfoView.layer.cornerRadius = 8.f;
		_postpaidRightTopInfoView.layer.borderColor = DC_UIColorFromRGB(0xE6E6E6).CGColor;
	}
	return _postpaidRightTopInfoView;
}

- (DCPostpaidOutstandingBillRightTopInfoView *)postpaidOutstandingBillRightTopInfoView {
	if (!_postpaidOutstandingBillRightTopInfoView) {
		_postpaidOutstandingBillRightTopInfoView = [[DCPostpaidOutstandingBillRightTopInfoView alloc] init];
		_postpaidOutstandingBillRightTopInfoView.layer.cornerRadius = 8.f;
		_postpaidOutstandingBillRightTopInfoView.layer.borderWidth = 1.f;
		_postpaidOutstandingBillRightTopInfoView.layer.borderColor = DC_UIColorFromRGB(0xE6E6E6).CGColor;
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
@interface DCDBTopInfoView (){
	BOOL _canSwitchSubs;
}

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
	
	NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
	NSDictionary *globalDic = json[@"global"];
	_canSwitchSubs = [globalDic[@"canSwitchSubs"] boolValue];
	
	[self addSubview:self.phoneImgView];
	[self addSubview:self.phoneNumberLab];
	[self addSubview:self.exchangeBtn];
}

- (void)layoutUI {
	[self.phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(24);
		// make.centerY.mas_equalTo(self.mas_centerY);
		make.top.mas_equalTo(self.mas_top).offset(4);
		make.leading.mas_equalTo(self.mas_leading).offset(12);
		make.bottom.mas_equalTo(self.mas_bottom).offset(-4);
	}];

	[self.phoneNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.mas_centerY);
		make.leading.mas_equalTo(self.phoneImgView.mas_trailing).offset(12);
		// make.height.mas_equalTo(14);
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
	[self.phoneImgView dc_setImageWithURLString:picItem.src placeholderImage:DC_image(@"ic_phonenumber_icon")];
	// 切换号码图标
	PicturesItem *picItem1 = [propsDic.circleChangeIcon firstObject];
	[self.exchangeBtn dc_setImageWithURL:picItem1.src forState:UIControlStateNormal placeholderImage:DC_image(@"ic_change_phonenumber")];
	// 手机号码以及预后付费 名称 #11186528
	NSString *isPaidFlag = [dic valueForKey:@"paidFlag"];
	NSString *serviceType = [dic valueForKey:@"serviceTypeCode"];
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	NSString *strPhone = @"";
	if ([paidFlag isEqualToString:@"1"]) {
		// 后付费
		if (self.isStickView) {
//			strPhone = [NSString stringWithFormat:@"%@", [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			if (self.isShowhalf) {
				// 只展示号码
				strPhone = [NSString stringWithFormat:@"%@",[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			} else {
				strPhone = [NSString stringWithFormat:@"%@ %@ | %@", DC_IsStrEmpty(serviceType)?@"":[[HJLanguageManager shareInstance] getTextByKey:[NSString stringWithFormat:@"lb_subs_service_type_%@", serviceType]] ,[[HJLanguageManager shareInstance] getTextByKey:@"lb_postpaid"], [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			}
		} else {
//			strPhone = [NSString stringWithFormat:@"%@ |  %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_mobile_postpaid"] ,[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			strPhone = [NSString stringWithFormat:@"%@ %@ | %@", DC_IsStrEmpty(serviceType)?@"":[[HJLanguageManager shareInstance] getTextByKey:[NSString stringWithFormat:@"lb_subs_service_type_%@", serviceType]] ,[[HJLanguageManager shareInstance] getTextByKey:@"lb_postpaid"],[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
		}
		
	} else if ([paidFlag isEqualToString:@"0"]) {
		// 预付费
		if (self.isStickView) {
//			strPhone = [NSString stringWithFormat:@"%@", [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			if (self.isShowhalf) {
				strPhone = [NSString stringWithFormat:@"%@",[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			} else {
				strPhone = [NSString stringWithFormat:@"%@ %@ | %@", DC_IsStrEmpty(serviceType)?@"":[[HJLanguageManager shareInstance] getTextByKey:[NSString stringWithFormat:@"lb_subs_service_type_%@", serviceType]] ,[[HJLanguageManager shareInstance] getTextByKey:@"lb_prepaid"], [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			}
		} else {
//			strPhone = [NSString stringWithFormat:@"%@ | %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_mobile_prepaid"],[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
			strPhone = [NSString stringWithFormat:@"%@ %@ | %@", DC_IsStrEmpty(serviceType)?@"":[[HJLanguageManager shareInstance] getTextByKey:[NSString stringWithFormat:@"lb_subs_service_type_%@", serviceType]] ,[[HJLanguageManager shareInstance] getTextByKey:@"lb_prepaid"],[PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
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
		_phoneNumberLab.font = [FontManager setNormalFontSize:12];
	}
	return _phoneNumberLab;
}

- (UIButton *)exchangeBtn {
	if (!_exchangeBtn) {
		_exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_exchangeBtn setImage:[UIImage imageNamed:@"ic_change_phonenumber"] forState:UIControlStateNormal];
		[_exchangeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
		_exchangeBtn.hidden = !_canSwitchSubs;
	}
	return _exchangeBtn;
}

@end


// ****************** DCNewDBTopInfoView ******************
#pragma mark -- 顶部新版本Top样式
@interface DCNewDBTopInfoView () {
	BOOL _canSwitchSubs;
}

@property (nonatomic, strong) UILabel *infoLab;
@property (nonatomic, strong) UILabel *phoneNumberLab;
@property (nonatomic, strong) UIButton *exchangeBtn;
@property (nonatomic, strong) UIImageView *iconImgView;
//@property (nonatomic, strong) UIImageView *registerImgView;
//@property (nonatomic, strong) UIImageView *unRegisterImgView;

@property (nonatomic, strong) DCMutiBalanceDashboardCellModel *cellModel;
@end

@implementation DCNewDBTopInfoView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	
	NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
	NSDictionary *globalDic = json[@"global"];
	_canSwitchSubs = [globalDic[@"canSwitchSubs"] boolValue];
	
	[self addSubview:self.infoLab];
	[self addSubview:self.phoneNumberLab];
	[self addSubview:self.exchangeBtn];
	[self addSubview:self.iconImgView];
//	[self addSubview:self.registerImgView];
//	[self addSubview:self.unRegisterImgView];
	
	
}

- (void)layoutUI {
	[self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(40);
		make.height.mas_equalTo(40);
		make.centerY.mas_equalTo(self.mas_centerY);
		make.trailing.mas_equalTo(-12);
	}];
	
	[self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mas_leading).offset(12);
		make.top.mas_equalTo(self.mas_top).offset(6);
		make.trailing.mas_equalTo(self.iconImgView.mas_trailing).offset(-10);
	}];
	
	[self.phoneNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.infoLab.mas_leading).offset(0);
		make.top.mas_equalTo(self.infoLab.mas_bottom).offset(4);
		make.bottom.mas_equalTo(self.mas_bottom).offset(-6);
	}];
	
	[self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.width.mas_equalTo(20);
		make.centerY.mas_equalTo(self.phoneNumberLab.mas_centerY);
		make.leading.mas_equalTo(self.phoneNumberLab.mas_trailing).offset(4);
	}];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	
	_cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;

	// 切换号码图标
	PicturesItem *picItem1 = [propsDic.circleChangeIcon firstObject];
	[self.exchangeBtn dc_setImageWithURL:picItem1.src forState:UIControlStateNormal placeholderImage:DC_image(@"ic_change_phonenumber")];
	
	// 手机号码以及预后付费 名称 #11186528
	NSString *isPaidFlag = [dic valueForKey:@"paidFlag"];
	NSString *serviceType = [dic valueForKey:@"serviceTypeCode"];
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	NSString *strPhone = [NSString stringWithFormat:@"%@", [PbTools numberFormatWithString:DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"] rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule]];
	self.phoneNumberLab.text = strPhone;
	
	// 属性设置
	BOOL isRealName = [[cellModel.customData valueForKey:@"isRealName"] boolValue];
	if (!isRealName) {
		// 未实名背景色
		NSString *bgColor = @"#FFFFFF";
		if (!DC_IsStrEmpty(propsDic.unVerifiedNumBgColor)) {
			bgColor = propsDic.unVerifiedNumBgColor;
			self.backgroundColor = [UIColor colorWithHexString:bgColor];
		}
		// 未实名文字颜色
		NSString *fontColor = @"#DF3847";
		if (!DC_IsStrEmpty(propsDic.unVerifiedNumColor)) {
			fontColor = propsDic.unVerifiedNumColor;
			self.infoLab.textColor = [UIColor colorWithHexString:fontColor];
			self.phoneNumberLab.textColor = [UIColor colorWithHexString:fontColor];
		}
		// 未实名文案
		NSString *infoStr =  [NSString stringWithFormat:@"Hi,%@", [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName];
//		infoStr = @"Hi, Hamfazlin Sanm Binti Mohameda Re-registration Required";
		if (!DC_IsStrEmpty(propsDic.unVerifiedText)) {
			infoStr = propsDic.unVerifiedText;
			infoStr = [infoStr stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"];
			infoStr = [NSString stringWithFormat:infoStr, [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName];
		}
		self.infoLab.text = infoStr;
		// 未实名图标
		UnVerifiedIcon *icon = propsDic.unVerifiedIcon.firstObject;
        [[RTLHelper sharedInstance].needReverseImgs addObject:icon.src];
		[self.iconImgView dc_setImageWithURLString:icon.src placeholderImage:DC_image(@"ic_enterDetail")];
	
	} else {
		// 已实名 文本
		NSString *infoStr = [NSString stringWithFormat:@"Hi,%@", [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName];
		self.infoLab.text = infoStr;
		NSString *fontColor = @"#242424";
		if (!DC_IsStrEmpty(propsDic.phoneNumberColor)) {
			fontColor = propsDic.phoneNumberColor;
			self.infoLab.textColor = [UIColor colorWithHexString:fontColor];
			self.phoneNumberLab.textColor =  [UIColor colorWithHexString:fontColor];
		}
		// 已实名的背景
		NSString *bgColor = @"#FFFFFF";
		if (!DC_IsStrEmpty(propsDic.phoneNumberBgColor)) {
			bgColor = propsDic.phoneNumberBgColor;
			self.backgroundColor = [UIColor colorWithHexString:bgColor];
		}
		// 已实名图标
		VerificationIcon *icon = propsDic.verificationIcon.firstObject;
		[self.iconImgView dc_setImageWithURLString:icon.src placeholderImage:DC_image(@"ic_verified")];
	}
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

// 点击事件
- (void)tapAdAction {
	// 如果未实名，则可点击
	BOOL isRealName = [[_cellModel.customData valueForKey:@"isRealName"] boolValue];
	if (!isRealName) {
		// 未实名
		DCFloorEventModel *model = [DCFloorEventModel new];
		model.link = @"/eta_app/registration_dialog"; // 链接
		model.floorEventType = DCFloorEventFloor;
		[self hj_routerEventWith:model];
	}
}

#pragma mark -- lazy load
- (UIImageView *)iconImgView {
	if (!_iconImgView) {
		_iconImgView = [[UIImageView alloc] init];
		// 添加点击事件
		_iconImgView.userInteractionEnabled = YES;
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdAction)];
		[_iconImgView addGestureRecognizer:tap];
	}
	return _iconImgView;
}

- (UILabel *)infoLab {
	if (!_infoLab) {
		_infoLab = [[UILabel alloc] init];
		_infoLab.font = [FontManager setNormalFontSize:14];
		_infoLab.numberOfLines = 0;
		_infoLab.lineBreakMode = NSLineBreakByWordWrapping;
		_infoLab.textAlignment = NSTextAlignmentLeft;
	}
	return _infoLab;
}

- (UILabel *)phoneNumberLab {
	if (!_phoneNumberLab) {
		_phoneNumberLab = [[UILabel alloc] init];
		_phoneNumberLab.font = [FontManager setBoldFontSize:14];
		_phoneNumberLab.textAlignment = NSTextAlignmentLeft;
	}
	return _phoneNumberLab;
}

- (UIButton *)exchangeBtn {
	if (!_exchangeBtn) {
		_exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_exchangeBtn setImage:[UIImage imageNamed:@"ic_change_phonenumber"] forState:UIControlStateNormal];
		[_exchangeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
		_exchangeBtn.hidden = !_canSwitchSubs;
	}
	return _exchangeBtn;
}

@end





// ****************** 右边 预付费上面 有积分 (有效期动态) ok ******************
#pragma mark - 右边 预付费上面
@interface DCPrepaidRightTopInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIView *rechargeView;
@property (nonatomic, strong) UILabel *rechargeLab;
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
	[self.paddingContentView addSubview:self.rechargeView];
	[self.rechargeView addSubview:self.rechargeLab];
	[self.rechargeView addSubview:self.loadBalanceBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.trailing.mas_equalTo(-12);
		make.top.mas_equalTo(self.mas_top).offset(4);
		make.height.mas_equalTo(110-4*2);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.mas_equalTo(0);
		make.height.mas_equalTo(16);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(28);
		make.top.mas_equalTo(self.titleLab.mas_bottom);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-5);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(16);
		make.top.mas_equalTo(self.moneyLab.mas_bottom);
	}];
	
	[self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.dateLab.mas_bottom).offset(0);
		make.height.mas_equalTo(40);
	}];
	
	[self.rechargeLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(0);
		make.leading.mas_equalTo(self.rechargeView.mas_leading).offset(0);
	}];
	
	[self.loadBalanceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(0);
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
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
	// 如果为空，则隐藏
	if (DC_IsStrEmpty(effDate)) {
		[self.paddingContentView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.mas_top).offset(12);
			make.height.mas_equalTo(110-12*2);
		}];
		
		[self.dateLab mas_updateConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(0);
		}];
	} else {
		self.dateLab.text = [NSString stringWithFormat:@"%@ %@" , [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_valid_until"] ,[PbTools getDateFormatAppByProperty:effDate]];
		
		[self.paddingContentView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.mas_top).offset(4);
			make.height.mas_equalTo(110-4*2);
		}];
		
		[self.dateLab mas_updateConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(16);
		}];
	}
	
	// 文字颜色
	self.rechargeLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
	
	// 按钮
	NSDictionary *balIconDic = [propsDic.balIcon firstObject];
	NSString *balIconSrc = [balIconDic objectForKey:@"src"];
	[self.loadBalanceBtn dc_setImageWithURL:balIconSrc forState:UIControlStateNormal placeholderImage:DC_image(@"ic_add")];
}

- (void)loadBalanceAction {
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
		_paddingContentView.userInteractionEnabled = YES;
	}
	return _paddingContentView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = [FontManager setNormalFontSize:12];
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_your_load_balance"];
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = [FontManager setBoldFontSize:18];
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = [FontManager setNormalFontSize:12];
		_dateLab.textAlignment = NSTextAlignmentLeft;
	}
	return _dateLab;
}

- (UIView *)rechargeView {
	if (!_rechargeView) {
		_rechargeView = [[UIView alloc] init];
		_rechargeView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadBalanceAction)];
		[_rechargeView addGestureRecognizer:tap];
	}
	return _rechargeView;
}

- (UILabel *)rechargeLab {
	if (!_rechargeLab) {
		_rechargeLab = [[UILabel alloc] init];
		_rechargeLab.textColor = DC_UIColorFromRGB(0x1AABBA);
		_rechargeLab.font = [FontManager setBoldFontSize:12];
		_rechargeLab.textAlignment = NSTextAlignmentLeft;
		_rechargeLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_top_up"];
	}
	return _rechargeLab;
}

- (UIButton *)loadBalanceBtn {
	if (!_loadBalanceBtn) {
		_loadBalanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_loadBalanceBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
		_loadBalanceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_loadBalanceBtn addTarget:self action:@selector(loadBalanceAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _loadBalanceBtn;
}
@end



// ****************** 右边 预付费无积分 (有效期动态) ******************
#pragma mark -  右边 预付费无积分 有有效期
@interface DCPrepaidRightInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIView *rechargeView;
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
	[self.paddingContentView addSubview:self.rechargeView];
	[self.rechargeView addSubview:self.topUpLab];
	[self.rechargeView addSubview:self.toViewBtn];
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
		make.height.mas_equalTo(28);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(0);
	}];
	
	[self.rechargeView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(40);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
		make.leading.trailing.mas_equalTo(0);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
	}];
	
	[self.topUpLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.centerY.mas_equalTo(self.rechargeView.mas_centerY);
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
	// 充值文字艳娥
	self.topUpLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
	
	// 按钮
	NSDictionary *balIconDic = [propsDic.balIcon firstObject];
	NSString *balIconSrc = [balIconDic objectForKey:@"src"];
	[self.toViewBtn dc_setImageWithURL:balIconSrc forState:UIControlStateNormal placeholderImage:DC_image(@"ic_add")];
}

- (void)loadBalanceAction {
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
		_titleLab.font =[FontManager setNormalFontSize:12];
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_your_load_balance"];
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = [FontManager setNormalFontSize:18];
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = [FontManager setNormalFontSize:12];
		_dateLab.textAlignment = NSTextAlignmentLeft;
	}
	return _dateLab;
}

- (UIView *)rechargeView {
	if (!_rechargeView) {
		_rechargeView = [[UIView alloc] init];
		_rechargeView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loadBalanceAction)];
		[_rechargeView addGestureRecognizer:tap];
	}
	return _rechargeView;
}

- (UILabel *)topUpLab {
	if (!_topUpLab) {
		_topUpLab = [[UILabel alloc] init];
		_topUpLab.textColor = DC_UIColorFromRGB(0x1AABBA);
		_topUpLab.font = [FontManager setNormalFontSize:12];
		_topUpLab.textAlignment = NSTextAlignmentLeft;
		_topUpLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_top_up"];
	}
	return _topUpLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(loadBalanceAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

@end



// ****************** 右边 后付费上面 有积分 (日期动态) OK ******************
#pragma mark - 右边 后付费上面
@interface DCPostpaidRightTopInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UIView *payMyBillsView;
@property (nonatomic, strong) UILabel *payLab;
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
	[self.paddingContentView addSubview:self.payMyBillsView];
	[self.payMyBillsView addSubview:self.payLab];
	[self.payMyBillsView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.trailing.mas_equalTo(-12);
		make.top.mas_equalTo(self.mas_top).offset(4);
		make.height.mas_equalTo(110-4*2);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.mas_equalTo(0);
		make.height.mas_equalTo(16);
	}];
	
	[self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom);
		make.height.mas_equalTo(16);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(28);
		make.top.mas_equalTo(self.titleLab.mas_bottom);
	}];

	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(16);
		make.top.mas_equalTo(self.moneyLab.mas_bottom);
	}];
	
	[self.payMyBillsView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(40);
		make.leading.mas_equalTo(0);
		make.trailing.mas_equalTo(0);
		make.top.mas_equalTo(self.dateLab.mas_bottom);
	}];
	
	[self.payLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.centerY.mas_equalTo(self.payMyBillsView.mas_centerY);
		make.height.mas_equalTo(18);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(0);
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
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
		
		[self.moneyLab mas_updateConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(0);
		}];
		
		[self.dateLab mas_updateConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(0);
		}];
		
		[self.payMyBillsView mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(40);
			make.leading.mas_equalTo(0);
			make.trailing.mas_equalTo(0);
			make.top.mas_equalTo(self.subTitleLab.mas_bottom);
		}];
		
    } else {
		[self.moneyLab mas_updateConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(28);
		}];
		
		[self.dateLab mas_updateConstraints:^(MASConstraintMaker *make) {
			make.height.mas_equalTo(16);
		}];
		
		[self.payMyBillsView mas_updateConstraints:^(MASConstraintMaker *make) {
			make.top.mas_equalTo(self.dateLab.mas_bottom);
		}];
		
        // 日期
        NSString *effDate = [dic objectForKey:@"effDate"];
        _subTitleLab.hidden = YES;
        _moneyLab.hidden = NO;
        _dateLab.hidden = NO;
		
		_moneyLab.text = [NSString stringWithFormat:@"%@%@", [DXPPBConfigManager shareInstance].currencySymbol,money];
		
		if (DC_IsStrEmpty(effDate) || [effDate isEqualToString:@"(null)"]) {
			
			[self.paddingContentView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.top.mas_equalTo(self.mas_top).offset(12);
				make.height.mas_equalTo(110-12*2);
			}];
			
			[self.dateLab mas_updateConstraints:^(MASConstraintMaker *make) {
				make.height.mas_equalTo(0);
			}];
			
		} else {
			_dateLab.text = [NSString stringWithFormat:@"%@ %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_due_by"] ,[PbTools getDateFormatAppByProperty:effDate]];
		
			[self.paddingContentView mas_updateConstraints:^(MASConstraintMaker *make) {
				make.top.mas_equalTo(self.mas_top).offset(4);
				make.height.mas_equalTo(110-4*2);
			}];
			
			[self.dateLab mas_updateConstraints:^(MASConstraintMaker *make) {
				make.height.mas_equalTo(16);
			}];
		}
    }
	// 文字颜色
	self.payLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
	
	// 按钮
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
	[self.toViewBtn dc_setImageWithURL:billIconSrc forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
}

- (void)toViewAction {
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
		_titleLab.font = [FontManager setNormalFontSize:12];
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
		_subTitleLab.font = [FontManager setNormalFontSize:14];
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
		_moneyLab.font = [FontManager setNormalFontSize:22];
		_moneyLab.textAlignment = NSTextAlignmentLeft;
        _moneyLab.hidden = YES;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = [FontManager setNormalFontSize:12];
		_dateLab.textAlignment = NSTextAlignmentLeft;
        _dateLab.hidden = YES;
	}
	return _dateLab;
}

- (UIView *)payMyBillsView {
	if (!_payMyBillsView) {
		_payMyBillsView = [[UIView alloc] init];
		_payMyBillsView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toViewAction)];
		[_payMyBillsView addGestureRecognizer:tap];
	}
	return _payMyBillsView;
}

- (UILabel *)payLab {
	if (!_payLab) {
		_payLab = [[UILabel alloc] init];
		_payLab.textColor = DC_UIColorFromRGB(0x1AABBA);
		_payLab.font = [FontManager setNormalFontSize:12];
		_payLab.textAlignment = NSTextAlignmentLeft;
		_payLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_view_my_bills"];
	}
	return _payLab;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}
@end


// ****************** 右边 后付费无积分 OK ******************
#pragma mark - 右边 后付费无积分
@interface DCPostpaidRightInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *dateLab;

@property (nonatomic, strong) UIView *viewBillView;

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
	[self.paddingContentView addSubview:self.viewBillView];
	[self.viewBillView addSubview:self.viewBillLab];
	[self.viewBillView addSubview:self.toViewBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.bottom.trailing.mas_equalTo(-12);
	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.trailing.mas_equalTo(0);
		make.height.mas_equalTo(16);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(28);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
	}];
	
	[self.dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(16);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(0);
	}];
	
	[self.viewBillView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(40);
		make.bottom.mas_equalTo(self.paddingContentView.mas_bottom);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.centerY.mas_equalTo(self.viewBillView.mas_centerY);
	}];
	
	[self.viewBillLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.centerY.mas_equalTo(self.viewBillView.mas_centerY);
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
	if (DC_IsStrEmpty(effDate) || [effDate isEqualToString:@"(null)"]) {
		self.dateLab.hidden = YES;
	} else {
		self.dateLab.hidden = NO;
		self.dateLab.text = [NSString stringWithFormat:@"%@ %@" , [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_due_by"] , [PbTools getDateFormatAppByProperty:effDate]];
	}
	
	// 按钮
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
	[self.toViewBtn dc_setImageWithURL:billIconSrc forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
	// 当showPoints为N时，渲染balOrBillLinkColor，为Y渲染pointsColor
	if ([propsDic.showPoints isEqualToString:@"Y"]) {
		self.viewBillLab.textColor = [UIColor hjp_colorWithHex:propsDic.pointsColor];
	} else {
		self.viewBillLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
	}
}

- (void)toViewAction {
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
		_titleLab.font = [FontManager setNormalFontSize:12];
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_outstanding_bill"];
	}
	return _titleLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.font = [FontManager setNormalFontSize:18];;
		_moneyLab.textAlignment = NSTextAlignmentLeft;
	}
	return _moneyLab;
}

- (UILabel *)dateLab {
	if (!_dateLab) {
		_dateLab = [[UILabel alloc] init];
		_dateLab.textColor = DC_UIColorFromRGB(0x242424);
		_dateLab.font = [FontManager setNormalFontSize:12];
		_dateLab.textAlignment = NSTextAlignmentLeft;
	}
	return _dateLab;
}

- (UIView *)viewBillView {
	if (!_viewBillView) {
		_viewBillView = [[UIView alloc] init];
		_viewBillView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toViewAction)];
		[_viewBillView addGestureRecognizer:tap];
	}
	return _viewBillView;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"btn_pay_my_bill"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

- (UILabel *)viewBillLab {
	if (!_viewBillLab) {
		_viewBillLab = [[UILabel alloc] init];
		_viewBillLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_viewBillLab.font = [FontManager setNormalFontSize:12];
		_viewBillLab.textAlignment = NSTextAlignmentLeft;
		_viewBillLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_view_my_bills"];
	}
	return _viewBillLab;
}
@end


// ****************** 右边 后付费无积分 (Outstanding Bill) OK ******************
#pragma mark - 右边 后付费无积分 (Outstanding Bill)
@interface DCPostpaidOutstandingBillRightTopInfoView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UIView *viewBillView;
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
	[self addSubview:self.viewBillView];
	[self.viewBillView addSubview:self.toViewBtn];
	[self.viewBillView addSubview:self.viewBillLab];
}

- (void)layoutUI {
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.top.mas_equalTo(12);
		make.height.mas_equalTo(16);
		make.trailing.mas_equalTo(-12);
	}];
	
	[self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.trailing.mas_equalTo(-12);
//		make.height.mas_equalTo(22);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
	}];
	
	[self.viewBillView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(12);
		make.trailing.mas_equalTo(-12);
		make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
		make.height.mas_equalTo(40);
	}];
	
	[self.toViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.trailing.mas_equalTo(0);
		make.centerY.mas_equalTo(self.viewBillView.mas_centerY);
	}];
	
	[self.viewBillLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.centerY.mas_equalTo(self.toViewBtn.mas_centerY).offset(0);
	}];
}

- (void)toViewAction {
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
	
	// 文字颜色
	self.viewBillLab.textColor = [UIColor hjp_colorWithHex:propsDic.balOrBillLinkColor];
	// 按钮
	NSDictionary *billIconDic = [propsDic.billIcon firstObject];
	NSString *billIconSrc = [billIconDic objectForKey:@"src"];
    [[RTLHelper sharedInstance].needReverseImgs addObject:billIconSrc];
	[self.toViewBtn dc_setImageWithURL:billIconSrc forState:UIControlStateNormal placeholderImage:DC_image(@"ic_to_view")];
}

#pragma mark - lazy load
- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.font = [FontManager setNormalFontSize:12];
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
		_subTitleLab.font = [FontManager setBoldFontSize:18];
		_subTitleLab.textAlignment = NSTextAlignmentLeft;
		_subTitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_no_outstanding_bills"];
	}
	return _subTitleLab;
}

- (UIView *)viewBillView {
	if (!_viewBillView) {
		_viewBillView = [[UIView alloc] init];
		_viewBillView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toViewAction)];
		[_viewBillView addGestureRecognizer:tap];
	}
	return _viewBillView;
}

- (UIButton *)toViewBtn {
	if (!_toViewBtn) {
		_toViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_toViewBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
		_toViewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		[_toViewBtn addTarget:self action:@selector(toViewAction) forControlEvents:UIControlEventTouchUpInside];
	}
	return _toViewBtn;
}

- (UILabel *)viewBillLab {
	if (!_viewBillLab) {
		_viewBillLab = [[UILabel alloc] init];
		_viewBillLab.textColor = DC_UIColorFromRGB(0x0077A6);
		_viewBillLab.font = [FontManager setNormalFontSize:12];
		_viewBillLab.textAlignment = NSTextAlignmentLeft;
		_viewBillLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_muti_balance_dashboard_view_my_bills"]; //@"View My Bills";
	}
	return _viewBillLab;
}

@end


// ****************** 积分 ok ******************
#pragma mark - 积分
@interface DCRightPointInfoView ()

@property (nonatomic, strong) UIView *paddingContentView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *moneyImgView;
@property (nonatomic, strong) UILabel *moneyLab;
//@property (nonatomic, strong) UIButton *toPointBtn;

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
//	[self.paddingContentView addSubview:self.toPointBtn];
}

- (void)layoutUI {
	[self.paddingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(4);
		make.bottom.mas_equalTo(-4);
		make.trailing.mas_equalTo(-12);
		make.leading.mas_equalTo(12);
	}];
	
//	[self.toPointBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerY.mas_equalTo(0);
//		make.width.height.mas_equalTo(40);
//		make.trailing.mas_equalTo(0);
//	}];
	
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.paddingContentView.mas_centerY);
		make.height.mas_equalTo(18);
		make.leading.mas_equalTo(0);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(24);
//		make.width.mas_equalTo(29);
		make.centerY.mas_equalTo(self.paddingContentView.mas_centerY);
		make.trailing.mas_equalTo(self.paddingContentView.mas_trailing).offset(0);
	}];
	
	[self.moneyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(14);
		make.centerY.mas_equalTo(self.paddingContentView.mas_centerY);
		make.trailing.mas_equalTo(self.moneyLab.mas_leading).offset(-4);
	}];
}

- (void)bindWithModel:(DCMutiBalanceDashboardCellModel *)cellModel {
	self.cellModel = cellModel;
	
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 跳转按钮
//	NSDictionary *pointsIconDic = [propsDic.pointsIcon firstObject];
//	NSString *pointsIconSrc = [pointsIconDic objectForKey:@"src"];
//	[self.toPointBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:pointsIconSrc] forState:UIControlStateNormal];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toPointAction)];
	[self addGestureRecognizer:tap];
	
	// 金币按钮
	NSDictionary *pointsAmountIconDic = [propsDic.pointsAmountIcon firstObject];
	NSString *pointsAmountIconSrc = [pointsAmountIconDic objectForKey:@"src"];
	[self.moneyImgView dc_setImageWithURLString:pointsAmountIconSrc placeholderImage:DC_image(@"ic_money_icon")];
	// point值
	NSString *pointVal = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usablePoint"]];
	self.moneyLab.text = (DC_IsStrEmpty(pointVal) || [pointVal isEqualToString:@"(null)"])?@"":pointVal;
	self.moneyLab.textColor = [UIColor colorWithHexString:propsDic.pointsColor];
}

- (void)toPointAction {
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
		_titleLab.font = [FontManager setNormalFontSize:12];
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
		_moneyLab.font = [FontManager setNormalFontSize:16];
		_moneyLab.textAlignment = NSTextAlignmentRight;
	}
	return _moneyLab;
}

//- (UIButton *)toPointBtn {
//	if (!_toPointBtn) {
//		_toPointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		[_toPointBtn setImage:[UIImage imageNamed:@"ic_to_view"] forState:UIControlStateNormal];
//		_toPointBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//		[_toPointBtn addTarget:self action:@selector(toPointAction:) forControlEvents:UIControlEventTouchUpInside];
//	}
//	return _toPointBtn;
//}

@end


