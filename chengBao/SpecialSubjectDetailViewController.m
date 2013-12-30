//
//  SpecialSubjectDetailViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-13.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "SpecialSubjectDetailViewController.h"
#import "SpecialSubjectPictureCell.h"
#import "EGOImageView.h"
#import "SpecialSubjectModel.h"
#import "SpecialSubjectCell.h"
#import "AriticleModel.h"
#import "SpecialArticleNetDeal.h"
#import "ILBarButtonItem.h"
#import "SpecialArticleNetDeal.h"
#import "DetailNewsViewController.h"
#import "ArticlesNetDeal.h"
#import "DBSpecialSubject.h"
#import "DBArticle.h"
@interface SpecialSubjectDetailViewController (){
    UITableView *_tableView;
    NSArray *_sectionTitle;
    CGFloat _guideHeight;
}
@end

@implementation SpecialSubjectDetailViewController

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
    _tableView.backgroundColor = [ToolsClass getColor];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc
{
    [_tableView release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    _guideHeight = 60;
    //设置默认选中项
    ILBarButtonItem *back = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_button"] frame:CGRectMake(0, 0, 50, 44) selectedImage:nil target:self action:@selector(backBarButtonItem)];
    self.navigationItem.leftBarButtonItem = back;
    _sectionTitle = [[NSArray alloc]initWithObjects:@"导语", @"专题新闻", @"结束语", nil];
    [self configData];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 44 - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark backButton
- (void)backBarButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark configData
- (void)configData
{
    if ([ToolsClass getAppDelegate].isNet) {
        SpecialArticleNetDeal *netDeal = [[SpecialArticleNetDeal alloc]init];
        [netDeal getSpecialAriticlesBySSId:_specialSubjectModel.ssId fontType:[ToolsClass getAppDelegate].fontStyle block:^(id result){
            self.specialSubjectModel.ariticles = [[NSArray alloc]initWithArray:result];
            [_tableView reloadData];
            [self saveAriticle];
        }];
        [netDeal release];
    } else {
        NSString *sql = @"select * from article where ssId = ?";
        DBArticle *dbArticle = [[DBArticle alloc] init];
        NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:_specialSubjectModel.ssId, nil]];
        if (array != nil && [array count] > 0) {
            _specialSubjectModel.ariticles = array;
        }
    }
}

#pragma mark save to db
- (void)saveAriticle
{
    NSString *sql = @"select * from article where menuId = ? and ssId = ?";
    DBArticle *dbArticle = [[DBArticle alloc] init];
    NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:_menuModel.menu_id, _specialSubjectModel.ssId,nil]];
    if (array != nil && [array count] > 0) {
        AriticleModel *fromDb = [array objectAtIndex:0];
        AriticleModel *fromNet = [_specialSubjectModel.ariticles objectAtIndex:0];
        if ([fromDb.ariticleId intValue] != [fromNet.ariticleId intValue]) {
            sql = @"delete from article where menuId = ? and ssId = ?";
            [dbArticle update:sql params:[NSArray arrayWithObjects:_menuModel.menu_id, _specialSubjectModel.ssId,nil]];
            [self saveToDB];
        }
    } else {
        [self saveToDB];
    }
    [dbArticle release];
}

- (void)saveToDB
{
    NSString *sql = @"insert into article(id, guide, createUser, imagePath, newsCategory,  name, clientFlag, intro, articleType, articleId, updateUser, ssId, menuId) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    DBArticle *dbArticle = [[DBArticle alloc] init];
    for (int i = 0; i < [_specialSubjectModel.ariticles count]; i ++) {
        AriticleModel *article = [_specialSubjectModel.ariticles objectAtIndex:i];
        NSString *path = @"";
        if (article.imagePath != nil) {
            path = article.imagePath;
        }
        [dbArticle update:sql params: [NSArray arrayWithObjects:[NSNull null], article.guide, article.auther, path, article.newsCategory, article.name, article.clientFlag,
                                  article.intro,article.type, article.ariticleId, article.updateUser, _specialSubjectModel.ssId, _menuModel.menu_id,nil]];
    }
    [dbArticle release];
}

