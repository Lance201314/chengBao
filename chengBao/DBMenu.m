//
//  DBMenu.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-23.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DBMenu.h"
#import "DBService.h"
#import "MenuModel.h"
@implementation DBMenu
//查询
- (NSArray *)query:(NSString *)sql params:(NSArray *)params
{
    DBService *service = [[DBService alloc] init];
    NSArray *list = [service query:sql params:params];
    NSMutableArray *menuList = [[NSMutableArray alloc] init];
    if (list != nil && [list count] > 0) {
        for (int i = 0; i < [list count]; i ++) {
            id obj = [list objectAtIndex:i];
            MenuModel *menu = [[MenuModel alloc] init];
            [menu setEnName:[obj objectForKey:@"enName"]];
            [menu setMenu_id:[obj objectForKey:@"menu_id"]];
            [menu setName:[obj objectForKey:@"name"]];
            [menu setShowOrder:[obj objectForKey:@"showOrder"]];
            [menu setImagePath:[obj objectForKey:@"image"]];
            [menu setSelectImage:[obj objectForKey:@"selectImage"]];
            [menu setMenuFlag:[obj objectForKey:@"menuFlag"]];
            [menuList addObject:menu];
            [menu release];
        }
    }
    [service release];
    return menuList;
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
