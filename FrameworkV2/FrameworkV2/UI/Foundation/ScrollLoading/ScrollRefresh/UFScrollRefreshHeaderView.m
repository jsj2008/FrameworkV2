//
//  UFScrollRefreshHeaderView.m
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollRefreshHeaderView.h"

@implementation UFScrollRefreshHeaderView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"frame"];
    
    [self.scrollView removeObserver:self forKeyPath:@"bounds"];
    
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
    
    if (newSuperview)
    {
        if ([newSuperview isKindOfClass:[UIScrollView class]])
        {
            UIScrollView *scrollView = (UIScrollView *)newSuperview;
            
            [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"contentInset" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"frame" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
            
            [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:0 context:nil];
            
            _scrollView = scrollView;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    self.frame = CGRectMake(0, self.scrollView.contentOffset.y - self.scrollView.contentInset.top, self.scrollView.frame.size.width, - self.scrollView.contentOffset.y + self.scrollView.contentInset.top);
    
    if (!self.isEnabled || self.status == UFScrollLoadingViewStatus_Loading)
    {
        return;
    }
    
    if ([keyPath isEqualToString:@"state"])
    {
        if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            __weak typeof(self) weakSelf = self;
            
            if (- self.scrollView.contentOffset.y >= self.loadingContentHeight)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.contentOffset.x, - weakSelf.loadingContentHeight - self.scrollView.contentInset.top) animated:YES];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [weakSelf start];
                    });
                });
                
            }
        }
    }
    else if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.scrollView.isTracking)
        {
            if (- self.scrollView.contentOffset.y > self.loadingContentHeight)
            {
                if (self.status != UFScrollLoadingViewStatus_Prepare)
                {
                    [self prepare];
                }
            }
            else if (- self.scrollView.contentOffset.y < self.loadingContentHeight)
            {
                if (self.status != UFScrollLoadingViewStatus_Reset)
                {
                    [self reset];
                }
            }
        }
    }
}

- (void)simulateStarting
{
    __weak typeof(self) weakSelf = self;
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, - self.loadingContentHeight - self.scrollView.contentInset.top) animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf start];
    });
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
        
        weakSelf.status = UFScrollLoadingViewStatus_Reset;
        
        [weakSelf customResetWithCompletion:^{
            
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.contentOffset.x, - self.scrollView.contentInset.top) animated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollRefreshHeaderViewDidStopRefreshing:)])
                {
                    [weakSelf.delegate scrollRefreshHeaderViewDidStopRefreshing:weakSelf];
                }
            });
        }];
    }];
}

@end
