//
//  DCGeneralSelectPopView.m
//  GaiaCLP
//
//  Created by Lee on 2022/5/16.
//

#import "DCGeneralSelectPopView.h"
#import "DCGeneralSelectedGroupCell.h"
#import <Masonry/Masonry.h>
#import "DCSubsListModel.h"
#import "DCGeneralSelectedCell.h"
#import <DXPManagerLib/HJLanguageManager.h>
#import "DCPB.h"

static NSString *DCGeneralSelectedCellId = @"DCGeneralSelectedCell";
static NSString *DCGeneralSelectedGroupCellId = @"DCGeneralSelectedGroupCell";

@interface DCGeneralSelectPopView () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _viewHeight;
    SwitchSubsBlock _switchSubsBlock;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *totalView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL displayStyleList; //
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation DCGeneralSelectPopView

- (id)initWithBlock:(SwitchSubsBlock)block {
    self = [super init];
    if (self) {
        self.dataSouce = [NSMutableArray new];
//        NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//        NSDictionary *subsSwitchPopup = json[@"subsSwitchPopup"];
		NSString *displayStyle = [DXPPBConfigManager shareInstance].displayStyle;
        self.displayStyleList = [@"list" isEqualToString:displayStyle];
        _switchSubsBlock = block;
        _viewHeight = 400 + DC_Safe_Area_Hegiht;
        self.frame = CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, DC_SCREEN_HEIGHT);
        self.totalView.backgroundColor =  self.displayStyleList ?  [UIColor whiteColor] : DC_UIColorFromRGB(0xF2F2F2);
        [self addSubview:self.bgView];
        [self addSubview:self.totalView];
        [self.totalView addSubview:self.titleLab];
        [self.totalView addSubview:self.closeBtn];
        [self.totalView addSubview:self.tableView];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.totalView.mas_centerX);
            make.top.equalTo(@20);
            make.height.equalTo(@26);
        }];
        
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-16);
            make.width.height.equalTo(@24);
            make.centerY.equalTo(self.titleLab.mas_centerY);
        }];
        if(self.displayStyleList) {
            self.tableView.backgroundColor = [UIColor whiteColor];
            
        }
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.equalTo(@66);
            make.bottom.equalTo(@(-(DC_Safe_Area_Hegiht)));
        }];
        _tableView.estimatedRowHeight = self.displayStyleList ? 55 : 100;
    }
    return self;
}


- (void)show {
    [self.dataSouce removeAllObjects];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    
    if(self.displayStyleList) {
        [self.dataSouce addObjectsFromArray:[DXPPBDataManager shareInstance].subsListModel.subsList];
    }else {
        [self.dataSouce addObjectsFromArray:[DXPPBDataManager shareInstance].subsListModel.bundleSubsList];
        [[DXPPBDataManager shareInstance].subsListModel.subsList enumerateObjectsUsingBlock:^(DCPBSubsItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj){
                
				DCSubsBundleListModel *xx = [DCSubsBundleListModel new];
                xx.subsList = @[obj];
                [self.dataSouce addObject:xx];
            }
        }];
    }
 
    CGFloat oneH = self.displayStyleList ? 55 : 80;
    _viewHeight = 66 + oneH *MAX(2,  MIN(self.dataSouce.count, 5))+10+ DC_Safe_Area_Hegiht;
    
    self.totalView.frame = CGRectMake(0, DC_SCREEN_HEIGHT, DC_DCP_SCREEN_WIDTH, _viewHeight);
    
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.totalView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.totalView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.totalView.layer.mask = maskLayer;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.totalView setFrame:CGRectMake(0, DC_SCREEN_HEIGHT - _viewHeight, DC_DCP_SCREEN_WIDTH, _viewHeight)];
    } completion:nil];
    
    [self.tableView reloadData];
}
 
- (void)dismiss {
    [self.totalView setFrame:CGRectMake(0, DC_SCREEN_HEIGHT - _viewHeight, DC_DCP_SCREEN_WIDTH, _viewHeight)];
    [UIView animateWithDuration:0.3f animations:^{
        self.totalView.frame = CGRectMake(0, DC_SCREEN_HEIGHT, DC_DCP_SCREEN_WIDTH, _viewHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.totalView removeFromSuperview];
    }];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return   self.dataSouce.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCGeneralSelectedGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:self.displayStyleList ? DCGeneralSelectedCellId : DCGeneralSelectedGroupCellId forIndexPath:indexPath];
    cell.cellSelectBlock = ^(DCPBSubsItemModel *model){
        if (_switchSubsBlock) {
			_switchSubsBlock(model);
        }
        [self dismiss];
    };
    [cell bindWithModel:self.dataSouce[indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    if (_switchSubsBlock) {
//        _switchSubsBlock([[HJGlobalDataManager shareInstance].subsListModel.subsList objectAtIndex:indexPath.section]);
//    }
//
//    [self dismiss];
}

#pragma mark -
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [DC_UIColorFromRGB(0x000000) colorWithAlphaComponent:0.6];
    }
    return _bgView;
}

- (UIView *)totalView {
    if (!_totalView) {
        _totalView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, _viewHeight)];
        _totalView.userInteractionEnabled = YES;
    }
    return _totalView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = FONT_BS(18);
        _titleLab.textColor = DC_UIColorFromRGB(0x242424);
        _titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_service_number"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:DC_image(@"ic_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, DC_DCP_SCREEN_WIDTH, 56*5) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//            _tableView.estimatedRowHeight = 0.f;
            _tableView.estimatedSectionHeaderHeight = 0.f;
            _tableView.estimatedSectionFooterHeight = 0.f;
        } else {

        }
        
        [_tableView registerClass:[DCGeneralSelectedCell class] forCellReuseIdentifier:DCGeneralSelectedCellId];
        [_tableView registerClass:[DCGeneralSelectedGroupCell class] forCellReuseIdentifier:DCGeneralSelectedGroupCellId];
    }
    return _tableView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
