//
//  ImageManager.m
//  DuomaiFrameWork
//
//  Created by Baymax on 4/10/15.
//  Copyright (c) 2015 Baymax. All rights reserved.
//

#import "UBImageDownloadManager.h"
#import "NotificationObserver.h"
#import "AsyncTaskDispatcher.h"
#import "ImageDownloadTask.h"
#import "ImageStorage.h"

@interface UBImageDownloadManager () <ImageDownloadTaskDelegate>

/*!
 * @brief 观察者
 */
@property (nonatomic) NSMutableDictionary *downloadImageObservers;

/*!
 * @brief 任务派发器
 */
@property (nonatomic) AsyncTaskDispatcher *taskDispatcher;

@end


@implementation UBImageDownloadManager

- (void)dealloc
{
    [self.taskDispatcher cancel];
}

+ (UBImageDownloadManager *)sharedInstance
{
    static UBImageDownloadManager *instance = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        if (!instance)
        {
            instance = [[UBImageDownloadManager alloc] init];
        }
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.downloadImageObservers = [[NSMutableDictionary alloc] init];
        
        self.taskDispatcher = [[AsyncTaskDispatcher alloc] init];
    }
    
    return self;
}

- (void)downLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer
{
    if (!URL)
    {
        return;
    }
    
    NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
    
    if (!set)
    {
        ImageDownloadTask *task = [[ImageDownloadTask alloc] init];
        
        task.imageURL = URL;
                
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

- (void)cancelDownLoadImageByURL:(NSURL *)URL withObserver:(id<ImageManagerDelegate>)observer
{
    if (URL && observer)
    {
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
    }
}

- (void)cancelDownLoadImageByURL:(NSURL *)URL
{
    if (URL)
    {
        NotificationObservingSet *set = [self.downloadImageObservers objectForKey:URL];
        
        [self.taskDispatcher cancelTask:set.object];
        
        [self.downloadImageObservers removeObjectForKey:URL];
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didFinishWithError:(NSError *)error data:(NSData *)data
{
    if (task.imageURL)
    {
        NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
        
        [set notifyObservers:^(id observer) {
            
            if (observer && [observer respondsToSelector:@selector(imageManager:didFinishDownloadImageByURL:withError:imageData:)])
            {
                [observer imageManager:self didFinishDownloadImageByURL:task.imageURL withError:error imageData:data];
            }
        }];
        
        [self.taskDispatcher removeTask:task];
        
        [self.downloadImageObservers removeObjectForKey:task.imageURL];
    }
}

- (void)imageDownloadTask:(ImageDownloadTask *)task didDownloadImageWithDownloadedSize:(long long)downloadedSize expectedSize:(long long)expectedSize
{
    if (task.imageURL)
    {
        NotificationObservingSet *set = [self.downloadImageObservers objectForKey:task.imageURL];
        
        [set notifyObservers:^(id observer) {
            
            if (observer && [observer respondsToSelector:@selector(imageManager:didDownloadImageByURL:withDownloadedSize:expectedSize:)])
            {
                [observer imageManager:self didDownloadImageByURL:task.imageURL withDownloadedSize:downloadedSize expectedSize:expectedSize];
            }
        }];
    }
}

@end
