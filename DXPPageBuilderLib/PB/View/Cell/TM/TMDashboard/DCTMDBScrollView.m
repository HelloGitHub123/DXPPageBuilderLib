//
//  DCTMDBScrollView.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/3/6.
//

#import "DCTMDBScrollView.h"
#import "DCBalanceDetailModel.h"
#import "DCMainBalanceSummaryModel.h"
#import "DCPB.h"

// ******************自定义view   滚动区域******************
@interface DCTMDBScrollView() <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) iCarousel *carousel;

// 单个cell
@property (nonatomic, strong) NSArray *viewArr;
@property (nonatomic, strong) DCTMDBScrollCell *scrollCell1;
@property (nonatomic, strong) DCTMDBScrollCell *scrollCell2;
@property (nonatomic, strong) DCTMDBScrollCell *scrollCell3;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) DCBalanceDetailItemModel *modelData;
@property (nonatomic, strong) DCBalanceDetailItemModel *modelVoice;
@property (nonatomic, strong) DCBalanceDetailItemModel *modelSMS;


@property (nonatomic, strong) NSString *themeType;

@property (nonatomic, weak) DCTMDashboardCellModel *cellModel;


@end

@implementation DCTMDBScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.viewArr = @[self.scrollCell2,self.scrollCell1,self.scrollCell3];
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.carousel];
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.equalTo(@0);
    }];
}

// 更新数据
- (void)bindWithModel:(DCTMDashboardCellModel*)cellModel {
    self.cellModel = cellModel;
    self.themeType = cellModel.props.themeType;
    NSMutableDictionary *dic = cellModel.customData;
    NSString *progressUpdate = [dic objectForKey:@"progressUpdate"];
    if ([progressUpdate boolValue]) {
        [dic setObject:@(NO) forKey:@"progressUpdate"];
        NSArray *arr = [dic objectForKey:@"progressData"] ?: @[];
        self.modelData = nil;
        self.modelVoice = nil;
        self.modelSMS = nil;
        
        if ([arr isKindOfClass:[NSArray class]]) {
            for (DCBalanceDetailItemModel * model in arr) {
                if ([model.unitTypeId intValue] == 1) {//data
                    self.modelData  = model;
                }else if ([model.unitTypeId intValue] == 2) {//voice
                    self.modelVoice  = model;
                }else if ([model.unitTypeId intValue] == 3) {//sms
                    self.modelSMS = model;
                }
            }
        }
        
        
        [self.carousel reloadData];
    }
}

#pragma mark -- 私有
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return self.viewArr.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    DCTMDBScrollCell *cell = self.viewArr[index];
    switch (index) {
        case 0:
            [cell bindCellWithModel:self.modelSMS];
            break;
        case 1:
            [cell bindCellWithModel:self.modelData ];
            break;
        case 2:
           [cell bindCellWithModel:self.modelVoice];
            break;
        default:
            break;
    }
    [cell setCompositionProps:self.cellModel.props];
    return cell;
}

