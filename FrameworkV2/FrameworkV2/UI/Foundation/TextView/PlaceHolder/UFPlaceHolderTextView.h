//
//  UFPlaceHolderTextView.h
//  Test
//
//  Created by ww on 16/5/9.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UFTextViewPlaceHolder.h"

/*********************************************************
 
    @class
        UFPlaceHolderTextView
 
    @abstract
        带placeHolder的textView
 
 *********************************************************/

@interface UFPlaceHolderTextView : UITextView

/*!
 * @brief placeHolder
 */
@property (nonatomic) UFTextViewPlaceHolder *placeHolder;

@end
