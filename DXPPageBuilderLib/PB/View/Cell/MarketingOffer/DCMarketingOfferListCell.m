//
//  DCMarketingOfferListCell.m
//  DXPPageBuilderLib
//
//  Created by 李标 on 2024/11/28.
//

#import "DCMarketingOfferListCell.h"
#import <DXPCategoryLib/UIColor+Category.h>
#import <DXPFontManagerLib/FontManager.h>
#import "UIImageView+PBSDWebImage.h"
#import "UIButton+PBSDWebImage.h"
#import "DCPromotionsModel.h"
#import <MJExtension/MJExtension.h>
//#import <ChangePlan/DCChangePlanOrderConfirmV2ViewController.h>
//#import <PurchasePackage/DCPackageOrderConfirmV2ViewController.h>
//#import <Repository/DCPlanAvailableListModel.h>
#import <DXPManagerLib/HJLanguageManager.h>
#import <DXPManagerLib/HJImageManager.h>

// ****************** Model ******************
@implementation DCMarketingOfferListCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
	self = [super initWithComponentModel:componentModel];
	return self;
}

- (void)coustructCellHeight {
	[super coustructCellHeight];
	
	if (self.props.isShowPoint) {
		self.cellHeight = 268 + 76;
	} else {
		self.cellHeight = 268 + 12;
	}
}

- (NSString *)cellClsName {
	return NSStringFromClass([DCMarketingOfferListCell class]);
}

+ (CGFloat)getTMDBTopMargin {
	return  DCP_NAV_HEIGHT + 10;
}

@end


// ****************** Cell ******************

@interface DCMarketingOfferListCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) DCMarketingOfferListCellModel *offerCellModel;

@property (nonatomic, strong) NSMutableArray <OfferItem *>*offerList;
@end


@implementation DCMarketingOfferListCell

- (void)configView {
	// [self setUpUI];
}

- (void)setUpUI {
	// 设置投影
	self.layer.masksToBounds = NO; // 允许阴影效果
	self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
	self.layer.shadowOpacity = 1; // 投影透明度，范围0.0~1.0
	self.layer.shadowRadius = 10.0; // 投影模糊半径
	self.layer.shadowOffset = CGSizeMake(0, 5); // 投影偏移量
	self.borderView.layer.cornerRadius = 16;
}

- (void)bindCellModel:(DCMarketingOfferListCellModel *)cellModel {
	[super bindCellModel:cellModel];
	self.offerCellModel = cellModel;
	CompositionProps *propsDic = cellModel.props;
	
	NSMutableDictionary *dic = cellModel.customData;
	if (dic.allKeys.count == 0) {
		return;
	}
	NSDictionary *promotionsDic = [dic valueForKey:@"PromotionsOfferList"];
	DCPromotionsModel *model= [DCPromotionsModel mj_objectWithKeyValues:promotionsDic];
	// DCDataItemModel *itemModel = [model.data objectAtIndex:0];
	// 汇集offer
	self.offerList = [[NSMutableArray alloc] init];
	[model.data enumerateObjectsUsingBlock:^(DCDataItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[obj.offerList enumerateObjectsUsingBlock:^(OfferItem *subObj, NSUInteger idx, BOOL * _Nonnull stop) {
			subObj.contactId = obj.contactId;
			[self.offerList addObject:subObj];
		}];
	}];
	
	// ============ 中间信息容器 container
	[self.baseContainer addSubview:self.backView];
	[self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.baseContainer);
	}];
	
	[self.backView addSubview:self.scrollView];
	[self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mas_leading).offset(16);
		make.width.mas_equalTo(DCP_SCREEN_WIDTH - 16);
		make.bottom.mas_equalTo(0);
		make.top.mas_equalTo(0);
	}];
	// 添加offer List视图
	double minimum = fmin([propsDic.maxNum intValue], [self.offerList count]);
	for (NSInteger i = 0; i < minimum; i++) {
		DCMarketingOfferView *view = [[DCMarketingOfferView alloc] init];
		[self.scrollView addSubview:view];
		view.tag = i;
		view.layer.cornerRadius = 16.f;
		view.backgroundColor = DC_UIColorFromRGB(0xD7E1FF);
		[view bindWithModel:cellModel];
//		OfferItem *item = [itemModel.offerList objectAtIndex:i];
		OfferItem *item = [self.offerList objectAtIndex:i];
		view.offerItemModel = item;
		// 点击事件
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(marketingOfferAction:)];
		[view addGestureRecognizer:tap];
		
		[view mas_makeConstraints:^(MASConstraintMaker *make) {
			if (i == 0) {
				make.left.equalTo(self.scrollView).offset(i*136);
			} else {
				make.left.equalTo(self.scrollView).offset(i*136 + i*10);
			}
			make.width.mas_equalTo(136);
			if (propsDic.isShowPoint) {
				make.height.mas_equalTo(288+20);
			} else {
				make.height.mas_equalTo(268+12);
			}
			make.top.mas_equalTo(0);
			if (i == [propsDic.maxNum intValue]-1) {
				make.right.equalTo(self.scrollView.mas_right);
			}
		}];
	}
}

