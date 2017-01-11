//
//  UFViewScene.h
//  MarryYou
//
//  Created by ww on 15/11/12.
//  Copyright © 2015年 MiaoTo. All rights reserved.
//

#import <UIKit/UIKit.h>

/*********************************************************
 
    @class
        UFViewScene
 
    @abstract
        场景，特定的页面和逻辑组成的UI业务场景，调度controller间的跳转
 
    @discussion
        1，场景内部建议使用UINavigationController管理controller的跳转，对于present产生的controller，应在场景的stop方法中做dismiss的保护，避免场景意外退出后仍有controller被present
 
 *********************************************************/

@interface UFViewScene : NSObject

/*!
 * @brief 初始化场景
 * @param navigationController 页面导航
 * @result 场景
 */
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

/*!
 * @brief 内部页面导航
 */
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

/*!
 * @brief 内部页面导航的起始controller
 * @discussion 标记场景内部页面逻辑的起始Controller
 */
@property (nonatomic, weak) UIViewController *startViewController;

/*!
 * @brief 启动场景
 */
- (void)start;

/*!
 * @brief 结束场景
 */
- (void)stop;

@end