#pragma mark UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return [_specialSubjectModel.ariticles count];
    } else if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 60;
    } else if (indexPath.section == 0) {
        return 100;
    } else {
        if (indexPath.row == 0 || indexPath.row == 2) {
            return 30;
        } else {
            return _guideHeight;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *cellIdentifier = @"picturecell";
            SpecialSubjectPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[SpecialSubjectPictureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            cell.picture.imageURL = [NSURL URLWithString:imagePath(_specialSubjectModel.imagePath)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        case 2:
        {
            static NSString *cellIdentifier = @"newscell";
            SpecialSubjectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[SpecialSubjectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            AriticleModel *ariticle = (AriticleModel *)[_specialSubjectModel.ariticles objectAtIndex:indexPath.row];
            cell.egoImageView.imageURL = [NSURL URLWithString:imagePath(ariticle.imagePath)];
            cell.titleName.text = ariticle.name;
            cell.subDesc.text = ariticle.guide;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
        default:
        {
            if (indexPath.row == 1) {
                static NSString *cellIdentifier = @"guidecell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                }
                if (indexPath.section == 1) {
                    cell.textLabel.text = _specialSubjectModel.startGuide;
                } else {
                    cell.textLabel.text = _specialSubjectModel.endGuide;
                }
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                CGSize size = [cell.textLabel.text sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(screenWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
                if (_guideHeight > size.height) {
                    _guideHeight = size.height + 10;
                } else {
                    _guideHeight = size.height;
                }
                cell.textLabel.textColor = [UIColor grayColor];
                [self tableView:_tableView heightForRowAtIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            } else {
                static NSString *cellIdentifier = @"guidecell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
                }
                if (indexPath.section == 1){
                    if (indexPath.row == 0) {
                        cell.textLabel.text = [_sectionTitle objectAtIndex:0];
                    } else {
                        cell.textLabel.text = [_sectionTitle objectAtIndex:1];
                    }
                } else {
                    cell.textLabel.text = [_sectionTitle objectAtIndex:2];
                }
                cell.textLabel.textColor = [UIColor redColor];
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
}

#pragma mark UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        AriticleModel *ariticle = (AriticleModel *)[_specialSubjectModel.ariticles objectAtIndex:indexPath.row];
        if ([ToolsClass getAppDelegate].isNet) {
            ArticlesNetDeal *netDeal = [[ArticlesNetDeal alloc]init];
            [netDeal getAriticlesById:ariticle.ariticleId fontType:[ToolsClass getAppDelegate].fontStyle block:^(id result){
                DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
                detailNews.ariticle = result;
                [self.navigationController pushViewController:detailNews animated:YES];
                [detailNews release];
                DBArticle *dbArticle = [[DBArticle alloc] init];
                NSString *sql = @"select * from article where articleId = ?";
                NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:ariticle.ariticleId, nil]];
                if (array != nil && [array count] == 1) {
                    AriticleModel *temp = [array objectAtIndex:0];
                    //是否已更新相关字段
                    if (temp.publishTime != nil && [@"" isEqualToString:[temp.publishTime stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]]) {
                        sql = @"update article set publishTime = ?, source = ? where articleId = ?";
                        [dbArticle update:sql params:[NSArray arrayWithObjects:detailNews.ariticle.publishTime, detailNews.ariticle.source, ariticle.ariticleId, nil]];
                    }
                }
             [dbArticle release];
             }];
            [netDeal release];
        } else {
            DBArticle *dbArticle = [[DBArticle alloc] init];
            NSString *sql = @"select * from article where articleId = ?";
            NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:ariticle.ariticleId, nil]];
            [dbArticle release];
            if (array != nil && [array count]  == 1) {
                DetailNewsViewController *detailNews = [[DetailNewsViewController alloc]init];
                detailNews.ariticle = [array objectAtIndex:0];
                [self.navigationController pushViewController:detailNews animated:YES];
                [detailNews release];
            }
        }
    }
    
}
@end
