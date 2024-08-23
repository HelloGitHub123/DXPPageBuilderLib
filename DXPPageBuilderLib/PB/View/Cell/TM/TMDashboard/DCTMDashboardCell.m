//
//  DCTMDashboardCell.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/2/21.
//

#import "DCTMDashboardCell.h"
#import "DCTMDBScrollView.h"
#import "DCPB.h"
#import "YYLabel.h"
#import "YYText.h"
#import <DXPCategoryLib/UIColor+Category.h>

#import "HJDitoProgress.h"
#import <SDWebImage/UIButton+WebCache.h>

#import "DCSubsListModel.h"

// ****************** Model ******************
@implementation DCTMDashboardCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    return self;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    if(self.dbCellType == DCFWBDashboard) {
        // 判断是否有内容，计算高度
        NSString *address = [self.customData objectForKey:@"Address"];
        CGFloat height = [self getMessageHeight:DC_IsStrEmpty(address)?@"":address];
        // Download Speed、Upload Speed 如果都为空，则隐藏，如果有一个为空，则中间的竖线和对应的速率隐藏
        NSString *upLoadVal = [self.customData objectForKey:@"upLoadVal"];
        NSString *downLoadVal = [self.customData objectForKey:@"downLoadVal"];
        if ([upLoadVal isEqualToString:@"0"] && [downLoadVal isEqualToString:@"0"]) {
            self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + 148 + 22 + height;
        } else {
            if (height == 0) {
                // address 没有数据，需要加上address 本身的行高度
                self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + 148 + 58 + height + 22;
            } else {
                self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + 148 + 58 + height;
            }
        }
    } else {
        // 如果 == 5
        self.cellHeight = 0;
    }
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCTMDashboardCell class]);
}

// 类型
- (void)setDbCellType:(DCTMDashboardCellHeightType)dbCellType {
    _dbCellType = dbCellType;
    
    switch (dbCellType) {
        case DCTMDashboardRegisterSim:
            self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + ((DCP_SCREEN_WIDTH - 16)/343*163);
            break;
        case  DCTMDashboardOpenAccount:
            self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + ((DCP_SCREEN_WIDTH - 16)/343*170 + 46) ;
            break;
        case  DCTMDashboardProgress:
            self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + 242 + 133;
            break;
        case DCFWBDashboard:
            self.cellHeight = [DCTMDashboardCellModel getTMDBTopMargin] + 223;
            break;
		case DCDashboardSIMDataVoice:
			self.cellHeight = 232;
			break;
        default:
            break;
    }
}

+ (CGFloat)getTMDBTopMargin {
    return  DCP_NAV_HEIGHT + 10;
}

/**
 *  获取lb的高度（默认字体14，行间距8，lb宽ScreenWidth-间隔-name2标题宽度）
 *  @param message lb.text
 *  @return lb的高度
 */
- (CGFloat)getMessageHeight:(NSString *)message
{
    NSMutableAttributedString *introText = [[NSMutableAttributedString alloc] initWithString:message];
    introText.yy_font = FONT_S(14);
    introText.yy_lineSpacing = 8;
    CGSize introSize = CGSizeMake(DC_DCP_SCREEN_WIDTH-16*5-66, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:introText];
    CGFloat introHeight = layout.textBoundingSize.height;
    return introHeight;
}
@end

@interface DCTMDashboardCell()
// Dashboard  容器
@property (nonatomic, strong)  DCTMDBContainerView *dbContainerView;
// FWB Dashboard
@property (nonatomic, strong)  DCFWBView *fwbView;
// 注册背景图
@property (nonatomic, strong) UIView *registerSimView;
@property (nonatomic, strong) UIView *openAccountView;
// 3个球
@property (nonatomic, strong) DCDashboardSIMDataVoiceView *dbSIMDataVoiceView;

@end
@implementation DCTMDashboardCell

- (void)configView {
    
    // ============  买卡激活页面
    [self.contentView addSubview:self.registerSimView];
    [self.registerSimView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.contentView addSubview:self.openAccountView];
    [self.openAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    // ============ 中间信息容器 container
    [self.contentView addSubview:self.dbContainerView];
    [self.dbContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.top.bottom.leading.equalTo(@0);
    }];
    
    // ============ FWB container
    [self.contentView addSubview:self.fwbView];
    [self.fwbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([DCTMDashboardCellModel getTMDBTopMargin]);
        make.trailing.bottom.leading.equalTo(@0);
    }];
	 
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTrackAction)];
    [self.contentView addGestureRecognizer:tap];
	
	[self.contentView addSubview:self.dbSIMDataVoiceView];
	[self.dbSIMDataVoiceView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(10);
		make.trailing.bottom.leading.equalTo(@0);
	}];
}

#pragma mark - dashboard增加埋点事件
- (void)addTrackAction {
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = @"Dashboard_Click";
    model.floorEventType = DCFloorEventCustome;
    [self hj_routerEventWith:model];
}

- (void)bindCellModel:(DCTMDashboardCellModel *)cellModel {
    [super bindCellModel:cellModel];
    self.cellModel = cellModel;

    
    // 首先隐藏页面
    self.registerSimView.hidden = YES;
    self.openAccountView.hidden = YES;
    self.dbContainerView.hidden = YES;
    self.fwbView.hidden = YES;
	self.dbSIMDataVoiceView.hidden = YES;
    
    UIImageView *bgImgView = nil;
    // 根据业务来判断具体展示什么内容
    if(cellModel.dbCellType == DCTMDashboardOpenAccount) {
        self.openAccountView.hidden = NO;
        bgImgView = [self.openAccountView viewWithTag:999];
    }else if(cellModel.dbCellType == DCTMDashboardRegisterSim){
        self.registerSimView.hidden = NO;
        bgImgView = [self.registerSimView viewWithTag:999];
    }else if (cellModel.dbCellType == DCFWBDashboard) {
        self.fwbView.hidden = NO;
        bgImgView = nil;
        [self.fwbView bindWithModel:cellModel];
	}else if (cellModel.dbCellType == DCDashboardSIMDataVoice) {
		self.dbSIMDataVoiceView.hidden = NO;
		bgImgView = nil;
		[self.dbSIMDataVoiceView bindWithModel:cellModel];
	}
    else {
        self.dbContainerView.hidden = NO;
        [self.dbContainerView bindWithModel:cellModel];
        bgImgView = nil;
    }
    
   
    if(bgImgView && !DC_IsStrEmpty(cellModel.props.themeType)) {
        NSString *imgStr = [NSString stringWithFormat:@"db_bg_%@_top",cellModel.props.themeType];
        bgImgView.image = [UIImage imageNamed:imgStr];
    }
}
- (void)registerSimAction {
    DBBoardingSetting *set =  self.cellModel.props.onBoardingSetting;
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.linkType = DC_IsStrEmpty(set.onBoardingType) ? @"1" :set.onBoardingType;
    model.link = set.onBoardingTypeUrl;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

// MARK: LAzy
- (DCTMDBContainerView *)dbContainerView {
    if(!_dbContainerView) {
        _dbContainerView = [DCTMDBContainerView new];
    }
    return _dbContainerView;
}

- (DCFWBView *)fwbView {
    if(!_fwbView) {
        _fwbView = [DCFWBView new];
    }
    return _fwbView;
}

- (UIView *)registerSimView {
    if(!_registerSimView){
        _registerSimView = [UIView new];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerSimAction)];
        _registerSimView.userInteractionEnabled = YES;
        [_registerSimView addGestureRecognizer:tap];
        // 背景图
        UIImageView *bgImgView = [UIImageView new];
        bgImgView.tag = 999;
        [_registerSimView addSubview:bgImgView];
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
       
        
        // 激活图片
        UIImageView *registerImgView = [UIImageView new];
        registerImgView.image = [UIImage imageNamed:@"db_sim_buy_bg"];
        [_registerSimView addSubview:registerImgView];
        [registerImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.trailing.equalTo(@-16);
            make.top.equalTo(@([DCTMDashboardCellModel getTMDBTopMargin]));
            make.height.equalTo(@((DCP_SCREEN_WIDTH - 16)/343*163));
        }];
    }
    return _registerSimView;
}

- (UIView *)openAccountView {
    if(!_openAccountView) {
        _openAccountView = [UIView new];
        
        // 背景图
        UIImageView *bgImgView = [UIImageView new];
        bgImgView.tag = 999;
        [_openAccountView addSubview:bgImgView];
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
       
        
        // 文案
        UILabel *titleLbl = [UILabel new];
        titleLbl.textColor = [UIColor whiteColor];
        titleLbl.text = @"Welcome to CLP. ";
        titleLbl.font = FONT_BS(20);
        [_openAccountView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.top.equalTo(@(16 + [DCTMDashboardCellModel getTMDBTopMargin]));
        }];
        
        // 图片
        UIImageView *buySim = [UIImageView new];
        buySim.image = [UIImage imageNamed:@"db_sim_buy_bg"];
        [_openAccountView addSubview:buySim];
        [buySim mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@16);
            make.trailing.equalTo(@-16);
            make.top.equalTo(@(46 + [DCTMDashboardCellModel getTMDBTopMargin]));
            make.height.equalTo(@((DCP_SCREEN_WIDTH - 16)/343*170));
        }];
        
        
    }
    return _openAccountView;
}

