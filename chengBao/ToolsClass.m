//
//  ToolsClass.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-11.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "ToolsClass.h"

@implementation ToolsClass
+ (NSString *)getDocumentPath
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array objectAtIndex:0];
}

+ (AppDelegate *)getAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIColor *)getColor
{
    float colorValue = 242 / 255.0;
    return [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1];
}

+ (UIColor *)getBorderColoer
{
    float colorValue = 213 / 255.0;
    return [UIColor colorWithRed:colorValue green:colorValue blue:colorValue alpha:1];
}

+ (NSString *)getImagePath:(NSString *)url
{
    return [NSString stringWithFormat:@"%@/%@?flag=%@",BASE_HTTP,url, [ToolsClass getAppDelegate].fontStyle];
}

+ (void)showNetInfo:(NSString *)title message:(NSString *)message;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
