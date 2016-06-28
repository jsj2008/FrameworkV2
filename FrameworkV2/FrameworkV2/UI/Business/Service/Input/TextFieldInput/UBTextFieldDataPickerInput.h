//
//  UBTextFieldDataPickerInput.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldInput.h"
#import "UBTextFieldDataPickerInputToolBar.h"

/*********************************************************
 
    @class
        UBTextFieldDataPickerInput
 
    @abstract
        TextField数据选择输入器，弹出数据选择器
 
 *********************************************************/

@interface UBTextFieldDataPickerInput : UBTextFieldInput

/*!
 * @brief 数据字典
 * @discussion 字典的value数组由字符串或字典组成
 */
@property (nonatomic) NSDictionary<NSString *, NSArray *> *data;

/*!
 * @brief 列数
 */
@property (nonatomic) NSInteger componentsNumber;

/*!
 * @brief 工具栏
 */
@property (nonatomic) UBTextFieldDataPickerInputToolBar *toolBar;

/*!
 * @brief 按行索引设置数据
 * @param indexes 索引
 * @param animated 是否需要动画
 * @discussion 选择器将按照行索引序列从首列开始设置，多余或者缺少的部分将不设置
 */
- (void)setIndexes:(NSArray<NSNumber *> *)indexes animated:(BOOL)animated;

/*!
 * @brief 已选择索引行
 * @param indexes 索引，nil表征没有选择（取消操作等）
 * @discussion 当输入工具栏选择确认后发送本通知，在此处理数据输入后的逻辑
 * @discussion 此方法默认不执行任何操作，子类可重写本方法实现自定义的功能
 */
- (void)didInputIndexes:(NSArray<NSNumber *> *)indexes;

/*!
 * @brief 行索引对应的文本
 * @param indexes 行索引
 * @result 文本
 */
- (NSArray<NSString *> *)titlesAtIndexes:(NSArray<NSNumber *> *)indexes;

/*!
 * @brief 更新输入器
 * @discussion 必须调用该方法才能正确启动输入器
 */
- (void)updateInput;

@end
