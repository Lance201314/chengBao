//
//  NetImage.m
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "NetImage.h"
#import "NetDeal.h"
@implementation NetImage
+ (void)getNetImage:(NSString *)stringUrl block:(GetImage)block
{
    [NetDeal getNetFile:stringUrl params:nil isGet:YES block:^(id result){
        UIImage *image = [UIImage imageWithData:result];
        block(image);
    }];
}

@end
