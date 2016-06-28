//
//  UFScrollRefreshHeaderView.m
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollRefreshHeaderView.h"
#import "UFScrollContentOffsetUpdater.h"

@interface UFScrollRefreshHeaderView ()
{
    __weak UIScrollView *_scrollView;
}

/*!
 * @brief 滚动视图的侦听开关
 * @discussion 在滚动视图自动滚动时，禁止侦听，以免状态错乱
 */
@property (nonatomic, getter=isScrollObservingEnabled) BOOL enableScrollObserving;

@property (nonatomic) UFScrollContentOffsetUpdater *contentOffsetUpdater;

- (void)didStop;

@end


@implementation UFScrollRefreshHeaderView

@synthesize scrollView = _scrollView;

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    
    [self.scrollView removeObserver:self forKeyPath:@"bounds"];
    
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    if (scrollView)
    {
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
        
        [scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
        
        [scrollView addObserver:self forKeyPath:@"contentInset" options:0 context:nil];
        
        [scrollView addObserver:self forKeyPath:@"frame" options:0 context:nil];
        
        [scrollView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
        
        [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:0 context:nil];
        
        self.frame = CGRectMake(0, scrollView.contentOffset.y, scrollView.frame.size.width, - scrollView.contentOffset.y - scrollView.contentInset.top);
    }
    
    self.enableScrollObserving = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] || [keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"contentInset"] || [keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"bounds"])
    {
        self.frame = CGRectMake(0, self.scrollView.contentOffset.y, self.scrollView.frame.size.width, - self.scrollView.contentOffset.y - self.scrollView.contentInset.top);
    }
    
    if (self.isEnabled)
    {
        if (self.isScrollObservingEnabled)
        {
            if ([keyPath isEqualToString:@"contentOffset"])
            {
                if (self.status == UFScrollLoadingViewStatus_Loading)
                {
                    ;
                }
                else if (self.scrollView.isTracking)
                {
                    if (- self.scrollView.contentOffset.y - self.scrollView.contentInset.top > self.loadingContentHeight)
                    {
                        if (self.status != UFScrollLoadingViewStatus_Prepare)
                        {
                            [self prepare];
                        }
                    }
                    else
                    {
                        if (self.status != UFScrollLoadingViewStatus_Reset)
                        {
                            [self reset];
                        }
                    }
                }
                else if (- self.scrollView.contentOffset.y - self.scrollView.contentInset.top == self.loadingContentHeight)
                {
                    if (self.status == UFScrollLoadingViewStatus_Prepare)
                    {
                        [self start];
                    }
                }
            }
            
            if ([keyPath isEqualToString:@"state"])
            {
                if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
                {
                    if (self.scrollView.contentOffset.y + self.scrollView.contentInset.top < 0 && - self.scrollView.contentOffset.y - self.scrollView.contentInset.top > self.loadingContentHeight)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, - self.loadingContentHeight - self.scrollView.contentInset.top) animated:YES];
                        });
                    }
                }
            }
        }
    }
}

- (void)simulateStarting
{
    self.enableScrollObserving = NO;
    
    self.scrollView.userInteractionEnabled = NO;
    
    self.contentOffsetUpdater = [[UFScrollContentOffsetUpdater alloc] init];
    
    self.contentOffsetUpdater.scrollView = self.scrollView;
    
    self.contentOffsetUpdater.contentOffset = CGPointMake(self.scrollView.contentOffset.x, - self.loadingContentHeight - self.scrollView.contentInset.top);
    
    self.contentOffsetUpdater.duration = 0.3;
    
    __weak typeof(self) weakSelf = self;
    
    self.contentOffsetUpdater.completion = ^(){
        
        weakSelf.enableScrollObserving = YES;
        
        weakSelf.scrollView.userInteractionEnabled = YES;
        
        [weakSelf start];
    };
    
    [self.contentOffsetUpdater update];
}

- (void)start
{
    self.status = UFScrollLoadingViewStatus_Loading;
    
    __weak typeof(self) weakSelf = self;
    
    [self customStartWithCompletion:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollRefreshHeaderViewDidStartRefreshing:)])
        {
            [weakSelf.delegate scrollRefreshHeaderViewDidStartRefreshing:weakSelf];
        }
    }];
}

- (void)stop
{
    __weak typeof(self) weakSelf = self;
    
    [self customStopWithCompletion:^{
        
        [weakSelf didStop];
    }];
}

- (void)didStop
{
    self.enableScrollObserving = NO;
    
    self.scrollView.userInteractionEnabled = NO;
    
    self.contentOffsetUpdater = [[UFScrollContentOffsetUpdater alloc] init];
    
    self.contentOffsetUpdater.scrollView = self.scrollView;
    
    self.contentOffsetUpdater.contentOffset = CGPointMake(self.scrollView.contentOffset.x, - self.scrollView.contentInset.top);
    
    self.contentOffsetUpdater.duration = 0.3;
    
    __weak typeof(self) weakSelf = self;
    
    self.contentOffsetUpdater.completion = ^(){
        
        weakSelf.status = UFScrollLoadingViewStatus_Reset;
        
        [weakSelf customResetWithCompletion:^{
            
            weakSelf.enableScrollObserving = YES;
            
            weakSelf.scrollView.userInteractionEnabled = YES;
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollRefreshHeaderViewDidStopRefreshing:)])
            {
                [weakSelf.delegate scrollRefreshHeaderViewDidStopRefreshing:weakSelf];
            };
        }];
    };
    
    [self.contentOffsetUpdater update];
}

@end
