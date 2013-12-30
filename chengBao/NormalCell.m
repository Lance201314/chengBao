//
//  NormalCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-12.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "NormalCell.h"
#define CellLeft 70
@implementation NormalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(CellLeft + 5, 10, 52, 44)];
        _icon.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_icon];
        _name = [[UILabel alloc]initWithFrame:CGRectMake(CellLeft + 65 , 10, 80, 44)];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.backgroundColor = [UIColor clearColor];
        [self addSubview:_name];
        
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
    [_icon release];
    [_name release];
    [super dealloc];
}
@end