- (DCDashboardSIMDataVoiceView *)dbSIMDataVoiceView {
	if(!_dbSIMDataVoiceView) {
		_dbSIMDataVoiceView = [DCDashboardSIMDataVoiceView new];
	}
	return _dbSIMDataVoiceView;
}

@end

// ****************** Dashboard 容器View ******************
@interface DCTMDBContainerView()
@property (nonatomic, strong) UIImageView *bgImgView1;
@property (nonatomic, strong) UIImageView *bgImgView2;

// 顶部View
@property (nonatomic, strong) UIImageView *alphaImgView;

@property (nonatomic, strong) UIView *topInfoView;
@property (nonatomic, strong) UILabel *numLbl;
@property (nonatomic, strong) UILabel *stateLbl; // 激活状态文本
@property (nonatomic, strong) UILabel *pointLbl;
// xx
@property (nonatomic, strong) UIView *balanceView;
// xx
@property (nonatomic, strong) UIView *rmView;
@property (nonatomic, strong) UILabel *rmLbl;
@property (nonatomic, strong) UILabel *expir2;
@property (nonatomic, strong) UILabel *expir1;

//@property (nonatomic, strong) UIImageView *gifImgView;

@property (nonatomic, strong) UILabel *balanceLbl;


// DashBoard 容器
@property (nonatomic, strong) UIView *dashboardView;

@property (nonatomic, strong) UIView *rightContainer; //右边积分视图


// 流量球内容
@property (nonatomic, strong) DCTMDBScrollView *progressView;
@property (nonatomic, strong) DCTMDashboardCellModel *cellModel;


@property (nonatomic, strong) UIImageView *phoneIcon; // 手机照片
@property (nonatomic, strong) UIButton *changeBtn; // 手机照片
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *activeLbl;
@property (nonatomic, strong) UIView *topMidLine;



@end
@implementation DCTMDBContainerView
- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.bgImgView1];
    [self.bgImgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.trailing.equalTo(@0);
        make.height.equalTo(@([DCTMDashboardCellModel getTMDBTopMargin] + 242));
    }];
    
    [self addSubview:self.bgImgView2];
    [self.bgImgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.trailing.equalTo(@0);
        make.top.equalTo(self.bgImgView1.mas_bottom);
    }];
    
    UIImageView *alphaImgView = [UIImageView new];
    alphaImgView.image = [UIImage imageNamed:@"pb_tm_db_mask1"];
    self.alphaImgView = alphaImgView;
    [self addSubview:alphaImgView];
    [alphaImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([DCTMDashboardCellModel getTMDBTopMargin]));
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@242);
    }];
    
    // 中间容器
    UIView *contentView = [UIView new];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@([DCTMDashboardCellModel getTMDBTopMargin]));
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.height.equalTo(@242);
    }];
    
    // 顶部信息
    [contentView addSubview:self.topInfoView];
    [self.topInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@14);
        make.trailing.equalTo(@-14);
        make.top.equalTo(@0);
        make.height.equalTo(@45);
    }];
    
    [contentView addSubview:self.balanceView];
    [self.balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topInfoView.mas_bottom).offset(8);
        make.bottom.equalTo(@0);
        make.leading.equalTo(@14);
        make.trailing.equalTo(@-14);
    }];
    
//    [contentView addSubview:self.gifImgView];
//    [self.gifImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.trailing.equalTo(@-10);
//        make.width.height.equalTo(@107);
//    }];
    
    // ============  滚动流量球
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@-10);
        make.height.equalTo(@234);
    }];
    
}


- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel {
    self.cellModel = cellModel;
    NSMutableDictionary *dic = cellModel.customData;
    NSString *num = [dic objectForKey:@"num"];
    if (!DC_IsStrEmpty(num)) {
        self.numLbl.text = num;
    }
    
    NSString *state = [dic objectForKey:@"state"];
    NSString *stateName = [dic objectForKey:@"stateName"];
    if(!DC_IsStrEmpty(stateName)) {
        self.activeLbl.text = [PbTools getStateNameWithstateName:stateName
                                                         state:state
                                                      paidFlag:[DXPPBDataManager shareInstance].selectedSubsModel.paidFlag];
        
        self.activeLbl.textColor = [PbTools getStateColorWithstate:state];
        self.dotView.backgroundColor = self.activeLbl.textColor;
    }else {
        self.activeLbl.text = @"";
		[self.dotView removeFromSuperview];
    }
    // 设置主题
//    self.gifImgView.image = [UIImage imageNamed:@"db_gif"];
    [self setThemeType:cellModel];
    [self.topInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@ ([@"3"  isEqualToString:cellModel.props.themeType] ?   6  : 0));
    }];
    
    
    if(!DC_IsArrEmpty(cellModel.props.circlePhoneIcon)){
        PicturesItem *item = [cellModel.props.circlePhoneIcon firstObject];
        [self.phoneIcon sd_setImageWithURL:[NSURL URLWithString:item.src]];
    }
    
    if(!DC_IsArrEmpty(cellModel.props.circleChangeIcon)){
        PicturesItem *item = [cellModel.props.circleChangeIcon firstObject];
        [self.changeBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:item.src] forState:UIControlStateNormal];
        [self.changeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(item.width/2.0);
            make.height.mas_equalTo(item.height/2.0);
        }];
    }
    
    if([DXPPBDataManager shareInstance].totalSubsArr.count <= 1) {
        self.changeBtn.hidden = YES;
        [self.topMidLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.numLbl.mas_trailing).offset(8);
        }];
    } else {
        self.changeBtn.hidden = NO;
    }
    
    self.rightContainer.hidden = YES;

    if([@"Y" isEqualToString:cellModel.props.showPoints] ) {
        self.rightContainer.hidden = NO;
        // 积分
        NSString *point = [dic objectForKey:@"usablePoint"] ?: @"";
        self.pointLbl.text = [DCPBManager stringFormatToThreeBit:point];
    }
    
    NSString *paidFlag = [dic objectForKey:@"paidFlag"];
    if ([@"0" isEqualToString:paidFlag]) {
		self.balanceLbl.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_balance_tips"];
    } else {
		self.balanceLbl.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_bill_amount_due"];
    }
    
    
    
    // 价格
    NSString *money = [dic objectForKey:@"money"];
//    if(DC_IsStrEmpty(money)) {
//        self.rmLbl.text = @"No Outstanding Bills";
//    }else {
        self.rmLbl.text = [PbTools getAmountWithScaleAndUnit:money];
//        self.rmLbl.text = [NSString stringWithFormat:@"RM %@",!DC_IsStrEmpty(money) ? money : @"--"];
//    }
    
    
    // 日期
    self.expir1.text = @"";
    self.expir2.text = @"";
    NSString *effDate = [dic objectForKey:@"effDate"];
    if (!DC_IsStrEmpty(effDate)) {
        if ([@"0" isEqualToString:paidFlag]) {
//            self.expir1.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_balance_expires_on"];
            self.expir1.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_valid_till"];
            self.expir2.text = [self dueFormatterDateWithString:effDate];
        } else if (![@"0" isEqualToString:paidFlag] && [money floatValue] > 0) {
            self.expir1.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_due_by"];
            self.expir2.text = [self dueFormatterDateWithString:effDate];
        }
    }
    
    [self.progressView bindWithModel:cellModel];
}

- (void)pointTapAction {
    DBPointsSetting *set =  self.cellModel.props.onPointsSetting;
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.linkType = DC_IsStrEmpty(set.onPointsType) ? @"1" :set.onPointsType;
    model.link = set.onPointsTypeUrl;
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
}

//  时间转换
- (NSString*)dueFormatterDateWithString:(NSString*)dueDate {
    //
    NSString *monthStr = @"";
    NSString *yearStr = @"";
    NSString *dayStr = @"";
    
    if (dueDate.length >= 8) {
        yearStr = [dueDate substringToIndex:4];
        monthStr = [dueDate substringWithRange:NSMakeRange(4, 2)];
        dayStr =  [dueDate substringWithRange:NSMakeRange(6, 2)];
        
        NSDictionary *monthUSDic = @{@"01":@"Jan",@"02":@"Feb",@"03":@"Mar",@"04":@"Apr",@"05":@"May",@"06":@"Jun",@"07":@"Jul",@"08":@"Aug",@"09":@"Sep",@"10":@"Oct",@"11":@"Nov",@"12":@"Dec"};
        return  [NSString stringWithFormat:@"%@ %@ %@",dayStr , [monthUSDic objectForKey:monthStr]?:@"", yearStr];
    }
    return  @"";
}


