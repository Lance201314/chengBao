//
//  NewsViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "NewsViewController.h"
#import "ArticlesNetDeal.h"
#import "AriticleModel.h"
#import "ReCurrentSelectionImagesCell.h"
#import "NewsCell.h"
#import "MenuModel.h"
#import "EGOImageView.h"
#import "DetailNewsViewController.h"
#import "DBArticle.h"
#define lxUrl @"/api/AppApi/getLxArticlesByMenu?clientFlag=PHONE&flag="
@interface NewsViewController (){
}
@property (nonatomic, retain) UIView *contentView;
@end

@implementation NewsViewController

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
    [_refreshHeaderAndFooterView release];
    [self removeObserver:self forKeyPath:@"_tableView.contentSize"];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    _tableView.backgroundColor = [ToolsClass getColor];
    self.view.backgroundColor = [ToolsClass getColor];
    [self addObserver:self forKeyPath:@"_tableView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self removeObserver:self forKeyPath:@"_tableView.contentSize"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)loadView
{
    [super loadView];
    _dataList = [[NSMutableArray alloc]init];
    _page = 0;
    [self configData: _page isNewData:NO];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 20 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    RefreshHeaderAndFooterView *view = [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    view.delegate = self;
    view.userInteractionEnabled = NO;
    [self.tableView addSubview:view];
    self.refreshHeaderAndFooterView = view;
    [view release];
}

#pragma mark autorotate
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(BOOL)shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

#pragma mark save some article
- (void)saveArticle
{
    if (_dataList != nil && [_dataList count] > 0) {
        DBArticle *dbArticle = [[DBArticle alloc] init];
        NSString *sql = @"select * from article where menuId = ? and isLx = 0 and ssId = -1";
        NSArray *list = [dbArticle query:sql params:[NSArray arrayWithObjects:_menuModel.menu_id, nil]];
        if (list != nil && [list count] > 0) {
            AriticleModel *fromDB = [list objectAtIndex:0];
            AriticleModel *fromNet = [_dataList objectAtIndex:0];
            if (![fromDB.ariticleId isEqualToString:fromNet.ariticleId]) {
                //清空表
                sql = @"delete from article where menuId = ? and isLx = 0";
                [dbArticle update:sql params:[NSArray arrayWithObjects:_menuModel.menu_id, nil]];
                [self saveToDB];
            }
        } else {
            [self saveToDB];
        }
        [dbArticle release];
    }
}

- (void)saveToDB
{
    // 保存到数据库
    DBArticle *dbArticle = [[DBArticle alloc] init];
    int rows = [_dataList count] >= 10 ? 10:[_dataList count];
    for (int i = 0; i < rows; i ++) {
        AriticleModel *news = [_dataList objectAtIndex:i];
        NSString *sql = @"insert into article(id, guide, publishTime, imagePath, clientFlag, menuId, articleId, intro, ssId, createUser, source, newsCategory, name, showOrder, articleType, updateUser) values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?, ?, ?)";
        NSString *path = @"";
        if (news.imagePath != nil) {
            path = news.imagePath;
        }
        [dbArticle update:sql params:[NSArray arrayWithObjects:[NSNull null], news.guide, news.publishTime, path, news.clientFlag,
                                      news.menuId, news.ariticleId, news.intro, @"-1", news.auther, news.source, news.newsCategory, news.name, news.showOrder,
                                      news.type, news.updateUser,nil]];
    }
    [dbArticle release];
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
    _refreshHeaderAndFooterView.frame =  CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, height);
}

- (void)doneLoadingViewData
{
	_reloading = NO;
    if (_isHead) {
        [self configData:0 isNewData:YES];
        _page = 1;
    } else {
        [self configData:_page isNewData:YES];
    }
    [_refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderAndFooterView RefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHeaderAndFooterView RefreshScrollViewDidEndDragging:scrollView];
	
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view
{
	_reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading) {//下拉刷新动作的内容
        _isHead = YES;
        [self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
    }else if(view.refreshFooterView.state == PullRefreshLoading){//上拉加载更多动作的内容
        _isHead = NO;
        [self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
    }
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view
{
	return _reloading;
}

#pragma mark init data
- (void)configData:(NSInteger)pages isNewData:(BOOL)isNewData
{
    if ([ToolsClass getAppDelegate].isNet) {
        ArticlesNetDeal *articlesNetDeal = [[ArticlesNetDeal alloc]init];
        [articlesNetDeal getAriticlesByMenuId: self.menuModel.menu_id fontType:[ToolsClass getAppDelegate].fontStyle page:pages block:^(id data){
            if (isNewData) {
                if (_isHead) {
                    if ([data count] > 0) {
                        AriticleModel *old = [_dataList objectAtIndex:0];
                        AriticleModel *new = [data objectAtIndex:0];
                        if ([old.ariticleId isEqualToString:new.ariticleId]) {
                            [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:0];
                        } else {
                            [_dataList removeAllObjects];
                            [_dataList addObjectsFromArray:data];
                            [_tableView reloadData];
                            [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:[data count]];
                        }
                    }
                } else {
                    if ([data count] > 0) {
                        [self.dataList addObjectsFromArray:data];
                        [self updateTableView:[data count] isHead:NO];
                        _page ++;
                        [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:[data count]];
                    }
                }
            } else {
                if ([data count] > 0) {
                    [self.dataList addObjectsFromArray:data];
                    [_tableView reloadData];
                }
                [self saveArticle];
                [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:[data count]];
                _page ++;
            }
        }];
        [articlesNetDeal release];
    } else {
        DBArticle *dbArticle = [[DBArticle alloc] init];
        NSArray *array = [dbArticle query:@"select * from article where menuId = ? and isLx = 0  and ssId = '-1'" params:[NSArray arrayWithObjects:_menuModel.menu_id, nil]];
        if ([array count] > 0) {
            [self.dataList addObjectsFromArray:array];
        }
        [dbArticle release];
        [_refreshHeaderAndFooterView.refreshHeaderView showHeaderMsg:0];
    }
}

#pragma mark UITableView dataSource
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
        cell.block = ^(AriticleModel *articleModel) {
            [self lxViewConfig:articleModel];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    } else {
        static NSString *cellIdentifier = @"normal";
        NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        AriticleModel *ariticleModel = [_dataList objectAtIndex:(indexPath.row)];
        cell.egoImageView.imageURL = [NSURL URLWithString:imagePath(ariticleModel.imagePath)];
        cell.menuName.text = [NSString stringWithFormat:@"%@  |", ariticleModel.newsCategory];
        CGRect frame = cell.menuName.frame;
        CGSize size = [cell.menuName.text sizeWithFont:cell.menuName.font constrainedToSize:CGSizeMake(MAXFLOAT, frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
        frame.size.width = size.width;
        cell.menuName.frame = frame;
        cell.titleName.text = ariticleModel.name;
        CGFloat y = frame.origin.x + frame.size.width + 5;
        cell.titleName.frame = CGRectMake(y, frame.origin.y, screenWidth - y - 5 , frame.size.height);
        cell.subDesc.text = ariticleModel.guide;
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

#pragma mark lxArticle configData
- (void)lxViewConfig:(AriticleModel *)articleModel
{
    [self showDetailNews:articleModel];
}

#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AriticleModel *article = [_dataList objectAtIndex:indexPath.row];
    [self showDetailNews:article];
}

- (void)showDetailNews:(AriticleModel *)article
{
    if ([ToolsClass getAppDelegate].isNet) {
        ArticlesNetDeal *ariticleNetDeal = [[ArticlesNetDeal alloc]init];
        [ariticleNetDeal getAriticlesById:article.ariticleId fontType:[ToolsClass getAppDelegate].fontStyle block:^(id data){
            if (data != nil) {
                DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
                AriticleModel *netArticle = data;
                detailNews.ariticle = netArticle;
                [self.navigationController pushViewController:detailNews animated:YES];
                [detailNews release];
                //update recode to database
                /*
                    if not exist the recode, do nothing, or update the recode.
                 */
                NSString *sql = @"select * from article where articleId = ?";
                DBArticle *dbArticle = [[DBArticle alloc] init];
                NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:article.ariticleId, nil]];
                if (array != nil && [array count] > 0) {
                    sql = @"update article set publishTime = ?, clientFlag = ?, menuId = ?, source = ?, newsCategory = ? where articleId = ?";
                    [dbArticle query:sql params:[NSArray arrayWithObjects:netArticle.publishTime, netArticle.clientFlag, netArticle.menuId, netArticle.source, netArticle.newsCategory, netArticle.ariticleId, nil]];
                }
                [dbArticle release];
            }
        }];
        [ariticleNetDeal release];
    } else {
        DBArticle *dbArticle = [[DBArticle alloc] init];
        NSArray *array = [dbArticle query:@"select * from article where articleId = ?" params:[NSArray arrayWithObjects:article.ariticleId, nil]];
        if ([array count] > 0) {
            DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
            detailNews.ariticle = [array objectAtIndex:0];
            [self.navigationController pushViewController:detailNews animated:YES];
            [detailNews release];
        }
    }
}

- (void)loadData
{
    if (_isHead) {
        [self configData:0 isNewData:YES];
    } else {
        [self configData:_page isNewData:YES];
    }
}

- (void)updateTableView:(NSInteger)rows isHead:(BOOL)isHead
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
@end
