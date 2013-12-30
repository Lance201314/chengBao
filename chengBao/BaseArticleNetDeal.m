//
//  BaseArticleNetDeal.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "BaseArticleNetDeal.h"
#import "NetDeal.h"
#import "AriticleModel.h"
@implementation BaseArticleNetDeal
- (void)getLxAriticlesByMenuId:(NSString *)menuId lxUrl:(NSString *)lxurl fontType:(NSString *)fontType block:(FinishData)block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&menuId=%@",BASE_HTTP, lxurl, fontType, menuId];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        NSArray *array = [result objectForKey:@"data"];
        NSMutableArray *ariticleList = [[NSMutableArray alloc]initWithCapacity:[array count]];
        for (int i = 0; i < [array count]; i ++) {
            AriticleModel *ariticleModel = [[AriticleModel alloc]init];
            id obj = [array objectAtIndex:i];
            [ariticleModel setAuther:[obj objectForKey:@"createUser"]];
            [ariticleModel setGuide:[obj objectForKey:@"guide"]];
            [ariticleModel setNewsCategory:[obj objectForKey:@"newsCategory"]];
            [ariticleModel setIntro:[obj objectForKey:@"intro"]];
            [ariticleModel setName:[obj objectForKey:@"name"]];
            [ariticleModel setShowOrder:[obj objectForKey:@"showOrder"]];
            [ariticleModel setType:[obj objectForKey:@"articleType"]];
            [ariticleModel setAriticleId:[obj objectForKey:@"articleId"]];
            [ariticleModel setUpdateUser:[obj objectForKey:@"updateUser"]];
            [ariticleModel setClientFlag:[obj objectForKey:@"clientFlag"]];
            NSString *path = [obj objectForKey:@"imagePath"];
            if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                [ariticleModel setImagePath:path];
            } else {
                [ariticleModel setImagePath:nil];
            }
          
            //relationData
            NSArray *relationArray = [obj objectForKey:@"relationData"];
            if (relationArray != nil && [relationArray count] > 0) {
                NSMutableArray *articleArray = [[NSMutableArray alloc] init];
                for (int j = 0; j < [relationArray count]; j ++) {
                    AriticleModel *articleModelRelation = [[AriticleModel alloc] init];
                    id object = [relationArray objectAtIndex:j];
                    [articleModelRelation setAuther:[object objectForKey:@"createUser"]];
                    [articleModelRelation setGuide:[object objectForKey:@"guide"]];
                    [articleModelRelation setNewsCategory:[object objectForKey:@"newsCategory"]];
                    [articleModelRelation setIntro:[object objectForKey:@"intro"]];
                    [articleModelRelation setName:[object objectForKey:@"name"]];
                    [articleModelRelation setShowOrder:[object objectForKey:@"showOrder"]];
                    [articleModelRelation setType:[object objectForKey:@"articleType"]];
                    [articleModelRelation setAriticleId:[object objectForKey:@"relationArticleId"]];
                    [articleModelRelation setUpdateUser:[object objectForKey:@"updateUser"]];
                    [articleModelRelation setClientFlag:[object objectForKey:@"clientFlag"]];
                    path = [obj objectForKey:@"imagePath"];
                    if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                        [articleModelRelation setImagePath:path];
                    } else {
                        [articleModelRelation setImagePath:nil];
                    }
                    [articleArray addObject:articleModelRelation];
                    [articleModelRelation release];
                }
                ariticleModel.relationData = [NSArray arrayWithArray:articleArray];
                [articleArray release];
            }
            
            [ariticleList addObject:ariticleModel];
            [ariticleModel release];
        }
        block(ariticleList);
        [ariticleList release];
    }];
}
@end
