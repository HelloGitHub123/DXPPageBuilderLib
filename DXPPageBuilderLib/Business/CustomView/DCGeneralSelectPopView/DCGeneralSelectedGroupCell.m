//
//  DCGeneralSelectedGroupCell.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/8/29.
//

#import "DCGeneralSelectedGroupCell.h"
#import <Masonry/Masonry.h>
#import "DCPB.h"

@interface DCGeneralSelectedGroupCell()
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) DCSubsBundleListModel*bundleModel;

@end

@implementation DCGeneralSelectedGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        UIView *content = [UIView new];
        self.content = content;
        content.backgroundColor = [UIColor whiteColor];
        content.layer.cornerRadius = 8;
        [self.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@12);
            make.trailing.equalTo(@-12);
            make.top.equalTo(@0);
            make.bottom.equalTo(@-8);
        }];
    }
    return self;
}


// 绑定cell
- (void)bindWithModel:(DCSubsBundleListModel*)bundleModel {
    self.bundleModel = bundleModel;
    [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    __block UIView *lastView = nil;
    [bundleModel.subsList enumerateObjectsUsingBlock:^(DCPBSubsItemModel* obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIView *xx = [self getOneRowView:obj];
        xx.tag = 1000 + i ;
        [self.content addSubview:xx];
        [xx mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(@0);
            make.top.equalTo(lastView  ? lastView.mas_bottom:  @0);
//            make.height.equalTo(@77);
            if(bundleModel.subsList.count == i + 1) {
                make.bottom.equalTo(@0);
            }
        }];
        lastView = xx;
    }];
   
}

- (void)contentTapAction:(UIGestureRecognizer*)rec {
    NSInteger index = rec.view.tag - 1000;
    if(self.cellSelectBlock) {
        self.cellSelectBlock(self.bundleModel.subsList[index]);
    }
}

- (UIView *)getOneRowView:(DCPBSubsItemModel*)model {
//    NSDictionary *json = [[HJPropertyManager shareInstance] getProperyJson];
//    NSDictionary *subsSwitchPopup = json[@"subsSwitchPopup"];
	BOOL showStatusTag = [DXPPBConfigManager shareInstance].showStatusTag;
	BOOL showPaidFlagTag = [DXPPBConfigManager shareInstance].showPaidFlagTag;
    
    
    UIView *contentView = [UIView new];
    contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapAction:)];
    [contentView addGestureRecognizer:tap];
    
    // 图片
    UIImageView *iconImg = [UIImageView new];
    iconImg.image =  [UIImage imageNamed: [model.primaryFlag isEqualToString:@"Y"]  ?  @"family_plan_principal" : @"family_plan_secondary" ];
    
    [contentView addSubview:iconImg];
    [iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@12);
        make.leading.equalTo(@16);
        make.width.height.equalTo(@32);
    }];
    
    // 标题
    UILabel *titleLab = [UILabel new];
    titleLab.text = model.accNbr;
    titleLab.font = FONT_BS(14);
    titleLab.textColor = [UIColor hjp_colorWithHex:@"#242424" ];
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(iconImg.mas_trailing).offset(8);
        make.centerY.equalTo(iconImg.mas_centerY);
        make.height.equalTo(@29);
    }];

    
//    if(showStatusTag) {
        UIView *lineView = [UIView new];  // 竖线
        [contentView addSubview:lineView];
        lineView.backgroundColor = [UIColor hjp_colorWithHex:@"#d5d5d5"];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(titleLab.mas_trailing).offset(8);
            make.centerY.equalTo(iconImg.mas_centerY);
            make.height.equalTo(@13);
            make.width.equalTo(@1);
        }];
        
        UILabel *stateLbl = [UILabel new];
        stateLbl.text =  [model.state isEqualToString:@"A"] ? @"Active" : @"Blocked";
        stateLbl.font = FONT_BS(12);
    stateLbl.textColor = [UIColor hjp_colorWithHex:[model.state isEqualToString:@"A"] ? @"#1CD287" : @"#FA2C2C"];
        [contentView addSubview:stateLbl];
        [stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(lineView.mas_trailing).offset(8);
            make.centerY.equalTo(iconImg.mas_centerY);
        }];
//    }
    
    
    if(showPaidFlagTag) {
        bool isPrepaid =  [model.paidFlag isEqualToString:@"0"] ;
        // 状态view
        
        
        
//    https://www.figma.com/file/ABHEg6YTnTM5Oi9bM50eTm/%E9%A9%AC%E6%9D%A5%E6%AD%A3%E5%BC%8F%E4%B8%8A%E7%BA%BF%E4%B8%80%E6%9C%9F?node-id=24325%3A60413&mode=dev
        UIView *statusView1 = [UIView new];
        statusView1.layer.cornerRadius = 10;
        
        
        statusView1.backgroundColor =  [UIColor hjp_colorWithHex:  @"#E6F7FE" ]; // : @"#E8E6FD"
        [contentView addSubview:statusView1];
        [statusView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@20);
            make.top.equalTo(titleLab.mas_bottom).offset(3);
            make.leading.equalTo(iconImg.mas_trailing).offset(8);
        }];
        
        UILabel *statusLbl1 = [UILabel new];
        statusLbl1.textColor = [UIColor hjp_colorWithHex: @"#04ACF3" ];
        statusLbl1.text = isPrepaid ? @"Prepaid" : @"Postpaid";
        statusLbl1.font = FONT_S(12);
        [statusView1 addSubview:statusLbl1];
        [statusLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(statusView1).with.insets(UIEdgeInsetsMake(0, 8, 0, 8));
        }];
    }
    
    
    UIImageView *checkImgV = [UIImageView new];
    [contentView addSubview:checkImgV];
    [checkImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.trailing.equalTo(@-18);
        make.centerY.equalTo(contentView.mas_centerY);
    }];


    checkImgV.image = [UIImage imageNamed:[model.accNbr isEqualToString:[DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr]?  @"radio_yes" : @"radio_no"];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor hjp_colorWithHex:@"#f2f2f2"];
    [contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(@0);
        make.height.equalTo(@1);
        make.top.equalTo(@(showPaidFlagTag ? 76 : 56));

    }];
    return contentView;
}


@end
