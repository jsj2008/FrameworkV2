//
//  UFDataPickerInput.h
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPicker.h"
#import "UFDataPickerInputAccessory.h"

@protocol UFDataPickerInputDelegate;


/*********************************************************
 
    @class
        UFDataPickerInput
 
    @abstract
        数据选择输入器
 
 *********************************************************/

@interface UFDataPickerInput : NSObject

/*!
 * @brief 初始化
 * @param dataPicker 数据选择器
 * @param accessory 附件
 * @result 初始化对象
 */
- (instancetype)initWithDataPicker:(UFDataPicker *)dataPicker accessory:(id<UFDataPickerInputAccessory>)accessory;

/*!
 * @brief 数据选择器
 */
@property (nonatomic, readonly) UFDataPicker *dataPicker;

/*!
 * @brief 附件
 */
@property (nonatomic, readonly) id<UFDataPickerInputAccessory> accessory;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFDataPickerInputDelegate> delegate;

/*!
 * @brief 按行索引设置数据
 * @param indexes 索引
 * @param animated 是否需要动画
 * @discussion 选择器将按照行索引序列从首列开始设置，多余或者缺少的部分将不设置
 */
- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated;

@end


/*********************************************************
 
    @protocol
        UFDataPickerInputDelegate
 
    @abstract
        数据选择输入器的代理协议
 
 *********************************************************/

@protocol UFDataPickerInputDelegate <NSObject>

/*!
 * @brief 已选择行索引
 * @param input 输入器
 * @param indexes 行索引
 * @discussion 当输入工具栏选择确认后发送本通知
 */
- (void)dataPickerInput:(UFDataPickerInput *)input didSelectIndexes:(NSArray<NSNumber *> *)indexes;

/*!
 * @brief 已取消
 * @param input 输入器
 * @discussion 当输入工具栏选择取消后发送本通知
 */
- (void)dataPickerInputDidCancel:(UFDataPickerInput *)input;

@end
