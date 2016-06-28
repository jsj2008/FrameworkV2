//
//  StateMachine.m
//  Application
//
//  Created by WW on 14-3-26.
//  Copyright (c) 2014年 ww. All rights reserved.
//

#import "StateMachine.h"

@interface StateMachine ()
{
    BOOL _cancelled;
}

@property (nonatomic) NSDictionary *currentInfo;

- (void)run;

- (void)operate:(void (^)(void))operation;

@end


@implementation StateMachine

- (id)initWithStartState:(StateMachineState)startState endState:(StateMachineState)endState
{
    if (self = [super init])
    {
        _startState = startState;
        
        _endState = endState;
        
        _currentState = startState;
    }
    
    return self;
}

- (StateMachineState)currentState
{
    return _currentState;
}

- (NSDictionary *)currentStateInfo
{
    return self.currentInfo;
}

- (void)startWithStateInfo:(NSDictionary *)stateInfo
{
    _currentState = _startState;
    
    self.currentInfo = stateInfo;
    
    [self run];
}

- (void)arriveAtState:(StateMachineState)state withStateInfo:(NSDictionary *)stateInfo
{
    _currentState = state;
    
    self.currentInfo = stateInfo;
    
    [self run];
}

- (void)cancel
{
    _cancelled = YES;
}

- (void)run
{
    if (!_cancelled)
    {
        StateMachineState state = _currentState;
        
        NSDictionary *stateInfo = self.currentStateInfo;
        
        if (state == _endState)
        {
            [self performSelector:@selector(operate:) onThread:[NSThread currentThread] withObject:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(stateMachine:didFinishAtState:withStateInfo:)])
                {
                    [self.delegate stateMachine:self didFinishAtState:state withStateInfo:stateInfo];
                }
            } waitUntilDone:NO];
        }
        else
        {
            [self performSelector:@selector(operate:) onThread:[NSThread currentThread] withObject:^{
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(stateMachine:didRunFromState:withStateInfo:)])
                {
                    [self.delegate stateMachine:self didRunFromState:state withStateInfo:stateInfo];
                }
            } waitUntilDone:NO];
        }
    }
}

- (void)operate:(void (^)(void))operation
{
    if (operation)
    {
        operation();
    }
}

@end