- (void)setThemeType:(DCTMDashboardCellModel *)cellModel {
    
    // 第五种样式
    if([@"5" isEqualToString:cellModel.props.themeType]){
        // 设置圆角
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH - 32, 242) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16,16)];
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        //maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.CGPath;
        self.alphaImgView.layer.cornerRadius = 24;
        
        // 设置颜色
        if([@"image" isEqualToString:cellModel.props.dashCardBgType]) {
            [self.alphaImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.props.dashCardBgImg.src] placeholderImage:DC_image(@"pb_download_speed") completed:nil];
        }
        if([@"Color" isEqualToString:cellModel.props.dashCardBgType] && !DC_IsStrEmpty(cellModel.props.circleCardColor)){
            self.alphaImgView.backgroundColor = [UIColor colorWithHexString:cellModel.props.circleCardColor];
            self.bgImgView2.alpha = [cellModel.props.circleCardColorOpacity integerValue] > 0 ? [cellModel.props.circleCardColorOpacity integerValue]/100 : 1;
        }
        
        if([@"image" isEqualToString:cellModel.props.dashBgType]) {
            [self.bgImgView1 sd_setImageWithURL:[NSURL URLWithString:cellModel.props.dashBgImg.src] placeholderImage:DC_image(@"pb_download_speed") completed:nil];
        }
        if([@"Color" isEqualToString:cellModel.props.dashBgType] && !DC_IsStrEmpty(cellModel.props.circleDashBgColor)){
            self.bgImgView1.backgroundColor = [UIColor colorWithHexString:cellModel.props.circleDashBgColor];
            self.bgImgView1.alpha = [cellModel.props.circleDashBgColorOpacity integerValue] > 0 ? [cellModel.props.circleDashBgColorOpacity integerValue]/100 : 1;
        }
        
        
        if([@"image" isEqualToString:cellModel.props.dashBottomBgType]) {
            [self.bgImgView2 sd_setImageWithURL:[NSURL URLWithString:cellModel.props.dashBottomBgImg.src] placeholderImage:DC_image(@"pb_download_speed") completed:nil];
        }
        
        if([@"Color" isEqualToString:cellModel.props.dashBottomBgType] && !DC_IsStrEmpty(cellModel.props.circleBottomBgColor)){
            self.bgImgView2.backgroundColor = [UIColor colorWithHexString:cellModel.props.circleBottomBgColor];
            self.bgImgView2.alpha = [cellModel.props.circleBottomBgColorOpacity integerValue]> 0 ? [cellModel.props.circleBottomBgColorOpacity intValue]/100 : 1;
        }
        
        // 设置文字颜色
        if(!DC_IsStrEmpty(cellModel.props.circleDataColor)){
            UIColor * circleDataColor= [UIColor colorWithHexString:cellModel.props.circleDataColor];
            self.numLbl.textColor = circleDataColor;
            self.rmLbl.textColor = circleDataColor;
            self.expir1.textColor = circleDataColor;
            self.expir2.textColor = circleDataColor;
        }
        
        if(!DC_IsStrEmpty(cellModel.props.circleStaticColor)){
            UIColor *  circleStaticColor= [UIColor colorWithHexString:cellModel.props.circleStaticColor];
            self.balanceLbl.textColor = circleStaticColor;
        }
    }else {
        if(!DC_IsStrEmpty(cellModel.props.themeType)) {
            self.bgImgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"db_bg_%@_top",cellModel.props.themeType]];
            self.bgImgView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"db_bg_%@_down",cellModel.props.themeType]];
            self.alphaImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pb_tm_db_mask%@",cellModel.props.themeType]];
        }
    }
}

// MARK: LAZY
- (void)exchageBtnAction {
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = @"EXCHANDE_NUM";
    model.floorEventType = DCFloorEventCustome;
    [self hj_routerEventWith:model];
}

- (UIImageView *)bgImgView1 {
    if(!_bgImgView1) {
        // 背景图
        UIImageView *bgImgView = [UIImageView new];
        bgImgView.tag = 999;
        bgImgView.image = [UIImage imageNamed:@"pb_tm_db_bg1"];
        _bgImgView1 = bgImgView;
       
    }
    return _bgImgView1;
}

- (UIImageView *)bgImgView2 {
    if(!_bgImgView2) {
        // 背景图
        UIImageView *bgImgView = [UIImageView new];
        bgImgView.tag = 999;
        bgImgView.image = [UIImage imageNamed:@"pb_tm_db_bg1_down"];
        _bgImgView2 = bgImgView;
       
    }
    return _bgImgView2;
}

//- (UIImageView *)gifImgView {
//    if(!_gifImgView){
//        _gifImgView = [UIImageView new];
//    }
//    return _gifImgView;
//}
- (UIView *)topInfoView {
    if(!_topInfoView) {
        _topInfoView = [UIView new];
        UIImageView *phoneImg = [UIImageView new];
        
        // phone img
        phoneImg.image = [UIImage imageNamed:@"pb_tm_phone_tag"];
        self.phoneIcon = phoneImg;
        [_topInfoView addSubview:phoneImg];
        
        UILabel *numLbl = [UILabel new];
        self.numLbl = numLbl;
        numLbl.font = FONT_BS(15);
        numLbl.text = @"********";
        numLbl.textColor = [UIColor whiteColor];
        [_topInfoView addSubview:numLbl];
        
        
        [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(numLbl.mas_centerY).offset(-1);
        }];
        
        //
        
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(phoneImg.mas_trailing).offset(2);
            make.centerY.equalTo(_topInfoView.mas_top).offset(27);
        }];
        
        // change 按钮
        UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.changeBtn = changeBtn;
        [changeBtn setBackgroundImage:[UIImage imageNamed:@"pb_tm_change_tag"] forState:UIControlStateNormal];
        [changeBtn addTarget:self action:@selector(exchageBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_topInfoView addSubview:changeBtn];
        [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(numLbl.mas_trailing).offset(5);
            make.centerY.equalTo(phoneImg.mas_centerY);
            make.width.height.equalTo(@20);
        }];
        
        
        UIView *midLine = [UIView new];
        self.topMidLine = midLine;
        midLine.backgroundColor = [UIColor hjp_colorWithHex:@"#FFDFCC"];
        [_topInfoView addSubview:midLine];
        [midLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(changeBtn.mas_trailing).offset(8);
            make.centerY.equalTo(phoneImg.mas_centerY);
            make.width.equalTo(@1);
            make.height.equalTo(@16);
        }];
        
        
        // 状态文本
		UIView *dotView = [[UIView alloc] init];
		self.dotView = dotView;
		dotView.layer.cornerRadius = 2.f;
		[_topInfoView addSubview:dotView];
		[dotView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(midLine.mas_trailing).offset(8);
			make.centerY.equalTo(numLbl.mas_centerY);
			make.width.equalTo(@4);
			make.height.equalTo(@4);
		}];
		
        UILabel *activeLbl = [UILabel new];
        self.activeLbl = activeLbl;
        activeLbl.font = FONT_BS(14);
        [_topInfoView addSubview:activeLbl];
        [activeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(dotView.mas_trailing).offset(4);
            make.centerY.equalTo(numLbl.mas_centerY);
        }];
        
        //
        UIView *rightContainer = [UIView new];
        rightContainer.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pointTapAction)];;
        [rightContainer addGestureRecognizer:tap];
        self.rightContainer = rightContainer;
        [_topInfoView addSubview:rightContainer];
        [rightContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-20);
            make.centerY.equalTo(phoneImg.mas_centerY);
        }];
        
        // point
        UIImageView *pointTag = [UIImageView new];
        pointTag.image = [UIImage imageNamed:@"pb_tm_point_Tag"];
        [rightContainer addSubview:pointTag];
        [pointTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@5);
            make.centerY.equalTo(rightContainer.mas_centerY).offset(4);
            make.top.bottom.equalTo(@0);
        }];
        
        // 具体的值
        UILabel *pointValue = [UILabel new];
        pointValue.font = FONT_BS(14);
        pointValue.text = @"point:";
        pointValue.textColor = [UIColor hjp_colorWithHex:@"#ffffff" alpha:0.5];
        [rightContainer addSubview:pointValue];
        [pointValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(pointTag.mas_trailing).offset(2);
            make.centerY.equalTo(rightContainer.mas_centerY);
        }];
        
        UILabel *pointLbl = [UILabel new];
        self.pointLbl = pointLbl;
        pointLbl.font = FONT_BS(14);
        pointLbl.textColor = [UIColor hjp_colorWithHex:@"#ffffff"];
        [rightContainer addSubview:pointLbl];
        [pointLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(pointValue.mas_trailing).offset(2);
            make.centerY.equalTo(rightContainer.mas_centerY);
            make.trailing.equalTo(@8);
        }];
        
        
//        // 背景图
//        UIView *pointBg = [UIView new];
//        pointBg.backgroundColor = [UIColor hjp_colorWithHex:@"#000000" alpha:0.2];
//        [_topInfoView addSubview:pointBg];
//        [pointBg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(pointTag.mas_leading).offset(-10);
//            make.centerY.equalTo(numLbl.mas_centerY);
//            make.height.equalTo(@30);
//            make.trailing.equalTo(pointLbl.mas_trailing).offset(10);
//        }];
        
        
        // 添加一条横线
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [UIColor hjp_colorWithHex:@"#ffffff" alpha:0.16];
        [_topInfoView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.bottom.equalTo(@0);
            make.height.equalTo(@1);
        }];
    }
    return _topInfoView;
}

