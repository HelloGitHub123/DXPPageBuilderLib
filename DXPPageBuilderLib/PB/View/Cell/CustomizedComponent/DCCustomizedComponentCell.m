//
//  DCCustomizedComponentCell.m
//  AFNetworking
//
//  Created by 李标 on 2024/9/13.
//

#import "DCCustomizedComponentCell.h"
#import "DCMacroHeader.h"
#import <DXPFontManagerLib/FontManager.h>

// ****************** Model ******************
@implementation DCCustomizedComponentCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
	self = [super initWithComponentModel:componentModel];
	return self;
}

- (void)coustructCellHeight {
	[super coustructCellHeight];
	
	// 判断是否实名过
    BOOL isRealName = [[self.customData valueForKey:@"isRealName"] boolValue];
	if (!isRealName) {
		self.cellHeight = 55+16; // 未实名
	} else {
		self.cellHeight = 20+16; // 已经实名
	}
}

- (NSString *)cellClsName {
	return NSStringFromClass([DCCustomizedComponentCell class]);
}

// 类型
- (void)setComponentCellType:(DCCustomizedComponentCellType)componentCellType {
	_componentCellType = componentCellType;
	
	switch (componentCellType) {
		case DCCustomizedComponentCellType_REGISTRATION_REQUIRED: {
//			NSString *regDate = [self.customData objectForKey:@"regDate"];
//			if (DC_IsStrEmpty(regDate)) {
//				self.cellHeight = 55+16;
//			} else {
				self.cellHeight = 1;
//			}
		}
			break;
		case DCCustomizedComponentCellType_MHAWALA_BALANCE: {
			self.cellHeight = 71 + 20 + 20;
		}
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


@interface DCCustomizedComponentCell ()

@property (nonatomic, strong) DCUnVerifiedComponentView *unVerifiedComponentView; // 未实名
@property (nonatomic, strong) DCVerifiedComponentView *verifiedComponentView; // 已经实名后的
@property (nonatomic, strong) DCMhawalaBalanceView *mhawalaBalanceView;
@end



@implementation DCCustomizedComponentCell

- (void)configView {
	// ============ 中间信息容器 container
	[self addSubview:self.unVerifiedComponentView];
	[self addSubview:self.verifiedComponentView];
	[self addSubview:self.mhawalaBalanceView];
	self.unVerifiedComponentView.hidden = YES;
	self.verifiedComponentView.hidden = YES;
	self.mhawalaBalanceView.hidden = YES;

	[self.unVerifiedComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(16);
		make.trailing.mas_equalTo(-16);
//		make.height.mas_equalTo(55);
		make.bottom.mas_equalTo(0);
		make.top.mas_equalTo(16);
	}];
	
	[self.verifiedComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(16);
		make.trailing.mas_equalTo(-16);
//		make.height.mas_equalTo(55);
		make.bottom.mas_equalTo(0);
		make.top.mas_equalTo(16);
	}];
	
	[self.mhawalaBalanceView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(16);
		make.trailing.mas_equalTo(-16);
		make.bottom.mas_equalTo(0);
		make.top.mas_equalTo(20);
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

- (void)bindCellModel:(DCCustomizedComponentCellModel *)cellModel {
	[super bindCellModel:cellModel];
	self.cellModel = cellModel;
	
	if (cellModel.componentCellType == DCCustomizedComponentCellType_REGISTRATION_REQUIRED) {
		// 判断是否实名过
		BOOL isRealName = [[self.cellModel.customData valueForKey:@"isRealName"] boolValue];
		if (!isRealName) {
			// 未实名
			self.unVerifiedComponentView.hidden = NO;
			self.verifiedComponentView.hidden = YES;
			
			[self.unVerifiedComponentView bindWithModel:cellModel];
		} else {
			// 已经实名过
			self.unVerifiedComponentView.hidden = YES;
			self.verifiedComponentView.hidden = NO;
			
			[self.verifiedComponentView bindWithModel:cellModel];
		}
	} else if (cellModel.componentCellType == DCCustomizedComponentCellType_MHAWALA_BALANCE) {
		self.mhawalaBalanceView.hidden = NO;
		
		[self.mhawalaBalanceView bindWithModel:cellModel];
	}
}

// MARK: LAzy
- (DCUnVerifiedComponentView *)unVerifiedComponentView {
	if(!_unVerifiedComponentView) {
		_unVerifiedComponentView = [DCUnVerifiedComponentView new];
		_unVerifiedComponentView.layer.cornerRadius = 16.f;
		_unVerifiedComponentView.backgroundColor = DC_UIColorFromRGB(0xFCEBED);
	}
	return _unVerifiedComponentView;
}

- (DCVerifiedComponentView *)verifiedComponentView {
	if(!_verifiedComponentView) {
		_verifiedComponentView = [DCVerifiedComponentView new];
		_verifiedComponentView.backgroundColor = [UIColor clearColor];
	}
	return _verifiedComponentView;
}

- (DCMhawalaBalanceView *)mhawalaBalanceView {
	if(!_mhawalaBalanceView) {
		_mhawalaBalanceView = [DCMhawalaBalanceView new];
		_mhawalaBalanceView.layer.cornerRadius = 16.f;
		_mhawalaBalanceView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
	}
	return _mhawalaBalanceView;
}

@end



//===========================================未实名================================================================

@interface DCUnVerifiedComponentView ()

@property (nonatomic, strong) DCCustomizedComponentCellModel *cellModel;

//@property (nonatomic, strong) UIView *bakView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *enterImgView;
@end

@implementation DCUnVerifiedComponentView

- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		
		
		[self configView];
	}
	return self;
}

