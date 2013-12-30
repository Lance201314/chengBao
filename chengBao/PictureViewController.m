//
//  PictureViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-16.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureCell.h"
#import "EGOImageView.h"
#import "PictureNetDeal.h"
#import "PictureModel.h"
#import "MenuModel.h"
#import "ShowBigImageViewController.h"
#import "DBPicture.h"
@interface PictureViewController () {
    BOOL _moreData;
}

@end

@implementation PictureViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.backgroundColor = [ToolsClass getColor];
    self.view.backgroundColor = [ToolsClass getColor];
}

#pragma mark dealloc
- (void)dealloc
{
    [_data release];
    [_refreshHeaderAndFooterView release];
    [_menuModel release];
    [super dealloc];
}

#pragma mark config data
- (void)configData:(NSInteger)page isNewData:(BOOL)isNewData
{
    if ([ToolsClass getAppDelegate].isNet) {
        PictureNetDeal *pictureNetDeal = [[PictureNetDeal alloc]init];
        [pictureNetDeal getPictureListByMenuId:_menuModel.menu_id fontTyp:[ToolsClass getAppDelegate].fontStyle page:page block:^(id data){
            if ([data count] > 0) {
                if (isNewData) {
                    if (_isHead) {
                        PictureModel *pnew = [data objectAtIndex:0];
                        PictureModel *pold = [_data objectAtIndex:0];
                        if (pnew.imageId.intValue == pold.imageId.intValue) {
                            [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:0];
                        } else {
                            [_data removeAllObjects];
                            [_data addObjectsFromArray:data];
                            [self.tableView reloadData];
                            [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:[data count]];
                        }
                    } else {
                        [_data addObjectsFromArray:data];
                        [self updateTableView:[data count]];
                        _page ++;
                        [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:[data count]];
                    }
                } else {
                    [_data addObjectsFromArray:data];
                    [self.tableView reloadData];
                    _page ++;
                    [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:[data count]];
                    [self savePicture];
                }
            }
        }];
        [pictureNetDeal release];
    } else {
        NSString *sql = @"select * from picture";
        DBPicture *dbPicture = [[DBPicture alloc] init];
        NSArray *array = [dbPicture query:sql params:nil];
        if (array != nil && [array count] > 0) {
            [_data addObjectsFromArray:array];
        } else {
            
        }
        [dbPicture release];
        [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:0];
    }
}

- (void)savePicture
{
    NSString *sql = @"select * from picture";
    DBPicture *dbPicture = [[DBPicture alloc] init];
    NSArray *array = [dbPicture query:sql params:nil];
    if (array != nil && [array count] > 0) {
        PictureModel *fromDb = [array objectAtIndex:0];
        PictureModel *fromNet = [_data objectAtIndex:0];
        if ([fromDb.imageId intValue] != [fromNet.imageId intValue]) {
            sql = @"delete from picture";
            [dbPicture update:sql params:nil];
            [self saveToDB];
        }
    } else {
        [self saveToDB];
    }
    [dbPicture release];
}

- (void)saveToDB
{
    NSString *sql = @"insert into picture(id, guide, imageId, imagePath, name, showOrder, intro) values(?,?,?,?,?,?,?)";
    DBPicture *dbPicture = [[DBPicture alloc] init];
    int rows = [_data count] >= 10 ? 10 : [_data count];
    for (int i = 0; i < rows; i ++) {
        PictureModel *picture = [_data objectAtIndex:i];
        NSString *path = @"";
        if (picture.imagePath != nil) {
            path = picture.imagePath;
        }
        [dbPicture update:sql params: [NSArray arrayWithObjects:[NSNull null], picture.guide, picture.imageId, path, picture.name, picture.showOrder, picture.intro ,nil]];
    }
    [dbPicture release];
}

- (void)loadView
{
    [super loadView];
    _page = 1;
    _moreData = YES;
    _data = [[NSMutableArray alloc]init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self configData:_page isNewData:NO];
    [self addObserver:self forKeyPath:@"self.tableView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
    RefreshHeaderAndFooterView *view = [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    view.delegate = self;
    view.userInteractionEnabled = NO;
    [self.tableView addSubview:view];
    self.refreshHeaderAndFooterView = view;
    [view release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self refreshFrame];
}

- (void)refreshFrame
{
    float height = self.tableView.contentSize.height;
    if (height < screenHeight) {
        height = screenHeight;
    }
    _refreshHeaderAndFooterView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, height);
}

#pragma mark UIScrollViewDelegate method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderAndFooterView RefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderAndFooterView RefreshScrollViewDidEndDragging:scrollView];
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView *)view
{
    return _reload;
}

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView *)view
{
    _reload = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading) {
        _isHead = YES;
        [self performSelector:@selector(doneLodingViewData) withObject:nil afterDelay:3.0];
    } else if (view.refreshFooterView.state == PullRefreshLoading) {
        _isHead = NO;
        [self performSelector:@selector(doneLodingViewData) withObject:nil afterDelay:3.0];
    }
}

- (void)doneLodingViewData
{
    _reload = NO;
    if (_isHead) {
        [self configData:0 isNewData:YES];
        _page = 1;
    } else {
        [self configData:_page isNewData:YES];
    }
    [_refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark bottom view
- (void)bottomView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 44)];
    view.hidden = YES;
    view.tag = 100;
    UILabel *msg = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth / 2 - 60, 0, 80, 44)];
    msg.font = [UIFont systemFontOfSize:14];
    msg.backgroundColor = [UIColor clearColor];
    msg.text = @"正在加载中...";
    msg.tag = 101;
    [view addSubview:msg];
    [msg release];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.frame = CGRectMake(screenWidth / 2 + 20, 0, 40, 40);
    activity.tag = 102;
    [view addSubview:activity];
    [activity release];
    self.tableView.tableFooterView = view;
    [view release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    PictureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PictureCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    PictureModel *pictureModel = [_data objectAtIndex:indexPath.row]; 
    cell.picture.imageURL = [NSURL URLWithString:imagePath([pictureModel imagePath])];
    cell.info.text = [pictureModel name];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowBigImageViewController *showPictures = [[ShowBigImageViewController alloc]init];
    showPictures.pictureModel = [_data objectAtIndex:indexPath.row];
    showPictures.menuModel = _menuModel;
    [self.navigationController pushViewController:showPictures animated:YES];
    [showPictures release];
}

#pragma mark - scroll view delegaet
- (void)updateTableView:(NSInteger)rows
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc]init];
    int j = [_data count] - rows;
    for (int i = 0; i < rows; i ++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:j + i inSection:0];
        [indexPaths addObject:index];
    }
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    [indexPaths release];
}
@end
