//
//  ShareViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-10.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Finish)(NSInteger index);
@interface BaseView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) NSArray *picture;
@property (nonatomic, copy) Finish block;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
