//
//  PictureNetDeal.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-16.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "BaseArticleNetDeal.h"

@interface PictureNetDeal : BaseArticleNetDeal

- (void)getPictureListByMenuId:(NSString *)menuId fontTyp:(NSString *)fontType page:(NSInteger)page block:(FinishData)block;
- (void)getPictureListBbPictureId:(NSString *)pictureId fontTyp:(NSString *)fontType block:(FinishData)block;
@end
