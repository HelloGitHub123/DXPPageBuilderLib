//
//  TLVerticalScrollItem.m
//  TalentsLadder
//
//  Created by goviewtech on 2020/6/17.
//  Copyright © 2020 dude. All rights reserved.
//

#import "TLVerticalScrollItem.h"
#import <Masonry/Masonry.h>
#import "DCPB.h"

@implementation TLVerticalScrollItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *contentView = [[UIView alloc]initWithFrame:frame];
        contentView.backgroundColor = [UIColor clearColor];
        _contentView = contentView;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.top.equalTo(@0);
            make.height.equalTo(@(frame.size.height));
            make.right.equalTo(@0);
        }];
        // 添加单击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentClick:)];
        [self.contentView addGestureRecognizer:tap];
        // 图片
        //        self.imgView = [[UIImageView alloc] init];
        //        [contentView addSubview:self.imgView];
        //        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.leading.equalTo(@10);
        //            make.top.equalTo(@5);
        //            make.height.equalTo(@26);
        //            make.width.equalTo(@26);
        //        }];
        
        // 文本
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor hjp_colorWithHex:@"#545454"];
		_textLabel.font = FONT_S(12);
        [contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.mas_equalTo(self.imgView.mas_trailing).offset(10);
            make.leading.equalTo(@0);
            make.top.equalTo(@7);
            make.height.equalTo(@22);
            make.right.equalTo(@0);
        }];
        
    }
    return self;
}

- (void)contentClick:(UIGestureRecognizer *)tap {
    if (_delegate && [_delegate conformsToProtocol:@protocol(NoticeViewEventDelegate)]) {
        if (_delegate && [_delegate respondsToSelector:@selector(NoticeViewClickByIndex:targetId:)]) {
            [_delegate NoticeViewClickByIndex:_rowIndex targetId:self];
        }
    }
}

- (void)setRowIndex:(NSInteger)rowIndex {
    _rowIndex = rowIndex;
//    [self.coverBtn setTag:rowIndex];
}

@end
