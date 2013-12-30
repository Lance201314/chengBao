//
//  AsdNetDeal.h
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#define AsdUrl @"/api/AppApi/getAdverts"
typedef void (^GetInfo)(id data);

@interface AsdNetDeal : NSObject
- (void)getAsdStartApp:(GetInfo)block;
@end
