//
//  NewsCell.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-5.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;

@interface NewsCell : UITableViewCell
@property (nonatomic, retain) EGOImageView *egoImageView;
@property (nonatomic, retain) UILabel *menuName;
@property (nonatomic, retain) UILabel *titleName;
@property (nonatomic, retain) UILabel *subDesc;
@end