// offer 点击跳转事件
- (void)marketingOfferAction:(UIGestureRecognizer *)tap {
	DCMarketingOfferView *offerView = (DCMarketingOfferView *)tap.view;
	
	OfferItem *item = [self.offerList objectAtIndex:offerView.tag];
	// 转换成dic
	NSDictionary *offerItemDic = [item mj_keyValues];
	// 判断事件类型
	NSString *link = @"";
	if ([item.offerType isEqualToString:@"2"]) {
		// 切换套餐活动流程
		link = @"/clp_promo_participation/change_plan_confirm";
		// OfferItem *model= [OfferItem mj_objectWithKeyValues:coustomData];
	} else if (DC_IsStrEmpty(item.offerType) || [item.offerType isEqualToString:@"4"]) {
		// 买包活动确认流程
		link = @"/clp_promo_participation/buy_pass_confirm";
	}
	// 抛出事件
	DCFloorEventModel *eventModel = [DCFloorEventModel new];
	eventModel.link = link;
	eventModel.linkType = @"1";
	eventModel.floorEventType = DCFloorEventFloor;
	eventModel.coustomData = offerItemDic;
	[self hj_routerEventWith:eventModel];
}

#pragma mark -- lazy load
- (UIView *)backView {
	if (!_backView) {
		_backView = [[UIView alloc] init];
	}
	return _backView;
}

- (UIScrollView *)scrollView {
	if (!_scrollView) {
		_scrollView = [[UIScrollView alloc] init];
		_scrollView.showsHorizontalScrollIndicator = YES;
		_scrollView.showsVerticalScrollIndicator = NO;
		_scrollView.alwaysBounceVertical = NO;
		_scrollView.directionalLockEnabled = YES;
		_scrollView.scrollEnabled = YES;
	}
	return _scrollView;
}
@end



// ****************** DCMarketingOfferView ******************
@interface DCMarketingOfferView ()

// 数据
@property (nonatomic, strong) DCMarketingOfferListCellModel *cellModel;
// UI
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *offerNameLab;
@property (nonatomic, strong) UILabel *remainLab; // 库存
@property (nonatomic, strong) UILabel *endsLab; // 日期
@property (nonatomic, strong) UILabel *vaildValLab;
@property (nonatomic, strong) UILabel *moneyLab;
@property (nonatomic, strong) UILabel *salesPriceLab; // 划线价格
// 积分
@property (nonatomic, strong) UILabel *pointLab;
@end

@implementation DCMarketingOfferView

- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		[self configUI];
	}
	return self;
}

- (void)configUI {
	[self addSubview:self.mainView];
	[self.mainView addSubview:self.headImageView];
	[self.mainView addSubview:self.offerNameLab];
	[self.mainView addSubview:self.remainLab];
	[self.mainView addSubview:self.endsLab];
	[self.mainView addSubview:self.vaildValLab];
	[self.mainView addSubview:self.moneyLab];
	[self.mainView addSubview:self.salesPriceLab];
	[self addSubview:self.pointLab];
	// UI布局
	[self configLayout];
}

