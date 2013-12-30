//
//  MenuCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-5.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "MenuCell.h"
#import "EGOImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        CGSize size = self.frame.size;
        imageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder"]];
        imageView.frame = CGRectMake(10, 10, 30, 30);
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        _titleName = [[UILabel alloc]initWithFrame:CGRectMake(60, 7.5, self.frame.size.width - 60, 20)];
        _titleName.backgroundColor = [UIColor clearColor];
        _titleName.font = [UIFont systemFontOfSize:20];
        _titleName.textColor = [UIColor grayColor];
        [self addSubview:_titleName];
        _subName = [[UILabel alloc]initWithFrame:CGRectMake(60, 32.5, self.frame.size.width - 60, 15)];
        _subName.backgroundColor = [UIColor clearColor];
        _subName.font = [UIFont systemFontOfSize:14];
        _subName.textColor = [UIColor grayColor];
        [self addSubview:_subName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [imageView cancelImageLoad];
    }
}

- (void)setImageView:(NSString *)url
{
    imageView.imageURL = [NSURL URLWithString:imagePath(url)];
}
- (void)dealloc
{
    [imageView release];
    [_titleName release];
    [_subName release];
    [super dealloc];
}
@end
