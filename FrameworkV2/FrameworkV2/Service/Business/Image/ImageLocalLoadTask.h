//
//  ImageLocalLoadTask.h
//  FrameworkV1
//
//  Created by ww on 16/5/31.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task.h"

@protocol ImageLocalLoadTaskDelegate;

/*********************************************************
 
    @class
        ImageLocalLoadTask
 
    @abstract
        图片本地加载任务
 
    @discussion
        支持加载文件和HTTP图片
 
 *********************************************************/

@interface ImageLocalLoadTask : Task

/*!
 * @brief 初始化
 * @param URL 图片URL，支持文件URL和HTTP类型URL
 * @result 初始化对象
 */
- (instancetype)initWithURL:(NSURL *)URL;

/*!
 * @brief 图片URL
 */
@property (nonatomic, readonly, copy) NSURL *URL;

@end


/*********************************************************
 
    @protocol
        ImageLocalLoadTaskDelegate
 
    @abstract
        图片本地加载消息协议
 
 *********************************************************/

@protocol ImageLocalLoadTaskDelegate <NSObject>

/*!
 * @brief 图片加载完成
 * @param task 任务
 * @param error 错误信息
 * @param data 图片数据
 */
- (void)imageLocalLoadTask:(ImageLocalLoadTask *)task didFinishWithError:(NSError *)error imageData:(NSData *)data;

@end
