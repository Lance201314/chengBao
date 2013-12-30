//
//  AboutViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "AboutView.h"
#import <QuartzCore/QuartzCore.h>
@interface AboutView ()

@end

@implementation AboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadView];
    }
    return self;
}

- (void)loadView
{
    // back button
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 44);
    [back setImage:[UIImage imageNamed:@"back_button"]  forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:back];
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(back.frame.size.width - 1, 3, 1.0f, back.frame.size.height - 6);
    rightBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [back.layer addSublayer:rightBorder];
    // view border line
    CALayer *viewBorder = [CALayer layer];
    viewBorder.frame = CGRectMake(0, 44, screenWidth, 1.0f);
    viewBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [self.layer addSublayer:viewBorder];
    // logo
    UIImageView *logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, screenWidth, 240)];
    logoImage.contentMode = UIViewContentModeScaleToFill;
    logoImage.image = [UIImage imageNamed:@"set_about_logo"];
    [self addSubview:logoImage];
    [logoImage release];
    UILabel *info = [[UILabel alloc]initWithFrame:CGRectMake(0, 290, screenWidth, 20)];
    info.text = @"联系我们";
    info.textAlignment = NSTextAlignmentCenter;
    info.textColor = [UIColor grayColor];
    info.backgroundColor = [UIColor clearColor];
    [self addSubview:info];
    [info release];
    for (int i = 0; i < 4; i ++){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(45 + i * 62.5, 330, 32, 32);
        [button setImage:[UIImage imageNamed:@"sina_logo"] forState:UIControlStateNormal];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    NSArray *array = @[@"Version 1.0", @"www.singpao.com"];
    for (int i = 0; i < [array count]; i ++) {
        UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, 380 + i * 25, screenWidth, 20)];
        version.text = [array objectAtIndex:i];
        version.backgroundColor = [UIColor clearColor];
        version.textAlignment = NSTextAlignmentCenter;
        version.textColor = [UIColor grayColor];
        [self addSubview:version];
        [version release];
    }
    [self setBackgroundColor:[ToolsClass getColor]];
}

#pragma mark back button
/*
    back for the last view
 */
- (void)backAction
{
    CGRect frame = self.frame;
    frame.origin.x = screenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

#pragma mark action button
/*
    some ways to connect us, eg sina.
 */
- (void)connectAction:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"connetion" message:@"message" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
