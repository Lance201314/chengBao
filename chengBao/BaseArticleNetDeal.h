//
//  BaseArticleNetDeal.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishData)(id data);
@interface BaseArticleNetDeal : NSObject
- (void)getLxAriticlesByMenuId:(NSString *)menuId lxUrl:(NSString *)lxurl fontType:(NSString *)fontType block:(FinishData)block;
@end