- (void)configView {
	[self addSubview:self.contentView];
	[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mas_leading).offset(12);
		make.top.mas_equalTo(self.mas_top).offset(8);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
		make.bottom.mas_equalTo(self.mas_bottom).offset(-8);
	}];
	
	[self.contentView addSubview:self.iconImgView];
	[self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.width.mas_equalTo(24);
		make.leading.mas_equalTo(self.contentView.mas_leading).offset(0);
		make.centerY.mas_equalTo(self.contentView.mas_centerY);
	}];
	
	[self.contentView addSubview:self.enterImgView];
	[self.enterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(35);
		make.height.mas_equalTo(39);
		make.centerY.mas_equalTo(self.contentView.mas_centerY);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
	}];
	
	[self.contentView addSubview:self.contentLab];
	[self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(8);
		make.centerY.mas_equalTo(self.enterImgView.mas_centerY);
		make.trailing.mas_equalTo(self.enterImgView.mas_leading).offset(-10);
//		make.top.mas_equalTo(8);
//		make.bottom.mas_equalTo(-8);
	}];

}

- (void)bindWithModel:(DCCustomizedComponentCellModel *)cellModel {
	self.cellModel = cellModel;
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	self.iconImgView.hidden = NO;
	self.contentLab.hidden = NO;
	self.enterImgView.hidden = NO;
	
	// 判断是否实名过
//	BOOL isRealName = [[self.cellModel.customData valueForKey:@"isRealName"] boolValue];
//	if (!isRealName) {
//		// 未实名
//		self.iconImgView.hidden = NO;
//		self.contentLab.hidden = NO;
//		self.enterImgView.hidden = NO;
//		
//	} else {
//		self.iconImgView.hidden = YES;
//		self.contentLab.hidden = YES;
//		self.enterImgView.hidden = YES;
//	}
	
}

// 点击事件
- (void)tapAdAction {
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.link = @"DCCustomizedComponentCellType_REGISTRATION_REQUIRED";
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

#pragma mark -- lazy load
- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.userInteractionEnabled = YES;
	}
	return _contentView;
}

- (UIImageView *)iconImgView {
	if (!_iconImgView) {
		_iconImgView = [[UIImageView alloc] init];
		_iconImgView.image = DC_image(@"ic_warnings");
	}
	return _iconImgView;
}

- (UILabel *)contentLab {
	if (!_contentLab) {
		_contentLab = [[UILabel alloc] init];
		_contentLab.textAlignment = NSTextAlignmentLeft;
		_contentLab.numberOfLines = 0;
		_contentLab.textColor = DC_UIColorFromRGB(0xDF3847);
		_contentLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"tip_registration_now"];
		_contentLab.font = [FontManager setNormalFontSize:12];
	}
	return _contentLab;
}

- (UIImageView *)enterImgView {
	if (!_enterImgView) {
		_enterImgView = [[UIImageView alloc] init];
		_enterImgView.image = DC_image(@"ic_enterDetail");
		_enterImgView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdAction)];
		[_enterImgView addGestureRecognizer:tap];
	}
	return _enterImgView;
}
	
@end


//===========================================已经实名================================================================


@interface DCVerifiedComponentView ()

@property (nonatomic, strong) DCCustomizedComponentCellModel *cellModel;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *imgView;
@end

@implementation DCVerifiedComponentView
- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		
		
		[self configView];
	}
	return self;
}

- (void)configView {
	[self addSubview:self.contentView];
	[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mas_leading).offset(0);
		make.top.mas_equalTo(self.mas_top).offset(0);
		make.trailing.mas_equalTo(self.mas_trailing).offset(0);
		make.bottom.mas_equalTo(self.mas_bottom).offset(0);
	}];
	
	[self.contentView addSubview:self.nameLab];
	[self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.contentView.mas_leading);
		make.centerY.mas_equalTo(self.contentView.mas_centerY);
	}];

	[self.contentView addSubview:self.imgView];
	[self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.nameLab.mas_trailing).offset(10);
		make.width.height.mas_equalTo(20);
		make.centerY.mas_equalTo(self.contentView.mas_centerY);
	}];
}

- (void)bindWithModel:(DCCustomizedComponentCellModel *)cellModel {
	self.cellModel = cellModel;
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
	// 文本
	NSString *infoStr = [NSString stringWithFormat:@"Hi,%@", [DXPPBDataManager shareInstance].myProfileModel.custProfile.custName];
	self.nameLab.text = infoStr;
}

