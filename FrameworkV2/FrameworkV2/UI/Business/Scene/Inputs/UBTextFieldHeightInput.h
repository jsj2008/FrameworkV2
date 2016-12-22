//
//  UBTextFieldHeightInput.h
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldInput.h"

@interface UBTextFieldHeightInput : UBTextFieldInput

/*!
 * @brief 身高值
 */
@property (nonatomic) NSNumber *height;

/*!
 * @brief 最小身高，默认140
 */
@property (nonatomic) NSInteger minHeight;

/*!
 * @brief 最大身高，默认200
 */
@property (nonatomic) NSInteger maxHeight;

@end