- (void)mybalanceAction:(NSInteger)index  itemModel:(DCBalanceDetailItemModel*)itemModel{
    if (index == 0 && self.cellModel.props.SMSAreaSetting) {
        //sms
        NSDictionary *dic = self.cellModel.props.SMSAreaSetting;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *SMSAreaType = dic[@"SMSAreaType"];
//            NSString *SMSAreaTypeId = dic[@"SMSAreaTypeId"];
            NSString *SMSAreaTypeUrl = dic[@"SMSAreaTypeUrl"];
            if (!DC_IsStrEmpty(SMSAreaType) && !DC_IsStrEmpty(SMSAreaTypeUrl)) {
                DCFloorEventModel *model = [DCFloorEventModel new];
                model.link = SMSAreaTypeUrl;
                model.linkType = SMSAreaType;
                model.floorEventType = DCFloorEventFloor;
                [self hj_routerEventWith:model];
                return;
            }
        }
    } else if (index == 1 && self.cellModel.props.dataAreaSetting) {
        //data
        NSDictionary *dic = self.cellModel.props.dataAreaSetting;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *dataAreaType = dic[@"dataAreaType"];
//            NSString *dataAreaTypeId = dic[@"dataAreaTypeId"];
            NSString *dataAreaTypeUrl = dic[@"dataAreaTypeUrl"];
            if (!DC_IsStrEmpty(dataAreaType) && !DC_IsStrEmpty(dataAreaTypeUrl)) {
                DCFloorEventModel *model = [DCFloorEventModel new];
                model.link = dataAreaTypeUrl;
                model.linkType = dataAreaType;
                model.floorEventType = DCFloorEventFloor;
                [self hj_routerEventWith:model];
                return;
            }
        }
    } else if (index == 2 && self.cellModel.props.voiceAreaSetting) {
        //voice
        NSDictionary *dic = self.cellModel.props.voiceAreaSetting;
        if ([dic isKindOfClass:[NSDictionary class]]) {
            NSString *voiceAreaType = dic[@"voiceAreaType"];
//            NSString *voiceAreaTypeId = dic[@"voiceAreaTypeId"];
            NSString *voiceAreaTypeUrl = dic[@"voiceAreaTypeUrl"];
            if (!DC_IsStrEmpty(voiceAreaType) && !DC_IsStrEmpty(voiceAreaTypeUrl)) {
                DCFloorEventModel *model = [DCFloorEventModel new];
                model.link = voiceAreaTypeUrl;
                model.linkType = voiceAreaType;
                model.floorEventType = DCFloorEventFloor;
                [self hj_routerEventWith:model];
                return;
            }
        }
    }
    
    DCFloorEventModel *model = [DCFloorEventModel new];
    model.link = @"/clp_mybalance/index";
    model.linkType = @"1";
    model.floorEventType = DCFloorEventFloor;
    [self hj_routerEventWith:model];
    
//    NSArray *arr = self.cellModel.props.infoList;
//    if (!IsArrEmpty(arr) && arr.count > index) {
//        NSDictionary *dic = arr[index];
//        NSString *link = @"/clp_my_balance/index";
//        CGFloat real = [itemModel.formatRealBalance floatValue];
//        if (real > 0 && !DC_IsStrEmpty([dic objectForKey:@"link"])) {
//            link = [dic objectForKey:@"link"];
//        }
//
//        DCFloorEventModel *model = [DCFloorEventModel new];
//        model.link = link;
//        model.linkType = @"1";
//        model.floorEventType = DCFloorEventFloor;
//        [self hj_routerEventWith:model];
//    }
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionSpacing:
            return 2;
            break;
            
        default:
            return value;
            break;
    }
}



- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [self mybalanceAction:index itemModel:self.modelSMS];
            break;
        case 1:
            [self mybalanceAction:index itemModel:self.modelData ];
            break;
        case 2:
            [self mybalanceAction:index itemModel:self.modelVoice ];
            break;
        default:
            break;
    }
}



// MARK: lazy
- (iCarousel *)carousel {
    if(!_carousel) {
        _carousel = [[iCarousel alloc] init];
        _carousel.viewpointOffset = CGSizeMake(0, -2);
        _carousel.dataSource = self;
        _carousel.delegate = self;
        _carousel.type = iCarouselTypeRotary;
        _carousel.pagingEnabled = YES;
        _carousel.perspective = - 0.0008; // - 0.002   - 0.005
        _carousel.scrollOffset = 100;
    }
    return _carousel;
}


