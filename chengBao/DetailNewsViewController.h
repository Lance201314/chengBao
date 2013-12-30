//
//  DetailNewsViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-9.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  AriticleModel;
@interface DetailNewsViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) AriticleModel *ariticle;
@end
