//
//  PictureCell.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-16.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface PictureCell : UITableViewCell
@property (nonatomic, retain) EGOImageView *picture;
@property (nonatomic, retain) UILabel *info;
@end