- (void)configLayout {
	[self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.leading.trailing.mas_equalTo(0);
	}];
	
	[self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(120);
		make.width.mas_equalTo(120);
		make.centerX.mas_equalTo(0);
		make.top.mas_equalTo(8);
	}];
	
	[self.offerNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mainView.mas_leading).offset(8+4);
		make.trailing.mas_equalTo(self.mainView.mas_trailing).offset(-8);
		make.top.mas_equalTo(self.headImageView.mas_bottom).offset(12);
	}];
	
	[self.remainLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mainView.mas_leading).offset(8+4);
		make.trailing.mas_equalTo(self.mainView.mas_trailing).offset(-8);
		make.top.mas_equalTo(self.offerNameLab.mas_bottom).offset(4);
	}];
	
	[self.endsLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mainView.mas_leading).offset(8+4);
		make.trailing.mas_equalTo(self.mainView.mas_trailing).offset(-8);
		make.top.mas_equalTo(self.remainLab.mas_bottom).offset(4);
	}];
	
	[self.vaildValLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mainView.mas_leading).offset(8+4);
		make.top.mas_equalTo(self.endsLab.mas_bottom).offset(4);
	}];
	
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mainView.mas_leading).offset(8+4);
		make.trailing.mas_equalTo(self.mainView.mas_trailing).offset(-8);
		make.top.mas_equalTo(self.vaildValLab.mas_bottom).offset(4);
	}];

	[self.salesPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mainView.mas_leading).offset(8+4);
		make.trailing.mas_equalTo(self.mainView.mas_trailing).offset(-8);
		make.top.mas_equalTo(self.moneyLab.mas_bottom).offset(0);
		make.bottom.mas_equalTo(self.mainView.mas_bottom).offset(-8);
	}];
	
	[self.pointLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.mainView.mas_bottom).offset(8);
		make.leading.mas_equalTo(self.mas_leading).offset(8+4);
	}];
}

