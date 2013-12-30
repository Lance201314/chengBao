//
//  DBArticle.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-23.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DBArticle.h"
#import "DBService.h"
#import "AriticleModel.h"
@implementation DBArticle
//查询
- (NSArray *)query:(NSString *)sql params:(NSArray *)params
{
    DBService *service = [[DBService alloc] init];
    NSArray *list = [service query:sql params:params];
    NSMutableArray *articleList = [[NSMutableArray alloc] init];
    if (list != nil && [list count] > 0) {
        for (int i = 0; i < [list count]; i ++) {
            id obj = [list objectAtIndex:i];
            AriticleModel *article = [[AriticleModel alloc] init];
            [article setGuide:[obj objectForKey:@"guide"]];
            [article setPublishTime:[obj objectForKey:@"publishTime"]];
            [article setImagePath:[obj objectForKey:@"imagePath"]];
            [article setClientFlag:[obj objectForKey:@"clientFlag"]];
            [article setMenuId:[obj objectForKey:@"menuId"]];
            [article setAriticleId:[obj objectForKey:@"articleId"]];
            [article setIntro:[obj objectForKey:@"intro"]];
            [article setSsid:[obj objectForKey:@"ssid"]];
            [article setAuther:[obj objectForKey:@"createUser"]];
            [article setSource:[obj objectForKey:@"source"]];
            [article setNewsCategory:[obj objectForKey:@"newsCategory"]];
            [article setName:[obj objectForKey:@"name"]];
            [article setShowOrder:[obj objectForKey:@"showOrder"]];
            [article setType:[obj objectForKey:@"articleType"]];
            [article setUpdateUser:[obj objectForKey:@"updateUser"]];
            [articleList addObject:article];
            [article release];
        }
    }
    [service release];
    return articleList;
}

//增删改
- (BOOL)update:(NSString *)sql params:(NSArray *)params
{
    DBService *service = [[DBService alloc] init];
    BOOL result = [service update:sql params:params];
    [service release];
    return result;
}
@end
