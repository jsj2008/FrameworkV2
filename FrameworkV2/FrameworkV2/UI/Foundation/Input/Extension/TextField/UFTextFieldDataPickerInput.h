//
//  UFTextFieldDataPickerInput.h
//  Test
//
//  Created by ww on 16/3/8.
//  Copyright © 2016年 ww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPickerSource.h"
#import "UFDataPickerInputAccessory.h"

@protocol UFTextFieldDataPickerInputDelegate;


/*********************************************************
 
    @class
        UFTextFieldDataPickerInput
 
    @abstract
        TextField数据选择输入器
 
 *********************************************************/

@interface UFTextFieldDataPickerInput : NSObject

/*!
 * @brief 初始化
 * @param textField 文本输入框
 * @param dataPickSouce 数据源，将根据数据源生成一个pickerView作为textField的输入器
 * @param inputAccessoryView 附件视图，将作为textField的附件视图使用
 * @result 初始化对象
 */
- (instancetype)initWithTextField:(UITextField *)textField dataPickSouce:(UFDataPickerSource *)dataPickSouce inputAccessoryView:(UIView<UFDataPickerInputAccessory> *)inputAccessoryView;

/*!
 * @brief 文本输入框
 */
@property (nonatomic, readonly) UITextField *textField;

/*!
 * @brief 数据源
 */
@property (nonatomic, readonly) UFDataPickerSource *dataPickSource;

/*!
 * @brief 附件视图
 */
@property (nonatomic, readonly) UIView<UFDataPickerInputAccessory> *inputAccessoryView;

/*!
 * @brief 协议代理
 */
@property (nonatomic, weak) id<UFTextFieldDataPickerInputDelegate> delegate;

/*!
 * @brief 按行索引设置数据
 * @param indexes 索引
 * @param animated 是否需要动画
 * @discussion 选择器将按照行索引序列从首列开始设置，多余或者缺少的部分将不设置
 */
- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated;

/*!
 * @brief 行索引对应的文本
 * @param indexes 行索引
 * @result 文本
 */
- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes;

@end


/*********************************************************
 
    @class
        UFTextFieldDataPickerInputDelegate
 
    @abstract
        TextField数据选择输入器的代理协议
 
 *********************************************************/

@protocol UFTextFieldDataPickerInputDelegate <NSObject>

/*!
 * @brief 已选择行索引
 * @param inputer 输入器
 * @param indexes 行索引
 * @discussion 当输入工具栏选择确认后发送本通知
 */
- (void)textFieldDataPickerInput:(UFTextFieldDataPickerInput *)input didSelectIndexes:(NSArray<NSNumber *> *)indexes;

/*!
 * @brief 已取消
 * @param inputer 输入器
 * @discussion 当输入工具栏选择取消后发送本通知
 */
- (void)textFieldDataPickerInputDidCancel:(UFTextFieldDataPickerInput *)input;

@end
