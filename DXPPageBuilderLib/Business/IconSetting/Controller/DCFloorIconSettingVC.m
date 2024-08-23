//
//  DCFloorIconSettingVC.m
//  Pods
//
//  Created by 孙全民 on 2023/2/13.
//

#import "DCFloorIconSettingVC.h"
#import "DCIconEditCell.h"
#import "DCPB.h"
#import <DXPCategoryLib/UIColor+Category.h>
#import <DXPToolsLib/SNAlertMessage.h>
#import "DCPBMenuItemModel.h"

@interface DCFloorIconSettingVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSMutableArray *dataSouce;

@end

@implementation DCFloorIconSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Services";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configView];
    [self configData];
}

// MARK: Private
- (void)configView {
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    // 设置右边按钮
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.equalTo(@0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(-self.view.safeAreaInsets.bottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
    }];
}

- (void)configData {
    // 取出  首页展示&&在菜单中的数据 menuid，留下面进行判断 是否展示
    NSArray *dbModels = [DCPBManager sharedInstance].iconMenuListData;
    NSMutableArray *dmModelIdArr = [NSMutableArray new];
    [dbModels enumerateObjectsUsingBlock:^(DCPBMenuItemModel*  _Nonnull temp, NSUInteger idx, BOOL * _Nonnull stop1) {
        if (!DC_IsArrEmpty(temp.children)) {
            [temp.children enumerateObjectsUsingBlock:^(DCPBMenuItemModel *  _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop2) {
                [dmModelIdArr addObject:model.menuId];
            }];
        }
    }];
    
    // 这里需要判断是否有缓存，缓存数据是DCMenuItemModel的数组
    NSArray *cacheArr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"kHomeDashboardIconCache"];
    NSMutableArray *homeIdArr = [NSMutableArray new];
    [cacheArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		DCPBMenuItemModel *itemModel = [DCPBMenuItemModel yy_modelWithJSON:obj];
        if ([dmModelIdArr indexOfObject:itemModel.menuId] != NSNotFound) {
            [homeIdArr addObject:itemModel.menuId?:@""];
        }
    }];
    
    
    // datasouce 中数组都是mutable，为了方便进行添加一移除操作
    self.dataSouce = [[NSMutableArray alloc]init];
    
    // 取出首页展示的
    NSMutableArray *showHomeArr = [[NSMutableArray alloc]init];
    
    // 添加金刚区数据
    [dbModels enumerateObjectsUsingBlock:^(DCPBMenuItemModel*  _Nonnull temp, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *midArr = [NSMutableArray new];
        if (!DC_IsArrEmpty(temp.children)) {
            [temp.children enumerateObjectsUsingBlock:^(DCPBMenuItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                DCIconEditCellModel *cellModel = [DCIconEditCellModel new];
                NSIndexPath *originIndexpath = [NSIndexPath indexPathForRow:midArr.count inSection:self.dataSouce.count+1];
                cellModel.originIndexPath = originIndexpath;
                cellModel.isEditing = NO;
                cellModel.data = obj;
                cellModel.isShow = NO;
                
                // 判断缓存数据展示数据
                if (DC_IsArrEmpty(homeIdArr)) {
                    if (!obj.isDashboardShow) {
                        [midArr addObject:cellModel];
                    }else{
                        cellModel.isFixed = [@"Y" isEqualToString:obj.fixFlag];
                        cellModel.isShow = YES;
                        [showHomeArr addObject:cellModel];
                    }
                }else {
                    if ([homeIdArr indexOfObject:obj.menuId] == NSNotFound) {
                        [midArr addObject:cellModel];
                    }else{
                        cellModel.isFixed = [@"Y" isEqualToString:obj.fixFlag];
                        cellModel.isShow = YES;
                        [showHomeArr addObject:cellModel];
                    }
                }
            }];
            
            NSMutableDictionary *dic = [NSMutableDictionary new];
            dic[@"menuName"]  = temp.menuName;
            dic[@"children"]  = midArr;
            [self.dataSouce addObject:dic];
        }
    }];
    
    // 首页展示的需要放在最上面（fixFlag是固定的不能进行移除）
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"menuName"]  = @"Home Services";
    dic[@"children"]  = [[showHomeArr sortedArrayUsingComparator:^NSComparisonResult(DCIconEditCellModel*  _Nonnull obj1, DCIconEditCellModel*  _Nonnull obj2) {
        if ([@"Y" isEqualToString:obj1.data.fixFlag]) {
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }] mutableCopy];
    [self.dataSouce insertObject:dic atIndex:0];
}



