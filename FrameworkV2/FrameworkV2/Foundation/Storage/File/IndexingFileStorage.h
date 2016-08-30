//
//  IndexingFileStorage.h
//  FrameworkV1
//
//  Created by ww on 16/4/29.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

/*********************************************************
 
    @class
        IndexingFileStorage
 
    @abstract
        索引式文件数据存储器，所有数据存放于文件中
 
 *********************************************************/

@interface IndexingFileStorage : NSObject

/*!
 * @brief 初始化
 * @param directory 文件根目录
 * @result 初始化后的对象
 */
- (instancetype)initWithDirectory:(NSString *)directory;

/*!
 * @brief 存储数据
 * @param data 待存储的二进制数据
 * @param index 数据索引
 * @result 存储是否成功
 */
- (BOOL)saveData:(NSData *)data forIndex:(NSString *)index;

/*!
 * @brief 存储数据
 * @param path 待存储的数据路径
 * @param index 数据索引
 * @param moveOrCopy 移动或拷贝文件，YES为移动，NO为拷贝
 * @param error 错误信息
 * @result 存储是否成功
 */
- (BOOL)saveDataWithPath:(NSString *)path forIndex:(NSString *)index moveOrCopy:(BOOL)moveOrCopy error:(NSError **)error;

/*!
 * @brief 读取数据
 * @param index 数据索引
 * @result 二进制数据
 */
- (NSData *)dataForIndex:(NSString *)index;

/*!
 * @brief 读取数据
 * @param indexes 数据索引
 * @result 数据字典，键为index，值为data，且只包含能够成功获取到的数据，空数据不出现在字典中
 */
- (NSDictionary<NSString *, NSData *> *)dataForIndexes:(NSArray<NSString *> *)indexes;

/*!
 * @brief 数据所在的文件路径
 * @param index 数据索引
 * @param account 数据账户
 * @result 文件路径
 */
- (NSString *)dataPathForIndex:(NSString *)index;

/*!
 * @brief 索引范围中数据已存在的索引
 * @param indexScope 索引范围
 * @result 数据已存在的索引
 */
- (NSArray<NSString *> *)existingDataIndexesInIndexScope:(NSArray<NSString *> *)indexScope;

/*!
 * @brief 清理数据
 * @param indexes 数据索引
 */
- (void)removeDataForIndexes:(NSArray<NSString *> *)indexes;

/*!
 * @brief 清理数据
 */
- (void)removeAllDatas;

/*!
 * @brief 当前数据大小
 * @discussion 计算数据量时会遍历所有文件，当文件量较大时，会比较耗时
 * @result 数据大小
 */
- (long long)currentDataSize;

@end
