//
//  NetDeal.h
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^completion)(id result);
@interface NetDeal : NSObject
+ (void)getNetInfo:(NSString *)urlstring params:(NSArray *)params isGet:(BOOL)get block:(completion)block;
+ (void)getNetFile:(NSString *)urlstring params:(NSArray *)params isGet:(BOOL)get block:(completion)block;
//同步获取数据
+ (id)getNetFileSynch:(NSString *)urlstring params:(NSArray *)params isGet:(BOOL)get;
@end
