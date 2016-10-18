//
//  UIViewController+Scene.h
//  P006
//
//  Created by ww on 16/9/10.
//  Copyright © 2016年 XKD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFScene.h"

/*********************************************************
 
    @category
        UIViewController (Scene)
 
    @abstract
        UIViewController对场景的扩展
 
    @discussion
        1，UIViewController支持内嵌场景，即UIViewController允许调用和管理场景
 
 *********************************************************/

@interface UIViewController (Scene)

/*!
 * @brief 辖内的场景
 */
@property (nonatomic, readonly) NSArray<UFScene *> *scenes;

/*!
 * @brief 添加并启动场景
 * @param scene 场景对象
 */
- (void)addScene:(UFScene *)scene;

/*!
 * @brief 移除并停止场景
 * @param scene 场景对象
 */
- (void)removeScene:(UFScene *)scene;

@end
