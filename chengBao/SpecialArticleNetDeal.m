//
//  SpecialArticle.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "SpecialArticleNetDeal.h"
#import "SpecialSubjectModel.h"
#import "NetDeal.h"
#import "AriticleModel.h"
#define LxAriticleUrl @"/api/AppApi/getLxSpecialSubjectByMenu?clientFlag=PHONE&flag="
#define AriticleUrl @"/api/AppApi/getSpecialSubjectByMenu?clientFlag=PHONE&flag="
#define AriticleIdUrl @"/api/AppApi/getSpecialSubectById?flag="
@implementation SpecialArticleNetDeal
- (void)getLxSpecialSubjectByMenuId:(NSString *)menuId fontType:(NSString *)fontType block:(SpecialfinishData) block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&menuId=%@", BASE_HTTP, LxAriticleUrl, fontType, menuId];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
    
    }];
}

- (void)getSpecialSubjectMenuId:(NSString *)menuId fontType:(NSString *)fontType page:(NSInteger)page block:(SpecialfinishData) block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&menuId=%@&page=%d", BASE_HTTP, AriticleUrl, fontType, menuId, page];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        NSArray *list = [result objectForKey:@"data"];
        NSMutableArray *specialList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [list count]; i ++){
            id obj = [list objectAtIndex:i];
            SpecialSubjectModel *special = [[SpecialSubjectModel alloc]init];
            [special setGuide:[obj objectForKey:@"guide"]];
            [special setCreateUser:[obj objectForKey:@"createUser"]];
            [special setSsId:[obj objectForKey:@"ssId"]];
            [special setEndGuide:[obj objectForKey:@"endGuide"]];
            NSString *path = [obj objectForKey:@"imagePath"];
            if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                [special setImagePath:[obj objectForKey:@"imagePath"]];
            } else {
                [special setImagePath:nil];
            }
            [special setStartGuide:[obj objectForKey:@"startGuide"]];
            [special setName:[obj objectForKey:@"name"]];
            [special setClientFlag:[obj objectForKey:@"clientFlag"]];
            [special setSsType:[obj objectForKey:@"ssType"]];
            [special setIntro:[obj objectForKey:@"intro"]];
            [special setRelationSSId:[obj objectForKey:@"relationSSId"]];
            [special setUpdateUser:[obj objectForKey:@"updateUser"]];
            [specialList addObject:special];
            [special release];
        }
        block(specialList);
        [specialList release];
    }];
}


- (void)getSpecialAriticlesBySSId:(NSString *)ssId fontType:(NSString *)fontType block:(SpecialfinishData)block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&id=%@", BASE_HTTP, AriticleIdUrl, fontType, ssId];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        NSArray *list = [[result objectForKey:@"data"] objectForKey:@"articles"];
        NSMutableArray *aritileList = [[NSMutableArray alloc]init];
        for (int i = 0; i < [list count]; i ++){
            id obj = [list objectAtIndex:i];
            AriticleModel *ariticle = [[AriticleModel alloc]init];
            [ariticle setGuide:[obj objectForKey:@"guide"]];
            [ariticle setAuther:[obj objectForKey:@"createUser"]];
            NSString *path = [obj objectForKey:@"imagePath"];
            if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                [ariticle setImagePath:[obj objectForKey:@"imagePath"]];
            } else {
                [ariticle setImagePath:nil];
            }
            [ariticle setNewsCategory:[obj objectForKey:@"newsCategory"]];
            [ariticle setName:[obj objectForKey:@"name"]];
            [ariticle setClientFlag:[obj objectForKey:@"clientFlag"]];
            [ariticle setIntro:[obj objectForKey:@"intro"]];
            [ariticle setType:[obj objectForKey:@"articleType"]];
            [ariticle setAriticleId:[obj objectForKey:@"articleId"]];
            [ariticle setUpdateUser:[obj objectForKey:@"updateUser"]];
            [ariticle setPublishTime:[obj objectForKey:@"publishTime"]];
            [ariticle setSource:[obj objectForKey:@"source"]];
            [aritileList addObject:ariticle];
            [ariticle release];
        }
        block(aritileList);
    }];
}
@end
