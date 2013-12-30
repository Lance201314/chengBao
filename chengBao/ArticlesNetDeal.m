//
//  LxArticles.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "ArticlesNetDeal.h"
#import "NetDeal.h"
#import "AriticleModel.h"
#define LxAriticleUrl @"/api/AppApi/getLxArticlesByMenu?clientFlag=PHONE&flag="
#define AriticleUrl @"/api/AppApi/getArticlesByMenu?clientFlag=PHONE&flag="
#define AriticleIdUrl @"/api/AppApi/getArticleById?flag="
@implementation ArticlesNetDeal

- (void)getAriticlesByMenuId:(NSString *)menuId fontType:(NSString *)fontType page:(NSInteger)page block:(FinishData) block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&menuId=%@&page=%d",BASE_HTTP, AriticleUrl, fontType, menuId, page];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        NSArray *array = [result objectForKey:@"data"];
        NSMutableArray *ariticleList = [[NSMutableArray alloc]initWithCapacity:[array count]];
        for (int i = 0; i < [array count]; i ++) {
            AriticleModel *ariticleModel = [[AriticleModel alloc]init];
            id obj = [array objectAtIndex:i];
            [ariticleModel setGuide:[obj objectForKey:@"guide"]];
            [ariticleModel setPublishTime:[obj objectForKey:@"publishTime"]];
            NSString *path = [obj objectForKey:@"imagePath"];
            if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                [ariticleModel setImagePath:[obj objectForKey:@"imagePath"]];
            } else {
                [ariticleModel setImagePath:nil];
            }
            [ariticleModel setClientFlag:[obj objectForKey:@"clientFlag"]];
            [ariticleModel setMenuId:[obj objectForKey:@"menuId"]];
            [ariticleModel setAriticleId:[obj objectForKey:@"articleId"]];
            [ariticleModel setIntro:[obj objectForKey:@"intro"]];
            [ariticleModel setAuther:[obj objectForKey:@"createUser"]];
            [ariticleModel setSource:[obj objectForKey:@"source"]];
            [ariticleModel setNewsCategory:[obj objectForKey:@"newsCategory"]];
            [ariticleModel setName:[obj objectForKey:@"name"]];
            [ariticleModel setShowOrder:[obj objectForKey:@"showOrder"]];
            [ariticleModel setType:[obj objectForKey:@"articleType"]];
            [ariticleModel setUpdateUser:[obj objectForKey:@"updateUser"]];
            [ariticleModel setSsid:[obj objectForKey:@"ssId"]];
            [ariticleList addObject:ariticleModel];
            [ariticleModel release];
        }
        block(ariticleList);
        [ariticleList release];
    }];
}

- (void)getAriticlesById:(NSString *)ariticleId fontType:(NSString *)fontType block:(FinishData)block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&id=%@",BASE_HTTP, AriticleIdUrl, fontType, ariticleId];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        id obj = [result objectForKey:@"data"];
        AriticleModel *ariticleModel = [[AriticleModel alloc] init];
        [ariticleModel setGuide:[obj objectForKey:@"guide"]];
        [ariticleModel setPublishTime:[obj objectForKey:@"publishTime"]];
        NSString *path = [obj objectForKey:@"imagePath"];
        if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
            [ariticleModel setImagePath:[obj objectForKey:@"imagePath"]];
        } else {
            [ariticleModel setImagePath:nil];
        }
        [ariticleModel setClientFlag:[obj objectForKey:@"clientFlag"]];
        [ariticleModel setMenuId:[obj objectForKey:@"menuId"]];
        [ariticleModel setAriticleId:[obj objectForKey:@"articleId"]];
        [ariticleModel setIntro:[obj objectForKey:@"intro"]];
        [ariticleModel setAuther:[obj objectForKey:@"createUser"]];
        [ariticleModel setSource:[obj objectForKey:@"source"]];
        [ariticleModel setNewsCategory:[obj objectForKey:@"newsCategory"]];
        [ariticleModel setName:[obj objectForKey:@"name"]];
        [ariticleModel setShowOrder:[obj objectForKey:@"showOrder"]];
        [ariticleModel setType:[obj objectForKey:@"articleType"]];
        [ariticleModel setUpdateUser:[obj objectForKey:@"updateUser"]];
        [ariticleModel setUrl:url];
        block(ariticleModel);
        [ariticleModel release];
    }];
}
@end
