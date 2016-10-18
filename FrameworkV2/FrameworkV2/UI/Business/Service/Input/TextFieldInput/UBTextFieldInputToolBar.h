//
//  UBTextFieldInputToolBar.h
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UBTextFieldInputToolBarDelegate;


/*********************************************************
 
    @class
        UBTextFieldInputToolBar
 
    @abstract
        TextField数据输入器工具栏
 
 *********************************************************/

@interface UBTextFieldInputToolBar : UIView

/*!
 * @brief 消息代理
 */
@property (nonatomic, weak) id<UBTextFieldInputToolBarDelegate> delegate;

@end


/*********************************************************
 
    @protocol
        UBTextFieldInputToolBarDelegate
 
    @abstract
        TextField数据输入器工具栏的协议消息
 
 *********************************************************/

@protocol UBTextFieldInputToolBarDelegate <NSObject>

/*!
 * @brief 确认输入
 * @param toolBar 工具栏
 */
- (void)textFieldInputToolBarDidConfirm:(UBTextFieldInputToolBar *)toolBar;

/*!
 * @brief 取消输入
 * @param toolBar 工具栏
 */
- (void)textFieldInputToolBarDidCancel:(UBTextFieldInputToolBar *)toolBar;

@end
