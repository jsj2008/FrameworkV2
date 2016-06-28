//
//  HTTPRequestBody+MIME.m
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestBody+MIME.h"
#import "HTTPConnectionInputStream+HTTPMultipartForm.h"

@implementation HTTPRequestBody (MIME)

+ (HTTPRequestBody *)requestBodyWithParameters:(NSDictionary<NSString *,NSString *> *)parameters
{
    NSMutableArray *queryItems = [[NSMutableArray alloc] init];
    
    for (NSString *key in parameters)
    {
        NSString *value = [parameters objectForKey:key];
        
        NSURLQueryItem *queryItem = [[NSURLQueryItem alloc] initWithName:key value:value];
        
        [queryItems addObject:queryItem];
    }
    
    NSURLComponents *URLComponents = [[NSURLComponents alloc] init];
    
    URLComponents.queryItems = queryItems;
    
    NSString *encodedQueryString = URLComponents.percentEncodedQuery;
    
    HTTPRequestDataBody *body = [[HTTPRequestDataBody alloc] init];
    
    body.contentType = @"application/x-www-form-urlencoded";
    
    body.data = [encodedQueryString dataUsingEncoding:NSUTF8StringEncoding];
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithText:(NSString *)text
{
    HTTPRequestDataBody *body = [[HTTPRequestDataBody alloc] init];
    
    body.contentType = @"text/plain;charset=utf-8";
    
    body.data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithJsonNode:(id)jsonNode
{
    NSData *data = jsonNode ? [NSJSONSerialization dataWithJSONObject:jsonNode options:0 error:nil] : nil;
    
    HTTPRequestDataBody *body = [[HTTPRequestDataBody alloc] init];
    
    body.contentType = @"application/json;charset=utf-8";
    
    body.data = data;
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithMultipartFormEntity:(HTTPMultipartFormEntity *)entity
{
    HTTPConnectionInputStream *stream = [[HTTPConnectionInputStream alloc] init];
    
    [stream addMultipartFormEntity:entity];
    
    HTTPRequestStreamBody *body = [[HTTPRequestStreamBody alloc] init];
    
    body.contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", entity.boundary];
    
    body.stream = stream;
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithPNGImageData:(NSData *)PNGImageData
{
    HTTPRequestDataBody *body = [[HTTPRequestDataBody alloc] init];
    
    body.contentType = @"image/png";
    
    body.data = PNGImageData;
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithPNGImageFile:(NSURL *)PNGImageFile
{
    HTTPRequestFileBody *body = [[HTTPRequestFileBody alloc] init];
    
    body.contentType = @"image/png";
    
    body.fileURL = PNGImageFile;
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithJPGImageData:(NSData *)JPGImageData
{
    HTTPRequestDataBody *body = [[HTTPRequestDataBody alloc] init];
    
    body.contentType = @"image/jpeg";
    
    body.data = JPGImageData;
    
    return body;
}

+ (HTTPRequestBody *)requestBodyWithJPGImageFile:(NSURL *)JPGImageFile
{
    HTTPRequestFileBody *body = [[HTTPRequestFileBody alloc] init];
    
    body.contentType = @"image/jpeg";
    
    body.fileURL = JPGImageFile;
    
    return body;
}

@end
