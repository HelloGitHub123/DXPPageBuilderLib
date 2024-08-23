//
//  DCCountdownPostCell.m
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/29.
//

#import "DCCountdownPostCell.h"
// ****************** Model ******************
@implementation DCCountdownPostCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    componentModel.props.showMore = NO;
    componentModel.props.showTitle = YES;
    self = [super initWithComponentModel:componentModel];
    
    // 判断是否显示
    if(!DC_IsStrEmpty(componentModel.props.expireTime) && componentModel.props.expireTime.length >= 19){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dateStr = [componentModel.props.expireTime substringToIndex:19];
        NSDate *expireDate = [DCCountdownPostCellModel dateByAddingHours:8 date:[formatter dateFromString:dateStr]];
        NSDate *dateNow = [NSDate date];
        NSTimeInterval aTimer = [expireDate timeIntervalSinceDate:dateNow];
        if(aTimer < 0 ) {
            self.cellHeight = 0;
        }
    }else {
        self.cellHeight = 0;
    }
    
    
    return self;
}

+ (NSDate *)dateByAddingHours:(NSInteger)hours date:(NSDate*)date {
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (void)coustructCellHeight {
    [super coustructCellHeight];
    CGFloat horizontalOutterMargin = self.props.horizontalOutterMargin ;
    PicturesItem *item = [self.props.pictures firstObject];
    self.cellHeight = self.cellHeight +  (DCP_SCREEN_WIDTH - 2 *horizontalOutterMargin)/item.width * item.height + 16;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCCountdownPostCell class]);
}
@end

// ****************** Cell ******************
@interface DCCountdownPostCell()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDate *expireDate;


@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UILabel *hourLbl;
@property (nonatomic, strong) UILabel *minLbl;
@property (nonatomic, strong) UILabel *secLbl;
@property (nonatomic, strong) UILabel *s1;
@property (nonatomic, strong) UILabel *s2;

@end
@implementation DCCountdownPostCell

- (void)bindCellModel:(DCCountdownPostCellModel *)cellModel {
    [super bindCellModel:cellModel];
    // 添加一个定时器
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatehourLbl) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    // 移除控件
    // 移除控件
    self.hourLbl.text = @"";
    self.minLbl.text = @"";
    self.secLbl.text = @"";
    [_imgView removeFromSuperview];
    [_timeView removeFromSuperview];
    _imgView = nil;
    _timeView = nil;
    
    // 添加控件
    // 添加控件
    [self.baseContainer addSubview:self.imgView];
    [self.borderView addSubview:self.timeView];
    [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(self.cellModel.props.topMargin?: 16));
    }];
    
    [_timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(@0);
    }];
    
   
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.leading.bottom.equalTo(@0);
    }];
    NSString *dateStr = [cellModel.props.expireTime substringToIndex:19];
    self.expireDate = [DCCountdownPostCellModel dateByAddingHours:8 date:[self.formatter dateFromString:dateStr]];
    [self updatehourLbl];
    
   
    PicturesItem *imgItem = [cellModel.props.pictures firstObject];
    NSURL *imgUrl = [NSURL URLWithString:imgItem.src];
    [self.imgView sd_setImageWithURL:imgUrl];
}

