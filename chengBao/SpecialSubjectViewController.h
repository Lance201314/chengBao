//
//  SpecialSubjectViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeaderAndFooterView.h"
@interface SpecialSubjectViewController : UIViewController <UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, RefreshHeaderAndFooterViewDelegate> {
    NSInteger _page; //加载数据的页数
    BOOL _reloading;
    BOOL _isHeader;
}
@property (nonatomic, retain) RefreshHeaderAndFooterView *refreshHeaderAndfooterView;
@property (nonatomic, retain) NSMutableArray *dataList;
@property (nonatomic, retain) MenuModel *menuModel;
@property (nonatomic, retain) UITableView *tableView;
@end
