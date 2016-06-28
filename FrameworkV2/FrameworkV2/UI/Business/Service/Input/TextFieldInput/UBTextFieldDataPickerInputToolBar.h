//
//  UBTextFieldDataPickerInputToolBar.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFDataPickerInputAccessory.h"

/*********************************************************
 
    @class
        UBTextFieldDataPickerInputToolBar
 
    @abstract
        TextField数据选择输入器工具栏
 
    @discussion
        1，可由子类实现工具栏的视图和布局
        2，dataPickerInputAccessoryDelegate会被自动配置，请勿随意修改
 
 *********************************************************/

@interface UBTextFieldDataPickerInputToolBar : UIView <UFDataPickerInputAccessory>

@end
