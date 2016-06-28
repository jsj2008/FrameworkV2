//
//  EpubBookLoadHandle.m
//  FoundationProject
//
//  Created by Game_Netease on 14-1-13.
//  Copyright (c) 2014年 WW. All rights reserved.
//

#import "EpubBookLoadHandle.h"
#import "EPub.h"

@interface EpubBookLoadHandle ()

@property (nonatomic, copy) NSString *directory;

@property (nonatomic) EPubBookContainerHandle *container;

@end


@implementation EpubBookLoadHandle

- (instancetype)initWithDirectory:(NSString *)directory
{
    if (self = [super init])
    {
        self.directory = directory;
    }
    
    return self;
}

- (void)loadBook
{
    EPubBookContainerHandle *containHandle = [[EPubBookContainerHandle alloc] init];
    
    EPubPackage *package = [[EPubPackage alloc] initWithEPubDirectory:self.directory];
    
    containHandle.bookId = self.bookId;
    
    containHandle.directory = self.directory;
    
    containHandle.package = package;
    
    self.container = containHandle;
}

- (EPubBookContainerHandle *)bookContainer
{
    return self.container;
}

@end
