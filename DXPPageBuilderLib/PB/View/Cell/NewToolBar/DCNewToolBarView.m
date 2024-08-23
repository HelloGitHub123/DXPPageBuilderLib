//
//  DCNewToolBarView.m
//  AFNetworking
//
//  Created by 孙全民 on 2023/6/12.
//

#import "DCNewToolBarView.h"
#import "DCNewToolBarMaskView.h"
#import "DCPB.h"
#import "DCPageBuildingViewController.h"
#import <DXPToolsLib/HJTool.h>

@interface DCNewToolBarView()
@property (nonatomic, strong) UIView *containerView; // 容器View
@property (nonatomic, strong) UIView *rightBtnView; // 右边容器

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *sidebar;

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) PageCompositionItem *model;
@property (nonatomic, strong) DCNewToolBarMaskView *moreItemView;
@property (nonatomic, strong) UIImageView *logoView;
@property (nonatomic, strong) UIView *notificationRedView;

@property (nonatomic, strong) UIImageView *backImgView;


@end



@implementation DCNewToolBarView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, DCP_SCREEN_WIDTH, DCP_NAV_HEIGHT)];
    if (self) {
        self.bgView.alpha = 0;
        [self configView];
    }
    return self;
}

- (void)configView {
    //
   
    [self addSubview:self.bgView];
    
    self.containerView = [UIView new];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.bottom.trailing.equalTo(@0);
        make.height.equalTo(@44);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];

    self.sidebar.hidden = NO;
    self.logoView.hidden = NO;
    self.titleLbl.hidden = NO;
}

// MARK: Set GEt
- (void)setBgAlpha:(CGFloat)bgAlpha {
    CompositionProps *props = self.model.content.props;
    // 沉浸试导航栏
	// props.toolbarBgStyle = @"IE";
	// props.hasToolbarBg = @"Y";
    if([@"IE" isEqualToString:props.toolbarBgStyle] && [@"Y" isEqualToString:props.hasToolbarBg]) {
        self.bgView.alpha = bgAlpha;
    }
  
}

