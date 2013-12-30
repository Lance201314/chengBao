//
//  RightViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "RightViewController.h"
#import "NLSideNavViewController.h"
#import "BaseView.h"
#import "CollectionView.h"
#import "NormalCell.h"
#import "DetailIcon.h"
#import "SpecailCell.h"
#import "AboutView.h"
#import "EGOCache.h"
#import "UINavigationBar+customBar.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareView.h"
#import <QuartzCore/QuartzCore.h>
typedef void (^DealResult)(NSInteger index);

enum { COLLECTION = 0, LANGUAGE, FONTSIZE, SHARE, PUSH_SWITCH, CLEARCACHE, CHECKUPDATE, ABOUT };

@interface RightViewController () {
    UINavigationController *_nav;
    int _switchPush;
    UIImageView *_imageView;
}

@end

@implementation RightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark nav  setting
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ToolsClass getColor];
    self.navigationController.navigationBar.hidden = YES;
    [self.infos replaceObjectAtIndex:5 withObject:[NSString stringWithFormat:@"%.2f M",[[EGOCache globalCache] calculateCache] / 1024 / 1024]];
    [self.tableView reloadData];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _switchPush = [[userDefault objectForKey:@"push_Switch"] intValue];
}

- (void)loadView
{
    [super loadView];
    [self initData];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 273, 457)];
    imageView.image = [UIImage imageNamed:@"set_bg"];
    self.tableView.backgroundView = imageView;
    self.tableView.separatorColor = [UIColor colorWithRed:32.0 / 255 green:32.0 / 255 blue:32.0 / 255 alpha:0.5];
    [imageView release];
}

- (void)dealloc
{
    [_toolsData release];
    [_iconImages release];
    [_infos release];
    [_imageView release];
    [super dealloc];
}

#pragma mark initdata
- (void)initData
{
    
    _toolsData = [[NSMutableArray alloc]init];
    if ([[ToolsClass getAppDelegate].fontStyle isEqual:@"true"]) {
        [_toolsData addObject:@"文章收藏"];
        [_toolsData addObject:@"语言"];
        [_toolsData addObject:@"正文字号"];
        [_toolsData addObject:@"社交分享"];
        [_toolsData addObject:@"推送开关"];
        [_toolsData addObject:@"清除缓存"];
        [_toolsData addObject:@"检查更新"];
        [_toolsData addObject:@"关于我们"];
    } else {
        [_toolsData addObject:@"文章收藏"];
        [_toolsData addObject:@"語言"];
        [_toolsData addObject:@"正文字號"];
        [_toolsData addObject:@"社交分享"];
        [_toolsData addObject:@"推送開關"];
        [_toolsData addObject:@"清除緩存"];
        [_toolsData addObject:@"檢查更新"];
        [_toolsData addObject:@"關於我們"];
    }
    self.iconImages = [NSArray arrayWithObjects:@"set_collection_icon", @"set_languate_icon", @"set_font_icon", @"set_share_icon",
                  @"set_push_icon", @"set_clearCache_icon", @"set_update_icon", @"set_about_icon", nil];
    self.infos = [NSMutableArray arrayWithObjects:@"", @"繁体中文", @"中", @"", @"picture",
             @"13.9M", @"word", @"", nil];
    self.switchIcon = [NSArray arrayWithObjects:@"set_pushNo", @"set_push", nil];
    self.updateWords = [NSArray arrayWithObjects:@"已是最新版本", @"有更新", nil];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    _switchPush = [[userDefault objectForKey:@"push_Switch"] intValue];
    if ([[ToolsClass getAppDelegate].fontStyle isEqualToString:@"true"]) {
        [self.infos replaceObjectAtIndex:1 withObject:@"繁体中文"];
    } else {
        [self.infos replaceObjectAtIndex:1 withObject:@"简体中文"];
    }
    int size = [[ToolsClass getAppDelegate].fontSize intValue];
    if (size == 12) {
        [self.infos replaceObjectAtIndex:2 withObject:@"小"];
    } else if (size == 14) {
        [self.infos replaceObjectAtIndex:2 withObject:@"中"];
    } else {
        [self.infos replaceObjectAtIndex:2 withObject:@"大"];
    }
}

