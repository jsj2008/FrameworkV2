//
//  UFDataPickerInputAccessory.h
//  FrameworkV1
//
//  Created by ww on 16/5/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UFDataPickerInputAccessory;


/*********************************************************
 
    @protocol
        UFDataPickerInputAccessoryDelegate
 
    @abstract
        数据选择输入器附件的代理协议
 
 *********************************************************/

@protocol UFDataPickerInputAccessoryDelegate <NSObject>

/*!
 * @brief 已确认
 * @param accessory 附件对象
 */
- (void)dataPickerInputAccessoryDidConfirm:(id<UFDataPickerInputAccessory>)accessory;

/*!
 * @brief 已取消
 * @param accessory 附件对象
 */
- (void)dataPickerInputAccessoryDidCancel:(id<UFDataPickerInputAccessory>)accessory;

@end


/*********************************************************
 
    @protocol
        UFDataPickerInputAccessory
 
    @abstract
        数据选择输入器附件协议
 
 *********************************************************/

@protocol UFDataPickerInputAccessory <NSObject>

/*!
 * @brief 附件代理对象
 */
@property (nonatomic, weak) id<UFDataPickerInputAccessoryDelegate> dataPickerInputAccessoryDelegate;

@end
