//
//  UBAgeRangeInput.h
//  Test
//
//  Created by ww on 16/6/17.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "UBTextFieldDataPickerInput.h"

@interface UBAgeRangeInput : UBTextFieldDataPickerInput

- (void)setFromAge:(NSUInteger)fromAge toAge:(NSUInteger)toAge;

@property (nonatomic, readonly) NSUInteger fromAge;

@property (nonatomic, readonly) NSUInteger toAge;

@end
