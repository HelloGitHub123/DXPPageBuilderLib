//
//  DCFloorBaseVC.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/27.
//
#import <UIKit/UIKit.h>
#import "DCFloorBaseViewDataSource.h"
#import "DCPageModel.h"
#import "DCFloorViewModel.h"
#import "PBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/// 播放器view的tag，列表中UI控件唯一tag值
#define kHJPBPlayerViewTag 898987

// 事件传递model需要重新创建


@interface DCFloorBaseVC : PBBaseViewController <UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DCFloorViewModel *viewModel;  // 页面数据model，暴露在外面给使用者
@property (nonatomic, weak) id<DCFloorBaseViewDataSource> dataSource; // 数据源接口

/**
 * 更新页面内容
 * @param model 页面内容数据
 */
- (void)updateFloorContent:(DCPageModel *) model;

/**
 * 根据code更新页面内容
 * @param code  对应的楼层code
 */
- (void)updateFloorWithCode:(NSString*)code;

// MARK: - scrollView的代理传递
/**
 在该方法中- (void)scrollViewDidScroll:(UIScrollView *)scrollView调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewDidScroll:(UIScrollView *)scrollView;
/**
 在该方法中- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewWillBeginDragging:(UIScrollView *)scrollView;
/**
 在该方法中- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
/**
 在该方法中- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView调用此方法
 子类可重写该方法完成自身需要在该代理方法中完成的操作
 @param scrollView scrollView
 */
- (void)floorBasicScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
