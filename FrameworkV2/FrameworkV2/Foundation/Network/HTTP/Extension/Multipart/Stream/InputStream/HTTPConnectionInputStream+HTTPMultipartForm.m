//
//  HTTPConnectionInputStream+HTTPMultipartForm.m
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnectionInputStream+HTTPMultipartForm.h"
#import "HTTPMultipartFormEntity+HTTPConnectionInputStreamChunk.h"

@implementation HTTPConnectionInputStream (HTTPMultipartForm)

- (void)addMultipartFormEntity:(HTTPMultipartFormEntity *)entity
{
    NSArray *chunks = [entity inputStreamChunks];
    
    for (int i = 0; i < [chunks count]; i ++)
    {
        HTTPConnectionInputStreamChunk *chunk = [chunks objectAtIndex:i];
        
        [self addChunk:chunk];
    }
}

@end
