//
//  UFScrollLoadingView.h
//  Test
//
//  Created by ww on 16/2/16.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @enum
        UFScrollLoadingViewStatus
 
    @abstract
        加载视图的状态
 
 *********************************************************/

typedef NS_ENUM(NSUInteger, UFScrollLoadingViewStatus)
{
    UFScrollLoadingViewStatus_Reset = 1,    // 重置状态
    UFScrollLoadingViewStatus_Prepare = 2,  // 准备状态
    UFScrollLoadingViewStatus_Loading = 3   // 加载中状态
};


/*********************************************************
 
    @class
        UFScrollLoadingView
 
    @abstract
        加载视图
 
    @discussion
        1，本类是含有加载操作的视图的抽象类，封装了加载流程并提供了相应接口
        2，加载操作包含了重置，准备和加载中三种状态，初始状态为重置状态
 
 *********************************************************/

@interface UFScrollLoadingView : UIView

/*!
 * @brief 加载时内容区域的高度
 * @discussion 内容区域是加载过程中的有效显示区域
 */
@property (nonatomic) CGFloat loadingContentHeight;

/*!
 * @brief 视图状态
 */
@property (nonatomic) UFScrollLoadingViewStatus status;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 自定义启动操作
 * @discussion 子类可重写本方法实现自定义的启动操作
 * @discussion 子类重写后，必须手动调用completion才能保证流程的正确
 * @param completion 自定义启动后执行的操作块
 */
- (void)customStartWithCompletion:(void (^)(void))completion;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 自定义停止操作
 * @discussion 子类可重写本方法实现自定义的停止操作
 * @discussion 子类重写后，必须手动调用completion才能保证流程的正确
 * @param completion 自定义停止后执行的操作块
 */
- (void)customStopWithCompletion:(void (^)(void))completion;

/*!
 * @brief 准备
 */
- (void)prepare;

/*!
 * @brief 自定义准备操作
 * @discussion 子类可重写本方法实现自定义的准备操作
 * @discussion 子类重写后，必须手动调用completion才能保证流程的正确
 * @param completion 自定义准备后执行的操作块
 */
- (void)customPrepareWithCompletion:(void (^)(void))completion;

/*!
 * @brief 重置
 */
- (void)reset;

/*!
 * @brief 自定义重置操作
 * @discussion 子类可重写本方法实现自定义的重置操作
 * @discussion 子类重写后，必须手动调用completion才能保证流程的正确
 * @param completion 自定义重置后执行的操作块
 */
- (void)customResetWithCompletion:(void (^)(void))completion;

@end
