//
//  UBTextFieldYMDDateInput.h
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldInput.h"

@interface UBTextFieldYMDDateInput : UBTextFieldInput

/*!
 * @brief 允许输入的最小日期
 * @discussion 默认1970-01-01
 */
@property (nonatomic) NSDate *minDate;

/*!
 * @brief 允许输入的最大日期
 * @discussion 默认1970-01-01
 */
@property (nonatomic) NSDate *maxDate;

/*!
 * @brief 日期
 */
@property (nonatomic) NSDate *date;

@end