// MARK: 绑定数据
- (void)bindCellModel:(PageCompositionItem *)item {
    self.model = item;
    [self.sidebar removeFromSuperview];
    [self.logoView removeFromSuperview];
    [self.titleLbl removeFromSuperview];
    [self.backImgView removeFromSuperview];
    [self.rightBtnView removeFromSuperview];
    self.notificationRedView = nil;
    // 移除在添加
    CompositionProps *props = item.content.props;
    if(props.horizontalOutterMargin > 0) {
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(props.horizontalOutterMargin));
            make.trailing.equalTo(@(-props.horizontalOutterMargin));
        }];
    }
    CGFloat sideBarRight = 0;
    CGFloat sideBarLeft = 0;
    
    // 背景色
	// props.toolbarBgStyle = @"color";
	// props.hasToolbarBg = @"Y";
    if ([@"color" isEqualToString:props.toolbarBgStyle] && [@"Y" isEqualToString:props.hasToolbarBg] && !DC_IsStrEmpty(props.toolbarBg)) {
        self.bgView.backgroundColor = [UIColor hjp_colorWithHex:props.toolbarBg];
        self.bgView.alpha = props.toolbarBgOpacity/100.0;
    }
    
    
    CGFloat margin = 16;
    if([@"Y" isEqualToString:props.hasSidebar] && !DC_IsArrEmpty(props.sidebarInfo)) {
        PicturesItem *sideitem = [props.sidebarInfo firstObject];
        [self.containerView addSubview:self.sidebar];
        CGFloat sideH = sideitem.height > 0  ? sideitem.height / 2 :  32; // 固定高度
        CGFloat sideW = sideitem.width > 0  ? sideitem.width / 2 :  32; // 固定高度
        [self.sidebar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@(sideBarLeft));
            make.width.equalTo(@(sideW));
            make.height.equalTo(@(sideH));
            make.centerY.equalTo(self.containerView.mas_centerY);
        }];

        [self.sidebar sd_setImageWithURL:[NSURL URLWithString:sideitem.src]];
        sideBarLeft = sideBarLeft + sideW + margin;
    }
    
    if([@"Y" isEqualToString:props.hasLogo]) {
        [self.containerView addSubview:self.logoView];
        PicturesItem *logoItem = [props.logoInfo firstObject];
        [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.width.equalTo(@(logoItem.width/2.0));
            make.height.equalTo(@(logoItem.height/2.0));
            make.leading.equalTo(@(sideBarLeft));
        }];
        [self.logoView sd_setImageWithURL:[NSURL URLWithString:logoItem.src]];
        sideBarLeft = sideBarLeft + margin + logoItem.width/2.0;
    }
    
    
    // 有返回按钮
    if([@"Y" isEqualToString:props.hasBack]) {
//        UIViewController *vc = [Tools currentVC].navigationController.viewControllers[0];
        if ([HJTool currentVC].navigationController.viewControllers.count != 1) {//![vc isKindOfClass:[DCPageBuildingViewController class]]
            //如果在首页，即使配置了返回按钮，也不展示
            [self.containerView addSubview:self.backImgView];
            PicturesItem *backItem = [props.backInfo firstObject];

            [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.containerView.mas_centerY);
                make.width.equalTo(@(backItem.width/2.0));
                make.height.equalTo(@(backItem.height/2.0));
                make.leading.equalTo(@(0));  // 左边间距
            }];
            [self.backImgView sd_setImageWithURL:[NSURL URLWithString:backItem.src]];
        }
    }
    
    // 添加右边按钮
    NSMutableArray *pictures = [[NSMutableArray alloc]initWithArray:props.pictures];
    if(props.pictures.count > 3){
        [pictures insertObject:[props.pictures firstObject] atIndex:0];
    }
    [self.rightBtnView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.rightBtnView removeFromSuperview];
    __block CGFloat btnH = 0;
    if(!DC_IsArrEmpty(props.pictures)){
        __block CGFloat btnTotalW = 0;
        [pictures enumerateObjectsUsingBlock:^(PicturesItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 创建按钮并添加
            UIButton *btn = [self getButtonItem:obj idx:idx];
            [self.rightBtnView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(@(-btnTotalW));
                make.width.equalTo(@(obj.width/ 2.0) );
                make.height.equalTo(@(obj.height/ 2.0 ));
                make.centerY.equalTo(self.rightBtnView.mas_centerY);
            }];
            btnH = obj.height/ 2.0 ;
            btnTotalW = btnTotalW + obj.width/ 2.0  + 8;
            if(idx >= 2){
                *stop = YES;
            }
        }];
        
        
        [self.containerView addSubview:self.rightBtnView];
        [self.rightBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@-16);
            make.height.equalTo(@(btnH));
            make.width.equalTo(@(btnTotalW - 8));
            make.centerY.equalTo(self.containerView.mas_centerY);
        }];
        
        sideBarRight = 16 + btnTotalW - 8;
        // 设置宽度
    }
    
    
    if(![@"Y" isEqualToString:props.hasLogo] && !DC_IsStrEmpty(props.title)){
        [self.containerView addSubview:self.titleLbl];
        // 设置样式
        self.titleLbl.textAlignment = NSTextAlignmentLeft;
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.containerView.mas_centerY);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
        }];
        self.titleLbl.text = props.title;
        if([@"left" isEqualToString:props.position]){
            self.titleLbl.textAlignment = NSTextAlignmentLeft;
        }else if([@"right" isEqualToString:props.position]) {
            self.titleLbl.textAlignment = NSTextAlignmentRight;
        }else {
            self.titleLbl.textAlignment = NSTextAlignmentCenter;
        }
        
        if(!DC_IsStrEmpty(props.titleFontColor)){
            self.titleLbl.textColor = [UIColor hjp_colorWithHex:props.titleFontColor];
        }
    }
}

