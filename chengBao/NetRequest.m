//
//  NetRequest.m
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "NetRequest.h"

@implementation NetRequest

- (void)startAsynrc
{
    self.data = [NSMutableData data];
    self.connection = [NSURLConnection connectionWithRequest:self delegate:self];
}

- (void)cancel
{
    [self cancel];
}

#pragma mark NSURLConnectionDataDelegate
// receive data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
// finish receive
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.block(self.data);
}
//error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"数据连接错误：%@", error);
}
@end
