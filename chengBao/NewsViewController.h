//
//  NewsViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeaderAndFooterView.h"
@class MenuModel;
@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RefreshHeaderAndFooterViewDelegate,UIScrollViewDelegate> {
    NSInteger _page; //加载数据的页数
    BOOL _isHead;
    BOOL _reloading;
    CGPoint _lastTableViewPoint;
}
@property (nonatomic, retain) RefreshHeaderAndFooterView *refreshHeaderAndFooterView;
@property (nonatomic, retain) NSMutableArray *dataList;
@property (nonatomic, retain) MenuModel *menuModel;
@property (nonatomic, retain) UITableView *tableView;
@end