- (NSMutableArray *)dataArray {
    if(!_dataArray){
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}


- (DCTMDBScrollCell *)scrollCell1 {
    if(!_scrollCell1) {
        _scrollCell1 = [[DCTMDBScrollCell alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
        _scrollCell1.cellType = DCTMDashboardCellData;
    }
    return _scrollCell1;
}

- (DCTMDBScrollCell *)scrollCell2 {
    if(!_scrollCell2) {
        _scrollCell2 = [[DCTMDBScrollCell alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
        _scrollCell2.cellType = DCTMDashboardCellSMS;
    }
    return _scrollCell2;
}

- (DCTMDBScrollCell *)scrollCell3 {
    if(!_scrollCell3) {
        _scrollCell3 = [[DCTMDBScrollCell alloc]initWithFrame:CGRectMake(0, 0, 180, 180)];
        _scrollCell3.cellType = DCTMDashboardCellVoice;
    }
    return _scrollCell3;
}
@end



// ******************自定义view   单个六边view******************

// ******************自定义view   单个六边view******************
@interface DCTMDBScrollCell()
@property (nonatomic, strong) UIImageView *bgImgView;
@property (nonatomic, strong) UIImageView *logoImgView;


@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UILabel *valueLbl;
@property (nonatomic, strong) UILabel *totalLbl;


@property (nonatomic, strong) UIImageView *unlimitedImgView; // 无线图标

@property (nonatomic, strong) UILabel *unlimitedLbl; // 无限量文本

@end


@implementation DCTMDBScrollCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configView];
    }
    return self;
}

- (void)configView {
    [self addSubview:self.bgImgView];
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(@-20);
        make.trailing.bottom.equalTo(@20);
    }];
    
    [self addSubview:self.typeLbl];
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(@2);
    }];
    
    
    [self addSubview:self.logoImgView];
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.width.height.equalTo(@44);
        make.bottom.equalTo(self.typeLbl.mas_top).offset(-10);
    }];
    
    
    [self addSubview:self.valueLbl];
    [self.valueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.typeLbl.mas_bottom).offset(2);
    }];
    
    [self addSubview:self.totalLbl];
    [self.totalLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.valueLbl.mas_bottom).offset(4);
    }];
    
    [self addSubview:self.unlimitedImgView];
    [self.unlimitedImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.typeLbl.mas_bottom).offset(8);
    }];
    
    
    [self addSubview:self.unlimitedLbl];
    [self.unlimitedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.typeLbl.mas_bottom).offset(8);
    }];
    
    self.valueLbl.hidden = YES;
}


- (void)bindCellWithModel:(DCMainBalanceSummaryItemModel *)model {
    self.unlimitedImgView.hidden = YES;
    self.unlimitedLbl.hidden = YES;
    self.valueLbl.hidden = YES;
    self.totalLbl.hidden = YES;
    
    if(model) {
        // 判断是否为无线数据
        if([@"Y" isEqualToString:model.unlimitedFlag]) {
            self.unlimitedLbl.hidden = NO;
        }else {
            self.valueLbl.hidden = NO;
            self.totalLbl.hidden = NO;
			if ([model.totalStr isEqualToString:[[HJLanguageManager shareInstance] getTextByKey:@"lb_per_sms"]]) {
                self.totalLbl.text = model.totalStr;
            } else {
				self.totalLbl.text = [NSString stringWithFormat:@"%@: %@", [[HJLanguageManager shareInstance] getTextByKey:@"lb_total1"], model.totalStr];
            }
            self.valueLbl.text = [NSString stringWithFormat:@"%@",model.valueStr];
        }
    }else {
        self.valueLbl.hidden = NO;
        self.totalLbl.hidden = NO;
		self.totalLbl.text = [NSString stringWithFormat:@"%@: 0", [[HJLanguageManager shareInstance] getTextByKey:@"lb_total1"]];
        self.valueLbl.text = @"0";
    }
}




#pragma mark - SET  GET

