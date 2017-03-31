//
//  HTTPMultipartFormEntity+HTTPConnectionInputStreamChunk.h
//  Test1
//
//  Created by ww on 16/4/20.
//  Copyright © 2016年 Miaotu. All rights reserved.
//

#import "HTTPMultipartFormEntity.h"
#import "HTTPConnectionInputStreamChunk.h"

/*********************************************************
 
    @category
        HTTPMultipartFormEntity (HTTPConnectionInputStreamChunk)
 
    @abstract
        HTTPMultipartFormEntity的流数据块扩展
 
 *********************************************************/

@interface HTTPMultipartFormEntity (HTTPConnectionInputStreamChunk)

/*!
 * @brief 生成流数据块
 * @result 流数据块
 */
- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks;

@end


/*********************************************************
 
    @category
        HTTPMultipartFormPart (HTTPConnectionInputStreamChunk)
 
    @abstract
        HTTPMultipartFormPart的流数据块扩展
 
 *********************************************************/

@interface HTTPMultipartFormPart (HTTPConnectionInputStreamChunk)

/*!
 * @brief 生成流数据块
 * @result 流数据块
 */
- (NSArray<HTTPConnectionInputStreamChunk *> *)inputStreamChunks;

@end


@interface HTTPMultipartFormDataPart (HTTPConnectionInputStreamChunk)

@end


@interface HTTPMultipartFormFilePart (HTTPConnectionInputStreamChunk)

@end


@interface HTTPMultipartFormEntityPart (HTTPConnectionInputStreamChunk)

@end
