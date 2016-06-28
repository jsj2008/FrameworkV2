//
//  HTTPMultipartFormPartContentDisposition.h
//  Test1
//
//  Created by ww on 16/4/14.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HTTPMultipartFormPartContentDispositionKeyValuePair;

/*********************************************************
 
    @class
        HTTPMultipartFormPartContentDisposition
 
    @abstract
        HTTP多表单部件的Content-Disposition
 
 *********************************************************/

@interface HTTPMultipartFormPartContentDisposition : NSObject

/*!
 * @brief 类型
 */
@property (nonatomic, copy) NSString *type;

/*!
 * @brief 键值对
 */
@property (nonatomic) NSArray<HTTPMultipartFormPartContentDispositionKeyValuePair *> *keyValuePairs;

/*!
 * @brief 初始化
 * @discussion 按照Content-Disposition首部格式解析字符串
 * @param string 字符串
 * @result 初始化后的对象
 */
- (instancetype)initWithString:(NSString *)string;

/*!
 * @brief 按照Content-Disposition首部格式拼接Content-Disposition的内容字符串
 * @result 字符串
 */
- (NSString *)string;

@end


/*********************************************************
 
    @class
        HTTPMultipartFormPartContentDispositionKeyValuePair
 
    @abstract
        HTTP多表单部件的Content-Disposition键值对
 
 *********************************************************/

@interface HTTPMultipartFormPartContentDispositionKeyValuePair : NSObject

/*!
 * @brief 键
 */
@property (nonatomic, copy) NSString *key;

/*!
 * @brief 值
 */
@property (nonatomic, copy) NSString *value;

/*!
 * @brief 初始化
 * @discussion 按照Content-Disposition首部格式解析键值字符串
 * @param string 字符串
 * @result 初始化后的对象
 */
- (instancetype)initWithString:(NSString *)string;

/*!
 * @brief 按照Content-Disposition首部格式拼接Content-Disposition的键值字符串
 * @result 字符串
 */
- (NSString *)string;

@end
