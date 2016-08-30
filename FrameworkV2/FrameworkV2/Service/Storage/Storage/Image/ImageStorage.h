//
//  ImageStorage.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        ImageStorage
 
    @abstract
        图片存储器
 
    @discussion
        存储器的操作都是线程安全的
 
 *********************************************************/

@interface ImageStorage : NSObject

/*!
 * @brief 单例
 */
+ (ImageStorage *)sharedInstance;

/*!
 * @brief 存储目录
 */
@property (nonatomic, copy) NSString *directory;

/*!
 * @brief 启动
 */
- (void)start;

/*!
 * @brief 停止
 */
- (void)stop;

/*!
 * @brief 保存图片
 * @param URL 图片URL
 * @param data 图片数据
 */
- (void)saveImageByURL:(NSURL *)URL withData:(NSData *)data;

/*!
 * @brief 保存图片
 * @param URL 图片URL
 * @param dataPath 图片数据路径
 * @param error 错误信息
 */
- (void)saveImageByURL:(NSURL *)URL withDataPath:(NSString *)dataPath error:(NSError **)error;

/*!
 * @brief 清理图片数据
 */
- (void)removeAllImages;

/*!
 * @brief 获取图片数据
 * @param URL 图片URL
 * @return 图片数据
 */
- (NSData *)imageDataByURL:(NSURL *)URL;

/*!
 * @brief 获取当前图片数据的大小
 * @return 图片数据大小
 */
- (long long)currentImageContentSize;

@end
