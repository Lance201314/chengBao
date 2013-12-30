//
//  SpecialSubjectViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//
#import "SpecialSubjectViewController.h"
#import "SpecialArticleNetDeal.h"
#import "SpecialSubjectModel.h"
#import "ReCurrentSelectionImagesCell.h"
#import "SpecialSubjectCell.h"
#import "EGOImageView.h"
#import "SpecialSubjectDetailViewController.h"
#import "DBSpecialSubject.h"
#define lxUrl  @"/api/AppApi/getLxSpecialSubjectByMenu?clientFlag=PHONE&flag="
@interface SpecialSubjectViewController ()

@end

@implementation SpecialSubjectViewController

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

- (void)dealloc
{
    [_tableView release];
    [_menuModel release];
    [_dataList release];
    [_refreshHeaderAndfooterView release];
    [self removeObserver:self forKeyPath:@"_tableView.contentSize"];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // some config information
    self.navigationController.navigationBar.hidden = NO;
    _tableView.backgroundColor = [ToolsClass getColor];
    self.view.backgroundColor = [ToolsClass getColor];
}

- (void)loadView
{
    [super loadView];
    //初始化参数
    _dataList = [[NSMutableArray alloc]init];
    _page = 0;
    //获取数据
    [self configData:_page isNewData:NO];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44 - 20) style:UITableViewStylePlain];  
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [self addObserver:self forKeyPath:@"_tableView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    RefreshHeaderAndFooterView *view = [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    view.delegate = self;
    view.userInteractionEnabled = NO;
    [self.tableView addSubview:view];
    self.refreshHeaderAndfooterView = view;
    [view release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self refreshFrame];
}

#pragma mark chang refreshview frame
- (void)refreshFrame
{
    float height = _tableView.contentSize.height;
    if (height < screenHeight) {
        height = screenHeight;
    }
    _refreshHeaderAndfooterView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, height);
}

#pragma mark UIScrollViewDelegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderAndfooterView RefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderAndfooterView RefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark RefreshHeaderAndFooterViewDelegate methods
- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView *)view
{
    _reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading) {
        _isHeader = YES;
        [self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
    } else if (view.refreshFooterView.state == PullRefreshLoading) {
        _isHeader = NO;
        [self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
    }
}

- (void)doneLoadingViewData
{
    _reloading = NO;
    // deal with data
    if (_isHeader) {
        [self configData:0 isNewData:YES];
        _page = 1;
    } else {
        [self configData:_page isNewData:YES];
    }
    [_refreshHeaderAndfooterView RefreshScrollViewDataSourceDidFinishedLoading:_tableView];
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView *)view
{
    return _reloading;
}

- (void)initrefreshView
{
    UIView *loadMsgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    loadMsgView.hidden = YES;
    loadMsgView.tag = 100;
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(screenWidth / 2 - 60, 2, 40, 40);
    activityIndicator.tag = 101;
    [loadMsgView addSubview:activityIndicator];
    [activityIndicator release];
    UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth / 2 - 20, 7, 80, 30)];
    msg.text = @"正在加载...";
    msg.font = [UIFont systemFontOfSize:12];
    msg.tag = 102;
    msg.backgroundColor = [UIColor clearColor];
    [loadMsgView addSubview:msg];
    [msg release];
    _tableView.tableFooterView = loadMsgView;
    [loadMsgView release];
}

#pragma mark init data
- (void)configData:(NSInteger)page isNewData:(BOOL)isNewData
{
    if ([ToolsClass getAppDelegate].isNet) {
        SpecialArticleNetDeal *specialNetDeal = [[SpecialArticleNetDeal alloc]init];
        [specialNetDeal getSpecialSubjectMenuId:self.menuModel.menu_id  fontType:[ToolsClass getAppDelegate].fontStyle page:page block:^(id data)
         {
             if (isNewData) {
                 if (_isHeader) {
                     if ([data count] > 0) {
                         SpecialSubjectModel *old = [_dataList objectAtIndex:0];
                         SpecialSubjectModel *new = [data objectAtIndex:0];
                         if (old.ssId.intValue  == new.ssId.intValue) {
                             [_refreshHeaderAndfooterView.refreshHeaderView showHeaderMsg:0];
                         } else {
                             [self.dataList removeAllObjects];
                             [self.dataList addObjectsFromArray:data];
                             [self.tableView reloadData];
                             [_refreshHeaderAndfooterView.refreshHeaderView showHeaderMsg:[data count]];
                         }
                     } else {
                         [_refreshHeaderAndfooterView.refreshHeaderView showHeaderMsg:0];
                     }
                 } else {
                     if ([data count] > 0) {
                         [self.dataList addObjectsFromArray:data];
                         [self updateTableView:[data count]];
                         _page ++;
                         [_refreshHeaderAndfooterView.refreshHeaderView showHeaderMsg:[data count]];
                     }
                 }
             } else {
                 [self.dataList addObjectsFromArray:data];
                 [_tableView reloadData];
                 [_refreshHeaderAndfooterView.refreshHeaderView showHeaderMsg:[data count]];
                 _page ++;
                 [self saveSpecialSubject];
             }
         }];
        [specialNetDeal release];
    } else {
        NSString *sql = @"select * from specialSub";
        DBSpecialSubject *dbSS = [[DBSpecialSubject alloc] init];
        NSArray *array = [dbSS query:sql params:nil];
        if (array != nil && [array count] > 0) {
            [_dataList addObjectsFromArray:array];
        }
        [dbSS release];
        [_refreshHeaderAndfooterView.refreshHeaderView showHeaderMsg:0];
    }
}

