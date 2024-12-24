//
//  DCBroadbandAccountCell.m
//  AFNetworking
//
//  Created by Lee on 27.2.24.
//

#import "DCBroadbandAccountCell.h"
#import "DCBroadbandView.h"
#import "DCBroadbandAccountCellModel.h"
@interface DCBroadbandAccountCell()
@property (nonatomic, strong) DCBroadbandView * broadBandView;

@end

@implementation DCBroadbandAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)bindCellModel:(DCBroadbandAccountCellModel *)cellModel {
    [super bindCellModel:cellModel];
    self.contentView.backgroundColor = DC_UIColorFromRGB(0xffffff);
    [_broadBandView removeFromSuperview];
    _broadBandView = nil;
    if (!_broadBandView) {
        _broadBandView = [[DCBroadbandView alloc] initWithFrame:CGRectZero withModel:cellModel];
        _broadBandView.layer.masksToBounds = YES;
        _broadBandView.layer.cornerRadius = 16.f;
    }
    [self.contentView addSubview:_broadBandView];
    [_broadBandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(16);
        make.trailing.mas_equalTo(-16);
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
    }];
}


#pragma mark -- lazy load


@end
