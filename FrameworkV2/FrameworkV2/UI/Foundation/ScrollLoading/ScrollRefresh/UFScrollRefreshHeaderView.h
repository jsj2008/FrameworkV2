//
//  UFScrollRefreshHeaderView.h
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadingView.h"

@protocol UFScrollRefreshHeaderViewDelegate;


/*********************************************************
 
    @class
        UFScrollRefreshView
 
    @abstract
        刷新视图
 
    @discussion
        1，加载视图的有效视图区域宽为scrollView的宽，高为从scrollView顶部到scrollView的contentInset顶部
        2，加载中状态时，不会触发加载视图的其它状态，加载结束后进入重置状态
        3，手指拖动时，若加载视图内容完全可见时，触发准备状态，遮挡时触发重置状态，手指松开时，若加载视图内容完全可见，加载视图会滚动至内容刚好完全可见时触发加载，遮挡时，收回加载视图
        4，加载结束，需执行停止加载操作，停止操作结束后将自动滚动收回加载视图，收回后自动执行重置操作，重置操作结束后发送scrollRefreshViewDidStopRefreshing:通知
        5，控制器初始状态为重置状态
        6，控制器提供模拟刷新操作，即滚动视图自动滚动到加载视图内容完全可见时触发加载
 
 *********************************************************/

@interface UFScrollRefreshHeaderView : UFScrollLoadingView

/*!
 * @brief 滚动视图
 */
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFScrollRefreshHeaderViewDelegate> delegate;

/*!
 * @brief 刷新功能的开关
 * @discussion 关闭刷新功能，将不会触发此时间点后的任何加载相关动作，已触发的仍旧有效，加载视图的大小自动调节仍旧有效
 * @discussion 默认值YES
 */
@property (nonatomic, getter=isEnabled) BOOL enable;

/*!
 * @brief 模拟刷新
 */
- (void)simulateStarting;

@end


/*********************************************************
 
    @protocol
        UFScrollRefreshHeaderViewDelegate
 
    @abstract
        刷新视图的代理协议
 
 *********************************************************/

@protocol UFScrollRefreshHeaderViewDelegate <NSObject>

/*!
 * @brief 刷新视图已启动刷新
 * @param refresHeaderView 刷新视图
 */
- (void)scrollRefreshHeaderViewDidStartRefreshing:(UFScrollRefreshHeaderView *)refresHeaderView;

/*!
 * @brief 刷新视图已停止刷新
 * @param refreshHeaderView 刷新视图
 */
- (void)scrollRefreshHeaderViewDidStopRefreshing:(UFScrollRefreshHeaderView *)refreshHeaderView;

@end
