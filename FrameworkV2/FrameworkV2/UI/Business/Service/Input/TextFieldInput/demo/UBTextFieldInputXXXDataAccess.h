//
//  UBTextFieldInputXXXDataAccess.h
//  FrameworkV1
//
//  Created by ww on 16/6/21.
//  Copyright © 2016年 WW. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用input的数据来更新指定数据

@class XXX;

@protocol UBTextFieldInputXXXDataAccess <NSObject>

- (void)updateInputWithXXX:(XXX *)xxx;

- (void)updateXXX:(XXX *)xxx;

@end