// balanceView
- (UIView *)balanceView {
    if(!_balanceView) {
        _balanceView = [UIView new];
        
        UILabel *balance = [UILabel new];
        self.balanceLbl = balance;
		balance.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_bill_amount_due"];
        balance.textColor = [UIColor hjp_colorWithHex:@"#ffffff" alpha:0.5];
        balance.font = FONT_BS(14);
        [_balanceView addSubview:balance];
        [balance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(@0);
        }];
        
        
        UILabel *rmLbl = [UILabel new];
        rmLbl.textColor = [UIColor whiteColor];
        rmLbl.font = FONT_BS(24);
        rmLbl.text = @"RM ";
        self.rmLbl = rmLbl;
        [_balanceView addSubview:rmLbl];
        [rmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(balance.mas_bottom).offset(4);
        }];
        
        // 过期时间
        UILabel *expir1 = [UILabel new];
        expir1.font =  FONT_S(14);
        expir1.textColor = [UIColor hjp_colorWithHex:@"ffffff" alpha:0.5];
        self.expir1 = expir1;
        [_balanceView addSubview:expir1];
        [expir1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(rmLbl.mas_bottom).offset(4);
        }];
        
        UILabel *expir2 = [UILabel new];
        expir2.font =  FONT_S(16);
        expir2.textColor = [UIColor hjp_colorWithHex:@"ffffff"];
        self.expir2 = expir2;
        [_balanceView addSubview:expir2];
        [expir2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(expir1.mas_trailing).offset(10);
            make.centerY.equalTo(expir1.mas_centerY);
        }];
    }
    return _balanceView;
}

- (UIView *)rmView {
    if(!_rmView) {
        _rmView = [UIView new];
        
        UILabel *rm = [UILabel new];
        rm.text = @"RM";
        [_rmView addSubview:rm];
        [rm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(@0);
        }];
        
        // 过期时间
        UILabel *expir1 = [UILabel new];
        expir1.font =  FONT_S(14);
        expir1.textColor = [UIColor hjp_colorWithHex:@"ffffff" alpha:0.5];
        expir1.text = @"Balance Expires on ";
        [_rmView addSubview:expir1];
        [expir1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(rm.mas_bottom).offset(4);
        }];
        
        UILabel *expir2 = [UILabel new];
        expir2.font =  FONT_S(14);
        expir2.textColor = [UIColor hjp_colorWithHex:@"ffffff"];
        [_rmView addSubview:expir2];
        [expir2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(expir1.mas_trailing).offset(2);
            make.centerY.equalTo(expir1.mas_centerY);
        }];
    }
    return _rmView;
}


// 流量球
- (DCTMDBScrollView *)progressView {
    if(!_progressView) {
        _progressView = [[DCTMDBScrollView alloc]init];
    }
    return _progressView;
}
@end

//============= DCTMDDBRegisterView ============
@interface DCTMDDBRegisterView()
@end
@implementation DCTMDDBRegisterView
@end


//============= DCFWBView ============

@interface OperationBtnView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *valLab;
@end

@implementation OperationBtnView

- (id)init {
    self = [super init];
    if (self) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.imgView];
    [self addSubview:self.titleLab];
    [self addSubview:self.valLab];
}

- (void)layoutUI {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@32);
        make.height.equalTo(@32);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(20);
    }];
    
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(8);
        make.height.equalTo(@18);
        make.left.mas_equalTo(self.imgView.mas_right).offset(8);
        make.right.mas_equalTo(self.mas_right).offset(-5);
    }];
    
    [self.valLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLab.mas_left).offset(0);
        make.height.equalTo(@18);
        make.right.mas_equalTo(self.mas_right).offset(-5);
        make.top.mas_equalTo(self.titleLab.mas_bottom).offset(0);
    }];
}

#pragma mark --lazy load
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_S(11);
        _titleLab.textColor = DC_UIColorFromRGB(0x545454);
        _titleLab.numberOfLines = 0;
        _titleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLab;
}

- (UILabel *)valLab {
    if (!_valLab) {
        _valLab = [[UILabel alloc] init];
        _valLab.font = FONT_BS(12);
        _valLab.textColor = DC_UIColorFromRGB(0x222222);
        _valLab.numberOfLines = 0;
        _valLab.textAlignment = NSTextAlignmentLeft;
    }
    return _valLab;
}

@end

// ****************** 顶部banner ******************

@interface TopbannerView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic, strong) UIImageView *swithImgView;
@end

@implementation TopbannerView

- (id)init {
    self = [super init];
    if (self) {
        [self initUI];
        [self layoutUI];
    }
    return self;
}

- (void)initUI {
    [self addSubview:self.imgView];
    [self addSubview:self.numberLab];
    [self addSubview:self.swithImgView];
}

- (void)layoutUI {
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@24);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(8);
    }];
    
    [self.swithImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@18);
        make.width.equalTo(@18);
        make.right.mas_equalTo(self.mas_right).offset(-8);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.numberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.left.mas_equalTo(self.imgView.mas_right).offset(2);
        make.right.mas_equalTo(self.swithImgView.mas_left).offset(-2);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
}

#pragma mark --lazy load
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIImageView *)swithImgView {
    if (!_swithImgView) {
        _swithImgView = [[UIImageView alloc] init];
        _swithImgView.tag = 40001;
        _swithImgView.userInteractionEnabled = YES;
    }
    return _swithImgView;
}

- (UILabel *)numberLab {
    if (!_numberLab) {
        _numberLab = [[UILabel alloc] init];
        _numberLab.font = FONT_BS(17);
        _numberLab.textColor = DC_UIColorFromRGB(0x3868FF);
        _numberLab.textAlignment = NSTextAlignmentLeft;
    }
    return _numberLab;
}

@end


@interface DCFWBView ()

@property (nonatomic, strong) UIView *bakView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) OperationBtnView *leftBottomView;
@property (nonatomic, strong) OperationBtnView *rightBottomView;
// 顶部长条bannner
@property (nonatomic, strong) TopbannerView *topbannerView;
// main view
@property (nonatomic, strong) UIImageView *mainImgView;
@property (nonatomic, strong) UILabel *balanceTitleLab;
@property (nonatomic, strong) UILabel *balanceValLab;
@property (nonatomic, strong) UILabel *expiresOnNameLab;
@property (nonatomic, strong) UILabel *expiresOnValLab;
@property (nonatomic, strong) UILabel *name1TitleLab;
@property (nonatomic, strong) UILabel *name2TitleLab;
@property (nonatomic, strong) UILabel *name1ValLab;
@property (nonatomic, strong) YYLabel *name2ValLab;
@end

@implementation DCFWBView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]){
        [self configView];
    }
    return self;
}

// 页面初始化 创建  布局
- (void)configView {
    // 大背景
    [self addSubview:self.bakView];
    [self.bakView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@16);
        make.trailing.equalTo(@-16);
        make.top.equalTo(@12);
        make.bottom.equalTo(@0);
    }];
    
    // 底部的bottom 按钮区域
    [self.bakView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.equalTo(@58);
    }];
    
    // 分割线
    [self.bottomView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@36);
        make.width.equalTo(@1);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
    }];
    
    // 底部两个按钮
    [self.bottomView addSubview:self.leftBottomView];
    [self.leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(@0);
        make.right.mas_equalTo(self.lineView.mas_left).offset(0);
    }];
    
    [self.bottomView addSubview:self.rightBottomView];
    [self.rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0);
        make.left.mas_equalTo(self.lineView.mas_right).offset(0);
    }];
    // 顶部长条banner
    [self addSubview:self.topbannerView];
    [self.topbannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(0);
        make.right.mas_equalTo(self.bakView.mas_right);
        make.height.equalTo(@36);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    // 主显示区域
    [self.bakView addSubview:self.mainImgView];
    [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(@0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
//        make.height.equalTo(@(148+17));
    }];
    
    [self.mainImgView addSubview:self.balanceTitleLab];
    [self.balanceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.top.equalTo(@12);
        make.height.equalTo(@22);
        make.right.mas_equalTo(self.topbannerView.mas_left).offset(5);
    }];
    
    [self.mainImgView addSubview:self.balanceValLab];
    [self.balanceValLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceTitleLab.mas_left);
        make.top.mas_equalTo(self.balanceTitleLab.mas_bottom).offset(0);
        make.height.equalTo(@36);
        make.width.greaterThanOrEqualTo(@100);
    }];
    
    [self.mainImgView addSubview:self.expiresOnValLab];
    [self.expiresOnValLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topbannerView.mas_bottom).offset(23);
        make.height.equalTo(@22);
        make.right.mas_equalTo(self.mainImgView.mas_right).offset(-16);
        make.width.greaterThanOrEqualTo(@80);
    }];
    
    [self.mainImgView addSubview:self.expiresOnNameLab];
    [self.expiresOnNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.expiresOnValLab.mas_left).offset(2);
        make.top.mas_equalTo(self.expiresOnValLab.mas_top);
        make.height.equalTo(@22);
        make.width.greaterThanOrEqualTo(@70);
    }];
    
    UIView *hLineView = [[UIView alloc] init];
    hLineView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
    hLineView.alpha = 0.2;
    [self.mainImgView addSubview:hLineView];
    [hLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceValLab.mas_left);
        make.right.mas_equalTo(self.mainImgView.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.top.mas_equalTo(self.expiresOnValLab.mas_bottom).offset(13);
    }];
    
    [self.mainImgView addSubview:self.name1TitleLab];
    [self.name1TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceValLab.mas_left);
        make.height.equalTo(@22);
        make.top.mas_equalTo(hLineView.mas_bottom).offset(12);
        make.width.equalTo(@66);
    }];
    
    [self.mainImgView addSubview:self.name2TitleLab];
    [self.name2TitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.balanceValLab.mas_left);
        make.height.equalTo(@22);
        make.top.mas_equalTo(self.name1TitleLab.mas_bottom).offset(8);
        make.width.equalTo(@66);
    }];
    
    [self.mainImgView addSubview:self.name1ValLab];
    [self.name1ValLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name1TitleLab.mas_right).offset(16);
        make.height.equalTo(@22);
        make.top.mas_equalTo(self.name1TitleLab.mas_top);
        make.right.mas_equalTo(self.mainImgView.mas_right).offset(-16);
    }];
    
    [self.mainImgView addSubview:self.name2ValLab];
    [self.name2ValLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.name1ValLab.mas_left);
        make.height.greaterThanOrEqualTo(@22);
        make.top.mas_equalTo(self.name2TitleLab.mas_top);
        make.right.mas_equalTo(self.mainImgView.mas_right).offset(-16);
    }];
    
    [self.bakView bringSubviewToFront:self.topbannerView];
    // 设置圆角
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self rounderWithCorners:UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerTopLeft radius:12 toView:self.topbannerView];
    });
}

- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel {
    NSMutableDictionary *dic = cellModel.customData;
    CompositionProps *propsDic = cellModel.props;

    NSString *mainPlanVal = [dic objectForKey:@"MainPlan"];
    
    // 底部
    NSString *upLoadVal = [dic objectForKey:@"upLoadVal"];
    NSString *downLoadVal = [dic objectForKey:@"downLoadVal"];
    self.leftBottomView.valLab.text = [NSString stringWithFormat:@"%@",downLoadVal];
    self.rightBottomView.valLab.text = [NSString stringWithFormat:@"%@",upLoadVal];
    self.leftBottomView.titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_download_speed"];
    self.rightBottomView.titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_upload_speed"];
    
    if (!DC_IsStrEmpty(propsDic.speedStaticColor)) {
        UIColor *color = [UIColor colorWithHexString:propsDic.speedStaticColor];
        self.leftBottomView.titleLab.textColor = color;
        self.rightBottomView.titleLab.textColor = color;
    }
    if (!DC_IsStrEmpty(propsDic.speedStaticColorOpacity)) {
        CGFloat alpha = [propsDic.speedStaticColorOpacity floatValue]/100;
        self.leftBottomView.titleLab.alpha = alpha;
        self.rightBottomView.titleLab.alpha = alpha;
    }
    if (!DC_IsStrEmpty(propsDic.speedInfoColor)) {
        UIColor *color = [UIColor colorWithHexString:propsDic.speedInfoColor];
        self.leftBottomView.valLab.textColor = color;
        self.rightBottomView.valLab.textColor = color;
    }
    if (!DC_IsStrEmpty(propsDic.speedInfoColorOpacity)) {
        CGFloat alpha = [propsDic.speedInfoColorOpacity floatValue]/100;
        self.leftBottomView.valLab.alpha = alpha;
        self.rightBottomView.valLab.alpha = alpha;
    }
    if (!DC_IsStrEmpty(propsDic.speedBgColor)) { // 底部颜色通过设置大背景
        UIColor *color = [UIColor colorWithHexString:propsDic.speedBgColor];
        self.bakView.backgroundColor = color;
    }
    if (!DC_IsStrEmpty(propsDic.speedBgColorOpacity)) {
        CGFloat alpha = [propsDic.speedBgColorOpacity floatValue]/100;
        self.bakView.alpha = alpha;
    }
    // 上传
    NSArray <UploadIconItem *>*uploadIconList = propsDic.uploadIcon;
    if (DC_IsArrEmpty(uploadIconList)) {
        self.rightBottomView.imgView.image = DC_image(@"pb_uploadload_speed");
    } else {
        UploadIconItem *item = [uploadIconList objectAtIndex:0];
        [self.rightBottomView.imgView sd_setImageWithURL:[NSURL URLWithString:item.src] placeholderImage:DC_image(@"pb_uploadload_speed") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
    // 下载
    NSArray <DownloadIconItem *>*downloadIconList = propsDic.downloadIcon;
    if (DC_IsArrEmpty(downloadIconList)) {
        self.leftBottomView.imgView.image = DC_image(@"pb_download_speed");
    } else {
        DownloadIconItem *item = [downloadIconList objectAtIndex:0];
        [self.leftBottomView.imgView sd_setImageWithURL:[NSURL URLWithString:item.src] placeholderImage:DC_image(@"pb_download_speed") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
    }
    
    // 底部速率View处理
    if ([downLoadVal isEqualToString:@"0"] && [upLoadVal isEqualToString:@"0"]) {
        // Download Speed、Upload Speed 如果都为空，则下面的条条隐藏
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        self.bottomView.clipsToBounds = YES;
    } else {
        // 如果有一个为空，则中间的竖线和对应的速率隐藏
        if ([downLoadVal isEqualToString:@"0"]) {
            // 下载为空，上传view 向右移动到左边显示
            self.rightBottomView.hidden = YES;
            self.lineView.hidden = YES;
            self.leftBottomView.valLab.text = [NSString stringWithFormat:@"%@",upLoadVal];
            self.leftBottomView.titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_upload_speed"];
            // 重设图标
            NSArray <UploadIconItem *>*uploadIconList = propsDic.uploadIcon;
            if (DC_IsArrEmpty(uploadIconList)) {
                self.leftBottomView.imgView.image = DC_image(@"pb_uploadload_speed");
            } else {
                UploadIconItem *item = [uploadIconList objectAtIndex:0];
                [self.leftBottomView.imgView sd_setImageWithURL:[NSURL URLWithString:item.src] placeholderImage:DC_image(@"pb_uploadload_speed") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                }];
            }
        } else if ([upLoadVal isEqualToString:@"0"]) {
            // 上传为空，则直接隐藏
            self.rightBottomView.hidden = YES;
            self.lineView.hidden = YES;
        } else {
            self.leftBottomView.hidden = NO;
            self.rightBottomView.hidden = NO;
            self.lineView.hidden = NO;
        }
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@58);
        }];
        self.bottomView.clipsToBounds = NO;
    }
    
    // 顶部banner
    NSArray <AccountIconItem *>*accountIconList = propsDic.accountIcon;
    if (!DC_IsStrEmpty(propsDic.accountNumColor)) {// 号码文本的颜色
        self.topbannerView.numberLab.textColor = [UIColor colorWithHexString:propsDic.accountNumColor];
    }
    if (!DC_IsStrEmpty(propsDic.accountNumColorOpacity)) { // 文本的透明度
        self.topbannerView.numberLab.alpha = [propsDic.accountNumColorOpacity floatValue] /100;
    }
    if (!DC_IsStrEmpty(propsDic.accountInfoBgColor)) {// 背景色
        self.topbannerView.backgroundColor = [UIColor colorWithHexString:propsDic.accountInfoBgColor];
    }
    if (!DC_IsStrEmpty(propsDic.accountInfoBgColorOpacity)) { // 透明度
        self.topbannerView.alpha = [propsDic.accountInfoBgColorOpacity floatValue]/100;
    }
    if (DC_IsArrEmpty(accountIconList)) {
        self.topbannerView.imgView.image = DC_image(@"pb_topBanner_icon");
    } else {
        AccountIconItem *item = [accountIconList objectAtIndex:0];
        [self.topbannerView.imgView sd_setImageWithURL:[NSURL URLWithString:item.src] placeholderImage:DC_image(@"pb_topBanner_icon") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        }];
        
        self.topbannerView.swithImgView.image = DC_image(@"pb_topbanner_Switch");
        self.topbannerView.swithImgView.hidden = NO;
        // 如果只有一个，那么隐藏切换按钮
        NSArray *subList = [DXPPBDataManager shareInstance].subsListModel.subsList;
        if (subList.count <= 1) {
            self.topbannerView.swithImgView.hidden = YES;
        }
        self.topbannerView.numberLab.text = DC_IsStrEmpty([DXPPBDataManager shareInstance].selectedSubsModel.accNbr)?@"":[DXPPBDataManager shareInstance].selectedSubsModel.accNbr;
    }
    
    // 主view
    if (!DC_IsStrEmpty(propsDic.dashTextColor)) {
        UIColor *color = [UIColor colorWithHexString:propsDic.dashTextColor];
        self.balanceTitleLab.textColor = color;
        self.expiresOnNameLab.textColor = color;
        self.name1TitleLab.textColor = color;
        self.name2TitleLab.textColor = color;
    }
    if (!DC_IsStrEmpty(propsDic.dashTextColorOpacity)) {
        CGFloat alpha = [propsDic.dashTextColorOpacity floatValue]/100;
        self.balanceTitleLab.alpha = alpha;
        self.expiresOnNameLab.alpha = alpha;
        self.name1TitleLab.alpha = alpha;
        self.name2TitleLab.alpha = alpha;
    }
    if (!DC_IsStrEmpty(propsDic.subInfoColor)) {
        UIColor *color = [UIColor colorWithHexString:propsDic.subInfoColor];
        self.balanceValLab.textColor = color;
        self.expiresOnValLab.textColor = color;
        self.name1ValLab.textColor = color;
        self.name2ValLab.textColor = color;
    }
    if (!DC_IsStrEmpty(propsDic.subInfoColorOpacity)) {
        CGFloat alpha = [propsDic.subInfoColorOpacity floatValue]/100;
        self.balanceValLab.alpha = alpha;
        self.expiresOnValLab.alpha = alpha;
        self.name1ValLab.alpha = alpha;
        self.name2ValLab.alpha = alpha;
    }
    if ([[propsDic.bgType lowercaseString] isEqualToString:@"image"]) {
        // 背景图片
        if (DC_IsStrEmpty(propsDic.bgImg.src)) {
            _mainImgView.image = DC_image(@"pb_FWB_Main");
        } else {
            [self.mainImgView sd_setImageWithURL:[NSURL URLWithString:propsDic.bgImg.src] placeholderImage:DC_image(@"pb_FWB_Main") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            }];
        }
    } else {
        // 背景颜色
        self.mainImgView.backgroundColor = [UIColor colorWithHexString:propsDic.bgColor];
    }

    // 赋值
    NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
    if ([paidFlag isEqualToString:@"1"]) {
        // 后付费
        self.balanceTitleLab.text =  [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_outstanding_Bill"];
    } else {
        // 预付费
        self.balanceTitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_my_balance"];
    }
    
    NSString *effDate = [dic objectForKey:@"effDate"];
    NSString *money = [dic objectForKey:@"money"];
    NSString *balanceVal;
    if ([money intValue] == 0 && [paidFlag isEqualToString:@"1"]) {
        balanceVal = [[HJLanguageManager shareInstance] getTextByKey:@"lb_no_outstanding_bills"];
    } else {
        balanceVal = [NSString stringWithFormat:@"RM %@",!DC_IsStrEmpty(money) ? money : @"--"];
    }
    self.balanceValLab.text = [NSString stringWithFormat:@"%@",balanceVal];
    self.expiresOnNameLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_balance_expires_on"];
    self.expiresOnValLab.text = [NSString stringWithFormat:@" %@", !DC_IsStrEmpty(effDate) ? [self dueFormatterDateWithString:effDate] : @"--"];
    if ([money intValue] == 0) {
        self.expiresOnNameLab.hidden = YES;
        self.expiresOnValLab.hidden = YES;
    } else {
        self.expiresOnNameLab.hidden = NO;
        self.expiresOnValLab.hidden = NO;
    }
    self.name1TitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_main_plan"];
    self.name2TitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_address"];
    self.name1ValLab.text = mainPlanVal;
    // 赋值name2Val
    NSString *address = DC_IsStrEmpty([dic objectForKey:@"Address"])?@"":[dic objectForKey:@"Address"];
    NSMutableAttributedString *attri_str = [[NSMutableAttributedString alloc] initWithString:address];
    attri_str.yy_minimumLineHeight = 22;
    [attri_str setYy_lineSpacing:0];
    [attri_str setYy_font:FONT_S(14)];
    [attri_str setYy_color:DC_UIColorFromRGB(0xFFFFFF)];
    [attri_str setYy_alignment:NSTextAlignmentLeft];
    YYTextContainer *containerC = [YYTextContainer containerWithSize:CGSizeMake(DC_DCP_SCREEN_WIDTH - 16*5 - 66, CGFLOAT_MAX)];
    YYTextLayout *layoutC = [YYTextLayout layoutWithContainer:containerC text:attri_str];
    self.name2ValLab.textLayout = layoutC;
    [self.name2ValLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layoutC.textBoundingSize.height);
    }];
    self.name2ValLab.attributedText = attri_str;
}

