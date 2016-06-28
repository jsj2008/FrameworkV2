//
//  BlockTask.h
//  Test
//
//  Created by ww on 16/6/27.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "Task.h"

/*********************************************************
 
    @class
        BlockTask
 
    @abstract
        代码块Task，用于执行特定的块代码
 
    @discussion
        1，Task只执行代码块中指定的代码，完成后自动执行cancel操作并发送协议结束消息
        2，Task提供了context属性，用于执行代码块时处理和传递数据，可以在代码块中任意修改其值，在协议结束消息中可以从task参数中读取其值
        3，代码块执行时，Task的cancel操作将失去作用；欲停止代码块的运行，必须由调用者对代码块实现控制（例如通过context来实现取消标记位的处理等）
 
 *********************************************************/

@interface BlockTask : Task

/*!
 * @brief 代码块
 */
@property (nonatomic, copy) void (^block)(void);

/*!
 * @brief 上下文属性，可以承载在代码块中处理的数据
 */
@property (nonatomic, readonly) NSMutableDictionary *context;

@end


/*********************************************************
 
    @protocol
        BlockTaskDelegate
 
    @abstract
        功能块Task的协议
 
 *********************************************************/

@protocol BlockTaskDelegate <NSObject>

/*!
 * @brief Task结束消息
 * @param blockTask task对象
 */
- (void)blockTaskDidFinish:(BlockTask *)blockTask;

@end