- (void)updatehourLbl {
    NSDate *dateNow = [NSDate date];
    NSTimeInterval aTimer = [self.expireDate timeIntervalSinceDate:dateNow];
    int hour = (int)(aTimer/3600);
    int minute = (int)(aTimer - hour*3600)/60;
    int second = aTimer - hour*3600 - minute*60;
    if((hour == 0 && minute == 0 && second == 0) ||aTimer < 0 ) {
        self.hourLbl.text = @"00";
        self.minLbl.text = @"00";
        self.secLbl.text = @"00";
        // 回调控制器，触发事件
        [self invalidateTimer];
        self.cellModel.cellHeight = 0;
        self.cellModel.isBinded = NO;
        self.reloadTableBlock();
        return;
    }
    NSString *dural = [NSString stringWithFormat:@"%@%d:%@%d:%@%d", hour<10? @"0" : @"", hour,minute<10? @"0" : @"", minute,second<10? @"0" : @"",second];
    self.hourLbl.text = dural;
    
    self.hourLbl.text = [NSString stringWithFormat:@"%@%d", hour<10? @"0" : @"", hour];
    self.minLbl.text = [NSString stringWithFormat:@"%@%d", minute<10? @"0" : @"", minute];
    self.secLbl.text = [NSString stringWithFormat:@"%@%d", second<10? @"0" : @"", second];
    
    if([@"Y" isEqualToString:self.cellModel.props.isCountdownbg] && !DC_IsStrEmpty(self.cellModel.props.countdownBg)) {
        self.hourLbl.backgroundColor = [UIColor hjp_colorWithHex:self.cellModel.props.countdownBg];
        self.minLbl.backgroundColor = [UIColor hjp_colorWithHex:self.cellModel.props.countdownBg];
        self.secLbl.backgroundColor = [UIColor hjp_colorWithHex:self.cellModel.props.countdownBg];
        self.s1.textColor =  [UIColor hjp_colorWithHex:self.cellModel.props.countdownBg];
        self.s2.textColor =  [UIColor hjp_colorWithHex:self.cellModel.props.countdownBg];
    }
    
}


- (void)invalidateTimer {
    [_timer invalidate];
    _timer = nil;
}


- (void)dealloc{

    [self invalidateTimer];

}


// MARK: LAZY
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (UILabel *)timeLbl {
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc]init];
    }
    return _timeLbl;
}

- (UIView *)timeView {
    if (!_timeView) {
        _timeView = [UIView new];
            
        UILabel *s1 = [UILabel new];
        self.s1 = s1;
        s1.textColor = [UIColor blackColor];
        s1.text = @":";
        UILabel *s2 = [UILabel new];
        s2.textColor = [UIColor blackColor];
        s2.text = @":";
        self.s2 = s2;
        _hourLbl = [[UILabel alloc]init];
        _hourLbl.textAlignment = NSTextAlignmentCenter;
        _hourLbl.textColor = [UIColor whiteColor];
        _hourLbl.backgroundColor = [UIColor blackColor];
        _minLbl = [[UILabel alloc]init];
        _minLbl.textAlignment = NSTextAlignmentCenter;
        _minLbl.textColor = [UIColor whiteColor];
        _minLbl.backgroundColor = [UIColor blackColor];
        _secLbl = [[UILabel alloc]init];
        _secLbl.textAlignment = NSTextAlignmentCenter;
        _secLbl.textColor = [UIColor whiteColor];
        _secLbl.backgroundColor = [UIColor blackColor];
        
        [_timeView addSubview:s1];
        [_timeView addSubview:s2];
        [_timeView addSubview:_secLbl];
        [_timeView addSubview:_minLbl];
        [_timeView addSubview:_hourLbl];
        
        
        [_hourLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(22));
            make.leading.top.bottom.equalTo(@(0));
        }];
        
        [s1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_hourLbl.mas_trailing).offset(2);
            make.centerY.equalTo(_timeView.mas_centerY);
        }];
        
        [_minLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(22));
            make.leading.equalTo(s1.mas_trailing).offset(2);;
            make.centerY.equalTo(_timeView.mas_centerY);
        }];
        
        [s2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_minLbl.mas_trailing).offset(2);
            make.centerY.equalTo(_timeView.mas_centerY);
        }];
        
        [_secLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(22));
            make.leading.equalTo(s2.mas_trailing);
            make.centerY.equalTo(_timeView.mas_centerY);
            make.trailing.equalTo(_timeView.mas_trailing);
        }];
    }
    return _timeView;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        _formatter = formatter;
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return _formatter;
}
@end
