//
//  LxImagesCell.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-5.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "ReCurrentSelectionImagesCell.h"
#import "EGOImageView.h"
#import "AriticleModel.h"
#import "ArticlesNetDeal.h"
#import "BaseArticleNetDeal.h"
#import "DBArticle.h"
#import "AriticleModel.h"
@implementation ReCurrentSelectionImagesCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuId:(NSString *)menuId lxurl:(NSString *)lxurl
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //滑动相册
        _lxInfo = [[NSMutableArray alloc]init];
        _menuId = [menuId retain];
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 142)];
        _scrollView.contentSize = CGSizeMake(screenWidth, 142);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        [self configData:_menuId lxurl:lxurl];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshCell
{
    [self reloadInputViews];
}

- (void)dealloc
{
    [_lxInfo release];
    [_scrollView release];
    [_menuId release];
    [_timer invalidate];
    [super dealloc];
}


#pragma mark save to db
- (void)saveLxArticle
{
    NSString *sql = @"select * from article where menuId = ? and isLx = 1";
    DBArticle *dbArticle = [[DBArticle alloc] init];
    NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:_menuId, nil]];
    if (array != nil && [array count] > 0) {
        AriticleModel *fromDb = [array objectAtIndex:0];
        AriticleModel *fromNet = [_lxInfo objectAtIndex:0];
        if ([fromDb.ariticleId intValue] != [fromNet.ariticleId intValue]) {
            for (int i = 0; i < [array count]; i ++) {
                AriticleModel *article = [array objectAtIndex:i];
                if (article.relationData != nil && [article.relationData count] > 0) {
                    AriticleModel *relationArticle = [article.relationData objectAtIndex:0];
                    sql = @"delete from article where releationId = ? and menuId = ?";
                    [dbArticle update:sql params:[NSArray arrayWithObjects:relationArticle.ariticleId, _menuId, nil]];
                }
            }
            sql = @"delete from article where menuId = ? and isLx = 1";
            [dbArticle update:sql params:[NSArray arrayWithObjects:_menuId, nil]];
            [self saveToDb];
        }
    } else {
        [self saveToDb];
    }
    [dbArticle release];
}

- (void)saveToDb
{
    NSString *sql = @"insert into article (id, guide, createUser, imagePath, newsCategory, name, clientFlag, showOrder, intro, articleType, articleId, updateUser, isLx, menuId) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
    DBArticle *dbArticle = [[DBArticle alloc] init];
    int rows = [_lxInfo count] >= 10 ? 10 : [_lxInfo count];
    for (int i = 0; i < rows; i ++) {
        AriticleModel *article = [_lxInfo objectAtIndex:i];
        [dbArticle update:sql params:[NSArray arrayWithObjects:[NSNull null], article.guide, article.auther, article.imagePath, article.newsCategory,
                                      article.name, article.clientFlag, article.showOrder, article.intro,
                                      article.type, article.ariticleId, article.updateUser, [NSNumber numberWithInt:1], _menuId,nil]];
        if (article.relationData != nil && [article.relationData count] > 0) {
            AriticleModel *articleRelation = [article.relationData objectAtIndex:0];
            NSString *sqlRelation = @"insert into article (id, guide, createUser, imagePath, newsCategory, name, showOrder, intro, articleType, articleId, updateUser, menuId, releationId) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
            [dbArticle update:sqlRelation params:[NSArray arrayWithObjects:[NSNull null], articleRelation.guide, articleRelation.auther, articleRelation.imagePath, articleRelation.newsCategory,  articleRelation.name, articleRelation.showOrder, articleRelation.intro, articleRelation.type, articleRelation.ariticleId, articleRelation.updateUser, _menuId, article.ariticleId, nil]];
        }
    }
    [dbArticle release];
}

- (void)loadImages
{
    for (int i = 0; i < [_lxInfo count]; i ++) {
        AriticleModel *ariticleModel = [_lxInfo objectAtIndex:i];
        //图片
        EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder_lx"]];
        imageView.frame = CGRectMake(i * screenWidth, 0, screenWidth, 142);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.imageURL = [NSURL URLWithString:imagePath(ariticleModel.imagePath)];
        [_scrollView addSubview:imageView];
        [imageView release];
        //单击事件
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tapGesture];
        [tapGesture release];
    }
    AriticleModel *ariticleModel = [_lxInfo objectAtIndex:0];
    //图片
    EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder_lx"]];
    imageView.frame = CGRectMake([_lxInfo count] * screenWidth, 0, screenWidth, 142);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.imageURL = [NSURL URLWithString:imagePath(ariticleModel.imagePath)];
    [_scrollView addSubview:imageView];
    [imageView release];
    //单击事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tapGesture];
    [tapGesture release];
    [self bottomView];
    //循环图片显示
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoreShowImages) userInfo:nil repeats:YES];
}

