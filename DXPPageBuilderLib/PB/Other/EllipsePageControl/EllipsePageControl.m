//
//  EllipsePageControl.m
//  EllipsePageControl
//
//  Created by cardlan_yuhuajun on 2017/7/26.
//  Copyright © 2017年 cardlan. All rights reserved.
//

#import "EllipsePageControl.h"
//#import <APCommonUI/APCommonUI.h>

@interface EllipsePageControl ()

@property (nonatomic, strong) UIView *mainView;

@end

@implementation EllipsePageControl
-(instancetype)init{
    if(self=[super init]) {}
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

-(void)initialize{
    self.backgroundColor=[UIColor clearColor];
    _numberOfPages = 0;
    _currentPage = 0;
    _controlSize = 6;
    _controlHeight = 3;
    _controlSpacing = 8;
    _currentColor = [UIColor blackColor];
    _otherColor = [_currentColor colorWithAlphaComponent:0.22];
    _pagecontrlStyle = EllipsePageControlStyleDefault;
 
}

- (void)setPagecontrlStyle:(EllipsePageControlStyle)pagecontrlStyle {
    if (_pagecontrlStyle != pagecontrlStyle) {
        _pagecontrlStyle = pagecontrlStyle;
        if (pagecontrlStyle == EllipsePageControlStyleLine) {
            _otherColor = [UIColor clearColor];
//            _mainView.backgroundColor = [_currentColor colorWithAlphaComponent:0.22];
            _controlSpacing = 0;
        } else {
            _otherColor = [_currentColor colorWithAlphaComponent:0.22];
            _mainView.backgroundColor = [UIColor clearColor];
//            _controlSpacing = 8;
        }
        [self createPointView];
    }
}

-(void)setOtherColor:(UIColor *)otherColor{
    
    if(![self isTheSameColor:otherColor anotherColor:_otherColor]){
        
        _otherColor = otherColor;
        [self createPointView];
    }
}

-(void)setCurrentColor:(UIColor *)currentColor{
    if(![self isTheSameColor:currentColor anotherColor:_currentColor]){
         _currentColor=currentColor;
        [self createPointView];
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    if (!CGSizeEqualToSize(_contentSize, contentSize)) {
        _contentSize = contentSize;
        [self createPointView];
    }
}

-(void)setControlSize:(NSInteger)controlSize{
    if(controlSize != _controlSize){
        _controlSize=controlSize;
        [self createPointView];

    }
}

-(void)setControlHeight:(NSInteger)controlHeight
{
    if(controlHeight != _controlHeight){
        _controlHeight=controlHeight;
        [self createPointView];
    }
}

-(void)setControlSpacing:(NSInteger)controlSpacing{
    if(_controlSpacing!=controlSpacing){
        
        _controlSpacing=controlSpacing;
        [self createPointView];

    }
}

-(void)setCurrentBkImg:(UIImage *)currentBkImg{
    if(_currentBkImg!=currentBkImg){
        _currentBkImg=currentBkImg;
        [self createPointView];
    }
}


-(void)setNumberOfPages:(NSInteger)page{
    if(_numberOfPages==page)
        return;
    _numberOfPages=page;
    [self createPointView];
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    
    if([self.delegate respondsToSelector:@selector(ellipsePageControlClick:index:)])
    {
        [self.delegate ellipsePageControlClick:self index:currentPage];
    }

    if(_currentPage==currentPage)
        return;
    
    [self exchangeCurrentView:_currentPage new:currentPage];
    _currentPage=currentPage;
 
    
}

-(void)clearView{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}



-(void)createPointView{
    [self clearView];
    if(_numberOfPages<=0) return;
    
    CGFloat elementWidth = (_pagecontrlStyle == EllipsePageControlStyleDefault) ? _controlSize: 2*_controlSize;
    
    //居中控件
    CGFloat startX=0;
    CGFloat startY=0;
    CGFloat mainWidth= (_numberOfPages - 1)*_controlSpacing + _numberOfPages * elementWidth;
    if(_contentSize.width<mainWidth){
        startX=0;
    }else{
        startX=(_contentSize.width-mainWidth)/2;
    }
    if(_contentSize.height<_controlHeight){
        startY=0;
    }else{
        startY=(_contentSize.height-_controlHeight)/2;
    }
    
    _controlHeight = (_pagecontrlStyle == EllipsePageControlStyleDefault) ? _controlSize : _controlHeight;
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, mainWidth, _controlHeight)];
    if (_pagecontrlStyle == EllipsePageControlStyleLine) {
//        _mainView.backgroundColor = [_currentColor colorWithAlphaComponent:0.22];
        _mainView.layer.masksToBounds = YES;
        _mainView.layer.cornerRadius = _controlHeight/2;
    } else
    {
        _mainView.backgroundColor = [UIColor clearColor];
        _mainView.layer.masksToBounds = NO;
        _mainView.layer.cornerRadius = _controlHeight/2;
    }
    [self addSubview:_mainView];
    
     //动态创建点
    for (int page=0; page<_numberOfPages; page++) {
        if(page==_currentPage){
            
            CGFloat width, height;
            if (_pagecontrlStyle == EllipsePageControlStyleDefault) {
                width = _controlSize;
                height = _controlSize;
            } else if (_pagecontrlStyle == EllipsePageControlStyleZoom)
            {
                width = _controlSize*2;
                height = _controlHeight;
            } else if (_pagecontrlStyle == EllipsePageControlStyleLine)
            {
                width = _controlSize*2;
                height = _controlHeight;
            } else
            {
                width = _controlSize;
                height = _controlHeight;
            }
            
             UIView *currPointView=[[UIView alloc]initWithFrame:CGRectMake(startX, startY, width, height)];
             currPointView.tag=page+1000;
             currPointView.backgroundColor=_currentColor;
             UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
             [currPointView addGestureRecognizer:tapGesture];
             [self addSubview:currPointView];
             startX=CGRectGetMaxX(currPointView.frame)+_controlSpacing;
            
            if (_pagecontrlStyle == EllipsePageControlStyleDefault || _pagecontrlStyle == EllipsePageControlStyleLine) {
                currPointView.layer.cornerRadius=height/2;
                currPointView.userInteractionEnabled=YES;
            } else if (_pagecontrlStyle == EllipsePageControlStyleZoom)
            {
                currPointView.layer.cornerRadius=0;
                currPointView.userInteractionEnabled=NO;
            }else
            {
                currPointView.layer.cornerRadius=height/2;
                currPointView.userInteractionEnabled=YES;
            }
            
 
            if(_currentBkImg){
                currPointView.backgroundColor=[UIColor clearColor];
                UIImageView *currBkImg=[UIImageView new];
                currBkImg.tag=1234;
                currBkImg.frame=CGRectMake(0, 0, currPointView.frame.size.width, currPointView.frame.size.height);
                currBkImg.image=_currentBkImg;
                [currPointView addSubview:currBkImg];
             }
            
        }else
        {
            CGFloat width, height;
            if (_pagecontrlStyle == EllipsePageControlStyleDefault) {
                width = _controlSize;
                height = _controlSize;
            } else if (_pagecontrlStyle == EllipsePageControlStyleZoom)
            {
                width = _controlSize*2;
                height = _controlHeight;
            } else if (_pagecontrlStyle == EllipsePageControlStyleLine)
            {
                width = _controlSize*2;
                height = _controlHeight;
            } else
            {
                width = _controlSize;
                height = _controlSize;
            }
            
            UIView *otherPointView=[[UIView alloc]initWithFrame:CGRectMake(startX, startY, width, height)];
            otherPointView.backgroundColor=_otherColor;
            otherPointView.tag=page+1000;

            if (_pagecontrlStyle == EllipsePageControlStyleDefault || _pagecontrlStyle == EllipsePageControlStyleLine) {
                otherPointView.layer.cornerRadius=height/2;
                otherPointView.userInteractionEnabled=YES;
            } else if (_pagecontrlStyle == EllipsePageControlStyleZoom)
            {
                otherPointView.layer.cornerRadius=0;
                otherPointView.userInteractionEnabled=NO;
            }else
            {
                otherPointView.layer.cornerRadius=height/2;
                otherPointView.userInteractionEnabled=YES;
            }
            
            
            UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [otherPointView addGestureRecognizer:tapGesture];
            [self addSubview:otherPointView];
             startX=CGRectGetMaxX(otherPointView.frame)+_controlSpacing;
        }
    }
    
}

