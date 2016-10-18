//
//  UBTextFieldBirthdayInput.h
//  FrameworkV2
//
//  Created by ww on 17/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldInput.h"

@interface UBTextFieldBirthdayInput : UBTextFieldInput

/*!
 * @brief 生日
 */
@property (nonatomic) NSDate *birthday;

/*!
 * @brief 最小日期
 */
@property (nonatomic) NSDate *minDate;

/*!
 * @brief 最大日期
 */
@property (nonatomic) NSDate *maxDate;

@end
