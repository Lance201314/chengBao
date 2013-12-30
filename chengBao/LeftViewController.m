//
//  LeftViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "LeftViewController.h"
#import "MenuList.h"
#import "MenuModel.h"
#import "AppDelegate.h"
#import "NLSideNavViewController.h"
#import "EGOImageView.h"
#import "MenuCell.h"
#import "NewsViewController.h"
#import "SpecialSubjectViewController.h"
#import "PictureViewController.h"
#import "ILBarButtonItem.h"
#import "UINavigationBar+customBar.h"
#import "DBService.h"

enum{NEWS = 0, TOPIC, LOCAL, REVIEW, FUN, MILITARY, ENTERTAINMENT, PICTURES};

@interface LeftViewController (){
    UITableView *_tableView;
}

@end

@implementation LeftViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [ToolsClass getColor];
    [self addObserver:self forKeyPath:@"data" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self saveData];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObserver:self forKeyPath:@"data"];
}
- (void)dealloc
{
    [_tableView release];
    [_data release];
    [super dealloc];
}

#pragma save data to db
- (void)saveData
{
    if (_data != nil && [_data count] > 0) {
        DBService *service = [[DBService alloc] init];
        NSString *sql = @"select * from menu";
        NSArray *array = [service query:sql params:nil];
        if ([array count] <= 0) {
            for (int i = 0; i < [_data count]; i ++) {
                MenuModel *menu = [_data objectAtIndex:i];
                sql = @"insert into menu(id, menu_id, enName, name, showOrder, image, selectImage, menuFlag) values(?,?,?,?,?,?,?,?)";
                [service update:sql params:[NSArray arrayWithObjects:[NSNull null], menu.menu_id, menu.enName, menu.name, menu.showOrder,menu.imagePath, menu.selectImage, menu.menuFlag, nil]];
            }
        }
        [service release];
    }
}

- (void)loadView
{
    [super loadView];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:66.0 / 255 green:66.0 / 255 blue:66.0 / 255 alpha:1.0];
    //分割线颜色
    [_tableView setSeparatorColor:[UIColor colorWithRed:32.0 / 255 green:32.0 / 255 blue:32.0 / 255 alpha:0.5]];
    [self.view addSubview:_tableView];
    if ([_data count] > 0) {
        [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [_tableView reloadData];
    [self tableView:_tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

#pragma mark UITableView dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[MenuCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
    }
    MenuModel *menuModel = (MenuModel *)[_data objectAtIndex:indexPath.row];
    cell.titleName.text = menuModel.name;
    cell.subName.text = menuModel.enName;
    [cell setImageView:menuModel.imagePath];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275, 60)];
    backgroundView.image = [UIImage imageNamed:@"u27_normal"];
    cell.selectedBackgroundView = backgroundView;
    [backgroundView release];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UINavigationController *navigation = (UINavigationController *)[appDelegate.revealSideViewController rootViewController];
    MenuModel *menuModel = (MenuModel *)[_data objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case TOPIC:
        {
            SpecialSubjectViewController *specialSubject = [[SpecialSubjectViewController alloc]init];
            specialSubject.menuModel = menuModel;
            specialSubject.title = menuModel.name;
            [self setNavBarItem:specialSubject];
            navigation.viewControllers = @[specialSubject];
            [specialSubject release];
            [self.revealSideViewController popViewControllerWithNewCenterController:navigation animated:YES];
            break;
        }
        case PICTURES:
        {
            PictureViewController *pictureView = [[PictureViewController alloc]init];
            pictureView.menuModel = menuModel;
            pictureView.title = menuModel.name;
            [self setNavBarItem:pictureView];
            navigation.viewControllers = @[pictureView];
            [pictureView release];
            [self.revealSideViewController popViewControllerWithNewCenterController:navigation animated:YES];
            break;
        }
        default:
        {
            NewsViewController *news = [[NewsViewController alloc]init];
            news.menuModel = menuModel;
            news.title = menuModel.name;
            [self setNavBarItem:news];
            navigation.viewControllers = @[news];
            [news release];
            [self.revealSideViewController popViewControllerWithNewCenterController:navigation animated:YES];
            break;
        }
    }
}

- (void)setNavBarItem:(UIViewController *)controller
{
    ILBarButtonItem *leftItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"leftMenu"] frame:CGRectMake(0, 0, 49, 37)
                        selectedImage:nil
                               target:self
                               action:@selector(leftPress:)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftPress:) object:leftItem];
    controller.navigationItem.leftBarButtonItem = leftItem;
    ILBarButtonItem *rightItem =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"rightSet"] frame:CGRectMake(0, 0, 49, 39)
                        selectedImage:nil
                               target:self
                               action:@selector(rightPress:)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rightPress:) object:rightItem];
    controller.navigationItem.rightBarButtonItem = rightItem;
    //定制titleview
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 39)];
    [title setText:controller.title];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    [title release];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((200 - 82 ) / 2.0, 39, 82, 3)];
    imageView.image = [UIImage imageNamed:@"underline_red"];
    [view addSubview:imageView];
    [imageView release];
    controller.navigationItem.titleView = view;
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

- (void)leftPress:(id) sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft animated:YES];
}

- (void)rightPress:(id) sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionRight animated:YES];
}
@end
