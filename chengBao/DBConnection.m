//
//  DBConnection.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DBConnection.h"
#import "FMDatabase.h"
@implementation DBConnection
static DBConnection *instance = nil;
+ (DBConnection *)getInstance
{
    @synchronized(self)
    {
        if (instance == nil) {
            instance = [[self alloc]init];
        }
    }
    return instance;
}
- (FMDatabase *)loadDB:(NSString *)dbName
{
    FMDatabase *db = [FMDatabase databaseWithPath:[[ToolsClass getDocumentPath] stringByAppendingPathComponent:dbName]];
    if (![db open]) {
        [db release];
        NSLog(@"can't open it");
        return nil;
    }
    return  db;
}

@end
