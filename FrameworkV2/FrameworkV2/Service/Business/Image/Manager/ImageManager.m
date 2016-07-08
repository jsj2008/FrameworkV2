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
#import "ImageManagerDownloadTask.h"
#import "ImageStorage.h"

@interface ImageManager () <ImageManagerDownloadTaskDelegate>

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
        
        self.syncQueue = dispatch_queue_create("ImageManager", DISPATCH_QUEUE_CONCURRENT);
        
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
    
    dispatch_sync(self.syncQueue, ^{
        
        if ([URL isFileURL])
        {
            NSData *data = [NSData dataWithContentsOfURL:URL];
            
            [self operate:^{
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:URL withError:nil imageData:data];
                }
                
            } onThread:[NSThread currentThread]];
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
                    
                } onThread:[NSThread currentThread]];
            }
            else
            {
                NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
                
                if (!set)
                {
                    ImageManagerDownloadTask *task = [[ImageManagerDownloadTask alloc] init];
                    
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
                
                notificationObserver.notifyThread = [NSThread currentThread];
                
                [set.observerDictionary setObject:notificationObserver forKey:index];
            }
        }
    });
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer
{
    if (URL && observer)
    {
        dispatch_sync(self.syncQueue, ^{
            
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
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
            
            [self.taskDispatcher cancelTask:set.object];
            
            [self.downloadImageObservers removeObjectForKey:URL];
        });
    }
}

- (void)imageManagerDownloadTask:(ImageManagerDownloadTask *)task didFinishWithError:(NSError *)error
{
    if (task.imageURL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            [[ImageStorage sharedInstance] saveImageByURL:task.imageURL withDataPath:[task.resourceURL path]];
            
            NSData *imageData = task.resourceURL ? [NSData dataWithContentsOfURL:task.resourceURL] : nil;
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notifyObservers:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
                {
                    [observer imageManager:self didFinishDownloadImageByURL:task.imageURL withError:error imageData:imageData];
                }
                
            } onThread:nil];
            
            [self.taskDispatcher removeTask:task];
            
            [self.downloadImageObservers removeObjectForKey:task.imageURL];
        });
    }
}

- (void)imageManagerDownloadTask:(ImageManagerDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if (task.imageURL)
    {
        dispatch_sync(self.syncQueue, ^{
            
            NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
            
            [set notifyObservers:^(id observer) {
                
                if (observer && [observer respondsToSelector:@selector(imageManager:didDownloadImageByURL:withDownloadedSize:expectedSize:)])
                {
                    [observer imageManager:self didDownloadImageByURL:task.imageURL withDownloadedSize:downloadedSize expectedSize:expectedSize];
                }
            } onThread:nil];
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
