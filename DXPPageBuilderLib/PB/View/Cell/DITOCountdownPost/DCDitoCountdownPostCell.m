//
//  DCDitoCountdownPostCell.m
//  DITOApp
//
//  Created by 孙全民 on 2022/7/27.
//

#import "DCDitoCountdownPostCell.h"
// ****************** Model ******************
@implementation DCDitoCountdownPostCellModel
- (instancetype)initWithComponentModel:(DCPageCompositionContentModel *)componentModel {
    self = [super initWithComponentModel:componentModel];
    
    
   
    // 判断是否显示
    if(!DC_IsStrEmpty(componentModel.props.expireTime) && componentModel.props.expireTime.length >= 19){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSString *dateStr = [componentModel.props.expireTime substringToIndex:19];
        NSDate *expireDate = [[formatter dateFromString:dateStr] dateByAddingTimeInterval:8*60*60];;
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

- (void)coustructCellHeight {
    self.cellHeight = 280;
}

- (NSString *)cellClsName {
    return NSStringFromClass([DCDitoCountdownPostCell class]);
}
@end

// ****************** Cell ******************
@interface DCDitoCountdownPostCell()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) NSDate *expireDate;



@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *leftEndLbl; //
@property (nonatomic, strong) UIView *timeViews; // 时间view的数组
@end

@implementation DCDitoCountdownPostCell

- (void)bindCellModel:(DCFloorBaseCellModel *)cellModel {
    [super bindCellModel:cellModel];
   
    [self.borderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake( 12, 11, 20, 11));
    }];
    
    // 控件移除
    [_leftEndLbl removeFromSuperview];
    _leftEndLbl = nil;
    [_imgView removeFromSuperview];
    _imgView = nil;
    [_timeViews removeFromSuperview];
    _timeViews = nil;
    
    // 添加控件
    if (!DC_IsArrEmpty(cellModel.props.pictures)) {
        PicturesItem *item = [cellModel.props.pictures firstObject];
        [self.baseContainer addSubview:self.imgView];
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(@-10);
            make.height.equalTo(@195);
        }];
		__weak typeof(self)weakSelf = self;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:item.src] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
          
            @try {
                CGFloat imgW = DCP_SCREEN_WIDTH - 22;
                CGFloat imgH = imgW / image.size.width * image.size.height;
                [weakSelf.imgView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(imgH);
                }];
                cellModel.cellHeight =  cellModel.cellHeight + imgH - 195;
                weakSelf.reloadTableBlock();
                
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
           
        }];
    }
    
    
    [self.baseContainer addSubview:self.leftEndLbl];
    [self.leftEndLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@5);
        make.bottom.equalTo(@-10);
    }];
    
    
    [self.baseContainer addSubview:self.timeViews];
    [self.timeViews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.leftEndLbl.mas_trailing).offset(8);
        make.trailing.equalTo(@0);
        make.centerY.equalTo(self.leftEndLbl.mas_centerY);
        make.height.equalTo(@30);
    }];
    
    for (int i = 1; i<= 3; i++) {
        [self.timeViews addSubview:[self getTimeViewWithIndex:i]];
    }
    [self.timeViews.subviews mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:9 leadSpacing:0 tailSpacing:0];
    [self.timeViews.subviews mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
    }];
    
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLbl) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    NSString *dateStr = [cellModel.props.expireTime substringToIndex:19];
    // 过期时间是0时区，
    self.expireDate = [[self.formatter dateFromString:dateStr] dateByAddingTimeInterval:8*60*60];
    [self updateTimeLbl];
}

- (UIView*)getTimeViewWithIndex:(NSInteger)index {
    UIView *content = [UIView new];
    content.backgroundColor = [UIColor hjp_colorWithHex:@"#CE1126"];
    content.layer.cornerRadius = 4.0;
    
    // 创建文本
    UILabel *timeLbl = [UILabel new];
    timeLbl.tag = 1000;
    timeLbl.textColor = [UIColor whiteColor];
	timeLbl.font = FONT_S(18);
    timeLbl.text = @"00";
    [content addSubview:timeLbl];
    [timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(content.mas_centerY);
        make.left.equalTo(@7);
    }];
    
    UILabel *unitLbl = [UILabel new];
    unitLbl.textColor = [UIColor whiteColor];
    unitLbl.font = FONT_S(7);
    [content addSubview:unitLbl];
    [unitLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(content.mas_centerY);
        make.trailing.equalTo(@-6);
    }];
    switch (index) {
        case 1:
            unitLbl.text = @"DAY/S";
            break;
        case 2:
            unitLbl.text = @"HOUR/S";
            break;
        case 3:
            unitLbl.text = @"MINUTE/S";
            break;
    }
    
    return content;
}


- (void)updateTimeLbl {
    NSDate *dateNow = [NSDate date];
    NSTimeInterval aTimer = [self.expireDate timeIntervalSinceDate:dateNow];
    UILabel *dayLbl = [self.timeViews.subviews[0] viewWithTag:1000];
    UILabel *hourLbl = [self.timeViews.subviews[1]  viewWithTag:1000];
    UILabel *minLbl = [self.timeViews.subviews[2]  viewWithTag:1000];
    
    if (aTimer <= 0) {
        dayLbl.text = @"00";
        hourLbl.text = @"00";
        minLbl.text = @"00";
        [self invalidateTimer];
        self.cellModel.cellHeight = 0;
        self.cellModel.isBinded = NO;
        self.reloadTableBlock();
        return;
    }
    
    int day = (int)(aTimer/3600/24);
    int hour = (int)(aTimer/3600 - day*24);
    int minute = (int)(aTimer  - (hour + day * 24 )*3600)/60;
    
    dayLbl.text = [NSString stringWithFormat:@"%@%d",day < 10 ? @"0" : @"", day];
    hourLbl.text = [NSString stringWithFormat:@"%@%d",hour < 10 ? @"0" : @"", hour];
    minLbl.text = [NSString stringWithFormat:@"%@%d",minute < 10 ? @"0" : @"", minute];
}

- (void)imgaeTapAction {
    if (!DC_IsArrEmpty(self.cellModel.props.pictures)) {
        PicturesItem *item = [self.cellModel.props.pictures firstObject];
        DCFloorEventModel *model = [DCFloorEventModel new];
        model.link = item.link;
        model.linkType = item.linkType;
        model.name = item.iconName;
        model.floorEventType = DCFloorEventFloor;
        [self hj_routerEventWith:model];
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
        _imgView = [UIImageView new];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgaeTapAction)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}


- (NSDateFormatter *)formatter {
    if (!_formatter) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        _formatter = formatter;
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    return _formatter;
}

- (UILabel *)leftEndLbl {
    if (!_leftEndLbl) {
        _leftEndLbl = [UILabel new];
        _leftEndLbl.text = @"This deal will end in:";
        _leftEndLbl.font = FONT_BS(10);
        _leftEndLbl.textColor = [UIColor hjp_colorWithHex:@"#3E3E3E"];
    }
    return _leftEndLbl;
}

- (UIView *)timeViews {
    if (!_timeViews) {
        _timeViews = [UIView new];
    }
    return _timeViews;
}

@end
