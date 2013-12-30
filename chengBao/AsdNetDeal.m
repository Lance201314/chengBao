//
//  AsdNetDeal.m
//  test
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "AsdNetDeal.h"
#import "NetDeal.h"
#import "NetImage.h"

@implementation AsdNetDeal
- (void)getAsdStartApp:(GetInfo)block
{
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",BASE_HTTP, AsdUrl];
    [NetDeal getNetInfo:urlstring params:nil isGet:YES block:^(id result){
        //封装信息 传回页面
        if (result != nil) {
            NSString *imagePath = [[[result objectForKey:@"data"] objectAtIndex:0] objectForKey:@"imagePath"];
            block([NSString stringWithFormat:@"%@%@", BASE_HTTP, imagePath]);
        }
    }];
}
@end