- (void)setOfferItemModel:(OfferItem *)offerItemModel {
	_offerItemModel = offerItemModel;
	// 图片
	[self.headImageView dc_setImageWithURLString:_offerItemModel.imageUrl placeholderImage:[[HJImageManager shareInstance] getImageByName:@"ic_xl_offer_icon"]];
	// offerName
	self.offerNameLab.text = _offerItemModel.offerName;
	//remain
	NSString *string = [[[HJLanguageManager shareInstance] getTextByKey:@"lb_promo_participation_remain"] stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"];
	self.remainLab.text = [NSString stringWithFormat:string, DC_IsStrEmpty(_offerItemModel.remainQuantity)?@"0":_offerItemModel.remainQuantity];
	if (DC_IsStrEmpty(_offerItemModel.remainQuantity) || [_offerItemModel.remainQuantity intValue] == 0) { // 如果为0 则进行隐藏
		self.remainLab.hidden = YES;
	} else {
		self.remainLab.hidden = NO;
	}
	// ends
	
	NSString *stringEndOn = [[[HJLanguageManager shareInstance] getTextByKey:@"lb_promo_participation_ends_on"] stringByReplacingOccurrencesOfString:@"%s" withString:@"%@"];
	
	NSString *dateStr = _offerItemModel.expDate;
	dateStr = [dateStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
	dateStr = [dateStr stringByReplacingOccurrencesOfString:@"Z" withString:@" "];
	NSString *expDate = [PbTools getDateFormatAppByGCP:dateStr];
	self.endsLab.text = [NSString stringWithFormat:stringEndOn,expDate];
	// Valid for
	NSString *unit = @"";
	if ([[_offerItemModel.validityPeriodUnitType lowercaseString] isEqualToString:@"h"]) {
		// hours
		unit = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_hours"];
	} else if ([[_offerItemModel.validityPeriodUnitType lowercaseString] isEqualToString:@"d"]) {
		// days
		unit = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_days"];
	} else if ([[_offerItemModel.validityPeriodUnitType lowercaseString] isEqualToString:@"w"]) {
		// weeks
		unit = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_weeks"];
	} else if ([[_offerItemModel.validityPeriodUnitType lowercaseString] isEqualToString:@"m"]) {
		// months
		unit = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_months"];
	} else if ([[_offerItemModel.validityPeriodUnitType lowercaseString] isEqualToString:@"y"]) {
		// years
		unit = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_years"];
	} else if ([[_offerItemModel.validityPeriodUnitType lowercaseString] isEqualToString:@"b"]) {
		// billing periods
		unit = [[HJLanguageManager shareInstance] getTextByKey:@"lb_billing_periods"];
	}
	self.vaildValLab.text = [NSString stringWithFormat:@"  %@ %@ %@  ", [[HJLanguageManager shareInstance] getTextByKey:@"lb_promo_offer_valid_for"],_offerItemModel.validityPeriod, unit];
	if (DC_IsStrEmpty(_offerItemModel.validityPeriod) || [_offerItemModel.validityPeriod intValue] == 0) { // 为0 则不展示，隐藏
		self.vaildValLab.hidden = YES;
	} else {
		self.vaildValLab.hidden = NO;
	}
	
	// 价格有可能是月租费，也有可能是一次性费用：
	if (!DC_IsStrEmpty(_offerItemModel.rentPriceInt) && [_offerItemModel.rentPriceInt floatValue] > 0) { // 月租费
		// 单位
		NSString *rentUnitType = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_mth"];
		if ([[_offerItemModel.rentUnitType lowercaseString] isEqualToString:@"d"]) {
			// day
			rentUnitType = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_day"];
		} else if ([[_offerItemModel.rentUnitType lowercaseString] isEqualToString:@"w"]) {
			// week
			rentUnitType = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_week"];
		} else if ([[_offerItemModel.rentUnitType lowercaseString] isEqualToString:@"y"]) {
			// year
			rentUnitType = [[HJLanguageManager shareInstance] getTextByKey:@"lb_lowercase_year"];
		}
		// 单位数字
		NSString *rent = @"/";
		if (![_offerItemModel.rentDuration isEqualToString:@"1"]) {
			rent = [rent stringByAppendingFormat:@"%@%@",DC_IsStrEmpty(_offerItemModel.rentDuration)?@"":_offerItemModel.rentDuration,rentUnitType];
		} else {
			rent = [rent stringByAppendingFormat:@"%@",rentUnitType];
		}
		NSString *price;
		// 实际价格
		if (!DC_IsStrEmpty(_offerItemModel.discountPriceInt) && [_offerItemModel.discountPriceInt floatValue] > 0) {
			// 如果 discountPriceInt 不为空且大于 0，则需要展示划线价，划线价取 rentPrice，实际单位左边的价格取 discountPrice；
			price = [NSString stringWithFormat:@"%@",_offerItemModel.discountPrice];
			// 展示划线价格
			NSString *rentPrice = _offerItemModel.rentPrice;
			NSString *salesPrice = [NSString stringWithFormat:@"%@%@%@",[DXPPBConfigManager shareInstance].currencySymbol ,rentPrice,rent];
			NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:salesPrice];
			// 设置划线属性
			[attributedString addAttribute:NSStrikethroughStyleAttributeName
									 value:@(NSUnderlineStyleSingle)
									 range:NSMakeRange(0, salesPrice.length)];
			self.salesPriceLab.attributedText = attributedString;
			self.salesPriceLab.hidden = NO;
			
		} else {
			// 否则不展示划线价：单位左边的价格取 rentPrice。
			price = [NSString stringWithFormat:@"%@",_offerItemModel.rentPrice];
			self.salesPriceLab.hidden = YES;
		}
	    NSString *fullString = [NSString stringWithFormat:@"%@%@%@",[DXPPBConfigManager shareInstance].currencySymbol, price, rent];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullString];
		// 设置整体颜色
		[attributedString addAttribute:NSForegroundColorAttributeName value:DC_UIColorFromRGB(0x3868FF) range:NSMakeRange(0, fullString.length)];
		// 设置特定部分的字体大小以及颜色
		UIFont *largerFont = [FontManager setBoldFontSize:12];
		NSRange range = [fullString rangeOfString:[DXPPBConfigManager shareInstance].currencySymbol]; // 查找要修改的部分
		NSRange range2 = [fullString rangeOfString:rent]; // 查找要修改的部分
		if (range.location != NSNotFound) {
			[attributedString addAttribute:NSFontAttributeName value:largerFont range:range];
		}
		if (range2.location != NSNotFound) {
			[attributedString addAttribute:NSFontAttributeName value:largerFont range:range2];
		}
		// 对小数点后面的精度进行处理
		// 查找小数点的位置
		NSRange decimalRange = [fullString rangeOfString:@"."];
		if (decimalRange.location != NSNotFound) {
			// 提取小数点后面的部分
			NSString *decimalPart = [fullString substringFromIndex:decimalRange.location];
			// 获取小数点后两位
			NSString *twoDecimalDigits = [decimalPart substringToIndex:3];
			// 输出结果
			NSRange range3 = [fullString rangeOfString:twoDecimalDigits]; // 查找要修改的部分
			if (range3.location != NSNotFound) {
				[attributedString addAttribute:NSFontAttributeName value:largerFont range:range3];
			}
		} else {
			NSLog(@"没有找到小数点");
		}
		[attributedString addAttribute:NSForegroundColorAttributeName value:DC_UIColorFromRGB(0x3868FF) range:range];
		self.moneyLab.attributedText = attributedString;
		
	} else {
		NSString *price;
		// 如果不是月租，则展示一次性费用
		if (!DC_IsStrEmpty(_offerItemModel.discountPriceInt) && [_offerItemModel.discountPriceInt floatValue] > 0) {
			// 展示划线价，划线价取 salesPrice，实际价格取 discountPrice；
			NSString *rentPrice = _offerItemModel.salesPrice;
			NSString *salesPrice = [NSString stringWithFormat:@"%@%@",[DXPPBConfigManager shareInstance].currencySymbol ,rentPrice];
			NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:salesPrice];
			// 设置划线属性
			[attributedString addAttribute:NSStrikethroughStyleAttributeName
									 value:@(NSUnderlineStyleSingle)
									 range:NSMakeRange(0, salesPrice.length)];
			self.salesPriceLab.attributedText = attributedString;
			self.salesPriceLab.hidden = NO;
			// 实际价格
			price = _offerItemModel.discountPrice;
			
		} else {
			// 否则不展示划线价：价格取 salesPrice
			price = _offerItemModel.salesPrice;
			self.salesPriceLab.hidden = YES;
		}
		NSString *fullString = [NSString stringWithFormat:@"%@%@",[DXPPBConfigManager shareInstance].currencySymbol, price];
		NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:fullString];
		// 设置整体颜色
		[attributedString addAttribute:NSForegroundColorAttributeName value:DC_UIColorFromRGB(0x3868FF) range:NSMakeRange(0, fullString.length)];
		// 设置特定部分的字体大小以及颜色
		UIFont *largerFont = [FontManager setBoldFontSize:12];
		NSRange range = [fullString rangeOfString:[DXPPBConfigManager shareInstance].currencySymbol]; // 查找要修改的部分
		if (range.location != NSNotFound) {
			[attributedString addAttribute:NSFontAttributeName value:largerFont range:range];
		}
		// 查找小数点的位置
		NSRange decimalRange = [fullString rangeOfString:@"."];
		if (decimalRange.location != NSNotFound) {
			// 提取小数点后面的部分
			NSString *decimalPart = [fullString substringFromIndex:decimalRange.location];
			// 获取小数点后两位
			NSString *twoDecimalDigits = [decimalPart substringToIndex:3];
			// 输出结果
			NSRange range3 = [fullString rangeOfString:twoDecimalDigits]; // 查找要修改的部分
			if (range3.location != NSNotFound) {
				[attributedString addAttribute:NSFontAttributeName value:largerFont range:range3];
			}
		} else {
			NSLog(@"没有找到小数点");
		}
		[attributedString addAttribute:NSForegroundColorAttributeName value:DC_UIColorFromRGB(0x3868FF) range:range];
		self.moneyLab.attributedText = attributedString;
	}
	// 是否展示积分 积分数取 predictionRewardList 中 rewardType=7 的 value，如果没有这个类型的，则默认展示 + 0 Points。
	__block NSString *pointVal = [NSString stringWithFormat:@"  + 0 %@  ", [[HJLanguageManager shareInstance] getTextByKey:@"lb_promo_participation_brand_points"]];
	[_offerItemModel.predictionRewardList enumerateObjectsUsingBlock:^(PredictionRewardItem *item, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([item.rewardType isEqualToString:@"7"]) {
			pointVal = [NSString stringWithFormat:@"  + %@ %@  ",item.value,  [[HJLanguageManager shareInstance] getTextByKey:@"lb_promo_participation_brand_points"]];
			*stop = YES;
		}
	}];
	self.pointLab.text = pointVal;
}

