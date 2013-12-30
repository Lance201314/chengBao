//
//  ToolsClass.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-11.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppDelegate;
@interface ToolsClass : NSObject
+ (NSString *)getDocumentPath;
+ (AppDelegate *)getAppDelegate;
+ (UIColor *)getColor;
+ (NSString *)getImagePath:(NSString *)url;
+ (UIColor *)getBorderColoer;
+ (void)showNetInfo:(NSString *)title message:(NSString *)message;
@end
