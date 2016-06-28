//
//  UFDataPickerSource.h
//  Test
//
//  Created by ww on 16/3/7.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UFDataPickerSourceDelegate;


/*********************************************************
 
    @class
        UFDataPickerSource
 
    @abstract
        数据选择器的数据源
 
 *********************************************************/

@interface UFDataPickerSource : NSObject

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFDataPickerSourceDelegate> delegate;

/*!
 * @brief 列数
 * @result 列数
 */
- (NSInteger)numberOfComponents;

/*!
 * @brief 指定列的行数
 * @param component 指定列
 * @result 指定列的行数
 */
- (NSInteger)numberOfRowsInComponent:(NSInteger)component;

/*!
 * @brief 指定行和列的文本
 * @param row 指定行
 * @param component 指定列
 * @result 文本
 */
- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component;

/*!
 * @brief 行索引对应的文本
 * @param indexes 行索引
 * @result 文本
 */
- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes;

@end


/*********************************************************
 
    @class
        UFDataPickerSourceDelegate
 
    @abstract
        数据选择器的数据源的代理协议
 
 *********************************************************/

@protocol UFDataPickerSourceDelegate <NSObject>

/*!
 * @brief 指定列已被选择的行
 * @param source 数据源
 * @param component 指定列
 * @result 指定列已被选择的行
 */
- (NSInteger)dataPickerSource:(UFDataPickerSource *)source selectedRowInComponent:(NSInteger)component;

@end


/*********************************************************
 
    @class
        UFDataPickerDictionarySource
 
    @abstract
        数据选择器的字典型数据源
 
 *********************************************************/

@interface UFDataPickerDictionarySource : UFDataPickerSource

/*!
 * @brief 数据字典
 * @discussion 字典的value数组由字符串或字典组成
 */
@property (nonatomic) NSDictionary<NSString *, NSArray *> *data;

/*!
 * @brief 列数
 */
@property (nonatomic) NSInteger componentsNumber;

@end
