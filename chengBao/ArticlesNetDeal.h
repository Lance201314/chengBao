//
//  LxArticles.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "BaseArticleNetDeal.h"
@interface ArticlesNetDeal : BaseArticleNetDeal
- (void)getAriticlesByMenuId:(NSString *)menuId fontType:(NSString *)fontType page:(NSInteger)page block:(FinishData) block;
- (void)getAriticlesById:(NSString *)ariticleId fontType:(NSString *)fontType block:(FinishData)block;
@end