//切换当前的点
-(void)exchangeCurrentView:(NSInteger)old new:(NSInteger)new
{
    UIView *oldSelect=[self viewWithTag:1000+old];
    CGRect mpSelect=oldSelect.frame;
 
    UIView *newSeltect=[self viewWithTag:1000+new];
    CGRect newTemp=newSeltect.frame;
    
    if(_currentBkImg){
        UIView *imgview=[oldSelect viewWithTag:1234];
        [imgview removeFromSuperview];
        
        newSeltect.backgroundColor=[UIColor clearColor];
        UIImageView *currBkImg=[UIImageView new];
        currBkImg.tag=1234;
        currBkImg.frame=CGRectMake(0, 0, mpSelect.size.width, mpSelect.size.height);
        currBkImg.image=_currentBkImg;
        [newSeltect addSubview:currBkImg];
    }
    oldSelect.backgroundColor=_otherColor;
    newSeltect.backgroundColor=_currentColor;
    //////////////////////
    
    CGFloat unselectedWidth = (_pagecontrlStyle == EllipsePageControlStyleDefault) ? _controlSize:2*_controlSize;
    
    CGFloat seletedWidth = (_pagecontrlStyle == EllipsePageControlStyleDefault)?_controlSize:2*_controlSize;
    
    
    //////////////////////
    __weak typeof(self) weakSelf = self;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat lx=mpSelect.origin.x;
//        if (new<old && (weakSelf.pagecontrlStyle == EllipsePageControlStyleZoom)) {
//            lx+=unselectedWidth;
//        }
        
        oldSelect.frame=CGRectMake(lx, mpSelect.origin.y, unselectedWidth, weakSelf.controlHeight);
 
        CGFloat mx=newTemp.origin.x;
//        if(new>old && (weakSelf.pagecontrlStyle == EllipsePageControlStyleZoom))
//        {
//            mx-=unselectedWidth;
//        }
        newSeltect.frame=CGRectMake(mx, newTemp.origin.y, seletedWidth, weakSelf.controlHeight);
 
        // 左边的时候到右边 越过点击
        if(new-old>1) {
            for(NSInteger t=old+1;t<new;t++)
            {
//                if (weakSelf.pagecontrlStyle == EllipsePageControlStyleZoom) {
//                    UIView *ms=[self viewWithTag:1000+t];
//                    ms.frame=CGRectMake(ms.frame.origin.x-seletedWidth, ms.frame.origin.y, unselectedWidth, weakSelf.controlSize);
//                }
            }
        }
        // 右边选中到左边的时候 越过点击
        if(new-old<-1) {
            for(NSInteger t=new+1;t<old;t++)
            {
//                if (weakSelf.pagecontrlStyle == EllipsePageControlStyleZoom) {
//                    UIView *ms=[self viewWithTag:1000+t];
//                    ms.frame=CGRectMake(ms.frame.origin.x+unselectedWidth, ms.frame.origin.y, unselectedWidth, weakSelf.controlSize);
//                }
            }
        }
    }];
}


-(void)clickAction:(UITapGestureRecognizer*)recognizer{
    
    NSInteger index=recognizer.view.tag-1000;
    
    NSLog(@"-----:%ld",index);

    [self setCurrentPage:index];


}



-(BOOL)isTheSameColor:(UIColor*)color1 anotherColor:(UIColor*)color2{
    return  CGColorEqualToColor(color1.CGColor, color2.CGColor);
}

@end
