//
//  DCNewToolBarMaskView.m
//  DCPageBuilding
//
//  Created by 孙全民 on 2023/6/15.
//

#import "DCNewToolBarMaskView.h"
#import "DCPB.h"
@interface DCNewToolBarMaskView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray*picItems;
@property (nonatomic, strong) UIView *maskView;



@end

@implementation DCNewToolBarMaskView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(0, 0, DC_DCP_SCREEN_WIDTH, DC_SCREEN_HEIGHT)];
    if (self) {
        [self configView];
        
        self.maskView = [UIView new];
        [self addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.bottom.equalTo(@(0));
        }];
        self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromSuperview)];
        [self.maskView addGestureRecognizer:tap];
        self.maskView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)configView {
   
}

- (void)showVithView:(UIView*)view  pictures:(NSArray*)picItem{
    self.picItems = picItem;
    
    [[UIApplication sharedApplication].delegate.window  addSubview:self];
    [self.tableView reloadData];
    

    //
    NSInteger itemCount =  picItem.count  - 2 > 3 ? 3.5 : picItem.count  - 2;
    [self.tableView removeFromSuperview];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@-10);
        make.height.equalTo(@(itemCount * 44));
        make.top.equalTo(@(DCP_NAV_HEIGHT - 5));
        make.width.equalTo(@80);
    }];
    
    
}

// MARK: Delegate && Datasouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return   self.picItems.count >= 2 ? self.picItems.count - 2 : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DCNewToolBarMaskItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell = [[DCNewToolBarMaskItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell bindWithCellModel:self.picItems[indexPath.row + 2]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.didSeletedItem){
        self.didSeletedItem(indexPath.row + 2);
    }
    
    [self removeFromSuperview];
}

// MARK: LAZY
- (UITableView *)tableView {
    
    if(!_tableView){
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = YES;
        _tableView.rowHeight = [[UIScreen mainScreen] bounds].size.height;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.scrollEnabled = YES;
        [_tableView registerClass:[DCNewToolBarMaskItemCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return _tableView;
}

- (NSArray *)picItems{
    if(!_picItems){
        _picItems = [NSArray new];
    }
    return _picItems;
}
@end




@interface DCNewToolBarMaskItemCell()
@property (nonatomic, strong) UIImageView*logoImgView;
@property (nonatomic, strong) UILabel *textLbl;
@end

@implementation DCNewToolBarMaskItemCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self ==  [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self configView];
    }
    return self;
}
- (void)configView {
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.textLbl];
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@8);
        make.width.height.equalTo(@32);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@52);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

- (void)bindWithCellModel:(PicturesItem*)item {
    [self.logoImgView sd_setImageWithURL:[NSURL URLWithString:item.src]];
    self.textLbl.text = item.iconName;
    
}

// Mark: Lazy
- (UIImageView *)logoImgView {
    if(!_logoImgView){
        _logoImgView = [UIImageView new];
    }
    return _logoImgView;
}


- (UILabel *)textLbl {
    if(!_textLbl) {
        _textLbl = [UILabel new];
    }
    return _textLbl;
}

@end