- (void)bottomView
{
    AriticleModel *ariticleModel = [_lxInfo objectAtIndex:0];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 107, screenWidth, 35)];
    subView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    //概要
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, screenWidth - 40, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.text = ariticleModel.name;
    label.tag = 300;
    label.textColor = [UIColor whiteColor];
    [subView addSubview:label];
    [label release];
    //序号
    UILabel *number = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 40, 5, 40, 25)];
    number.backgroundColor = [UIColor clearColor];
    number.text = [NSString stringWithFormat:@"%d/%d", 1, [_lxInfo count]];
    number.textColor = [UIColor redColor];
    number.tag = 301;
    [subView addSubview:number];
    [number release];
    [self addSubview:subView];
    [subView release];
}

#pragma mark autore showImage action
static int _flag = 0;
- (void)autoreShowImages
{
    CGPoint size = _scrollView.contentOffset;
    if (_flag == 0) {
        size.x += screenWidth;
        if (size.x >= (_scrollView.contentSize.width)) {
            _flag = 1;
        }
    }
    if (_flag == 1) {
        size.x -= screenWidth;
        if (size.x <= 0) {
            size.x = 0;
            _flag = 0;
        }
    }
    int index = (int)(size.x / screenWidth);
    index = index % [_lxInfo count];
    AriticleModel *ariticle = [_lxInfo objectAtIndex:index];
    UILabel *label = (UILabel *)[self viewWithTag:300];
    label.text = ariticle.name;
    label = (UILabel *)[self viewWithTag:301];
    label.text = [NSString stringWithFormat:@"%d/%d",  index + 1, [_lxInfo count]];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    _scrollView.contentOffset = size;
    [UIView commitAnimations];
}

- (void)configData:(NSString *)menuId lxurl:(NSString *)lxurl
{
    if ([ToolsClass getAppDelegate].isNet) {
        BaseArticleNetDeal *ariticleNetDeal = [[BaseArticleNetDeal alloc]init];
        [ariticleNetDeal getLxAriticlesByMenuId:menuId lxUrl:lxurl fontType:[ToolsClass getAppDelegate].fontStyle block:^(id data){
            if ([data count] > 0) {
                [self.lxInfo addObjectsFromArray:data];
                _scrollView.contentSize = CGSizeMake(screenWidth * ([_lxInfo count] + 1), 142);
                [self loadImages];
                [self saveLxArticle];
            } else {
                _scrollView.contentSize = CGSizeMake(screenWidth, 142);
                EGOImageView *imageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder_lx"]];
                imageView.frame = CGRectMake(0, 0, screenWidth, 142);
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                [_scrollView addSubview:imageView];
                [imageView release];
            }
        }];
        [ariticleNetDeal release];
    } else {
        NSString *sql = @"select * from article where menuId = ? and isLx = 1";
        DBArticle *dbArticle = [[DBArticle alloc] init];
        NSArray *array = [dbArticle query:sql params:[NSArray arrayWithObjects:_menuId, nil]];
        if (array != nil && [array count] > 0) {
            for (int i = 0; i < [array count]; i ++) {
                AriticleModel *article = [array objectAtIndex:i];
                sql = @"select * from article where releationId = ? and menuId = ?";
                NSArray *relationArray = [dbArticle query:sql params:[NSArray arrayWithObjects:article.ariticleId, _menuId,  nil]];
                if (relationArray != nil && [relationArray count] > 0) {
                    article.relationData = relationArray;
                }
                [self.lxInfo addObject:article];
            }
            _scrollView.contentSize = CGSizeMake(screenWidth * ([_lxInfo count] + 1), 142);
            [self loadImages];
        } else {
            _scrollView.contentSize = CGSizeMake(screenWidth, 142);
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder_lx"]];
            imageView.frame = CGRectMake(0, 0, screenWidth, 142);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [_scrollView addSubview:imageView];
            [imageView release];
        }
    }
}

#pragma mark action
//点击之后跳转到文章详情
- (void)tapImage:(id)sender
{
    int index = (int)(_scrollView.contentOffset.x / screenWidth);
    AriticleModel *article = [_lxInfo objectAtIndex:index % [_lxInfo count]];
    if (article.relationData != nil && [article.relationData count] > 0) {
        self.block([article.relationData objectAtIndex:0]);
    }
}
@end
