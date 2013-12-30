//
//  ShareViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-10.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "BaseView.h"
#import "BaseViewCell.h"
#import "ILBarButtonItem.h"
#import <QuartzCore/QuartzCore.h>
@interface BaseView (){
    NSIndexPath *_lastIndexPath;
    UITableView *_tableView;
}

@end

@implementation BaseView

- (void)dealloc
{
    [_data release];
    [_picture release];
    [_block release];
    [_tableView release];
    [super dealloc];
}


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
    // view border line
    CALayer *viewBorder = [CALayer layer];
    viewBorder.frame = CGRectMake(0, 43, screenWidth, 1.0f);
    viewBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [self.layer addSublayer:viewBorder];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // remove the tableview backgroundView , so I can set the tableview's backgroundcolor
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [ToolsClass getColor];
    self.backgroundColor = [ToolsClass getColor];
    [self addSubview:_tableView];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(5, 0, 50, 44);
    [back setImage:[UIImage imageNamed:@"back_button"]  forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:back];
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(back.frame.size.width - 1, 3, 1.0f, back.frame.size.height - 6);
    rightBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [back.layer addSublayer:rightBorder];
}

#pragma mark backButton

- (void)backButton
{
    CGRect frame = self.frame;
    frame.origin.x = screenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    BaseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[BaseViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    cell.name.text = [_data objectAtIndex:indexPath.row];
    if (indexPath.row == _selectedIndex) {
        cell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:1]];
        _lastIndexPath = [[NSIndexPath indexPathForRow:_selectedIndex inSection:0] retain];
    } else {
        cell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:0]];
    }
    return cell;
}


#pragma mark UITableView delegate mentods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int newRow = [indexPath row];
    int oldRow = (_lastIndexPath != nil) ? [_lastIndexPath row] : -1;
    if (newRow != oldRow) {
        BaseViewCell *newCell = (BaseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        newCell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:1]];
        BaseViewCell *oldCell = (BaseViewCell *)[tableView cellForRowAtIndexPath:_lastIndexPath];
        oldCell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:0]];
        _lastIndexPath = [indexPath retain];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.block(indexPath.row);
}
@end
