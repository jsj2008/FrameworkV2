//
//  HTTPConnectionInputStream.h
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTTPConnectionInputStreamChunk.h"

/*********************************************************
 
    @class
        HTTPConnectionInputStream
 
    @abstract
        HTTP连接的数据输入流
 
    @discussion
        1，HTTPConnectionInputStream重写了NSStream和NSInputStream的方法，实现了特定形式的数据传输方案，子类不许重写这些方法
        2，HTTPConnectionInputStream必须在open前使用add...方法群完成原始数据添加，一旦open，将忽略所有之后的数据添加
        3，HTTPConnectionInputStream忽略runloop，在设置delegate时会记录当前线程，并在当前线程发送NSStreamDelegate消息
 
 *********************************************************/

@interface HTTPConnectionInputStream : NSInputStream <NSCopying>

/*!
 * @brief 添加流数据块
 * @param chunk 流数据块
 */
- (void)addChunk:(HTTPConnectionInputStreamChunk *)chunk;

/*!
 * @brief 添加数据块
 * @param data 数据块
 */
- (void)addData:(NSData *)data;

/*!
 * @brief 添加文件
 * @param filePath 文件路径
 */
- (void)addFile:(NSString *)filePath;

/*!
 * @brief 添加输入流
 * @param stream 输入流
 */
- (void)addInputStream:(NSInputStream<NSCopying> *)stream;

@end
