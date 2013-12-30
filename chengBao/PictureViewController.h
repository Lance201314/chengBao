//
//  PictureViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-16.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshHeaderAndFooterView.h"
@class MenuModel;
@interface PictureViewController : UITableViewController <UIScrollViewDelegate, RefreshHeaderAndFooterViewDelegate>{
    NSInteger _page;
    BOOL _reload;
    BOOL _isHead;
}
@property (nonatomic, retain) RefreshHeaderAndFooterView *refreshHeaderAndFooterView;
@property (nonatomic, retain) MenuModel *menuModel;
@property (nonatomic, retain) NSMutableArray *data;
@end
