//
//  NetImage.h
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^GetImage)(id);
@interface NetImage : NSObject
+ (void)getNetImage:(NSString *)stringUrl block:(GetImage)block;
@end
