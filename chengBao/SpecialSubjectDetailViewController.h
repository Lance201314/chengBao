//
//  SpecialSubjectDetailViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SpecialSubjectModel;
@class MenuModel;
@interface SpecialSubjectDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) SpecialSubjectModel *specialSubjectModel;
@property (nonatomic, retain) MenuModel *menuModel;
@end
