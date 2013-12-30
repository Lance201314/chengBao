//
//  OriginalContextViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-10.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OriginalContextViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) NSString *url;
- (id)initWithUrl:(NSString *)url;
@end
