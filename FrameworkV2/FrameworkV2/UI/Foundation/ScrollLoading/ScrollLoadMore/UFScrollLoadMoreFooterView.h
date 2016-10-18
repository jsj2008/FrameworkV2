//
//  UFScrollLoadMoreFooterView.h
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadingView.h"

@protocol UFScrollLoadMoreFooterViewDelegate;


/*********************************************************
 
    @class
        UFScrollLoadMoreFooterView
 
    @abstract
        加载更多视图
 
    @discussion
        1，加载视图的有效视图区域为宽为scrollView的宽，高为从scrollView的contentInset底部到scrollView底部
        2，加载中状态时，不会触发加载视图的其它状态，加载结束后进入重置状态
        3，当滚动视图大小(frame)能容纳其内容区域和加载视图内容区域（包括inset）时，若手指拖动使得滚动视图contentOffset负偏移时，触发准备状态，正偏移时触发重置状态
        4，当滚动视图大小(frame)不能容纳其内容区域和加载视图内容区域时，若手指拖动，当加载视图完全可见时，触发准备状态，被遮挡时，触发重置状态，手指松开时，若加载视图完全可见触发加载状态
        5，加载结束，需执行停止加载操作，停止操作结束后自动执行重置操作，重置操作结束后发送scrollLoadMoreViewDidStopLoadingMore:通知
        6，控制器初始状态为重置状态
        7，加载视图大小自动调节，将填充滚动视图内容区域（包括inset）尾后的空白区域，若滚动视图内容区域大小为0，加载视图将会设置为0
 
 *********************************************************/

@interface UFScrollLoadMoreFooterView : UFScrollLoadingView

/*!
 * @brief 滚动视图
 */
@property (nonatomic, readonly) UIScrollView *scrollView;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFScrollLoadMoreFooterViewDelegate> delegate;

/*!
 * @brief 加载更多功能的开关
 * @discussion 关闭加载更多功能，将不会触发此时间点后的任何加载相关动作，已触发的仍旧有效，加载视图的大小自动调节仍旧有效
 * @discussion 默认值YES
 * @discussion 开启时，若此时autoLoadingWhenContentSizeVisible也开启，将自动检测当前状态，若符合自动加载条件，立即启动自动加载
 */
@property (nonatomic, getter=isEnabled) BOOL enable;

@end


/*********************************************************
 
    @protocol
        UFScrollLoadMoreFooterViewDelegate
 
    @abstract
        加载更多视图的代理协议
 
 *********************************************************/

@protocol UFScrollLoadMoreFooterViewDelegate <NSObject>

/*!
 * @brief 加载更多视图已启动加载更多
 * @param loadMoreFooterView 加载更多视图
 */
- (void)scrollLoadMoreFooterViewDidStartLoadingMore:(UFScrollLoadMoreFooterView *)loadMoreFooterView;

/*!
 * @brief 加载更多视图已停止加载更多
 * @param loadMoreFooterView 加载更多视图
 */
- (void)scrollLoadMoreFooterViewDidStopLoadingMore:(UFScrollLoadMoreFooterView *)loadMoreFooterView;

@end
