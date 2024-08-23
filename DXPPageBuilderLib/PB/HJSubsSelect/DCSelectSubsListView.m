//
//  DCSelectSubsListView.m
//  GaiaCLP
//
//  Created by mac on 2022/7/13.
//

#import "DCSelectSubsListView.h"
#import "DCSelectSubsListCell.h"
#import <Masonry/Masonry.h>
#import "DCSubsListModel.h"
#import "DCSubsBundleModel.h"
#import <DXPManagerLib/HJTokenManager.h>
#import <DXPManagerLib/HJLanguageManager.h>
#import "DCPB.h"

static NSString *selectID = @"DCSelectSubsListCellIdentifier";

@interface DCSelectSubsListView () <UITableViewDelegate, UITableViewDataSource> {
    CGFloat _viewHeight;
    SwitchSubsBlock _switchSubsBlock;
    BOOL isList;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *totalView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DCSelectSubsListView

- (id)initWithBlock:(SwitchSubsBlock)block {
    self = [super init];
    if (self) {
        
        _switchSubsBlock = block;
        _viewHeight = 400 + DC_Safe_Area_Hegiht;
        self.frame = CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, DC_SCREEN_HEIGHT);
        [self initData];
        [self addSubview:self.bgView];
        [self addSubview:self.totalView];
        [[HJTokenManager shareInstance] setViewBackgroundColorWithToken:@"ref-global-bgColor-secondary-app" view:self.totalView size:CGSizeMake(DC_DCP_SCREEN_WIDTH, 1)];
        [self.totalView addSubview:self.titleLab];
        [self.totalView addSubview:self.closeBtn];
        [self.totalView addSubview:self.tableView];
    }
    return self;
}

- (void)initData{
//    NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//    NSDictionary *subsSwitchPopup = json[@"subsSwitchPopup"];
    isList = [@"list" isEqualToString:[DXPPBConfigManager shareInstance].displayStyle];
}

- (void)show {
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    NSInteger count = [DXPPBDataManager shareInstance].totalSubsArr.count;
    _viewHeight = 50+95*MIN(count, 5)+10+DC_Safe_Area_Hegiht;
    self.totalView.frame = CGRectMake(0, DC_SCREEN_HEIGHT, DC_DCP_SCREEN_WIDTH, _viewHeight);

    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:self.totalView.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerTopLeft cornerRadii:CGSizeMake(16, 16)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = self.totalView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.totalView.layer.mask = maskLayer;
	__weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.totalView setFrame:CGRectMake(0, DC_SCREEN_HEIGHT - _viewHeight, DC_DCP_SCREEN_WIDTH, _viewHeight)];
    } completion:nil];
}
 
- (void)dismiss {
    [self.totalView setFrame:CGRectMake(0, DC_SCREEN_HEIGHT - _viewHeight, DC_DCP_SCREEN_WIDTH, _viewHeight)];
	__weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.totalView.frame = CGRectMake(0, DC_SCREEN_HEIGHT, DC_DCP_SCREEN_WIDTH, _viewHeight);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
        [weakSelf.totalView removeFromSuperview];
    }];
}


#pragma mark - Methods
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLab.text = titleStr;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [DXPPBDataManager shareInstance].totalSubsListArr.count;
//    if(isList){
//        return [HJGlobalDataManager shareInstance].totalSubsListArr.count;
//    }
//
//    return [HJGlobalDataManager shareInstance].subsListModel.subsList.count+[HJGlobalDataManager shareInstance].subsListModel.bundleSubsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return isList?CGFLOAT_MIN:8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor clearColor];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = [UIColor clearColor];
    return sectionView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray * arr = [DXPPBDataManager shareInstance].totalSubsListArr[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * cellID = @"DCSelectSubsListCell";
    NSMutableArray * arr = [DXPPBDataManager shareInstance].totalSubsListArr[indexPath.section];
    
    if (isList) {
        cellID = @"DCSelectSubsListCell";
    }else{
        cellID = (indexPath.row==0 && [arr[indexPath.row] isKindOfClass:[DCSubsBundleModel class]]) ? @"HJSelectViewMyHouseCell" : @"HJSelectSubsGroupCell";
    }
	DCSelectSubsListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DCSelectSubsListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if(isList){
        [cell setContentWithIndexPath:indexPath];
    }else{
        if (indexPath.row==0 && [arr[indexPath.row] isKindOfClass:[DCSubsBundleModel class]]) {
            [cell setContentWithBundleModel:[arr objectAtIndex:indexPath.row]];
        } else {
			DCPBSubsItemModel *model = [arr objectAtIndex:indexPath.row];
            [cell setContentWithModel:model];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray * arr = [DXPPBDataManager shareInstance].totalSubsListArr[indexPath.section];
    
    if (indexPath.row==0 && [arr[indexPath.row] isKindOfClass:[DCSubsBundleModel class]]) {
        if (self.switchBundleBlock){
            self.switchBundleBlock([arr objectAtIndex:indexPath.row]);
        }
    } else {
        if (_switchSubsBlock) {
            _switchSubsBlock([arr objectAtIndex:indexPath.row]);
        }
    }
    [self dismiss];
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
        _totalView.backgroundColor = DC_UIColorFromRGB(0xffffff);
    }
    return _totalView;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, DC_DCP_SCREEN_WIDTH-100, 26)];
        _titleLab.font = FONT_BS(18);
        _titleLab.textColor = DC_UIColorFromRGB(0x242424);
		_titleLab.text = [[HJLanguageManager shareInstance] getTextByKey:@"lb_your_service_number"];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(DC_DCP_SCREEN_WIDTH-50, 18, 30, 30);
        [_closeBtn setImage:DC_image(@"ic_close") forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        NSInteger count = [DXPPBDataManager shareInstance].totalSubsArr.count;
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, DC_DCP_SCREEN_WIDTH, 95*MIN(count, 5)) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 50.f;
//        _tableView.rowHeight = 77.f;

        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedSectionHeaderHeight = 0.f;
            _tableView.estimatedSectionFooterHeight = 0.f;
        } else {

        }
        [_tableView registerClass:[DCSelectSubsListCell class] forCellReuseIdentifier:selectID];
    }
    return _tableView;
}

@end
