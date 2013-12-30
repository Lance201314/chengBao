//
//  SpecialCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "SpecialSubjectCell.h"
#import "EGOImageView.h"
@implementation SpecialSubjectCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _egoImageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder"]];
        _egoImageView.frame = CGRectMake(10, 10, 60, 40);
        _egoImageView.backgroundColor = [UIColor clearColor];
        _egoImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_egoImageView];
        [_egoImageView release];
        _titleName = [[UILabel alloc]initWithFrame:CGRectMake(75, 8, 245, 15)];
        _titleName.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleName];
        _titleName.lineBreakMode = NSLineBreakByWordWrapping;
        _titleName.font = [UIFont systemFontOfSize:16];
        [_titleName release];
        _subDesc = [[UILabel alloc]initWithFrame:CGRectMake(75, 25, 245, 30)];
        _subDesc.font = [UIFont systemFontOfSize:12];
        _subDesc.backgroundColor = [UIColor clearColor];
        _subDesc.numberOfLines = 2;
        _subDesc.lineBreakMode = NSLineBreakByTruncatingTail;
        _subDesc.textColor = [UIColor grayColor];
        [self addSubview:_subDesc];
        [_subDesc release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
