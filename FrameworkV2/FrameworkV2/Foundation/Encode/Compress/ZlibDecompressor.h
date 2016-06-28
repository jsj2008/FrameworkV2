//
//  ZlibDecompressor.h
//  Test1
//
//  Created by ww on 16/4/26.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @enum
        ZlibDecompressStatus
 
    @abstract
        Zlib解压状态
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, ZlibDecompressStatus)
{
    // 解压中
    ZlibDecompressing = 1,
    
    // 解压结束
    ZlibDecompressCompleted = 2,
    
    // 解压错误
    ZlibDecompressError = 3
};

/******************************************************
 
    @class
        ZlibDecompressor
 
    @abstract
        Zlib数据解压器，负责对数据解压缩
 
    @discussion
        1，ZlibDecompressor本身对数据进行透传，需要实现子类来完成解码功能
 
 ******************************************************/

@interface ZlibDecompressor : NSObject

/*!
 * @brief 解压状态
 */
@property (nonatomic) ZlibDecompressStatus status;

/*!
 * @brief 错误码
 */
@property (nonatomic) NSError *error;

/*!
 * @brief 添加数据并解压
 * @param data 原始数据
 */
- (void)addData:(NSData *)data;

/*!
 * @brief 未解压的原始数据，在解压结束后可获取
 * @result 未解压的原始数据
 */
- (NSData *)undecompressedData;

/*!
 * @brief 清理未解压的原始数据
 */
- (void)cleanUndecompressedData;

/*!
 * @brief 解压得到的数据
 */
@property (nonatomic, readonly) NSMutableData *decompressedData;

@end


/******************************************************
 
    @class
        DeflateDecompressor
 
    @abstract
        Deflate格式数据解码器
 
 ******************************************************/

@interface DeflateDecompressor : ZlibDecompressor

@end


/******************************************************
 
    @class
        GzipDecompressor
 
    @abstract
        Gzip格式数据解码器
 
 ******************************************************/

@interface GzipDecompressor : ZlibDecompressor

@end


// zlib解码的错误域
extern NSString * const ZlibDecompressionErrorDomain;


/******************************************************
 
    @category
        NSError (ZlibDecompression)
 
    @abstract
        错误对象的zlib解压扩展
 
 ******************************************************/

@interface NSError (ZlibDecompression)

/*!
 * @brief zlib解压错误对象
 * @param code 错误码
 * @param description 错误描述
 * @result zlib解压错误对象
 */
+ (NSError *)ZlibDecompressionErrorWithCode:(int)code description:(NSString *)description;

@end
