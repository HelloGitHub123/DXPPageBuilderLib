//
//  DCGeneralSelectedCell.m
//  GaiaCLP
//
//  Created by Lee on 2022/5/16.
//

#import "DCGeneralSelectedCell.h"
#import "DCSubsListModel.h"
#import <Masonry/Masonry.h>
#import "DCPBCurrentInfoModel.h"
#import "DCPB.h"
#import <DXPToolsLib/HJTool.h>
#import "PbTools.h"

@interface DCGeneralSelectedCell()
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) DCPBSubsItemModel *model;

@end

@implementation DCGeneralSelectedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *content = [UIView new];
        self.content = content;
        [self.contentView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsZero);
        }];
       
    }
    return self;
}

- (void)contentTapAction {
    if(self.cellSelectBlock) {
        self.cellSelectBlock(self.model);
    }
}

- (void)bindWithModel:(DCPBSubsItemModel *)model{
    self.model = model;
    [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.content.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentTapAction)];
    [self.content addGestureRecognizer:tap];
    
    
    UILabel *titleLab = [UILabel new];
    titleLab.font = FONT_BS(16);
    titleLab.textColor = DC_UIColorFromRGB(0x000000);
    [self.content addSubview:titleLab];
    titleLab.text = [PbTools numberFormatWithString:model.accNbr rule:[DXPPBConfigManager shareInstance].serviceNbrBreakRule];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@18);
        make.centerY.equalTo(self.content.mas_centerY);
    }];
    
    UIView *lineView = [UIView new];  // 竖线
    [self.content addSubview:lineView];
    lineView.backgroundColor = DC_UIColorFromRGB(0xd5d5d5);
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleLab.mas_trailing).offset(8);
        make.centerY.equalTo(self.content.mas_centerY);
        make.height.equalTo(@13);
        make.width.equalTo(@1);
    }];
    
    UILabel *stateLbl = [UILabel new];
    stateLbl.text =  [model.state isEqualToString:@"A"] ? @"Active" : @"Blocked";
    stateLbl.font = FONT_BS(14);
    stateLbl.textColor = DC_UIColorFromRGB([model.state isEqualToString:@"A"]  ? 0x1CD287 : 0xFA2C2C );
    [self.content addSubview:stateLbl];
    [stateLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(lineView.mas_trailing).offset(8);
        make.centerY.equalTo(self.content.mas_centerY);
    }];
    
    
    UIImageView *checkImgV = [UIImageView new];
    [self.content addSubview:checkImgV];

    checkImgV.image = [UIImage imageNamed:[model.accNbr isEqualToString:[DXPPBDataManager shareInstance].currentInfoModel.currentAccNbr]?  @"radio_yes" : @"radio_no"];

//    checkImgV.image = [UIImage imageNamed:[model.accNbr isEqualToString:infoModel.currentAccNbrr]?  @"radio_yes" : @"radio_no"];
    [checkImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.trailing.equalTo(@-18);
        make.centerY.equalTo(self.content.mas_centerY);
    }];
    

    UIView *lineView2 = [UIView new];
    lineView2.backgroundColor = DC_UIColorFromRGB(0xE8E8E8);
    [self.content addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@18);
        make.trailing.equalTo(@-18);
        make.bottom.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
}

@end
