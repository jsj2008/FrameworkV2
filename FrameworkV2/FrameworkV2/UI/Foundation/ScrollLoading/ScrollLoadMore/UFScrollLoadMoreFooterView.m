//
//  UFScrollLoadMoreFooterView.m
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadMoreFooterView.h"

@implementation UFScrollLoadMoreFooterView

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
    
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
            
            [scrollView addObserver:self forKeyPath:@"contentSize" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"contentInset" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"frame" options:0 context:nil];
            
            [scrollView addObserver:self forKeyPath:@"bounds" options:0 context:nil];
            
            [scrollView.panGestureRecognizer addObserver:self forKeyPath:@"state" options:0 context:nil];
            
            if (scrollView.contentSize.height > 0)
            {
                self.frame = CGRectMake(0, scrollView.contentSize.height + scrollView.contentInset.bottom, scrollView.frame.size.width, scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height - scrollView.contentInset.bottom);
            }
            else
            {
                self.frame = CGRectZero;
            }
            
            _scrollView = scrollView;
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] || [keyPath isEqualToString:@"contentSize"] || [keyPath isEqualToString:@"contentInset"] || [keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"bounds"])
    {
        if (self.scrollView.contentSize.height > 0)
        {
            self.frame = CGRectMake(0, self.scrollView.contentSize.height + self.scrollView.contentInset.bottom, self.scrollView.frame.size.width, self.scrollView.contentOffset.y + self.scrollView.frame.size.height - self.scrollView.contentSize.height - self.scrollView.contentInset.bottom);
        }
        else
        {
            self.frame = CGRectZero;
        }
    }
    
    if (!self.isEnabled || self.status == UFScrollLoadingViewStatus_Loading)
    {
        return;
    }
    
    // 加载更多视图在滚动视图的可视范围内外处理不同
    if (self.scrollView.contentSize.height + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom + self.loadingContentHeight <= self.scrollView.frame.size.height)
    {
        if ([keyPath isEqualToString:@"state"])
        {
            if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
            {
                __weak typeof(self) weakSelf = self;
                
                if (self.scrollView.contentOffset.y > self.scrollView.contentInset.top)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.contentOffset.x, - self.scrollView.contentInset.top) animated:YES];
                        
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
                if (self.scrollView.contentOffset.y > self.scrollView.contentInset.top)
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
        }
    }
    else
    {
        if ([keyPath isEqualToString:@"state"])
        {
            if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
            {
                __weak typeof(self) weakSelf = self;
                
                if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height > self.scrollView.contentSize.height + self.scrollView.contentInset.bottom + self.loadingContentHeight)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.scrollView.contentOffset.x, self.scrollView.contentSize.height + self.scrollView.contentInset.bottom + self.loadingContentHeight - self.scrollView.frame.size.height) animated:YES];
                        
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
                if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height > self.scrollView.contentSize.height + self.scrollView.contentInset.bottom + self.loadingContentHeight)
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
        }
    }
}

- (void)start
{
    self.status = UFScrollLoadingViewStatus_Loading;
    
    __weak typeof(self) weakSelf = self;
    
    [self customStartWithCompletion:^{
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollLoadMoreFooterViewDidStartLoadingMore:)])
        {
            [weakSelf.delegate scrollLoadMoreFooterViewDidStartLoadingMore:weakSelf];
        }
    }];
}

- (void)stop
{
    __weak typeof(self) weakSelf = self;
    
    [self customStopWithCompletion:^{
        
        weakSelf.status = UFScrollLoadingViewStatus_Reset;
        
        [weakSelf customResetWithCompletion:^{
            
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(scrollLoadMoreFooterViewDidStopLoadingMore:)])
            {
                [weakSelf.delegate scrollLoadMoreFooterViewDidStopLoadingMore:weakSelf];
            }
        }];
    }];
}

@end
