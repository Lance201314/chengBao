//
//  MenuList.m
//  test
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "MenuList.h"
#import "NetDeal.h"
#import "MenuModel.h"
#import "NetImage.h"
#define MenuUrl @"/api/AppApi/getMenuList?flag="
@implementation MenuList

+ (void)getMenuList:(NSString *)fontType block:(FinishData)block;
{
     NSString *urlString = [NSString stringWithFormat:@"%@%@%@",BASE_HTTP, MenuUrl, fontType];
    [NetDeal getNetInfo:urlString params:nil isGet:YES block:^(id result){
        NSArray *data = [result objectForKey:@"data"];
        NSMutableArray *menuList = [[NSMutableArray alloc]initWithCapacity:[data count]];
        for (int i = 0; i < [data count]; i ++){
            MenuModel *menuModel = [[MenuModel alloc]init];
            [menuModel setMenu_id:[[data objectAtIndex:i] objectForKey:@"menu_id"]];
            [menuModel setEnName:[[data objectAtIndex:i] objectForKey:@"enName"]];
            [menuModel setName:[[data objectAtIndex:i] objectForKey:@"name"]];
            [menuModel setMenuFlag:[[data objectAtIndex:i] objectForKey:@"menuFlag"]];
            [menuModel setShowOrder:[[data objectAtIndex:i] objectForKey:@"showOrder"]];
            [menuModel setSelectImage:[[data objectAtIndex:i] objectForKey:@"selectImage"]];
            [menuModel setImagePath:[[data objectAtIndex:i] objectForKey:@"image"]];
            [menuList addObject:menuModel];
            [menuModel release];
        }
        block(menuList);
        [menuList release];
    }];
}
//[NSString stringWithFormat:@"%@%@?flag=%@",BASE_HTTP, [[data objectAtIndex:i] objectForKey:@"image"],fontType]
+ (void)getMenuImageList:(NSString *)fontType imagePath:(NSString *)imagePath block:(FinishData)block
{
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@?flag=%@",BASE_HTTP, imagePath, fontType];
    [NetImage getNetImage:imageUrl block:^(id result){
        NSLog(@"%@", result);
        block(result);
    }];
}
@end
