//
//  HJMultiCountdownPostIndicatorView.m
//  DITOApp
//
//  Created by 严贵敏 on 2022/12/16.
//

#import "HJMultiCountdownPostIndicatorView.h"
#import <Masonry/Masonry.h>

CGFloat maxWidth = 35;
CGFloat deftaulWidth = 6;
CGFloat deftaulHeight = 6;
CGFloat deftaulMargin = 10;

@interface HJMultiCountdownPostIndicatorView();
@property (nonatomic,strong) NSMutableArray *views;
@property (nonatomic,assign) NSInteger lastSelect;
@end

@implementation HJMultiCountdownPostIndicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

-(void)setCount:(NSInteger)count{
    _count = count;
    [self setUI];
}

-(void)setUI{

    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.views removeAllObjects];
    MASViewAttribute *leftAttribute = self.mas_left;
    for (int i = 0 ; i<self.count; i++) {
        UIView *subView =[UIView new];
        subView.layer.cornerRadius = deftaulHeight/2;
        subView.backgroundColor = [UIColor redColor];

        if(self.defaulColer){
            subView.backgroundColor = self.defaulColer;
        }

        if(self.selectColor){
            if(i == 0){
                subView.backgroundColor = self.selectColor;
            }
        }

        [self addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i == 0){
                make.left.equalTo(leftAttribute);
                make.width.mas_offset(maxWidth);
            }else{
                make.left.equalTo(leftAttribute).offset(deftaulMargin);
                make.width.mas_offset(deftaulWidth);
            }
            make.height.mas_offset(deftaulHeight);
            make.top.equalTo(self);
        }];
        leftAttribute = subView.mas_right;
        [self.views addObject:subView];
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(leftAttribute);
    }];
    self.lastSelect = 0;
}

-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    [self setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.15 animations:^{
        [self.views enumerateObjectsUsingBlock:^(UIView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(idx == self.lastSelect){
                if(self.defaulColer){
                    obj.backgroundColor = self.defaulColer;
                }
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_offset(deftaulWidth);
                }];
                [obj.superview layoutIfNeeded];
            }
            if(idx == _selectIndex){
                if(self.selectColor){
                    obj.backgroundColor = self.selectColor;
                }
                [obj mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_offset(maxWidth);
                }];
                [obj.superview layoutIfNeeded];
            }
        }];

    }];
    self.lastSelect = _selectIndex;
}

-(NSMutableArray *)views{

    if (_views == nil) {
        _views = [NSMutableArray new];
    }
    return _views;
}

@end
