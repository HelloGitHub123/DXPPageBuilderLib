//
//  HJSDCycleScrollView.m
//  DITOApp
//
//  Created by 严贵敏 on 2023/2/23.
//

#import "HJSDCycleScrollView.h"
#import "HJSDCollectionViewCell.h"
#import "HJSDCycleModel.h"
#import "UIImageView+WebCache.h"
#import "NSTimer+HJBlocksSupport.h"
//默认定时器时间
static CGFloat const DefaultTime = 3.0f;
static NSString * const reusedID = @"ShowBannerCell";

@interface HJSDCycleScrollView () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    CGFloat _dragStartX;
    CGFloat _dragEndX;
}

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic,strong) UIView *maskView;
@end

@implementation HJSDCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame imgMargin:(CGFloat)imgMargin imgWidth:(CGFloat)imgWidth collectionInset:(CGFloat)collectionInset{

    if (self = [super initWithFrame:frame]) {
        self.imgMargin = imgMargin;
        self.imgWidth = imgWidth;
        self.collectionInset = collectionInset;
    }
    return self;
}

- (UICollectionViewFlowLayout *)flowLayout{

//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    [flowLayout setItemSize:CGSizeMake([self cellWidth],self.bounds.size.height)];
//    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    [flowLayout setMinimumLineSpacing:[self cellMargin]];
//    return flowLayout;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(self.imgWidth > 0 ? self.imgWidth : self.bounds.size.width-44,self.bounds.size.height)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumLineSpacing:self.imgMargin > 0 ? self.imgMargin : 12];
        return flowLayout;
}

- (UICollectionView *)collection{

    return _collection = _collection ?: ({
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:[self flowLayout]];
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.backgroundColor = [UIColor clearColor];
        [collectionView registerClass:[HJSDCollectionViewCell class] forCellWithReuseIdentifier:reusedID];
        [collectionView setUserInteractionEnabled:YES];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.clipsToBounds = NO;
        [self addSubview:collectionView];
//        [self addSubview:self.maskView];
        collectionView;
    });
}

//-(UIView *)maskView{
//
//    if (_maskView == nil) {
//        _maskView = [UIView new];
//        _maskView.backgroundColor = [UIColor whiteColor];
//        _maskView.frame = CGRectMake(0, 0, 16, self.bounds.size.height);
//
//    }
//    return _maskView;
//}


#pragma mark - 构造方法
- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

