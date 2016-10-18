//
//  UIViewController+Scene.m
//  P006
//
//  Created by ww on 16/9/10.
//  Copyright © 2016年 XKD. All rights reserved.
//

#import "UIViewController+Scene.h"
#import <objc/runtime.h>

static const char kUIViewControllerPropertyKey_Scenes[] = "scenes";


@implementation UIViewController (Scene)

- (NSArray<UFScene *> *)scenes
{
    NSMutableArray *scenes = objc_getAssociatedObject(self, kUIViewControllerPropertyKey_Scenes);
    
    return scenes.count > 0 ? [[NSArray alloc] initWithArray:scenes] : nil;
}

- (void)addScene:(UFScene *)scene
{
    if (!scene)
    {
        return;
    }
    
    NSMutableArray *scenes = objc_getAssociatedObject(self, kUIViewControllerPropertyKey_Scenes);
    
    if (!scenes)
    {
        scenes = [[NSMutableArray alloc] init];
        
        objc_setAssociatedObject(self, kUIViewControllerPropertyKey_Scenes, scenes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [scenes addObject:scene];
    
    [scene start];
}

- (void)removeScene:(UFScene *)scene
{
    if (!scene)
    {
        return;
    }
    
    [scene stop];
    
    NSMutableArray *scenes = objc_getAssociatedObject(self, kUIViewControllerPropertyKey_Scenes);
    
    [scenes removeObject:scene];
}

@end
