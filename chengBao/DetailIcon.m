//
//  DetailIcon.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "DetailIcon.h"
@implementation DetailIcon

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _detailIcon = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 20, 25, 9, 15)];
        _detailIcon.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_detailIcon];
        _showInfo = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - 130, 25, 100, 15)];
        _showInfo.font = [UIFont systemFontOfSize:12];
        _showInfo.textAlignment = NSTextAlignmentRight;
        _showInfo.backgroundColor = [UIColor clearColor];
        [self addSubview:_showInfo];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [_detailIcon release];
    [_showInfo release];
    [super dealloc];
}

@end