- (void)bindWithModel:(DCMarketingOfferListCellModel *)cellModel {
	CompositionProps *propsDic = cellModel.props;
	self.cellModel = cellModel;
	NSMutableDictionary *dic = cellModel.customData;
	
	if (!propsDic.isShowPoint) {
		self.pointLab.hidden = YES;
	} else {
		self.pointLab.hidden = NO;
	}
}

#pragma mark -- lazy load
- (UIView *)mainView {
	if (!_mainView) {
		_mainView = [[UIView alloc] init];
		_mainView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
		_mainView.layer.cornerRadius = 16.f;
		_mainView.clipsToBounds = YES;
	}
	return _mainView;
}

- (UIImageView *)headImageView {
	if (!_headImageView) {
		_headImageView = [[UIImageView alloc] init];
		_headImageView.layer.cornerRadius = 16.f;
	}
	return _headImageView;
}

- (UILabel *)offerNameLab {
	if (!_offerNameLab) {
		_offerNameLab = [[UILabel alloc] init];
		_offerNameLab.numberOfLines = 2;
		_offerNameLab.lineBreakMode = NSLineBreakByTruncatingTail;
		_offerNameLab.textAlignment = NSTextAlignmentLeft;
		_offerNameLab.font = [FontManager setBoldFontSize:14];
		_offerNameLab.textColor = DC_UIColorFromRGB(0x3D3D3D);
	}
	return _offerNameLab;
}

