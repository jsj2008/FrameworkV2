//
//  JsonSerialize.m
//  FoundationProject
//
//  Created by user on 13-11-11.
//  Copyright (c) 2013年 WW. All rights reserved.
//

#import "JsonSerialize.h"

#pragma mark - NSData (JsonSerialize)

@implementation NSData (JsonSerialize)

- (id)jsonRootNodeWithError:(NSError *__autoreleasing *)error
{
    return [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingAllowFragments error:error];
}

+ (NSData *)dataWithJsonRootNode:(id)node error:(NSError *__autoreleasing *)error
{
    return node ? [NSJSONSerialization dataWithJSONObject:node options:0 error:error] : nil;
}

@end


#pragma mark - NSString (JsonSerialize)

@implementation NSString (JsonSerialize)

- (id)jsonRootNodeWithError:(NSError *__autoreleasing *)error
{
    return [[self dataUsingEncoding:NSUTF8StringEncoding] jsonRootNodeWithError:error];
}

+ (NSString *)stringWithJsonRootNode:(id)node error:(NSError *__autoreleasing *)error
{
    // NSJSONSerialization会将/转义成\/，需手动将其反转
    return node ? [[[NSString alloc] initWithData:[NSData dataWithJsonRootNode:node error:error] encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"] : nil;
}

@end


#pragma mark - NSDictionary (JsonObject)

@implementation NSDictionary (JsonObject)

- (id)jsonObjectForKey:(NSString *)key
{
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSNull class]])
    {
        value = nil;
    }
    
    return value;
}

- (NSString *)jsonStringForKey:(NSString *)key
{
    id value = [self jsonObjectForKey:key];
    
    if (value && ![value isKindOfClass:[NSString class]])
    {
        NSAssert(NO, @"json parse failed for string");
        
        value = nil;
    }
    
    return value;
}

- (NSArray *)jsonArrayForKey:(NSString *)key
{
    id value = [self jsonObjectForKey:key];
    
    if (value && ![value isKindOfClass:[NSArray class]])
    {
        NSAssert(NO, @"json parse failed for array");
        
        value = nil;
    }
    
    return value;
}

- (NSDictionary *)jsonDictionaryForKey:(NSString *)key
{
    id value = [self jsonObjectForKey:key];
    
    if (value && ![value isKindOfClass:[NSDictionary class]])
    {
        NSAssert(NO, @"json parse failed for dictionary");
        
        value = nil;
    }
    
    return value;
}

- (int)jsonIntForKey:(NSString *)key
{
    int result = 0;
    
    id value = [self jsonObjectForKey:key];
    
    if (value)
    {
        if ([value isKindOfClass:[NSNumber class]])
        {
            result = [(NSNumber *)value intValue];
        }
#ifdef kJsonCompatibilityMode
        else if ([value isKindOfClass:[NSString class]])
        {
            result = [(NSString *)value intValue];
        }
#endif
        else
        {
            NSAssert(NO, @"json parse failed for int");
        }
    }
    
    return result;
}

- (NSInteger)jsonIntegerForKey:(NSString *)key
{
    NSInteger result = 0;
    
    id value = [self jsonObjectForKey:key];
    
    if (value)
    {
        if ([value isKindOfClass:[NSNumber class]])
        {
            result = [(NSNumber *)value integerValue];
        }
#ifdef kJsonCompatibilityMode
        else if ([value isKindOfClass:[NSString class]])
        {
            result = [(NSString *)value integerValue];
        }
#endif
        else
        {
            NSAssert(NO, @"json parse failed for integer");
        }
    }
    
    return result;
}

- (long long)jsonLongLongForKey:(NSString *)key
{
    long long result = 0;
    
    id value = [self jsonObjectForKey:key];
    
    if (value)
    {
        if ([value isKindOfClass:[NSNumber class]])
        {
            result = [(NSNumber *)value longLongValue];
        }
#ifdef kJsonCompatibilityMode
        else if ([value isKindOfClass:[NSString class]])
        {
            result = [(NSString *)value longLongValue];
        }
#endif
        else
        {
            NSAssert(NO, @"json parse failed for long long");
        }
    }
    
    return result;
}

- (BOOL)jsonBoolForKey:(NSString *)key
{
    BOOL result = 0;
    
    id value = [self jsonObjectForKey:key];
    
    if (value)
    {
        if ([value isKindOfClass:[NSNumber class]])
        {
            result = [(NSNumber *)value boolValue];
        }
#ifdef kJsonCompatibilityMode
        else if ([value isKindOfClass:[NSString class]])
        {
            result = [(NSString *)value boolValue];
        }
#endif
        else
        {
            NSAssert(NO, @"json parse failed for bool");
        }
    }
    
    return result;
}

- (float)jsonFloatForKey:(NSString *)key
{
    float result = 0;
    
    id value = [self jsonObjectForKey:key];
    
    if (value)
    {
        if ([value isKindOfClass:[NSNumber class]])
        {
            result = [(NSNumber *)value floatValue];
        }
#ifdef kJsonCompatibilityMode
        else if ([value isKindOfClass:[NSString class]])
        {
            result = [(NSString *)value floatValue];
        }
#endif
        else
        {
            NSAssert(NO, @"json parse failed for float");
        }
    }
    
    return result;
}

- (double)jsonDoubleForKey:(NSString *)key
{
    double result = 0;
    
    id value = [self jsonObjectForKey:key];
    
    if (value)
    {
        if ([value isKindOfClass:[NSNumber class]])
        {
            result = [(NSNumber *)value doubleValue];
        }
#ifdef kJsonCompatibilityMode
        else if ([value isKindOfClass:[NSString class]])
        {
            result = [(NSString *)value doubleValue];
        }
#endif
        else
        {
            NSAssert(NO, @"json parse failed for double");
        }
    }
    
    return result;
}

@end


#pragma mark - NSMutableDictionary (JsonObject)

@implementation NSMutableDictionary (JsonObject)

- (void)setJsonObject:(id)object forKey:(NSString *)key
{
    if (key && object && [key length] && ![object isKindOfClass:[NSNull class]])
    {
        [self setObject:object forKey:key];
    }
}

@end


#pragma mark - NSArray (JsonObject)

@implementation NSArray (JsonObject)

- (id)jsonObjectAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return object;
}

- (NSString *)jsonStringAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSString class]])
        {
            NSAssert(NO, @"json parse failed for string");
            
            object = nil;
        }
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return object;
}

- (NSArray *)jsonArrayAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSArray class]])
        {
            NSAssert(NO, @"json parse failed for array");
            
            object = nil;
        }
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return object;
}

- (NSDictionary *)jsonDictionaryAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSDictionary class]])
        {
            NSAssert(NO, @"json parse failed for dictionary");
            
            object = nil;
        }
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return object;
}

- (int)jsonIntAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSNumber class]])
        {
            NSAssert(NO, @"json parse failed for int");
            
            object = nil;
        }
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return [object intValue];
}

- (float)jsonFloatAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSNumber class]])
        {
            NSAssert(NO, @"json parse failed for float");
            
            object = nil;
        }
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return [object floatValue];
}

- (double)jsonDoubleAtIndex:(NSUInteger)index
{
    id object = nil;
    
    if (index < [self count])
    {
        object = [self objectAtIndex:index];
        
        if (object && ![object isKindOfClass:[NSNumber class]])
        {
            NSAssert(NO, @"json parse failed for double");
            
            object = nil;
        }
    }
    else
    {
        NSAssert(NO, @"json parse failed for array index");
    }
    
    return [object doubleValue];
}

@end
