//
//  SpecailCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "SpecailCell.h"

@implementation SpecailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _view = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width - 105, 0, 100, 44)];
        _view.backgroundColor = [UIColor clearColor];
        [self addSubview:_view];
    }
    return self;
}

- (void)dealloc
{
    [_view release];
    [super dealloc];
}

@end