- (UILabel *)remainLab {
	if (!_remainLab) {
		_remainLab = [[UILabel alloc] init];
		_remainLab.textAlignment = NSTextAlignmentLeft;
		_remainLab.font = [FontManager setNormalFontSize:10];
		_remainLab.textColor = DC_UIColorFromRGB(0x95969D);
	}
	return _remainLab;
}

- (UILabel *)endsLab {
	if (!_endsLab) {
		_endsLab = [[UILabel alloc] init];
		_endsLab.textAlignment = NSTextAlignmentLeft;
		_endsLab.font = [FontManager setNormalFontSize:10];
		_endsLab.textColor = DC_UIColorFromRGB(0x95969D);
	}
	return _endsLab;
}

- (UILabel *)vaildValLab {
	if (!_vaildValLab) {
		_vaildValLab = [[UILabel alloc] init];
		_vaildValLab.textColor = DC_UIColorFromRGB(0x242424);
		_vaildValLab.layer.borderColor = DC_UIColorFromRGB(0x3D3D3D).CGColor;
		_vaildValLab.layer.borderWidth = 1.f;
		_vaildValLab.layer.cornerRadius = 5.f;
		_vaildValLab.font = [FontManager setNormalFontSize:10];
		_vaildValLab.textAlignment = NSTextAlignmentCenter;
	}
	return _vaildValLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textAlignment = NSTextAlignmentLeft;
		_moneyLab.font = [FontManager setBoldFontSize:20];
		_moneyLab.textColor = DC_UIColorFromRGB(0x3868FF);
	}
	return _moneyLab;
}

- (UILabel *)salesPriceLab {
	if (!_salesPriceLab) {
		_salesPriceLab = [[UILabel alloc] init];
		_salesPriceLab.textAlignment = NSTextAlignmentLeft;
		_salesPriceLab.font = [FontManager setNormalFontSize:12];
		_salesPriceLab.textColor = DC_UIColorFromRGB(0x95969D);
		_salesPriceLab.text = @"0.00";
	}
	return _salesPriceLab;
}

- (UILabel *)pointLab {
	if (!_pointLab) {
		_pointLab = [[UILabel alloc] init];
		_pointLab.textAlignment = NSTextAlignmentCenter;
		_pointLab.layer.borderColor = DC_UIColorFromRGB(0x3868FF).CGColor;
		_pointLab.layer.borderWidth = 1.f;
		_pointLab.layer.cornerRadius = 5.f;
		_pointLab.font = [FontManager setBoldFontSize:10];
		_pointLab.textColor = DC_UIColorFromRGB(0x3868FF);
	}
	return _pointLab;
}

@end
