//
//  HTTPRequestBody.m
//  FrameworkV1
//
//  Created by ww on 16/5/19.
//  Copyright © 2016年 WW. All rights reserved.
//

#import "HTTPRequestBody.h"

@implementation HTTPRequestBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request session:session];
}

@end


@implementation HTTPRequestDataBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request fromData:self.data session:session];
}

@end


@implementation HTTPRequestFileBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request fromFile:self.fileURL session:session];
}

@end


@implementation HTTPRequestStreamBody

- (HTTPUploadConnection *)uploadConnectionWithRequest:(NSURLRequest *)request session:(HTTPSession *)session
{
    return [[HTTPUploadConnection alloc] initWithRequest:request fromStream:self.stream session:session];
}

@end
