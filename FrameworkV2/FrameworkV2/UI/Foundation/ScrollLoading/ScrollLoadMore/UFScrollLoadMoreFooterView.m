//
//  UFScrollLoadMoreFooterView.m
//  Test
//
//  Created by ww on 16/2/3.
//  Copyright © 2016年 ww. All rights reserved.
//

#import "UFScrollLoadMoreFooterView.h"

@interface UFScrollLoadMoreFooterView ()
{
    __weak UIScrollView *_scrollView;
}

@end


@implementation UFScrollLoadMoreFooterView

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
        
        if (scrollView.contentSize.height > 0)
        {
            self.frame = CGRectMake(0, scrollView.contentSize.height + scrollView.contentInset.bottom, scrollView.frame.size.width, scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height - scrollView.contentInset.bottom);
        }
        else
        {
            self.frame = CGRectZero;
        }
    }
}

- (void)setAutoLoadingWhenContentSizeVisible:(BOOL)autoLoadingWhenContentSizeVisible
{
    _autoLoadingWhenContentSizeVisible = autoLoadingWhenContentSizeVisible;
    
    if (autoLoadingWhenContentSizeVisible && self.isEnabled)
    {
        self.scrollView.contentOffset = self.scrollView.contentOffset;
    }
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    
    if (enable && self.autoLoadingWhenContentSizeVisible)
    {
        self.scrollView.contentOffset = self.scrollView.contentOffset;
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
    
    if (self.isEnabled)
    {
        if ([keyPath isEqualToString:@"contentOffset"])
        {
            if (self.status == UFScrollLoadingViewStatus_Loading)
            {
                ;
            }
            else if (self.scrollView.contentSize.height == 0)
            {
                ;
            }
            else if (self.scrollView.contentSize.height + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom + self.loadingContentHeight <= self.scrollView.frame.size.height)
            {
                if (self.scrollView.isTracking)
                {
                    if (self.scrollView.contentOffset.y > - self.scrollView.contentInset.top)
                    {
                        if (self.status != UFScrollLoadingViewStatus_Prepare)
                        {
                            [self prepare];
                        }
                    }
                    else if (self.scrollView.contentOffset.y < - self.scrollView.contentInset.top)
                    {
                        if (self.status != UFScrollLoadingViewStatus_Reset)
                        {
                            [self reset];
                        }
                    }
                }
                else
                {
                    if (self.autoLoadingWhenContentSizeVisible)
                    {
                        if (self.status != UFScrollLoadingViewStatus_Loading)
                        {
                            [self start];
                        }
                    }
                    else
                    {
                        if (self.scrollView.contentOffset.y == - self.scrollView.contentInset.top)
                        {
                            if (self.status == UFScrollLoadingViewStatus_Prepare)
                            {
                                [self start];
                            }
                        }
                    }
                }
            }
            else
            {
                if (self.scrollView.isTracking)
                {
                    if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height > self.scrollView.contentSize.height + self.loadingContentHeight + self.scrollView.contentInset.bottom)
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
                else
                {
                    if (fabs(self.scrollView.contentOffset.y + self.scrollView.frame.size.height - self.scrollView.contentSize.height - self.loadingContentHeight - self.scrollView.contentInset.bottom) < 1)
                    {
                        if (self.status == UFScrollLoadingViewStatus_Prepare)
                        {
                            [self start];
                        }
                    }
                }
            }
        }
        
        if ([keyPath isEqualToString:@"state"])
        {
            if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
            {
                if (self.scrollView.contentOffset.y + self.scrollView.frame.size.height > self.scrollView.contentSize.height + self.scrollView.contentInset.bottom + self.loadingContentHeight && self.scrollView.contentSize.height + self.loadingContentHeight + self.scrollView.contentInset.top + self.scrollView.contentInset.bottom > self.scrollView.frame.size.height)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, self.loadingContentHeight + self.scrollView.contentSize.height + self.scrollView.contentInset.bottom - self.scrollView.frame.size.height) animated:YES];
                    });
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
