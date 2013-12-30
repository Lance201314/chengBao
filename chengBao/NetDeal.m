//
//  NetDeal.m
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "NetDeal.h"
#import "NetRequest.h"
@implementation NetDeal
// json
+ (void)getNetInfo:(NSString *)urlstring params:(NSArray *)params isGet:(BOOL)get block:(completion)block
{
    //封装参数
    if (params != nil) {
        NSMutableString *urlnew = [NSMutableString stringWithString:urlstring];
        for (int i = 0; i < [params count]; i ++) {
            [urlnew appendFormat:@"&%@", [params objectAtIndex:i]];
        }
        urlstring = urlnew;
    }
    //  转换成NSURL
    NSURL *url = [NSURL URLWithString:urlstring];
    NetRequest *request = [NetRequest requestWithURL:url];
    [request setTimeoutInterval:30];
    if (!get) {
        //do smo
    }
    request.block = ^(NSMutableData *data){
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        block(result);
    };
    [request startAsynrc];
}
//file
+ (void)getNetFile:(NSString *)urlstring params:(NSArray *)params isGet:(BOOL)get block:(completion)block
{
    if (params != nil) {
        NSMutableString *urlNew = [NSString stringWithString:urlstring];
        for (int i = 0; i < [params count]; i ++) {
            [urlNew appendFormat:@"&%@", [params objectAtIndex:i]];
        }
        urlstring = urlNew;
    }
    NSURL *url = [NSURL URLWithString:urlstring];
    NetRequest *request = [NetRequest requestWithURL:url];
    [request setTimeoutInterval:30];
    if (!get) {
        
    }
    request.block = ^(NSMutableData *data){
        block(data);
    };
    [request startAsynrc];
}

//同步获取数据
+ (id)getNetFileSynch:(NSString *)urlstring params:(NSArray *)params isGet:(BOOL)get
{
    if (params != nil) {
        NSMutableString *urlNew = [NSString stringWithString:urlstring];
        for (int i = 0; i < [params count]; i ++){
            [urlNew appendFormat:@"&%@", [params objectAtIndex:i]];
        }
        urlstring = urlNew;
    }
    NSURL *url = [NSURL URLWithString:urlstring];
    NSURLRequest *request = [[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10] autorelease];
    NSError *error = nil;
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        NSLog(@"接受数据失败：%@", error);
        return nil;
    }
    return received;
}
@end
