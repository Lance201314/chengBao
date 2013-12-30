//
//  SpecialSubjectPictureCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "SpecialSubjectPictureCell.h"
#import "EGOImageView.h"
@implementation SpecialSubjectPictureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _picture = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder"]];
        _picture.frame = CGRectMake(0, 0, screenWidth, 100);
        _picture.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_picture];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [_picture release];
    [super dealloc];
}
@end
