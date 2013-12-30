//
//  DBPicture.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-24.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DBPicture.h"
#import "DBService.h"
#import "PictureModel.h"
@implementation DBPicture
//查询
- (NSArray *)query:(NSString *)sql params:(NSArray *)params
{
    DBService *dbService = [[DBService alloc] init];
    NSArray *array = [dbService query:sql params:params];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    if (array != nil && [array count] > 0) {
        for (int i = 0; i < [array count]; i ++) {
            id obj = [array objectAtIndex:i];
            PictureModel *picture = [[PictureModel alloc] init];
            [picture setGuide:[obj objectForKey:@"guide"]];
            [picture setImageId:[obj objectForKey:@"imageId"]];
            [picture setName:[obj objectForKey:@"name"]];
            [picture setShowOrder:[obj objectForKey:@"showOrder"]];
            [picture setIntro:[obj objectForKey:@"intro"]];
            [picture setImagePath:[obj objectForKey:@"imagePath"]];
            [list addObject:picture];
            [picture release];
        }
    }
    return list;
}

//增删改
- (BOOL)update:(NSString *)sql params:(NSArray *)params
{
    DBService *dbService = [[DBService alloc] init];
    BOOL result = [dbService update:sql params:params];
    return result;
}
@end
