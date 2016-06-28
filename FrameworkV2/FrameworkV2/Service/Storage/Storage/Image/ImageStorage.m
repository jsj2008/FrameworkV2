//
//  ImageStorage.m
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "ImageStorage.h"
#import "IndexingFileStorage.h"

@interface ImageStorage ()

@property (nonatomic) IndexingFileStorage *storage;

- (NSString *)indexOfURL:(NSURL *)URL;

@end


@implementation ImageStorage

+ (ImageStorage *)sharedInstance
{
    static ImageStorage *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ImageStorage alloc] init];
        }
    });
    
    return instance;
}

- (void)start
{
    self.storage = [[IndexingFileStorage alloc] initWithDirectory:self.directory];
}

- (void)stop
{
    self.storage = nil;
}

- (void)saveImageByURL:(NSURL *)URL withData:(NSData *)data
{
    [self.storage saveData:data forIndex:[self indexOfURL:URL]];
}

- (void)saveImageByURL:(NSURL *)URL withDataPath:(NSString *)dataPath
{
    [self.storage saveDataWithPath:dataPath forIndex:[self indexOfURL:URL] moveOrCopy:YES];
}

- (void)removeAllImages
{
    [self.storage removeAllDatas];
}

- (NSData *)imageDataByURL:(NSURL *)URL
{
    return [self.storage dataForIndex:[self indexOfURL:URL]];
}

- (long long)currentImageContentSize
{
    return [self.storage currentDataSize];
}

- (NSString *)indexOfURL:(NSURL *)URL
{
    return [[[URL absoluteString] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
}

@end