- (void)setCompositionProps:(CompositionProps*)props {
    NSString *themeType = props.themeType;
    
    if(DC_IsStrEmpty(themeType)) {return;}
    
//    if([themeType isEqualToString:@"5"] && self.cellType == DCTMDashboardCellSMS) {
////        self.totalLbl.text = @"Per SMS";
//        self.totalLbl.text = Language(@"lb_per_sms");
//        self.valueLbl.text = [NSString stringWithFormat:@"%@0.15",[HJConfigRequestManager shareInstance].currencySymbol];
//    }
    
    
    UIColor *circleDataColor = [UIColor whiteColor];
    UIColor *circleStaticColor = [UIColor whiteColor];
    // 设置文字颜色
    if(!DC_IsStrEmpty(props.circleDataColor)){
        circleDataColor= [UIColor hjp_colorWithHex:props.circleDataColor]?:[UIColor whiteColor];
    }
    // 静态文字颜色
    if(!DC_IsStrEmpty(props.circleStaticColor)){
        circleStaticColor= [UIColor hjp_colorWithHex:props.circleStaticColor]?:[UIColor whiteColor];
    }
    self.valueLbl.textColor = circleDataColor;
    self.valueLbl.alpha = [props.circleCardColorOpacity integerValue] > 0 ? [props.circleCardColorOpacity integerValue] /100 : 1;
    self.typeLbl.textColor = circleStaticColor;
    self.typeLbl.alpha = props.circleStaticColorOpacity > 0 ? props.circleStaticColorOpacity /100 : 1;
    self.unlimitedLbl.textColor = circleStaticColor;
    self.unlimitedLbl.alpha = props.circleStaticColorOpacity > 0 ? props.circleStaticColorOpacity/100 : 1;
    
    if(!self.totalLbl.hidden) {
        if([self.totalLbl.text containsString:@"Total:"]) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:self.totalLbl.text];
            
            [attr addAttributes:@{NSForegroundColorAttributeName: circleStaticColor} range:NSMakeRange(0, @"Total:".length)];
            [attr addAttributes:@{NSForegroundColorAttributeName: circleDataColor} range:NSMakeRange(@"Total:".length,self.totalLbl.text.length -  @"Total:".length)];
            
            [attr addAttributes:@{NSFontAttributeName:  [UIFont boldSystemFontOfSize:16]} range:NSMakeRange(0, self.totalLbl.text.length)];
            self.totalLbl.attributedText = attr;
        }else {
            self.totalLbl.textColor = circleStaticColor;
        }
    }
    
    switch (self.cellType) {
        case DCTMDashboardCellData:
        {
            if([themeType isEqualToString:@"5"]) {
                if([props.dataBgType isEqualToString:@"Color"]) {
                    self.bgImgView.backgroundColor = [UIColor hjp_colorWithHex:props.dataBgColor];
                    self.bgImgView.layer.cornerRadius = self.bgImgView.frame.size.width / 2.0;
                }else {
                    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:props.dataBgImg.src]];
                    if(!DC_IsArrEmpty(props.circleDataIcon)) {
                        PicturesItem *item = [props.circleDataIcon firstObject];
                        [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:item.src]];
                    }
                }
            }else {
                self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pb_tm_progress%@_data",themeType]];
                self.logoImgView.image = [UIImage imageNamed:@"pb_tm_icon_data"];
                
            }
           
            if (![themeType  isEqualToString:@"3"]) {
                self.unlimitedImgView.image = [UIImage imageNamed:@"pb_progress_data_unlimited"];
            }
//            self.typeLbl.text = @"Remaining Data";
			self.typeLbl.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_remaining_data"];
        }
            break;
        case DCTMDashboardCellSMS:
        {
            if([themeType isEqualToString:@"5"]) {
                if([props.smsBgType isEqualToString:@"Color"]) {
                    self.bgImgView.backgroundColor = [UIColor hjp_colorWithHex:props.smsBgColor];
                    self.bgImgView.layer.cornerRadius = self.bgImgView.frame.size.width / 2.0;
                }else {
                    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:props.smsBgImg.src]];
                    if(!DC_IsArrEmpty(props.circleSmsIcon)) {
                        PicturesItem *item = [props.circleSmsIcon firstObject];
                        [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:item.src]];
                    }
                }
            }else {
                self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pb_tm_progress%@_sms",themeType]];
                self.logoImgView.image = [UIImage imageNamed:@"pb_tm_icon_sms"];
            }
            if (![themeType  isEqualToString:@"3"]) {
                self.unlimitedImgView.image = [UIImage imageNamed:@"pb_progress_sms_unlimited"];
            }
