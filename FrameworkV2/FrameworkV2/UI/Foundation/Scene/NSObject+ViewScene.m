//
//  NSObject+ViewScene.m
//  FrameworkV2
//
//  Created by ww on 11/01/2017.
//  Copyright © 2017 WW. All rights reserved.
//

#import "NSObject+ViewScene.h"
#import <objc/runtime.h>

static const char kUFViewScenePropertyKey_ViewScenes[] = "viewScenes";

@implementation NSObject (Scene)

- (NSArray<UFViewScene *> *)viewScenes
{
    NSMutableArray *scenes = objc_getAssociatedObject(self, kUFViewScenePropertyKey_ViewScenes);
    
    return scenes.count > 0 ? [[NSArray alloc] initWithArray:scenes] : nil;
}

- (void)addViewScene:(UFViewScene *)viewScene
{
    if (!viewScene)
    {
        return;
    }
    
    NSMutableArray *viewScenes = objc_getAssociatedObject(self, kUFViewScenePropertyKey_ViewScenes);
    
    if (!viewScenes)
    {
        viewScenes = [[NSMutableArray alloc] init];
        
        objc_setAssociatedObject(self, kUFViewScenePropertyKey_ViewScenes, viewScenes, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    [viewScenes addObject:viewScene];
    
    [viewScene start];
}

- (void)removeViewScene:(UFViewScene *)viewScene
{
    if (!viewScene)
    {
        return;
    }
    
    [viewScene stop];
    
    NSMutableArray *scenes = objc_getAssociatedObject(self, kUFViewScenePropertyKey_ViewScenes);
    
    [scenes removeObject:viewScene];
}

@end
