//
//  HTTPConnectionInputStreamChunk.h
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        HTTPConnectionInputStreamChunk
 
    @abstract
        HTTP连接的数据输入流的数据块
 
 *********************************************************/

@interface HTTPConnectionInputStreamChunk : NSObject <NSCopying>

/*!
 * @brief 生成数据输入流
 * @result 输入流
 */
- (NSInputStream *)inputStream;

@end


/*********************************************************
 
    @class
        HTTPConnectionInputStreamDataChunk
 
    @abstract
        HTTP连接的数据输入流的Data块
 
 *********************************************************/

@interface HTTPConnectionInputStreamDataChunk : HTTPConnectionInputStreamChunk

/*!
 * @brief 初始化
 * @param data 数据块
 * @result 初始化后的对象
 */
- (instancetype)initWithData:(NSData *)data;

/*!
 * @brief 数据块
 */
@property (nonatomic, readonly) NSData *data;

@end


/*********************************************************
 
    @class
        HTTPConnectionInputStreamFileChunk
 
    @abstract
        HTTP连接的数据输入流的文件块
 
 *********************************************************/

@interface HTTPConnectionInputStreamFileChunk : HTTPConnectionInputStreamChunk

/*!
 * @brief 初始化
 * @param filePath 文件路径
 * @result 初始化后的对象
 */
- (instancetype)initWithFilePath:(NSString *)filePath;

/*!
 * @brief 文件路径
 */
@property (nonatomic, readonly, copy) NSString *filePath;

@end


/*********************************************************
 
    @class
        HTTPConnectionInputStreamStreamChunk
 
    @abstract
        HTTP连接的数据输入流的流块
 
 *********************************************************/

@interface HTTPConnectionInputStreamStreamChunk : HTTPConnectionInputStreamChunk

/*!
 * @brief 初始化
 * @param stream 数据流
 * @result 初始化后的对象
 */
- (instancetype)initWithStream:(NSInputStream<NSCopying> *)stream;

/*!
 * @brief 数据流
 */
@property (nonatomic, readonly) NSInputStream<NSCopying> *stream;

@end
