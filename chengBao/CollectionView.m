//
//  CollectionViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-11.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "CollectionView.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ILBarButtonItem.h"
#import "ArticlesNetDeal.h"
#import "DetailNewsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DBArticle.h"
@interface CollectionView () {
    NSMutableArray *_data;
    UITableView *_tableView;
}

@end

@implementation CollectionView

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
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
    _tableView.backgroundColor = [ToolsClass getColor];
    self.view.backgroundColor = [ToolsClass getColor];
}

- (void)dealloc
{
    [_data release];
    [_tableView release];
    [super dealloc];
}

- (void)configData
{
    _data = [[NSMutableArray alloc]init];
    NSString *dbPath = [[ToolsClass getDocumentPath] stringByAppendingPathComponent:collectionDataBaseName];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    @try {
        [db open];
        NSString *sql = @"select * from collection";
        FMResultSet *result = [db executeQuery:sql];
        NSMutableArray *ids = [[NSMutableArray alloc]init];
        NSMutableArray *names = [[NSMutableArray alloc]init];
        while ([result next]) {
            [ids addObject: [result stringForColumn:@"id"]];
            [names addObject:[result stringForColumn:@"name"]];
        }
        [_data addObject:ids];
        [ids release];
        [_data addObject:names];
        [names release];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        [db close];
    }
}

- (void)loadView
{
    [super loadView];
    [self configData];
    [self initView];
}

- (void)initView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [ToolsClass getColor];
    [self.view addSubview:_tableView];
    ILBarButtonItem *back = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_button"] frame:CGRectMake(0, 0, 50, 44) selectedImage:nil target:self action:@selector(backBarButtonItem)];
    self.navigationItem.leftBarButtonItem = back;
    ILBarButtonItem *deleteItem = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"set_delete"] frame:CGRectMake(0, 0, 50, 44) selectedImage:nil target:self action:@selector(deleteCell)];
    self.navigationItem.rightBarButtonItem = deleteItem;
}

#pragma mark navigator item action
- (void)backBarButtonItem
{
    CGRect frame = self.navigationController.view.frame;
    frame.origin.x = screenWidth;
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.frame = frame;
    } completion:^(BOOL finished){
        if (finished) {
            [self.navigationController.view removeFromSuperview];
            self.back();
        }
    }];
}

- (void)deleteCell
{
    _tableView.editing = !_tableView.editing;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_data objectAtIndex:0] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text = [[_data objectAtIndex:1] objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        // delete it from sqlite
        FMDatabase *db = [FMDatabase databaseWithPath:[[ToolsClass getDocumentPath] stringByAppendingPathComponent:collectionDataBaseName]];
        @try {
            [db open];
            [db executeUpdate:@"delete from collection where id = ?", [[_data objectAtIndex:0] objectAtIndex:indexPath.row]];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
        @finally {
            [db close];
        }
        [[_data objectAtIndex:0] removeObjectAtIndex:indexPath.row];
        [[_data objectAtIndex:1] removeObjectAtIndex:indexPath.row];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *articleId = [[_data objectAtIndex:0] objectAtIndex:indexPath.row];
    if ([ToolsClass getAppDelegate].isNet) {
        ArticlesNetDeal *ariticleNet = [[ArticlesNetDeal alloc]init];
        [ariticleNet getAriticlesById:articleId fontType:[ToolsClass getAppDelegate].fontStyle block:^(id result){
            DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
            detailNews.ariticle = result;
            [self.navigationController pushViewController:detailNews animated:YES];
            [detailNews release];
        }];
        [ariticleNet release];
    } else {
        NSString *sql = @"select * from article where articleId = ?";
        DBArticle *dbArticle = [[DBArticle alloc] init];
        NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:articleId, nil]];
        if (array != nil && [array count] > 0) {
            DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
            detailNews.ariticle = [array objectAtIndex:0];
            [self.navigationController pushViewController:detailNews animated:YES];
            [detailNews release];
        } else {
            NSLog(@"there is not recode in database");
            [ToolsClass showNetInfo:@"网络异常" message:@"没有网络数据"];
        }
        [dbArticle release];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
@end
