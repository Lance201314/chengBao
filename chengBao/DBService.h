//
//  DBService.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBService : NSObject
//查询
- (NSArray *)query:(NSString *)sql params:(NSArray *)params;
//增删改
- (BOOL)update:(NSString *)sql params:(NSArray *)params;
@end