#pragma mark UITableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_toolsData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_infos objectAtIndex:indexPath.row] isEqual:@"picture"]) {
        static NSString *cellIdentifier = @"specal2";
        SpecailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[SpecailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.icon.image = [UIImage imageNamed:[_iconImages objectAtIndex:indexPath.row]];
        cell.name.text = [_toolsData objectAtIndex:indexPath.row];
        cell.name.textColor = [UIColor grayColor];
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(cell.view.frame.size.width - 48, 15, 43, 25)];
        _imageView.image = [UIImage imageNamed:[_switchIcon objectAtIndex:_switchPush]];
        _imageView.tag = 1000;
        [cell.view addSubview:_imageView];
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 60)];
        backgroundView.image = [UIImage imageNamed:@"u27_normal"];
        cell.selectedBackgroundView = backgroundView;
        [backgroundView release];
        return cell;
    } else if ([[_infos objectAtIndex:indexPath.row] isEqual:@"word"]) {
        static NSString *cellIdentifier = @"specal";
        SpecailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[SpecailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.icon.image = [UIImage imageNamed:[_iconImages objectAtIndex:indexPath.row]];
        cell.name.text = [_toolsData objectAtIndex:indexPath.row];
        cell.name.textColor = [UIColor grayColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 100, 15)];
        label.text = [_updateWords objectAtIndex:0];
        label.font = [UIFont systemFontOfSize:12];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = [UIColor grayColor];
        [cell.view addSubview:label];
        [label release];
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 60)];
        backgroundView.image = [UIImage imageNamed:@"u27_normal"];
        cell.selectedBackgroundView = backgroundView;
        [backgroundView release];
        return cell;
    } else {
        static NSString *cellIdentifier = @"cell";
        DetailIcon *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[DetailIcon alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.icon.image = [UIImage imageNamed:[_iconImages objectAtIndex:indexPath.row]];
        cell.name.text = [_toolsData objectAtIndex:indexPath.row];
        cell.name.textColor = [UIColor grayColor];
        cell.detailIcon.image = [UIImage imageNamed:@"set_detail_icon"];
        cell.showInfo.text = [_infos objectAtIndex:indexPath.row];
        cell.showInfo.textColor = [UIColor grayColor];
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 60)];
        backgroundView.image = [UIImage imageNamed:@"u27_normal"];
        cell.selectedBackgroundView = backgroundView;
        [backgroundView release];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DetailIcon *cell = (DetailIcon *)[tableView cellForRowAtIndexPath:indexPath];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    switch (indexPath.row) {
        case COLLECTION:
        {
            [self showCollection:indexPath.row];
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(showCollection:) object:self];
            break;
        }
        case LANGUAGE:
        {
            NSArray *array = [NSArray arrayWithObjects:@"繁体中文", @"简体中文",nil];
            NSArray *picture = [NSArray arrayWithObjects:@"set_unselected", @"set_selected", nil];
            NSInteger selectedIndex = [[ToolsClass getAppDelegate].fontStyle isEqual:@"true"] ? 0 : 1;
            [self showView:array icon:picture row:indexPath.row  selectedIndex:selectedIndex block:^(NSInteger result){
                if (result == 0) {
                    [ToolsClass getAppDelegate].fontStyle = @"true";
                } else {
                    [ToolsClass getAppDelegate].fontStyle = @"false";
                }
                [userDefault setObject:[ToolsClass getAppDelegate].fontStyle forKey:@"fontStyle"];
                cell.showInfo.text = [array objectAtIndex:result];
            }];
            break;
        }
        case FONTSIZE:
        {
            NSArray *array = [NSArray arrayWithObjects:@"小号字体", @"中号字体", @"大号字体",nil];
            NSArray *size = [NSArray arrayWithObjects:@"12", @"14", @"18", nil];
            NSArray *picture = [NSArray arrayWithObjects:@"set_unselected", @"set_selected", nil];
            NSInteger selectedIndex = [size indexOfObject:[ToolsClass getAppDelegate].fontSize];
            [self showView:array icon:picture row:indexPath.row selectedIndex:selectedIndex block:^(NSInteger result){
                [ToolsClass getAppDelegate].fontSize = [size objectAtIndex:result];
                cell.showInfo.text = [array objectAtIndex:result];
                [userDefault setObject:[ToolsClass getAppDelegate].fontSize forKey:@"fontSize"];
            }];
            break;
        }
        case SHARE:
        {
            ShareView *shareView = [[ShareView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
            [self setNavTitleView:shareView titleName:[_toolsData objectAtIndex:indexPath.row]];
            [app.window.rootViewController.view insertSubview:shareView aboveSubview:app.window.rootViewController.view];
            CGRect frame = shareView.frame;
            frame.origin.x = 0;
            [UIView animateWithDuration:0.5 animations:^(){
                shareView.frame = frame;
            }];
            [shareView release];
            break;
        }
        case PUSH_SWITCH:
        {
            _switchPush = !_switchPush;
            [_imageView setImage:[UIImage imageNamed:[_switchIcon objectAtIndex:_switchPush]]];
            if (_switchPush == 1) {
                [userDefault setObject:@"1" forKey:@"push_Switch"];
            } else {
                [userDefault setObject:@"0" forKey:@"push_Switch"];
            }
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        }
        case CLEARCACHE:
        {
            [[EGOCache globalCache] clearCache];
            cell.showInfo.text = [NSString stringWithFormat:@"%0.2f M", [[EGOCache globalCache] calculateCache] / 1024 / 1024];
            break;
        }
        case CHECKUPDATE:
        {
            break;
        }
        case ABOUT:
        {
            AboutView *about = [[AboutView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
            [self setNavTitleView:about titleName:[_toolsData objectAtIndex:indexPath.row]];
            CGRect frame = about.frame;
            frame.origin.x =0;
            [app.window.rootViewController.view insertSubview: about aboveSubview:app.window.rootViewController.view];
            [UIView animateWithDuration:0.5 animations:^{
                about.frame = frame;
            }];
            break;
        }
    }
}

#pragma mark show collection
- (void)showCollection: (NSInteger)row
{
    self.tableView.userInteractionEnabled = NO;
    CollectionView *collection = [[CollectionView alloc] init];
    collection.title = [_toolsData objectAtIndex:row];
    [self setNavTitleView:collection];
    collection.back = ^() {
        self.tableView.userInteractionEnabled = YES;
        [_nav release];
    };
    _nav = [[UINavigationController alloc] initWithRootViewController:collection];
    _nav.view.backgroundColor = [UIColor whiteColor];
    [collection release];
    [_nav.navigationBar customNavigationBar];
    [[UIApplication sharedApplication].keyWindow addSubview:_nav.view];
    __block CGRect frame = _nav.view.frame;
    frame.origin.x = CGRectGetWidth(frame);
    _nav.view.frame = frame;
    [UIView animateWithDuration:0.5 animations:^(){
        frame.origin.x = 0.f;
        _nav.view.frame = frame;
    }];
}

- (void)showView:(NSArray *)data icon:(NSArray *)picture row:(NSInteger)row  selectedIndex:(NSInteger)selectedIndex block:(DealResult)block
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BaseView *baseView = [[BaseView alloc]initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
    [self setNavTitleView:baseView titleName:[_toolsData objectAtIndex:row]];
    baseView.selectedIndex = selectedIndex;
    baseView.data = data;
    baseView.picture = picture;
    baseView.block = ^(NSInteger index){
        block(index);
    };
    [app.window.rootViewController.view insertSubview:baseView aboveSubview:app.window.rootViewController.view];
    CGRect frame = baseView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 animations:^{
        baseView.frame = frame;
    }];
    [baseView release];
}

- (void)initShareData
{
    
}

//设置子界面的导航栏格式
- (void)setNavTitleView:(UIView *)view titleName:(NSString *)name
{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth / 2 - 41, 0, 82, 39)];
    [title setText:name];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    [title release];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth / 2 - 41 , 39, 82, 3)];
    imageView.image = [UIImage imageNamed:@"underline_red"];
    [view addSubview:imageView];
    [imageView release];
}

- (void)setNavTitleView:(UIViewController *)viewController
{
    //定制titleview
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 39)];
    [title setText:viewController.title];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    [title release];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((200 - 82)/2.0, 39, 82, 3)];
    imageView.image = [UIImage imageNamed:@"underline_red"];
    [view addSubview:imageView];
    [imageView release];
    viewController.navigationItem.titleView = view;
    [view release];
    // border color
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0, 3, 1, 38);
    leftBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [view.layer addSublayer:leftBorder];
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(199, 3, 1, 38);
    rightBorder.backgroundColor = [ToolsClass getBorderColoer].CGColor;
    [view.layer addSublayer:rightBorder];
}

@end