- (UIButton*)getButtonItem:(PicturesItem*)item idx:(NSInteger)idx{
    UIButton *btn = [UIButton new];
    btn.tag = 1000 +idx;
    [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if(self.model.content.props.pictures.count > 3 && idx == 0){
        [btn setImage:[UIImage imageNamed:@"pb_menu"] forState:UIControlStateNormal];
    }else {
        [btn sd_setImageWithURL:[NSURL URLWithString:item.src] forState:UIControlStateNormal];
    }
   
    UIView *redView = [UIView new];
    redView.hidden = YES;
    if([@"/clp_notification/index" isEqualToString:item.link]) {
        self.notificationRedView = redView;
        if(self.redViewShow) {
            redView.hidden = NO;
        }
    }
    redView.backgroundColor = [UIColor redColor];
    redView.layer.cornerRadius = 3;
    [btn addSubview:redView];
    [redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@6);
        make.top.equalTo(btn.mas_top);
        make.trailing.equalTo(btn.mas_trailing);
    }];
    return btn;
}

// 更新通知红点
- (void)setRedViewShow:(BOOL)redViewShow {
    _redViewShow = redViewShow;
    if(self.notificationRedView) {
        self.notificationRedView.hidden = !redViewShow;
    }
}

// MARK: Lazy
- (void)menuClick {
    if(self.toolBarActionBlock) {
        self.toolBarActionBlock(DCPBToolBarActionMenu,nil);
    }
}

- (void)logoClick {
    return;
    if(self.toolBarActionBlock) {
        CompositionProps *props = self.model.content.props;
        if(!DC_IsArrEmpty(props.logoInfo)) {
            PicturesItem *item = [props.logoInfo firstObject];
            self.toolBarActionBlock(DCPBToolBarActionBtns,item);
        }
       
    }
}

// 返回按钮点击
- (void)backClick {
    if(self.toolBarBackAction) {
            self.toolBarBackAction();
    }
}
- (void)rightBtnClick:(UIView*)view {
    NSInteger index = view.tag - 1000;
    CompositionProps *props = self.model.content.props;
    if(props.pictures.count > 2 && index == 0) {
        [self.moreItemView showVithView:self.rightBtnView pictures:props.pictures];
    }else {
        if(self.toolBarActionBlock) {
            PicturesItem *item  = nil;
            if(props.pictures.count > index) {
                item = [props.pictures objectAtIndex:index];
            }
            self.toolBarActionBlock(DCPBToolBarActionBtns, item);
        }
    }
}


// MARK: LAzy
- (UIImageView*)sidebar {
    if (!_sidebar) {
        _sidebar = [UIImageView new];
        _sidebar.image = [UIImage imageNamed:@"pb_tm_menu"];
        _sidebar.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(menuClick)];
        [_sidebar addGestureRecognizer:tap];
    }
    return _sidebar;
}

- (UIImageView*)logoView {
    if (!_logoView) {
        _logoView =  [UIImageView new];
        _logoView.image = [UIImage imageNamed:@"pb_tm_logo"];
        _logoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(logoClick)];
        [_logoView addGestureRecognizer:tap];
    }
    return _logoView;
}

- (UIView *)bgView {
    if(!_bgView) {
        _bgView = [UIView new];
    }
    return _bgView;
}

- (UILabel *)titleLbl {
    if(!_titleLbl) {
        _titleLbl = [UILabel new];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = FONT_BS(16);
    }
    return _titleLbl;
}

- (UIView *)rightBtnView {
    if(!_rightBtnView){
        _rightBtnView = [UIView new];
    }
    return _rightBtnView;
}

- (DCNewToolBarMaskView *)moreItemView {
    if(!_moreItemView) {
        _moreItemView = [DCNewToolBarMaskView new];
		__weak typeof(self)weakSelf = self;
        _moreItemView.didSeletedItem = ^(NSInteger index) {
            if(weakSelf.toolBarActionBlock) {
                CompositionProps *props = weakSelf.model.content.props;
                PicturesItem *item  = nil;
                if(props.pictures.count > index) {
                    item = [props.pictures objectAtIndex:index];
                }
                weakSelf.toolBarActionBlock(DCPBToolBarActionBtns, item);
            }
        };
    }
    return _moreItemView;
}



- (UIImageView*)backImgView {
    if (!_backImgView) {
        _backImgView =  [UIImageView new];
        _backImgView.image = [UIImage imageNamed:@"pb_tm_logo"];
        _backImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backClick)];
        [_backImgView addGestureRecognizer:tap];
    }
    return _backImgView;
}
@end
