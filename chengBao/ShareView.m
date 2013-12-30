//
//  ShareView.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-18.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "ShareView.h"
#import "ILBarButtonItem.h"
#import "BaseViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>
@interface ShareView (){
    UITableView *_tableView;
    NSMutableArray *_data;
    NSArray *_picture;
    NSMutableArray *_selectIndexs;
    NSArray *_platformssTypes;
}

@end

@implementation ShareView

- (void)dealloc
{
    [_data release];
    [_picture release];
    [_tableView release];
    [_platformssTypes release];
    [_selectIndexs release];
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
    [self configData];
    // view border line
    CALayer *viewBorder = [CALayer layer];
    viewBorder.frame = CGRectMake(0, 43, screenWidth, 1.0f);
    viewBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [self.layer addSublayer:viewBorder];
    self.backgroundColor = [ToolsClass getColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, screenWidth, screenHeight - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
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

- (void)configData
{
    _data = [[NSMutableArray alloc]init];
    _selectIndexs = [[NSMutableArray alloc]init];
    _platformssTypes = [[NSArray alloc] initWithArray:[ShareSDK connectedPlatformTypes]];
    for (int i = 0; i < [_platformssTypes count]; i ++) {
        ShareType shareType = ((NSNumber *)[_platformssTypes objectAtIndex:i]).intValue;
        [_data addObject:[ShareSDK getClientNameWithType:shareType]];
        //已授权平台
        if ([ShareSDK hasAuthorizedWithType:shareType]) {
            [_selectIndexs addObject:[_platformssTypes objectAtIndex:i]];
        }
    }
    _picture = [[NSArray alloc] initWithObjects :@"set_baseview_unselected", @"set_baseview_selected", nil];
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
    if ([_selectIndexs containsObject:[_platformssTypes objectAtIndex:indexPath.row]]) {
        cell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:1]];
    } else {
        cell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:0]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int shareType = ((NSNumber *)[_platformssTypes objectAtIndex:indexPath.row]).intValue;
    //取消授权
    if ([_selectIndexs containsObject:[_platformssTypes objectAtIndex:indexPath.row]]) {
        [ShareSDK cancelAuthWithType:shareType];
        BaseViewCell *oldCell = (BaseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        oldCell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:0]];
    } else { //授权
        [ShareSDK authWithType:shareType options:nil result:^(SSAuthState state, id<ICMErrorInfo> error){
            if (state == SSAuthStateSuccess) {
                BaseViewCell *oldCell = (BaseViewCell *)[tableView cellForRowAtIndexPath:indexPath];
                oldCell.icon.image = [UIImage imageNamed:[_picture objectAtIndex:1]];
            } else if (state == SSAuthStateFail) {
                NSLog(@"%@", error);
            }
        }];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

