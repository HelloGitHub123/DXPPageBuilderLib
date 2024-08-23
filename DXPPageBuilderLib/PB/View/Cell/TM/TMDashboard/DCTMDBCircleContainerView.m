//
//  DCTMDBCircleContainerView.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/8/25.
//

#import "DCTMDBCircleContainerView.h"

@interface DCTMDBCircleContainerView()
@property (nonatomic, strong) UIImageView *bgImgView1;
@property (nonatomic, strong) UIImageView *bgImgView2;

// 顶部View
@property (nonatomic, strong) UIImageView *alphaImgView;

@property (nonatomic, strong) UIView *topInfoView;
@property (nonatomic, strong) UILabel *numLbl;
@property (nonatomic, strong) UILabel *pointLbl;
// xx
@property (nonatomic, strong) UIView *balanceView;
// xx
@property (nonatomic, strong) UIView *rmView;
@property (nonatomic, strong) UILabel *rmLbl;
@property (nonatomic, strong) UILabel *expir2;
@property (nonatomic, strong) UILabel *expir1;

// DashBoard 容器
@property (nonatomic, strong) UIView *dashboardView;
@property (nonatomic, strong) UIView *rightContainer; //右边积分视图

// 流量球内容
@property (nonatomic, strong) DCTMDBScrollView *progressView;
@property (nonatomic, strong) DCTMDashboardCellModel *cellModel;

@property (nonatomic, strong) UIImageView *phoneIcon; // 手机照片
@property (nonatomic, strong) UIButton *changeBtn; // 手机照片

@end
@implementation DCTMDBCircleContainerView

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
    
    // ============  滚动流量球
    [self addSubview:self.progressView];
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@254);
    }];
}

- (void)bindWithModel:(DCTMDashboardCellModel *)cellModel {
    self.cellModel = cellModel;
    NSMutableDictionary *dic = cellModel.customData;
    NSString *num = [dic objectForKey:@"num"];
    if (!DC_IsStrEmpty(num)) {
        self.numLbl.text = num;
    }
    
    // 设置主题
    [self setThemeType:cellModel];
    [self.topInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@ ([@"3"  isEqualToString:cellModel.props.themeType] ?   6  : 0));
    }];
    
   
    
    self.rightContainer.hidden = YES;

    if([@"Y" isEqualToString:cellModel.props.showPoints] ) {
        self.rightContainer.hidden = NO;
        // 积分
        NSString *point = [dic objectForKey:@"usablePoint"] ?: @"";
        self.pointLbl.text = [DCPBManager stringFormatToThreeBit:point];
    }
    
    NSString *paidFlag = [dic objectForKey:@"paidFlag"];
    if(paidFlag){
        if([@"1" isEqualToString:paidFlag]) {
            self.expir1.text = @"Balance Expires on";
        }else {
            self.expir1.text = @"Expires on";
        }
    }
    
    // 日期
    NSString *effDate = [dic objectForKey:@"effDate"];
    if (!DC_IsStrEmpty(effDate)) {
        self.expir2.text = [self dueFormatterDateWithString:effDate];
    }else {  // 如果没有文案 就置空
        self.expir2.text = @"";
        self.expir1.text = @"";
    }
    
    // 价格
    NSString *money = [dic objectForKey:@"money"];
    if(DC_IsStrEmpty(money)) {
//        self.rmLbl.text = @"No Outstanding Bills";
		self.rmLbl.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_no_outstanding_bills"];
    }else {
        self.rmLbl.text = [NSString stringWithFormat:@"RM %@",!DC_IsStrEmpty(money) ? money : @"--"];
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
    NSString *num = @"1";
    if(!DC_IsStrEmpty(cellModel.props.themeType)) {
        self.bgImgView1.image = [UIImage imageNamed:[NSString stringWithFormat:@"db_bg_%@_top",cellModel.props.themeType]];
        self.bgImgView2.image = [UIImage imageNamed:[NSString stringWithFormat:@"db_bg_%@_down",cellModel.props.themeType]];
        self.alphaImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pb_tm_db_mask%@",cellModel.props.themeType]];
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

- (UIView *)topInfoView {
    if(!_topInfoView) {
        _topInfoView = [UIView new];
        UIImageView *phoneImg = [UIImageView new];
        
        // phone img
        phoneImg.image = [UIImage imageNamed:@"pb_tm_phone_tag"];
        self.phoneIcon = phoneImg;
        [_topInfoView addSubview:phoneImg];
        [phoneImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@4);
            make.width.equalTo(@10);
            make.height.equalTo(@15);
            make.top.equalTo(@18);
        }];
        
        //
        UILabel *numLbl = [UILabel new];
        self.numLbl = numLbl;
        numLbl.font = FONT_BS(14);
        numLbl.text = @"********";
        numLbl.textColor = [UIColor whiteColor];
        [_topInfoView addSubview:numLbl];
        [numLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(phoneImg.mas_trailing).offset(5);
            make.centerY.equalTo(phoneImg.mas_centerY);
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
            make.width.height.equalTo(@18);
        }];
        
 
        //
        UIView *rightContainer = [UIView new];
        rightContainer.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pointTapAction)];;
        [rightContainer addGestureRecognizer:tap];
        self.rightContainer = rightContainer;
//        rightContainer.backgroundColor = [UIColor redColor];
//        rightContainer.backgroundColor = [UIColor hjp_colorWithHex:@"#211DE9" alpha:0.7];
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
//        balance.text = @"Bill Amount Due";
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
        expir2.font =  FONT_S(14);
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
        expir2.text = @"20/11/2022";
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