//            self.typeLbl.text = @"SMS";
			self.typeLbl.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_dashboard_sms"];
        }
           break;
        case DCTMDashboardCellVoice:
        {
            if([themeType isEqualToString:@"5"]) {
                if([props.voiceBgType isEqualToString:@"Color"]) {
                    self.bgImgView.backgroundColor = [UIColor hjp_colorWithHex:props.voiceBgColor];
                    self.bgImgView.layer.cornerRadius = self.bgImgView.frame.size.width / 2.0;
                }else {
                    [self.bgImgView sd_setImageWithURL:[NSURL URLWithString:props.voiceBgImg.src]];
                    if(!DC_IsArrEmpty(props.circleSmsIcon)) {
                        PicturesItem *item = [props.circleVoiceIcon firstObject];
                        [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:item.src]];
                    }
                }
            }else {
                self.bgImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pb_tm_progress%@_voice",themeType]];
                self.logoImgView.image = [UIImage imageNamed:@"pb_tm_icon_voice"];
            }
            if (![themeType  isEqualToString:@"3"]) {
                self.unlimitedImgView.image = [UIImage imageNamed:@"pb_progress_voice_unlimited"];
            }
//            self.typeLbl.text = @"Remaining Voice";
			self.typeLbl.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_remaining_voice"];
        }
            break;
        default:
            break;
    }
    
    if ([themeType isEqualToString:@"3"]) {
        self.unlimitedImgView.image = [UIImage imageNamed:@"pb_tm_u"];
    }
}


#pragma mark -- 私有
- (UIImageView *)bgImgView {
    if(!_bgImgView){
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"pb_tm_bg_data"];
    }
    return _bgImgView;
}

- (UIImageView *)logoImgView {
    if(!_logoImgView) {
        _logoImgView = [UIImageView new];
        _logoImgView.image = [UIImage imageNamed:@"pb_tm_icon_data"];
    }
    return _logoImgView;
}

- (UILabel *)typeLbl {
    if(!_typeLbl) {
        _typeLbl = [UILabel new];
        _typeLbl.textAlignment = NSTextAlignmentCenter;
        _typeLbl.font = FONT_BS(16);
        _typeLbl.textColor = [UIColor whiteColor];
    }
    return _typeLbl;
}

- (UILabel *)valueLbl {
    if(!_valueLbl) {
        _valueLbl = [UILabel new];
        _valueLbl.textAlignment = NSTextAlignmentCenter;
        _valueLbl.text = @" ";
        _valueLbl.font =  FONT_BS(24);
        _valueLbl.textColor = [UIColor whiteColor];
    }
    return _valueLbl;
}

- (UILabel *)totalLbl {
    if(!_totalLbl) {
        _totalLbl = [UILabel new];
        _totalLbl.text = @"Total: ";
        _totalLbl.textAlignment = NSTextAlignmentCenter;
        _totalLbl.font =  FONT_BS(14);
        _totalLbl.textColor = [UIColor whiteColor];
    }
    return _totalLbl;
}

- (UIImageView *)unlimitedImgView {
    if(!_unlimitedImgView) {
        _unlimitedImgView = [UIImageView new];
        _unlimitedImgView.hidden = YES;
    }
    return _unlimitedImgView;
}

- (UILabel *)unlimitedLbl {
    if(!_unlimitedLbl) {
        _unlimitedLbl = [UILabel new];
        _unlimitedLbl.text = @"Unlimited";
        _unlimitedLbl.font = FONT_BS(20);
    }
    return _unlimitedLbl;
}
@end