#pragma mark -- lazy load
- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.userInteractionEnabled = YES;
	}
	return _contentView;
}

- (UIImageView *)imgView {
	if (!_imgView) {
		_imgView = [[UIImageView alloc] init];
		_imgView.image = DC_image(@"ic_verified");
	}
	return _imgView;
}

- (UILabel *)nameLab {
	if (!_nameLab) {
		_nameLab = [[UILabel alloc] init];
		_nameLab.textAlignment = NSTextAlignmentLeft;
		_nameLab.numberOfLines = 0;
		_nameLab.textColor = DC_UIColorFromRGB(0x242424);
		_nameLab.text = @"";
		_nameLab.font = [FontManager setBoldFontSize:16];
	}
	return _nameLab;
}

@end


//===========================================MHAWALA================================================================

@interface DCMhawalaBalanceView ()

@property (nonatomic, strong) DCCustomizedComponentCellModel *cellModel;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UIImageView *enterImgView;
@end

@implementation DCMhawalaBalanceView

- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]) {
		
		[self configView];
	}
	return self;
}

- (void)configView {
	[self addSubview:self.contentView];
	[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.mas_leading).offset(12);
		make.top.mas_equalTo(self.mas_top).offset(12);
		make.trailing.mas_equalTo(self.mas_trailing).offset(-12);
		make.bottom.mas_equalTo(self.mas_bottom).offset(-12);
	}];
	
	[self.contentView addSubview:self.iconImgView];
	[self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(82);
		make.height.mas_equalTo(24);
		make.leading.mas_equalTo(self.contentView.mas_leading).offset(0);
		make.centerY.mas_equalTo(self.contentView.mas_centerY);
	}];
	
	// 分割线
	UIView *lineView = [[UIView alloc] init];
	lineView.backgroundColor = DC_UIColorFromRGB(0xE6E6E6);
	[self.contentView addSubview:lineView];
	[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(1);
		make.top.mas_equalTo(self.contentView.mas_top).offset(2);
		make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-2);
		make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(12);
	}];
	
	
	[self.contentView addSubview:self.enterImgView];
	[self.enterImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(40);
		make.centerY.mas_equalTo(self.contentView.mas_centerY);
		make.trailing.mas_equalTo(self.contentView.mas_trailing);
	}];
	
	[self.contentView addSubview:self.titleLab];
	[self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(self.contentView.mas_top).offset(0);
		make.leading.mas_equalTo(lineView.mas_trailing).offset(12);
		make.height.mas_equalTo(15);
		make.trailing.mas_equalTo(self.enterImgView.mas_leading).offset(-5);
	}];
	
	[self.contentView addSubview:self.balanceLab];
	[self.balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(self.titleLab.mas_leading).offset(0);
		make.top.mas_equalTo(self.titleLab.mas_bottom).offset(3);
		make.bottom.mas_equalTo(self.contentView).offset(0);
		make.trailing.mas_equalTo(self.titleLab.mas_trailing).offset(0);
	}];
	
}

- (void)bindWithModel:(DCCustomizedComponentCellModel *)cellModel {
	self.cellModel = cellModel;
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
}

// 点击事件
- (void)tapAdAction {
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.link = @"MHAWALA_BALANCE";
	model.floorEventType = DCFloorEventFloor;
	[self hj_routerEventWith:model];
}

#pragma mark -- lazy load
- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.userInteractionEnabled = YES;
	}
	return _contentView;
}

- (UIImageView *)iconImgView {
	if (!_iconImgView) {
		_iconImgView = [[UIImageView alloc] init];
		_iconImgView.image = DC_image(@"ic_logo_hawala");
	}
	return _iconImgView;
}

- (UILabel *)titleLab {
	if (!_titleLab) {
		_titleLab = [[UILabel alloc] init];
		_titleLab.textAlignment = NSTextAlignmentLeft;
		_titleLab.numberOfLines = 0;
		_titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.text = @"mHawala Balance";
		_titleLab.font = [FontManager setNormalFontSize:12];
	}
	return _titleLab;
}

- (UILabel *)balanceLab {
	if (!_balanceLab) {
		_balanceLab = [[UILabel alloc] init];
		_balanceLab.textAlignment = NSTextAlignmentLeft;
		_balanceLab.numberOfLines = 0;
		_balanceLab.textColor = DC_UIColorFromRGB(0x242424);
		_balanceLab.text = @"0Afs";
		_balanceLab.font = [FontManager setNormalFontSize:22];
	}
	return _balanceLab;
}


- (UIImageView *)enterImgView {
	if (!_enterImgView) {
		_enterImgView = [[UIImageView alloc] init];
		_enterImgView.image = DC_image(@"ic_to_view");
		
		_enterImgView.userInteractionEnabled = YES;
		
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdAction)];
		[_enterImgView addGestureRecognizer:tap];
	}
	return _enterImgView;
}

@end
