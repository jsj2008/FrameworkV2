//
//  UFScene+Scene.h
//  P006
//
//  Created by ww on 16/9/10.
//  Copyright © 2016年 XKD. All rights reserved.
//

#import "UFScene.h"

/*********************************************************
 
    @category
        UFScene (Scene)
 
    @abstract
        UFScene对内嵌场景的扩展
 
    @discussion
        1，UFScene支持内嵌场景，即UFScene允许调用和管理场景
 
 *********************************************************/

@interface UFScene (Scene)

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
