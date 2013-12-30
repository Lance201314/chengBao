//
//  PictureCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-16.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "PictureCell.h"
#import "EGOImageView.h"
@implementation PictureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.frame = CGRectMake(0, 0, screenWidth, 160);
        [self loadView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma  mark view
- (void)loadView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 5, self.frame.size.width - 20, self.frame.size.height - 10)];
    view.backgroundColor = [UIColor whiteColor];
    _picture = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder_lx"]];
    _picture.frame = CGRectMake(5, 5, view.frame.size.width - 10, 120);
    _picture.contentMode = UIViewContentModeScaleAspectFill;
    _picture.clipsToBounds = YES;
    [view addSubview:_picture];
    _info = [[UILabel alloc]initWithFrame:CGRectMake(5, 127, view.frame.size.width, 20)];
    _info.textAlignment = NSTextAlignmentCenter;
    _info.backgroundColor = [UIColor clearColor];
    [view addSubview:_info];
    [self addSubview:view];
    [view release];
}

- (void)dealloc
{
    [_picture release];
    [_info release];
    [super dealloc];
}
@end
