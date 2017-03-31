//
//  HTTPConnectionInputStream+HTTPMultipartForm.h
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPConnectionInputStream.h"
#import "HTTPMultipartFormEntity.h"

/*********************************************************
 
    @category
        HTTPConnectionInputStream (HTTPMultipartForm)
 
    @abstract
        HTTPConnectionInputStream的多表单数据扩展
 
 *********************************************************/

@interface HTTPConnectionInputStream (HTTPMultipartForm)

/*!
 * @brief 添加多表单数据
 * @param entity 多表单数据
 */
- (void)addMultipartFormEntity:(HTTPMultipartFormEntity *)entity;

@end