- (void)tapAction:(UIGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag;
    if (tag == 20001) {
        // 左边 下行速度
    }
    if (tag == 30001) {
        // 右边 上行速度
    }
    if (tag == 40001) {
        [self exchageBtnAction];
    }
}

// 切换账号
- (void)exchageBtnAction {
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = @"EXCHANDE_NUM";
    model.floorEventType = DCFloorEventCustome;
    [self hj_routerEventWith:model];
}

//  时间转换
- (NSString*)dueFormatterDateWithString:(NSString*)dueDate {
    //
    NSString *monthStr = @"";
    NSString *yearStr = @"";
    NSString *dayStr = @"";
    
    if (dueDate.length >= 8) {
        yearStr = [dueDate substringToIndex:4];
        monthStr = [dueDate substringWithRange:NSMakeRange(4, 2)];
        dayStr =  [dueDate substringWithRange:NSMakeRange(6, 2)];
        
        NSDictionary *monthUSDic = @{@"01":@"Jan",@"02":@"Feb",@"03":@"Mar",@"04":@"Apr",@"05":@"May",@"06":@"Jun",@"07":@"Jul",@"08":@"Aug",@"09":@"Sep",@"10":@"Oct",@"11":@"Nov",@"12":@"Dec"};
        return  [NSString stringWithFormat:@"%@ %@ %@",dayStr , [monthUSDic objectForKey:monthStr]?:@"", yearStr];
    }
    return  @"";
}

#pragma mark -- lazy load
- (UIView *)bakView {
    if (!_bakView) {
        _bakView = [[UIView alloc] init];
        _bakView.layer.cornerRadius = 16;
        _bakView.backgroundColor = DC_UIColorFromRGB(0xEBF0FF);
    }
    return _bakView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = DC_UIColorFromRGB(0x3868FF);
    }
    return _lineView;
}

