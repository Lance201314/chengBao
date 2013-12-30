//
//  DBConnection.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@interface DBConnection : NSObject
+ (DBConnection *)getInstance;
- (FMDatabase *)loadDB:(NSString *)dbName;
@end
