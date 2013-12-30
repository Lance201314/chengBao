//
//  DBSpecialSubject.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-24.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DBSpecialSubject.h"
#import "SpecialSubjectModel.h"
#import "DBService.h"
@implementation DBSpecialSubject
//查询
- (NSArray *)query:(NSString *)sql params:(NSArray *)params
{
    DBService *dbService = [[DBService alloc] init];
    NSArray *array = [dbService query:sql params:params];
    NSMutableArray *ssArray = [[NSMutableArray alloc] init];
    if (array != nil && [array count] > 0) {
        for (int i = 0; i < [array count]; i ++) {
            id obj = [array objectAtIndex:i];
            SpecialSubjectModel *ssModel = [[SpecialSubjectModel alloc] init];
            [ssModel setGuide:[obj objectForKey:@"guide"]];
            [ssModel setEndGuide:[obj objectForKey:@"endGuide"]];
            [ssModel setPublishTime:[obj objectForKey:@"publishTime"]];
            [ssModel setImagePath:[obj objectForKey:@"imagePath"]];
            [ssModel setClientFlag:[obj objectForKey:@"clientFlag"]];
            [ssModel setSsType:[obj objectForKey:@"ssType"]];
            [ssModel setIntro:[obj objectForKey:@"intro"]];
            [ssModel setSsId:[obj objectForKey:@"ssId"]];
            [ssModel setCreateUser:[obj objectForKey:@"createUser"]];
            [ssModel setSpecialSubject:[obj objectForKey:@"specialSubject"]];
            [ssModel setName:[obj objectForKey:@"name"]];
            [ssModel setStartGuide:[obj objectForKey:@"startGuide"]];
            [ssModel setUpdateUser:[obj objectForKey:@"updateUser"]];
            [ssModel setMenuId:[obj objectForKey:@"menuId"]];
            [ssModel setRelationSSId:[obj objectForKey:@"releationSSId"]];
            [ssArray addObject:ssModel];
            [ssModel release];
        }
    }
    [dbService release];
    return ssArray;
}

//增删改
- (BOOL)update:(NSString *)sql params:(NSArray *)params
{
    DBService *dbService = [[DBService alloc] init];
    BOOL result = [dbService update:sql params:params];
    [dbService release];
    return result;
}
@end
