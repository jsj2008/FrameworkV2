//
//  ImageManager.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "ImageManager.h"
#import "NotificationObserver.h"
#import "AsyncTaskDispatcher.h"
#import "ImageDownloadTask.h"
#import "ImageStorage.h"

@interface ImageManager () <ImageDownloadTaskDelegate>

/*!
 * @brief 观察者
 */
@property (nonatomic) NSMutableDictionary *downloadImageObservers;

/*!
 * @brief 任务派发器
 */
@property (nonatomic) AsyncTaskDispatcher *taskDispatcher;

/*!
 * @brief 同步队列
 */
@property (nonatomic) dispatch_queue_t syncQueue;

@end


@implementation ImageManager

- (void)dealloc
{
    dispatch_sync(self.syncQueue, ^{});
}

+ (ImageManager *)sharedInstance
{
    static ImageManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[ImageManager alloc] init];
        }
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.downloadImageObservers = [[NSMutableDictionary alloc] init];
        
        self.syncQueue = dispatch_queue_create("ImageManager", 0);
        
        self.taskDispatcher = [[AsyncTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)start
{
    
}

- (void)stop
{
    [self.taskDispatcher cancel];
}

- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer
{
    if (!URL)
    {
        return;
    }
    
    NSThread *currentThread = [NSThread currentThread];
    
    dispatch_async(self.syncQueue, ^{
        
        if ([URL isFileURL])
        {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            
            [self operate:^{
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:URL withError:nil imageData:data];
                }
                
            } onThread:currentThread];
        }
        else
        {
            NSData *data = [[ImageStorage sharedInstance] imageDataByURL:URL];
            
            if (data)
            {
                [self operate:^{
                    
                    if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                    {
                        [observer imageManager:self didFinishDownloadImageByURL:URL withError:nil imageData:data];
                    }
                    
                } onThread:currentThread];
            }
            else
            {
                NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
                
                if (!set)
                {
                    ImageDownloadTask *task = [[ImageDownloadTask alloc] init];
                    
                    task.imageURL = URL;
                    
                    task.resourceURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[NSDate date].description]];
                                        
                    task.delegate = self;
                    
                    [self.taskDispatcher addTask:task];
                    
                    set = [[NotificationObservingSet alloc] init];
                    
                    set.object = task;
                    
                    [self.downloadImageObservers setObject:set forKey:URL];
                }
                
                NSString *index = [NSString stringWithFormat:@"%llx", (long long)observer];
                
                NotificationObserver *notificationObserver = [[NotificationObserver alloc] init];
                
                notificationObserver.observer = observer;
                
                notificationObserver.notifyThread = currentThread;
                
                [set.observerDictionary setObject:notificationObserver forKey:index];
            }
        }
    });
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer
{
    if (URL && observer)
    {
        dispatch_async(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            if (set)
            {
                NSString *index = [NSString stringWithFormat:@"%llx", (long long)observer];
                
                [set.observerDictionary removeObjectForKey:index];
            }
            
            if ([[set.observerDictionary allValues] count] == 0)
            {
                [self.taskDispatcher cancelTask:set.object];
                
                [self.downloadImageObservers removeObjectForKey:URL];
            }
        });
    }
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL
{
    if (URL)
    {
        dispatch_async(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            [self.taskDispatcher cancelTask:set.object];
            
            [self.downloadImageObservers removeObjectForKey:URL];
        });
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error
{
    if (task.imageURL)
    {
        dispatch_async(self.syncQueue, ^{
            
            [[ImageStorage sharedInstance] saveImageByURL:task.imageURL withDataPath:[task.resourceURL path]];
            
            NSData *imageData = task.resourceURL ? [NSData dataWithContentsOfURL:task.resourceURL] : nil;
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notifyObservers:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:task.imageURL withError:error imageData:imageData];
                }
                
            }];
            
            [self.taskDispatcher removeTask:task];
            
            [self.downloadImageObservers removeObjectForKey:task.imageURL];
        });
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if (task.imageURL)
    {
        dispatch_async(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notifyObservers:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didDownloadImageByURL:withDownloadedSize:expectedSize:)])
                {
                    [observer imageManager:self didDownloadImageByURL:task.imageURL withDownloadedSize:downloadedSize expectedSize:expectedSize];
                }
            }];
        });
    }
}

- (NSData *)localImageDataForURL:(NSURL *)URL
{
    __block NSData *data = nil;
    
    if (URL)
    {
        if ([URL isFileURL])
        {
            data = [NSData dataWithContentsOfURL:URL];
        }
        else
        {
            dispatch_sync(self.syncQueue, ^{
                
                data = [[ImageStorage sharedInstance] imageDataByURL:URL];
            });
        }
    }
    
    return data;
}

@end
