//
//  DBService.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DBService.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "DBConnection.h"
@implementation DBService
//查询
- (NSArray *)query:(NSString *)sql params:(NSArray *)params
{
    FMDatabase *base = [[DBConnection getInstance] loadDB:collectionDataBaseName];
    NSMutableArray *list = nil;
    @try {
        FMResultSet *result = [base executeQuery:sql withArgumentsInArray:params];
        list = [[[NSMutableArray alloc]init] autorelease];
        while ([result next]) {
            int column = [result columnCount];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            for (int i = 0; i < column; i ++){
                if ([result stringForColumnIndex:i] != nil) {
                    [dic setObject:[result stringForColumnIndex:i] forKey:[result columnNameForIndex:i]];
                } else {
                    [dic setObject:@"" forKey:[result columnNameForIndex:i]];
                }
            }
            [list addObject:dic];
            [dic release];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        [base close];
    }
    return list;
}
//增删改
- (BOOL)update:(NSString *)sql params:(NSArray *)params
{
    BOOL result = NO;
    FMDatabase *base = [[DBConnection getInstance] loadDB:collectionDataBaseName];
    @try {
        result = [base executeUpdate:sql withArgumentsInArray:params];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        [base close];
    }
    return result;
}

@end