#pragma mark Setter

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex  = currentIndex;

    if(currentIndex>=0){
        //设置初始位置
        if (_models.count > 0) {
            [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

            if(self.itemDidScrollOperationBlock && self.models.count){
                HJSDCycleModel *item = self.models[_currentIndex];
                self.itemDidScrollOperationBlock(item.index);
            }
            [self.collection reloadData];
        }
    }
}
-(void)setIsAutomatic:(BOOL)isAutomatic
{
    _isAutomatic = isAutomatic;
}
-(void)setIsRepeat:(BOOL)isRepeat
{
    _isRepeat = isRepeat;
}
- (void)setModels:(NSArray *)models{

    if (models.count == 0) {
        return;
    }

    //处理模型 实现无限滚动
    NSMutableArray *modelsM = @[].mutableCopy;
    [modelsM addObjectsFromArray:models];
    if (modelsM.count >= 3) {
        if(_isRepeat){
            HJSDCycleModel *first = modelsM.firstObject;
            HJSDCycleModel *seconed = modelsM[1];
            HJSDCycleModel *last = modelsM.lastObject;
            HJSDCycleModel *lastTwo = modelsM[models.count - 2];

            [modelsM insertObject:last atIndex:0];
            [modelsM insertObject:lastTwo atIndex:0];

            [modelsM addObject:first];
            [modelsM addObject:seconed];
        }else
        {
//            HJSDCycleModel *first = [[HJSDCycleModel alloc]init];
//            [modelsM addObject:first];
        }
        _currentIndex = 1;
    }else if (modelsM.count == 2) {

        if(_isRepeat){
                    HJSDCycleModel *first = modelsM.firstObject;
                    HJSDCycleModel *seconed = modelsM.lastObject;
                    HJSDCycleModel *last = modelsM.lastObject;
                    HJSDCycleModel *lastTwo = modelsM.firstObject;

                    [modelsM insertObject:last atIndex:0];
                    [modelsM insertObject:lastTwo atIndex:0];

                    [modelsM addObject:first];
                    [modelsM addObject:seconed];
        }else
        {
//            HJSDCycleModel *first = [[HJSDCycleModel alloc]init];
//            [modelsM addObject:first];
        }
        _currentIndex = 1;
    }else if (modelsM.count == 1) {
        _currentIndex = 0;
        if(_isRepeat){
                    HJSDCycleModel *first = modelsM.firstObject;
                    HJSDCycleModel *seconed = modelsM.firstObject;
                    HJSDCycleModel *last = modelsM.lastObject;
                    HJSDCycleModel *lastTwo = models.lastObject;
                    [modelsM insertObject:last atIndex:0];
                    [modelsM insertObject:lastTwo atIndex:0];
                    [modelsM addObject:first];
                    [modelsM addObject:seconed];
        }else
        {
//            HJSDCycleModel *first = [[HJSDCycleModel alloc]init];
//            [ modelsM addObject:first];
        }
    }
    _models = modelsM;
    //设置初始位置
    if (models.count > 0) {
        [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

        if(self.itemDidScrollOperationBlock && self.models.count){
            HJSDCycleModel *item = self.models[_currentIndex];
            self.itemDidScrollOperationBlock(item.index);
        }

        [self.collection reloadData];
        if(_isAutomatic){
            //开启定时器
           [self startTimer];
        }

    }


}

#pragma mark - CollectionDelegate
//配置cell居中
- (void)fixCellToCenter {

    //最小滚动距离
    float dragMiniDistance = self.bounds.size.width/20.0f;
    if (_dragStartX -  _dragEndX >= dragMiniDistance) {
        _currentIndex -= 1;//向右
    }else if(_dragEndX -  _dragStartX >= dragMiniDistance){
        _currentIndex += 1;//向左
    }
    NSInteger maxIndex = [self.collection numberOfItemsInSection:0] - 1;
    _currentIndex = _currentIndex <= 0 ? 0 : _currentIndex;
    _currentIndex = _currentIndex >= maxIndex ? maxIndex : _currentIndex;

    [self scrollToCenter];
}

- (void)scrollToCenter {


    if(!_isRepeat && _currentIndex >= self.models.count){
        return;
    }


    [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];


    if(self.itemDidScrollOperationBlock && self.models.count){
        HJSDCycleModel *item = self.models[_currentIndex];
        self.itemDidScrollOperationBlock(item.index);
    }

    //    self.imageView.image = [UIImage imageNamed:model.picture];
    if(_isRepeat){
            //如果是最后一张图
            if (_currentIndex == self.models.count - 1 ) {

                _currentIndex = 2;
                [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                return;
            }
            //第一张图
            else if (_currentIndex == 1) {

                _currentIndex = self.models.count - 3;
                [self.collection scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];

                return;
            }
    }

}

#pragma mark - CollectionDataSource

//卡片宽度
- (CGFloat)cellWidth {
    return self.bounds.size.width-44;
}

//卡片间隔
- (CGFloat)cellMargin {
    return 12;
}

//设置左右缩进
- (CGFloat)collectionInset {

    return 16;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

    if(self.collectionInset > 0) {
        return UIEdgeInsetsMake(0, 0, 0, self.collectionInset);
    }
    if(self.collectionInset == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return UIEdgeInsetsMake(0, 0, 0, 16);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    HJSDCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusedID forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    if(self.imgMargin > 0) {
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return cell;
}

#pragma mark- --------定时器相关方法--------
#pragma mark 设置定时器时间
- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    if(_isAutomatic){
        [self startTimer];
    }

}

- (void)startTimer {
    //如果只有一张图片，则直接返回，不开启定时器
    if (_models.count <= 1) return;
    //如果定时器已开启，先停止再重新开启
    if (self.timer){
        [self stopTimer];
    }
    NSTimeInterval timeInterval = _timeInterval > 0 ? _timeInterval : DefaultTime;
    self.timer = [NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextPage {
    _currentIndex += 1;
    [self scrollToCenter];
}

#pragma mark - UIScrollViewDelegate
//手指拖动开始
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    _dragStartX = scrollView.contentOffset.x;
    [self stopTimer];
}

//手指拖动停止
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    _dragEndX = scrollView.contentOffset.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self fixCellToCenter];
    });
    if(_isAutomatic){
          [self startTimer];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    _currentIndex = indexPath.row;
    [self scrollToCenter];

    if(self.clickItemOperationBlock && self.models.count){

        HJSDCycleModel *item = self.models[_currentIndex];
        self.clickItemOperationBlock(item.index);
    }
}



@end