- (OperationBtnView *)leftBottomView {
    if (!_leftBottomView) {
        _leftBottomView = [[OperationBtnView alloc] init];
        _leftBottomView.tag = 20001;
        [_leftBottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    }
    return _leftBottomView;
}

- (OperationBtnView *)rightBottomView {
    if (!_rightBottomView) {
        _rightBottomView = [[OperationBtnView alloc] init];
        _rightBottomView.tag = 30001;
        [_rightBottomView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    }
    return _rightBottomView;
}

- (UIImageView *)mainImgView {
    if (!_mainImgView) {
        _mainImgView = [[UIImageView alloc] init];
        _mainImgView.contentMode = UIViewContentModeScaleToFill;
        _mainImgView.layer.cornerRadius = 6.f;
    }
    return _mainImgView;
}

// my Balance标题
- (UILabel *)balanceTitleLab {
    if (!_balanceTitleLab) {
        _balanceTitleLab = [[UILabel alloc] init];
        _balanceTitleLab.font = FONT_S(14);
        //        _balanceTitleLab.text = @"My Balance";
        _balanceTitleLab.textColor = DC_UIColorFromRGB(0xB0C3FF);
        _balanceTitleLab.numberOfLines = 0;
        _balanceTitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _balanceTitleLab;
}

- (TopbannerView *)topbannerView {
    if (!_topbannerView) {
        _topbannerView = [[TopbannerView alloc] init];
        _topbannerView.backgroundColor = DC_UIColorFromRGB(0xD7E1FF);
        [_topbannerView.swithImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    }
    return _topbannerView;
}

- (UILabel *)balanceValLab {
    if (!_balanceValLab) {
        _balanceValLab = [[UILabel alloc] init];
        _balanceValLab.font = FONT_BS(24);
        _balanceValLab.textColor = DC_UIColorFromRGB(0xFFFFFF);
        _balanceValLab.textAlignment = NSTextAlignmentLeft;
    }
    return _balanceValLab;
}
    
- (UILabel *)expiresOnNameLab {
    if (!_expiresOnNameLab) {
        _expiresOnNameLab = [[UILabel alloc] init];
        _expiresOnNameLab.font = FONT_S(14);
        _expiresOnNameLab.text = @"Expires on ";
        _expiresOnNameLab.textColor = DC_UIColorFromRGB(0xB0C3FF);
        _expiresOnNameLab.numberOfLines = 0;
        _expiresOnNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _expiresOnNameLab;
}

- (UILabel *)expiresOnValLab {
    if (!_expiresOnValLab) {
        _expiresOnValLab = [[UILabel alloc] init];
        _expiresOnValLab.font = FONT_S(14);
        _expiresOnValLab.textColor = DC_UIColorFromRGB(0xFFFFFF);
        _expiresOnValLab.textAlignment = NSTextAlignmentLeft;
    }
    return _expiresOnValLab;
}

- (UILabel *)name1TitleLab {
    if (!_name1TitleLab) {
        _name1TitleLab = [[UILabel alloc] init];
        _name1TitleLab.font = FONT_S(14);
        _name1TitleLab.textColor = DC_UIColorFromRGB(0xB0C3FF);
        _name1TitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _name1TitleLab;
}

- (UILabel *)name2TitleLab {
    if (!_name2TitleLab) {
        _name2TitleLab = [[UILabel alloc] init];
        _name2TitleLab.font = FONT_S(14);
        _name2TitleLab.textColor = DC_UIColorFromRGB(0xB0C3FF);
        _name2TitleLab.textAlignment = NSTextAlignmentLeft;
    }
    return _name2TitleLab;
}

- (UILabel *)name1ValLab {
    if (!_name1ValLab) {
        _name1ValLab = [[UILabel alloc] init];
        _name1ValLab.font = FONT_S(14);
        _name1ValLab.textColor = DC_UIColorFromRGB(0xFFFFFF);
        _name1ValLab.textAlignment = NSTextAlignmentLeft;
    }
    return _name1ValLab;
}

- (YYLabel *)name2ValLab {
    if (!_name2ValLab) {
        _name2ValLab = [[YYLabel alloc] init];
        _name2ValLab.numberOfLines = 0;
        _name2ValLab.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _name2ValLab;
}

#pragma mark -- other
- (void)rounderWithCorners:(UIRectCorner)corners radius:(CGFloat)radius toView:(UIView *)toView {
    [toView.superview layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:toView.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskPath.CGPath;
    toView.layer.mask = maskLayer;
}
@end





@interface DownContentView : UIView

@property (nonatomic, strong) HJDitoProgress *progrssView1;
@property (nonatomic, strong) HJDitoProgress *progrssView2;
@property (nonatomic, strong) HJDitoProgress *progrssView3;
@end

@implementation DownContentView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.progrssView1];
	[self addSubview:self.progrssView2];
	[self addSubview:self.progrssView3];
}

- (void)layoutUI {
	[self.progrssView1 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_top).offset(2);
		make.leading.equalTo(@0);
		make.width.equalTo(@((DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3));
		make.height.equalTo(@92);
	}];
	
	[self.progrssView2 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_top).offset(2);
		make.leading.equalTo(@((DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3 + 9));
		make.width.equalTo(@((DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3));
		make.height.equalTo(@92);
	}];
	
	[self.progrssView3 mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.equalTo(self.mas_top).offset(2);
		make.leading.equalTo(@((DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3 * 2 + 9*2));
		make.width.equalTo(@((DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3));
		make.height.equalTo(@92);
	}];
}

#pragma mark - lazy load
- (HJDitoProgress *)progrssView1 {
	if (!_progrssView1) {
		_progrssView1 = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, (DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3, 92)];
	}
	return _progrssView1;
}

- (HJDitoProgress *)progrssView2 {
	if (!_progrssView2) {
		_progrssView2 = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, (DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3, 92)];
	}
	return _progrssView2;
}

- (HJDitoProgress *)progrssView3 {
	if (!_progrssView3) {
		_progrssView3 = [[HJDitoProgress alloc]initWithFrame:CGRectMake(0, 0, (DC_DCP_SCREEN_WIDTH - 16*2 - 12*2 - 9*2)/3, 92)];
	}
	return _progrssView3;
}

@end


@interface PointView :UIView

@property (nonatomic, strong) UIImageView *iconImgView; // icon
@property (nonatomic, strong) UILabel *pointValueLab; // 积分值
@property (nonatomic, strong) UIImageView *arrowImgView; // 箭头图标
@end

@implementation PointView

- (id)init {
	self = [super init];
	if (self) {
		[self initUI];
		[self layoutUI];
	}
	return self;
}

- (void)initUI {
	[self addSubview:self.iconImgView];
	[self addSubview:self.pointValueLab];
	[self addSubview:self.arrowImgView];
}

- (void)layoutUI {
	[self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(16);
		make.centerY.mas_equalTo(self.mas_centerY);
		make.trailing.mas_equalTo(self.mas_trailing).offset(0);
	}];
	
	[self.pointValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.mas_equalTo(self.mas_centerY);
		make.trailing.mas_equalTo(self.arrowImgView.mas_leading).offset(-4);
		make.height.mas_equalTo(18);
	}];
	
	[self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(20);
		make.centerY.mas_equalTo(self.mas_centerY);
		make.trailing.mas_equalTo(self.pointValueLab.mas_leading).offset(-4);
	}];
}

#pragma mark - lazy load
- (UIImageView *)iconImgView {
	if (!_iconImgView) {
		_iconImgView = [[UIImageView alloc] init];
		_iconImgView.image = DC_image(@"ic_point_logo");
	}
	return _iconImgView;
}

- (UILabel *)pointValueLab {
	if (!_pointValueLab) {
		_pointValueLab = [[UILabel alloc] init];
		_pointValueLab.text = @"Point ";
		_pointValueLab.textColor = DC_UIColorFromRGB(0x3868FF);
		_pointValueLab.font = FONT_S(12);
	}
	return _pointValueLab;
}

- (UIImageView *)arrowImgView {
	if (!_arrowImgView) {
		_arrowImgView = [[UIImageView alloc] init];
		_arrowImgView.image = DC_image(@"ic_point_detail");
	}
	return _arrowImgView;
}

@end


@interface DCDashboardSIMDataVoiceView ()

@property (nonatomic, strong) UIView *bakView;
@property (nonatomic, strong) UIView *contentView;
// 上区
@property (nonatomic, strong) UIView *upContentView;
@property (nonatomic, strong) UIImageView *iconImgView; // 手机图标
@property (nonatomic, strong) UILabel *phoneNumberLab; // 号码
@property (nonatomic, strong) UIButton *changeBtn; // 切换按钮
@property (nonatomic, strong) UIView *topMidLine; // 分割线
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *activeLbl;
@property (nonatomic, strong) PointView *pointView;
// 中区
@property (nonatomic, strong) UIView *midContentView;
@property (nonatomic, strong) UILabel *midTitleLab;
@property (nonatomic, strong) UILabel *expDateLab;
@property (nonatomic, strong) UILabel *moneyLab;
// 下区
@property (nonatomic, strong) DownContentView *downContentView;

@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelData;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelVoice;
@property (nonatomic, strong) DCMainBalanceSummaryItemModel *modelSMS;
@end

@implementation DCDashboardSIMDataVoiceView

- (instancetype)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame]){
		
//		self.backgroundColor = [UIColor redColor];
		[self configView];
	}
	return self;
}

// 页面初始化 创建  布局
- (void)configView {
	// 大背景
	[self addSubview:self.bakView];
	[self.bakView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@16);
		make.trailing.equalTo(@-16);
		make.top.equalTo(@12);
		make.bottom.equalTo(@0);
	}];
	// 内容背景
	[self.bakView addSubview:self.contentView];
	[self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(@12);
		make.trailing.equalTo(@-12);
		make.top.equalTo(@16);
		make.bottom.equalTo(@-16);
	}];
	// 上区
	[self.contentView addSubview:self.upContentView];
	[self.upContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.top.mas_equalTo(0);
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(20);
	}];
	
	[self.upContentView addSubview:self.iconImgView];
	[self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(20);
		make.top.mas_equalTo(1);
		make.leading.mas_equalTo(self.upContentView.mas_leading);
	}];
	
	[self.upContentView addSubview:self.phoneNumberLab];
	[self.phoneNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.mas_equalTo(22);
		make.top.mas_equalTo(0);
		make.leading.mas_equalTo(self.iconImgView.mas_trailing).offset(8);
	}];
	
	[self.upContentView addSubview:self.changeBtn];
	[self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(20);
		make.top.mas_equalTo(1);
		make.leading.mas_equalTo(self.phoneNumberLab.mas_trailing).offset(8);
	}];
	
	
	UIView *midLine = [UIView new];
	self.topMidLine = midLine;
	midLine.backgroundColor = [UIColor hjp_colorWithHex:@"#FFDFCC"];
	[self.upContentView addSubview:midLine];
	[midLine mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(self.changeBtn.mas_trailing).offset(8);
		make.centerY.equalTo(self.iconImgView.mas_centerY);
		make.width.equalTo(@1);
		make.height.equalTo(@16);
	}];
	
	
	// 状态文本
	UIView *dotView = [[UIView alloc] init];
	self.dotView = dotView;
	dotView.layer.cornerRadius = 2.f;
	[self.upContentView addSubview:dotView];
	[dotView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(midLine.mas_trailing).offset(8);
		make.centerY.equalTo(self.phoneNumberLab.mas_centerY);
		make.width.equalTo(@4);
		make.height.equalTo(@4);
	}];
	
	UILabel *activeLbl = [UILabel new];
	self.activeLbl = activeLbl;
	activeLbl.font = FONT_BS(14);
	[self.upContentView addSubview:activeLbl];
	[activeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.equalTo(dotView.mas_trailing).offset(4);
		make.centerY.equalTo(self.phoneNumberLab.mas_centerY);
	}];
	
	
	
	
	
//	[self.upContentView addSubview:self.pointView];
//	[self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.trailing.mas_equalTo(0);
//		make.height.mas_equalTo(22);
//		make.top.mas_equalTo(0);
//	}];

	// 分割线
	UIView *lineView = [[UIView alloc] init];
	[self.contentView addSubview:lineView];
	lineView.backgroundColor = DC_UIColorFromRGB(0xE6E6E6);
	[lineView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(1);
		make.top.mas_equalTo(self.upContentView.mas_bottom).offset(12);
	}];

	// 中区 金额区域
	[self.contentView addSubview:self.midContentView];
	[self.midContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18+4+26);
		make.top.mas_equalTo(lineView.mas_bottom).offset(12);
	}];
	
	[self.midContentView addSubview:self.midTitleLab];
	[self.midTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.midContentView.mas_top).offset(0);
	}];
	
	[self.midContentView addSubview:self.expDateLab];
	[self.expDateLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.trailing.mas_equalTo(0);
		make.height.mas_equalTo(18);
		make.top.mas_equalTo(self.midContentView.mas_top).offset(0);
	}];
	
	[self.midContentView addSubview:self.moneyLab];
	[self.moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.mas_equalTo(0);
		make.height.mas_equalTo(26);
		make.top.mas_equalTo(self.midTitleLab.mas_bottom).offset(4);
	}];

	// 下区 图标区域
	[self.contentView addSubview:self.downContentView];
	[self.downContentView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.leading.trailing.mas_equalTo(0);
		make.height.mas_equalTo(92);
		make.top.mas_equalTo(self.midContentView.mas_bottom).offset(12);
	}];
	
}

- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel {
	NSMutableDictionary *dic = cellModel.customData;
	CompositionProps *propsDic = cellModel.props;
	
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
		NSDictionary *propDic1 = [propsList objectAtIndex:0];
		DCMainBalanceSummaryItemModel *model2 = [list objectAtIndex:1];
		NSDictionary *propDic2 = [propsList objectAtIndex:1];
		DCMainBalanceSummaryItemModel *model3 = [list objectAtIndex:2];
		NSDictionary *propDic3 = [propsList objectAtIndex:2];
		
		// 构建数据 progressModel1
		HJDitoProgressModel *progressModel1 = [[HJDitoProgressModel alloc]initWithGross:model1.formatGrossBalance grossUnit:model1.formatGrossBalanceUnitName balance:model1.formatRealBalance balanceUnit:@"" type:model1.temp expire:@"" des:@"" btnName:@"" realBalance:model1.realBalance grossBalance:model1.grossBalance];
		[self.downContentView.progrssView1 updateWithModel:progressModel1 props:propDic1];
		// 构建数据 progressModel2
		HJDitoProgressModel *progressModel2 = [[HJDitoProgressModel alloc]initWithGross:model2.formatGrossBalance grossUnit:model2.formatGrossBalanceUnitName balance:model2.formatRealBalance balanceUnit:@"" type:model2.temp expire:@"" des:@"" btnName:@"" realBalance:model2.realBalance grossBalance:model2.grossBalance];
		[self.downContentView.progrssView2 updateWithModel:progressModel2 props:propDic2];
		
		// 构建数据 progressModel3
		HJDitoProgressModel *progressModel3 = [[HJDitoProgressModel alloc]initWithGross:model3.formatGrossBalance grossUnit:model3.formatGrossBalanceUnitName balance:model3.formatRealBalance balanceUnit:@"" type:model3.temp expire:@"" des:@"" btnName:@"" realBalance:model3.realBalance grossBalance:model3.grossBalance];
		[self.downContentView.progrssView3 updateWithModel:progressModel3 props:propDic3];
	}
	
	// 中间数据
	NSString *paidFlag = [DXPPBDataManager shareInstance].selectedSubsModel.paidFlag; // 是否后付费
	if ([paidFlag isEqualToString:@"1"]) {
		// 后付费
		self.midTitleLab.text =  [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_bill_amount_due"];
	} else {
		// 预付费
		self.midTitleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_bill_to_be_paid"];
	}
	
	NSString *effDate = [dic objectForKey:@"effDate"];
	NSString *money = [dic objectForKey:@"money"];
	NSString *balanceVal;
	if ([money intValue] == 0 && [paidFlag isEqualToString:@"1"]) {
		balanceVal = [[HJLanguageManager shareInstance] getTextByKey:@"lb_no_outstanding_bills"];
	} else {
		balanceVal = [NSString stringWithFormat:@" %@",!DC_IsStrEmpty(money) ? money : @"--"];
	}
	self.moneyLab.text = [NSString stringWithFormat:@"%@%@", [DXPPBConfigManager shareInstance].currencySymbol,balanceVal];
	self.expDateLab.text = [NSString stringWithFormat:@"%@ %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_before"] ,!DC_IsStrEmpty(effDate) ? [PbTools getDateFormatAppByProperty:effDate] : @"--"];
	if ([money intValue] == 0) {
		self.expDateLab.hidden = YES;
	} else {
		self.expDateLab.hidden = NO;
	}
	self.moneyLab.textColor = [UIColor colorWithHexString:propsDic.phoneNumberColor];
	self.expDateLab.textColor = [UIColor colorWithHexString:propsDic.balanceColor];
	
	// 最上面的数据
    NSDictionary *phoneIconDic = [propsDic.phoneIcon firstObject];
	[self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[phoneIconDic objectForKey:@"src"]] placeholderImage:DC_image(@"ic_phonenumber_icon")];
	
	NSDictionary *changeIconDic = [propsDic.changeIcon firstObject];
	[self.changeBtn sd_setImageWithURL:[NSURL URLWithString:[changeIconDic objectForKey:@"src"]] forState:UIControlStateNormal placeholderImage:DC_image(@"ic_change_phonenumber")];
	
	NSDictionary *pointsIconDic = [propsDic.pointsIcon firstObject];
	[self.pointView.iconImgView sd_setImageWithURL:[NSURL URLWithString:[pointsIconDic objectForKey:@"src"]] placeholderImage:DC_image(@"ic_point_logo")];
	
	self.phoneNumberLab.text = DC_IsStrEmpty([dic objectForKey:@"num"]) ? @"" : [dic objectForKey:@"num"];
	self.phoneNumberLab.textColor =  [UIColor colorWithHexString:propsDic.phoneNumberColor];
	
	// 订户状态
	NSString *state = [dic objectForKey:@"state"];
	NSString *stateName = [dic objectForKey:@"stateName"];
	if(!DC_IsStrEmpty(stateName)) {
		self.activeLbl.text = [PbTools getStateNameWithstateName:stateName
														 state:state
													  paidFlag:[DXPPBDataManager shareInstance].selectedSubsModel.paidFlag];
		
		self.activeLbl.textColor = [PbTools getStateColorWithstate:state];
		self.dotView.backgroundColor = self.activeLbl.textColor;
	} else {
		self.activeLbl.text = @"";
		[self.dotView removeFromSuperview];
	}
	// 判断是否展示
	if([DXPPBDataManager shareInstance].totalSubsArr.count <= 1) {
		self.changeBtn.hidden = YES;
		[self.topMidLine mas_makeConstraints:^(MASConstraintMaker *make) {
			make.leading.equalTo(self.phoneNumberLab.mas_trailing).offset(8);
		}];
	} else {
		self.changeBtn.hidden = NO;
	}
	
	
	// 积分
	
	NSString *pointVal = [NSString stringWithFormat:@"%@ %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_points"],[dic objectForKey:@"usablePoint"]];
	self.pointView.pointValueLab.text = pointVal;
	self.pointView.pointValueLab.textColor = [UIColor colorWithHexString:propsDic.pointsColor];

	// 是否隐藏point
	if (![[propsDic.showPoints lowercaseString] isEqualToString:@"y"]) {
		self.pointView.hidden = YES;
	}
}

// 切换订户
- (void)changeAction:(id)sender {
	DCFloorEventModel *model = [DCFloorEventModel new];
	model.link = @"EXCHANDE_NUM";
	model.floorEventType = DCFloorEventCustome;
	[self hj_routerEventWith:model];
}

#pragma mark -- lazy load
- (UIView *)bakView {
	if (!_bakView) {
		_bakView = [[UIView alloc] init];
		_bakView.layer.cornerRadius = 16;
		_bakView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
	}
	return _bakView;
}

- (UIView *)contentView {
	if (!_contentView) {
		_contentView = [[UIView alloc] init];
		_contentView.backgroundColor = DC_UIColorFromRGB(0xFFFFFF);
	}
	return _contentView;
}

- (UIView *)upContentView {
	if (!_upContentView) {
		_upContentView = [[UIView alloc] init];
//		_upContentView.backgroundColor = [UIColor redColor];
	}
	return _upContentView;
}

- (UIImageView *)iconImgView {
	if (!_iconImgView) {
		_iconImgView = [[UIImageView alloc] init];
		_iconImgView.image = DC_image(@"ic_phonenumber_icon");
	}
	return _iconImgView;
}

- (UILabel *)phoneNumberLab {
	if (!_phoneNumberLab) {
		_phoneNumberLab = [[UILabel alloc] init];
		_phoneNumberLab.textColor = DC_UIColorFromRGB(0x242424);
		_phoneNumberLab.textAlignment = NSTextAlignmentLeft;
		_phoneNumberLab.font = FONT_BS(14);
		_phoneNumberLab.text = @"";
	}
	return _phoneNumberLab;
}

- (UIButton *)changeBtn {
	if (!_changeBtn) {
		_changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[_changeBtn setImage:[UIImage imageNamed:@"ic_change_phonenumber"] forState:UIControlStateNormal];
		[_changeBtn addTarget:self action:@selector(changeAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _changeBtn;
}

- (PointView *)pointView {
	if (!_pointView) {
		_pointView = [[PointView alloc] init];
	}
	return _pointView;
}

- (UIView *)midContentView {
	if (!_midContentView) {
		_midContentView = [[UIView alloc] init];
		// _midContentView.backgroundColor = [UIColor yellowColor];
	}
	return _midContentView;
}

- (UILabel *)midTitleLab {
	if (!_midTitleLab) {
		_midTitleLab = [[UILabel alloc] init];
		_midTitleLab.textAlignment = NSTextAlignmentLeft;
		_midTitleLab.font = FONT_S(12);
		_midTitleLab.textColor = DC_UIColorFromRGB(0x242424);
		_midTitleLab.text = @"";
	}
	return _midTitleLab;
}

- (UILabel *)expDateLab {
	if (!_expDateLab) {
		_expDateLab = [[UILabel alloc] init];
		_expDateLab.textAlignment = NSTextAlignmentRight;
		_expDateLab.font = FONT_S(12);
		_expDateLab.textColor = DC_UIColorFromRGB(0x858585);
		_expDateLab.text = @"";
	}
	return _expDateLab;
}

- (UILabel *)moneyLab {
	if (!_moneyLab) {
		_moneyLab = [[UILabel alloc] init];
		_moneyLab.textAlignment = NSTextAlignmentRight;
		_moneyLab.font = FONT_BS(18);
		_moneyLab.textColor = DC_UIColorFromRGB(0x242424);
		_moneyLab.text = @"€";
	}
	return _moneyLab;
}

- (DownContentView *)downContentView{
	if (!_downContentView) {
		_downContentView = [[DownContentView alloc] init];
//		_downContentView.backgroundColor = [UIColor lightGrayColor];
	}
	return _downContentView;
}

@end
