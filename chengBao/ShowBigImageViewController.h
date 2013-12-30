//
//  ShowBigImageViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-9.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PictureModel;
@class MenuModel;
@interface ShowBigImageViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, retain) NSMutableArray *imagePaths;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PictureModel *pictureModel;
@property (nonatomic, retain) MenuModel *menuModel;
@end