// MARK: 事件处理
- (void)onClickedOKbtn:(UIButton*) btn {
    
    // 判断homeData数组是否为空(不能为空)
    btn.selected = !btn.selected;
    [self.collectionView reloadData];
    
    if (!btn.selected) {
        NSMutableArray *homeIconArr =  [[self.dataSouce firstObject] objectForKey:@"children"];
        if (DC_IsArrEmpty(homeIconArr)) return;
        // 这里要保存编辑后的数据，保存到本地， 下次首页获取的数据就直接从缓存获取数据
        NSMutableArray *showItemArr = [NSMutableArray new];
        [homeIconArr enumerateObjectsUsingBlock:^(DCIconEditCellModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [showItemArr addObject:obj.data];
        }];
        NSArray *arr = [showItemArr yy_modelToJSONObject];
        // 首页金刚区缓存数据，进入首页要判断是否有缓存，有缓存直接使用缓存。
        
        if (!DC_IsArrEmpty(arr)) {
            [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"kHomeDashboardIconCache"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateFloorWithoutContent" object:@{@"code":@"GAIAIcon"}];
            
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// MARK: Delegate Datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataSouce.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSMutableDictionary * temp = (NSMutableDictionary*)self.dataSouce[section];
    NSArray * childRenArr = [temp objectForKey:@"children"];
    return childRenArr.count;
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DCIconEditCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSMutableDictionary * temp = (NSMutableDictionary*)self.dataSouce[indexPath.section];
    NSArray * childRenArr = [temp objectForKey:@"children"];
    DCIconEditCellModel *cellModel = childRenArr[indexPath.row];
    cellModel.isEditing = self.rightBtn.selected;
    [cell bindCellModel:cellModel];
    return cell;
}


- (CGSize)collectionView:(UICollectionView*)collectionView  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeMake(DCP_SCREEN_WIDTH, 43);
    return size;
}

- (CGSize)collectionView:(UICollectionView*)collectionView  layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = CGSizeMake(DCP_SCREEN_WIDTH, 0);
    return size;
}
 
// 创建一个继承collectionReusableView的类,用法类比tableViewcell
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        // 头部视图
        // 代码初始化表头
        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView"];
      
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderReusableView" forIndexPath:indexPath];
        
        UILabel *titleLbl = [[UILabel alloc]init];
        titleLbl.textColor = [UIColor blackColor];
        titleLbl.font = FONT_S(14);
        NSMutableDictionary * temp = (NSMutableDictionary*)self.dataSouce[indexPath.section];
        titleLbl.text = [temp objectForKey:@"menuName"];
        [reusableView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [reusableView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@16);
        }];
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        // 底部视图设置同理
//        [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableView"];
//
//        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterReusableView" forIndexPath:indexPath];
//
//        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = UIColorFromRGB(0xFFCD00);
//        UILabel *contentLbl = [[UILabel alloc]init];
//        contentLbl.text = @"Select your favorite services to use on Home Page";
//        [view addSubview:contentLbl];
//        [contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(@16);
//            make.trailing.equalTo(@-16);
//            make.top.equalTo(@7);
//            make.bottom.equalTo(@-9);
//        }];
//        [reusableView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(@8);
//            make.leading.trailing.equalTo(@0);
//        }];
    }
    return reusableView;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.rightBtn.selected) {
        // 当前选中对象
        NSMutableDictionary * currentDic = (NSMutableDictionary*)self.dataSouce[indexPath.section];
        NSMutableArray * currentArr = [currentDic objectForKey:@"children"];
        DCIconEditCellModel *currentModel = currentArr[indexPath.row];
        if (currentModel.isFixed) return;
        
        // 添加到目标位置
        if (currentModel.isShow) {
            NSMutableArray * originChildrenArr = self.dataSouce[currentModel.originIndexPath.section][@"children"];
            [originChildrenArr addObject:currentModel];
            
            
            if (originChildrenArr.count > 1) {
                NSArray *tmpArr = [originChildrenArr sortedArrayUsingComparator:^NSComparisonResult(DCIconEditCellModel *obj1, DCIconEditCellModel *obj2) {
                    return obj1.originIndexPath.row - obj2.originIndexPath.row;
                }];
                self.dataSouce[currentModel.originIndexPath.section][@"children"] = [NSMutableArray arrayWithArray:tmpArr];
            }else {
                self.dataSouce[currentModel.originIndexPath.section][@"children"] = originChildrenArr;
            }
            
        } else {
            NSMutableArray * homeShowArr = [self.dataSouce firstObject][@"children"];
            if(homeShowArr.count >= 15) {
                [SNAlertMessage displayMessageInView:self.view Message:@"最多添加15个"];
                return;
            }
            [homeShowArr addObject:currentModel];
        }
        // 移除当前对象
        [currentArr removeObject:currentModel];
        
        currentModel.isShow = !currentModel.isShow;
        
        [self.collectionView reloadData];
    }else {
        // 当前选中对象
        NSMutableDictionary * currentDic = (NSMutableDictionary*)self.dataSouce[indexPath.section];
        NSMutableArray * currentArr = [currentDic objectForKey:@"children"];
        DCIconEditCellModel *currentModel = currentArr[indexPath.row];
		DCPBMenuItemModel *itemModel = currentModel.data;
        [[DCRouterManager sharedInstance] dealWithViewNameWithUrl:itemModel.appUrl type:[itemModel.schemaType intValue] fromVc:self serviceName:itemModel.menuName];
    }
       
    
    
}

////定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(96, 100);
//}
//
////定义每个UICollectionView 的 margin
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(5, 5, 5, 5);
//}

// MARK: LAZY
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemW = (DCP_SCREEN_WIDTH - 32)/4.0;
        layout.itemSize = CGSizeMake( itemW , 112);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(0, 16, 8, 16);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dragInteractionEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.clipsToBounds = NO;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [_collectionView registerClass:[DCIconEditCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}


- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
        [_rightBtn setTitle:@"Edit" forState:UIControlStateNormal];
        [_rightBtn setTitle:@"Save" forState:UIControlStateSelected];
        [_rightBtn setTitleColor:[UIColor colorWithHexString:@"#959E6"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(onClickedOKbtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
@end
