//
//  UBTextFieldHeightRangeInput.h
//  FrameworkV2
//
//  Created by ww on 19/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import "UBTextFieldInput.h"
#import "UBTextFieldInputHeightRange.h"

@interface UBTextFieldHeightRangeInput : UBTextFieldInput

@property (nonatomic) UBTextFieldInputHeightRange *heightRange;

@property (nonatomic) NSInteger minHeight;

@property (nonatomic) NSInteger maxHeight;

@end
