//
//  CollectionViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-11.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BackViewController)();
@interface CollectionView : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) BackViewController back;
@end
