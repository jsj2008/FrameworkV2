//
//  UBTextFieldInputLocation.h
//  FrameworkV2
//
//  Created by ww on 19/10/2016.
//  Copyright © 2016 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBTextFieldInputLocation : NSObject

@end


@interface UBTextFieldInputPCLocation : UBTextFieldInputLocation

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@end
