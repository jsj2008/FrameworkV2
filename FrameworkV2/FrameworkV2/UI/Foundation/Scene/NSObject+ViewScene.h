//
//  NSObject+ViewScene.h
//  FrameworkV2
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UFViewScene.h"

/*********************************************************
 
    @category
        NSObject (ViewScene)
 
    @abstract
        NSObject对内嵌场景的扩展
 
 *********************************************************/

@interface NSObject (ViewScene)

/*!
 * @brief 辖内的场景
 */
@property (nonatomic, readonly) NSArray<UFViewScene *> *viewScenes;

/*!
 * @brief 添加并启动场景
 * @param scene 场景对象
 */
- (void)addViewScene:(UFViewScene *)viewScene;

/*!
 * @brief 移除并停止场景
 * @param scene 场景对象
 */
- (void)removeViewScene:(UFViewScene *)viewScene;

@end
