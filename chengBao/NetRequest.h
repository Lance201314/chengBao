//
//  NetRequest.h
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishNet) (NSMutableData *data);
@interface NetRequest : NSMutableURLRequest <NSURLConnectionDataDelegate>

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, copy) FinishNet block;
- (void)startAsynrc;
- (void)cancel;
@end
