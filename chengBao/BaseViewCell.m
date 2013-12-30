//
//  ShareCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-10.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "BaseViewCell.h"

@implementation BaseViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _name = [[UILabel alloc]initWithFrame:CGRectMake(20, 7.5, 120, 25)];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.backgroundColor = [UIColor clearColor];
        [self addSubview:_name];
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 63, 7.5, 43, 25)];
        [self addSubview:_icon];
        self.backgroundColor = [ToolsClass getColor];
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
    [_name release];
    [_icon release];
    [super dealloc];
}
@end
