//
//  ZlibCompressor.h
//  HS
//
//  Created by ww on 16/6/6.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/******************************************************
 
    @enum
        ZlibCompressStatus
 
    @abstract
        Zlib压缩状态
 
 ******************************************************/

typedef NS_ENUM(NSUInteger, ZlibCompressStatus)
{
    // 压缩中
    ZlibCompressing = 1,
    
    // 压缩结束
    ZlibCompressCompleted = 2,
    
    // 压缩错误
    ZlibCompressError = 3
};


/******************************************************
 
    @class
        ZlibCompressor
 
    @abstract
        Zlib数据压缩器，负责对数据压缩
 
    @discussion
        1，ZlibCompressor本身对数据进行透传，需要实现子类来完成压缩功能
 
 ******************************************************/

@interface ZlibCompressor : NSObject

/*!
 * @brief 压缩状态
 */
@property (nonatomic) ZlibCompressStatus status;

/*!
 * @brief 错误码
 */
@property (nonatomic) NSError *error;

/*!
 * @brief 添加数据并压缩
 * @param data 原始数据
 */
- (void)addData:(NSData *)data;

/*!
 * @brief 结束压缩
 */
- (void)finishCompressing;

/*!
 * @brief 未压缩的原始数据，在压缩结束后可获取
 * @result 未压缩的原始数据
 */
- (NSData *)uncompressedData;

/*!
 * @brief 清理未压缩的原始数据
 */
- (void)cleanUncompressedData;

/*!
 * @brief 压缩得到的数据
 */
@property (nonatomic, readonly) NSMutableData *compressedData;

@end


/******************************************************
 
    @class
        DeflateCompressor
 
    @abstract
        Deflate格式数据压缩器
 
 ******************************************************/

@interface DeflateCompressor : ZlibCompressor

@end


/******************************************************
 
    @class
        GzipCompressor
 
    @abstract
        Gzip格式数据压缩器
 
 ******************************************************/

@interface GzipCompressor : ZlibCompressor

@end


// zlib压缩的错误域
extern NSString * const ZlibCompressionErrorDomain;


/******************************************************
 
    @category
        NSError (ZlibCompression)
 
    @abstract
        错误对象的zlib压缩扩展
 
 ******************************************************/

@interface NSError (ZlibCompression)

/*!
 * @brief zlib压缩错误对象
 * @param code 错误码
 * @param description 错误描述
 * @result zlib压缩错误对象
 */
+ (NSError *)ZlibCompressionErrorWithCode:(int)code description:(NSString *)description;

@end