- (void)saveSpecialSubject
{
    NSString *sql = @"select * from specialSub";
    DBSpecialSubject *dbSS = [[DBSpecialSubject alloc] init];
    NSArray *array = [dbSS query:sql params:nil];
    if (array != nil && [array count] > 0) {
        SpecialSubjectModel *fromDb = [array objectAtIndex:0];
        SpecialSubjectModel *fromNet = [_dataList objectAtIndex:0];
        if ([fromNet.ssId intValue] != [fromDb.ssId intValue]) {
            sql = @"delete from specialSub";
            [dbSS update:sql params:nil];
            [self saveToDB];
        }
    } else {
        [self saveToDB];
    }
    [dbSS release];
}

- (void)saveToDB
{
    NSString *sql = @"insert into specialSub(id, guide, endGuide, imagePath, clientFlag, ssType, intro, ssId, createUser, name, startGuide, updateUser, releationSSId, menuId, publishTime) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    DBSpecialSubject *dbSS = [[DBSpecialSubject alloc] init];
    int rows = [_dataList count] >= 10 ? 10 : [_dataList count];
    for (int i = 0; i < rows; i ++) {
        SpecialSubjectModel *ss = [_dataList objectAtIndex:i];
        NSString *path = @"";
        if (ss.imagePath != nil) {
            path = ss.imagePath;
        }
        [dbSS update:sql params: [NSArray arrayWithObjects:[NSNull null], ss.guide, ss.endGuide, path, ss.clientFlag, ss.ssType, ss.intro,
                                  ss.ssId, ss.createUser, ss.name, ss.startGuide, ss.updateUser, ss.relationSSId, _menuModel.menu_id, @"", nil]];
    }
    [dbSS release];
}

#pragma mark UItableView dataSource;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0){
        return 1;
    }else{
        return [_dataList count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellIdentifier = @"specal";
        ReCurrentSelectionImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[ReCurrentSelectionImagesCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier menuId:_menuModel.menu_id lxurl:lxUrl] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return  cell;
    } else {
        static NSString *cellIdentifier = @"normal";
        SpecialSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[SpecialSubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        SpecialSubjectModel *specialModel = [_dataList objectAtIndex:(indexPath.row)];
        cell.egoImageView.imageURL = [NSURL URLWithString:imagePath(specialModel.imagePath)];
        cell.titleName.text = specialModel.name;
        cell.subDesc.text = specialModel.guide;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return  cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 142;
    } else {
        return 60;
    }
}

#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialSubjectModel *ssModel = (SpecialSubjectModel *)[_dataList objectAtIndex:indexPath.row];
    SpecialSubjectDetailViewController *viewController = [[SpecialSubjectDetailViewController alloc]init];
    viewController.specialSubjectModel = ssModel;
    viewController.menuModel = _menuModel;
    viewController.title = ssModel.name;
    [self setNavTitleView:viewController];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}

- (void)updateTableView:(NSInteger)rows
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    int j = [_dataList count] - rows;
    for (int i = 0; i < rows; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow: j + i  inSection:1];
        [indexPaths addObject:indexPath];
    }
    [_tableView beginUpdates];
    [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [_tableView endUpdates];
    [indexPaths release];
}
//设置子界面的导航栏格式
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
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [view addSubview:title];
    [title release];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(59, 39, 82, 3)];
    imageView.image = [UIImage imageNamed:@"u5_normal"];
    [view addSubview:imageView];
    [imageView release];
    viewController.navigationItem.titleView = view;
    [view release];
}
@end
