//
//  HTTPRequestBody+MIME.h
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestBody.h"
#import "HTTPMultipartFormEntity.h"

/*********************************************************
 
    @category
        HTTPRequestBody (MIME)
 
    @abstract
        HTTP请求体的分类扩展，提供各种数据类型的请求体
 
 *********************************************************/

@interface HTTPRequestBody (MIME)

/*!
 * @brief 参数请求体
 * @param parameters 参数字体（未编码）
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithParameters:(NSDictionary<NSString *, NSString *> *)parameters;

/*!
 * @brief 纯文本数据请求体
 * @param text 纯文本数据
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithText:(NSString *)text;

/*!
 * @brief json数据请求体
 * @param jsonNode json节点
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithJsonNode:(id)jsonNode;

/*!
 * @brief 多表单数据请求体
 * @param entity 多表单数据
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithMultipartFormEntity:(HTTPMultipartFormEntity *)entity;

/*!
 * @brief PNG图片数据请求体
 * @param PNGImageData PNG图片数据
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithPNGImageData:(NSData *)PNGImageData;

/*!
 * @brief PNG文件请求体
 * @param PNGImageFile PNG文件
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithPNGImageFile:(NSURL *)PNGImageFile;

/*!
 * @brief JPG图片数据请求体
 * @param JPGImageData JPG图片数据
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithJPGImageData:(NSData *)JPGImageData;

/*!
 * @brief JPG文件请求体
 * @param JPGImageData JPG文件
 * @result 请求体
 */
+ (HTTPRequestBody *)requestBodyWithJPGImageFile:(NSURL *)JPGImageFile;

@end
