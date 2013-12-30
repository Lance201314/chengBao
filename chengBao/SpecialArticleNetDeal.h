//
//  SpecialArticle.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "BaseArticleNetDeal.h"
typedef void (^SpecialfinishData)(id data);
@interface SpecialArticleNetDeal : BaseArticleNetDeal

- (void)getSpecialSubjectMenuId:(NSString *)menuId fontType:(NSString *)fontType page:(NSInteger)page block:(SpecialfinishData) block;
- (void)getSpecialAriticlesBySSId:(NSString *)ssId fontType:(NSString *)fontType block:(SpecialfinishData)block;
@end
