//
//  HTTPMultipartFormEntity.h
//  Test1
//
//  Created by ww on 16/4/13.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * HTTPMultipartFormEntity族
 * 版本号0.0
 *
 * HTTPMultipartFormEntity族是对多表单数据传输的处理集合，遵循RFC1867协议
 */



@class HTTPMultipartFormPart;


/*********************************************************
 
    @class
        HTTPMultipartFormEntity
 
    @abstract
        HTTP多表单数据
 
    @discussion
        多表单数据同时支持数据块，文件和多表单嵌套
 
 *********************************************************/

@interface HTTPMultipartFormEntity : NSObject

/*!
 * @brief 边界字符串
 */
@property (nonatomic, copy) NSString *boundary;

/*!
 * @brief 表单部件
 */
@property (nonatomic) NSArray<HTTPMultipartFormPart *> *parts;

@end


/*********************************************************
 
    @class
        HTTPMultipartFormPart
 
    @abstract
        HTTP多表单部件
 
 *********************************************************/

@interface HTTPMultipartFormPart: NSObject

/*!
 * @brief 名字
 */
@property (nonatomic, copy) NSString *name;

/*!
 * @brief 内容类型
 */
@property (nonatomic, copy) NSString *contentType;

/*!
 * @brief 配置扩展，用于在Content-Disposition中添加补充信息
 */
@property (nonatomic) NSDictionary<NSString *, NSString *> *dispositionExtensions;

/*!
 * @brief 补充首部
 */
@property (nonatomic) NSDictionary<NSString *, NSString *> *additionalHeaderFields;

@end


/*********************************************************
 
    @class
        HTTPMultipartFormDataPart
 
    @abstract
        HTTP多表单数据块部件
 
 *********************************************************/

@interface HTTPMultipartFormDataPart : HTTPMultipartFormPart

/*!
 * @brief 数据块
 */
@property (nonatomic) NSData *data;

@end


/*********************************************************
 
    @class
        HTTPMultipartFormFilePart
 
    @abstract
        HTTP多表单文件部件
 
 *********************************************************/

@interface HTTPMultipartFormFilePart : HTTPMultipartFormPart

/*!
 * @brief 文件路径
 */
@property (nonatomic, copy) NSString *filePath;

/*!
 * @brief 文件名
 */
@property (nonatomic, copy) NSString *fileName;

@end


/*********************************************************
 
    @class
        HTTPMultipartFormEntityPart
 
    @abstract
        HTTP多表单多表单部件
 
 *********************************************************/

@interface HTTPMultipartFormEntityPart : HTTPMultipartFormPart

/*!
 * @brief 多表单数据对象
 */
@property (nonatomic) HTTPMultipartFormEntity *entity;

@end
