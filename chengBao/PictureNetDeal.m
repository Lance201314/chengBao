//
//  PictureNetDeal.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-16.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "PictureNetDeal.h"
#import "NetDeal.h"
#import "PictureModel.h"
#define imageUrl @"/api/AppApi/getImagesByMenu?clientFlag=PHONE&flag="
#define imagesUrl @"/api/AppApi/getImagesById?flag="
@implementation PictureNetDeal
- (void)getPictureListByMenuId:(NSString *)menuId fontTyp:(NSString *)fontType page:(NSInteger)page block:(FinishData)block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&page=%d&menuId=%@", BASE_HTTP, imageUrl, fontType, page, menuId];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        NSArray *piclist = [result objectForKey:@"data"];
        NSMutableArray *list = [[NSMutableArray alloc]init];
        for (int i = 0; i < [piclist count]; i ++){
            id obj = [piclist objectAtIndex:i];
            PictureModel *picture = [[PictureModel alloc]init];
            [picture setGuide:[obj objectForKey:@"guide"]];
            [picture setImageId:[obj objectForKey:@"imageId"]];
            NSString *path = [obj objectForKey:@"imagePath"];
            if (![@"" isEqualToString:[path stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                [picture setImagePath:[obj objectForKey:@"imagePath"]];
            } else {
                [picture setImagePath:nil];
            }
            [picture setName:[obj objectForKey:@"name"]];
            [picture setShowOrder:[obj objectForKey:@"showOrder"]];
            [picture setIntro:[obj objectForKey:@"intro"]];
            [list addObject:picture];
            [picture release];
        }
        block(list);
        [list release];
    }];
}

- (void)getPictureListBbPictureId:(NSString *)pictureId fontTyp:(NSString *)fontType block:(FinishData)block
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@&id=%@", BASE_HTTP, imagesUrl, fontType, pictureId];
    [NetDeal getNetInfo:url params:nil isGet:YES block:^(id result){
        id obj = [result objectForKey:@"data"];
        PictureModel *picture = [[PictureModel alloc]init];
        [picture setGuide:[obj objectForKey:@"guide"]];
        [picture setImageId:[obj objectForKey:@"imageId"]];
        [picture setImagePath:[obj objectForKey:@"imagePath"]];
        [picture setName:[obj objectForKey:@"name"]];
        [picture setShowOrder:[obj objectForKey:@"showOrder"]];
        [picture setIntro:[obj objectForKey:@"intro"]];
        [picture setImageIntro:[obj objectForKey:@"imageIntro"]];
        block(picture);
        [picture release];
    }];
}
@end
