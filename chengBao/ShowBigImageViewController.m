//
//  ShowBigImageViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-9.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "ShowBigImageViewController.h"
#import "EGOImageView.h"
#import "PictureNetDeal.h"
#import "PictureModel.h"
#import "ImageViewControl.h"
#import "DBService.h"
@interface ShowBigImageViewController () {
    UILabel *_info;
    UILabel *_pages;
    NSInteger _page;
    UITextView *_textInfo;
}

@end

@implementation ShowBigImageViewController

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
    self.navigationController.navigationBar.hidden = YES;
    _scrollView.backgroundColor = [ToolsClass getColor];
    self.view.backgroundColor = [ToolsClass getColor];
}

- (void)dealloc
{
    [_scrollView release];
    [_imagePaths release];
    [_pictureModel release];
    [_menuModel release];
    [_info release];
    [_textInfo release];
    [_pages release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    _imagePaths = [[NSMutableArray alloc]init];
    _page = 1;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    [self configData];
    // back
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"picture_big_back"] forState:UIControlStateNormal];
    back.frame = CGRectMake(10, 10, 36, 44);
    [back addTarget:self action:@selector(backToDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
    [download setImage:[UIImage imageNamed:@"picture_big_download"] forState:UIControlStateNormal];
    download.frame = CGRectMake(screenWidth - 46, 10, 36, 44);
    [download addTarget:self action:@selector(downLoadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:download];
}

#pragma mark barButtonItem action
- (void)backToDetail
{
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downLoadImage
{
    int index = (int)_scrollView.contentOffset.x / screenWidth;
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:200 + index];
    UIImageWriteToSavedPhotosAlbum(imageView.image, self,  @selector(image:didFinishSavingWithError:contextInfo:),  nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if (error == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:@"保存图片成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示信息" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (void)initView
{
    _scrollView.contentSize = CGSizeMake(screenWidth * _imagePaths.count, screenHeight);
    for (int i = 0; i < [_imagePaths count]; i ++) {
        ImageViewControl *view = [[ImageViewControl alloc] initWithFrame:CGRectMake(i * screenWidth, 0, screenWidth, screenHeight)];
        view.imageView.imageURL = [NSURL URLWithString:imagePath([_imagePaths objectAtIndex:i])];
        view.tag = 200 + i;
        [_scrollView addSubview:view];
        [view release];
    }
    [self bottomView];
}

- (void)bottomView
{    
    _textInfo =  [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 40, 0)];
    _textInfo.text = _pictureModel.intro;
    _textInfo.font = [UIFont systemFontOfSize:12];
    _textInfo.backgroundColor = [UIColor clearColor];
    _textInfo.textColor = [UIColor whiteColor];
    _textInfo.editable = NO;
    CGSize size = [_textInfo.text sizeWithFont:_textInfo.font constrainedToSize:CGSizeMake(_textInfo.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    if (size.height > 60) {
        size.height = 60;
    } else if (size.height < 40) {
        size.height = 40;
    }
    _textInfo.frame = CGRectMake(_textInfo.frame.origin.x, _textInfo.frame.origin.y, _textInfo.frame.size.width, size.height);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - size.height - 25, screenWidth, size.height)];
    [view addSubview:_textInfo];
    _pages = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 30, _textInfo.frame.origin.y , 25, size.height)];
    _pages.backgroundColor = [UIColor clearColor];
    _pages.textColor = [UIColor redColor];
    _pages.text = [NSString stringWithFormat:@"%d/%d", _page, [_imagePaths count]];
    [view addSubview:_pages];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.15];
    [self.view addSubview:view];
    [view release];
}

- (void)configData
{
    if ([ToolsClass getAppDelegate].isNet) {
        PictureNetDeal *pictureNetDeal = [[PictureNetDeal alloc]init];
        [pictureNetDeal getPictureListBbPictureId:_pictureModel.imageId fontTyp:[ToolsClass getAppDelegate].fontStyle block:^(id data){
            if (data != nil) {
                self.pictureModel = data;
                NSArray *urls = [_pictureModel.imagePath componentsSeparatedByString:@","];
                for (int i = 0; i < [urls count]; i ++){
                    [_imagePaths addObject:[urls objectAtIndex:i]];
                }
                [self saveImage];
                // init view
                [self initView];
            }
        }];
        [pictureNetDeal release];
    } else {
        NSString *sql = @"select * from images where imageId = ?";
        DBService *service = [[DBService alloc] init];
        NSArray *array = [service query:sql params:[NSArray arrayWithObjects:_pictureModel.imageId, nil]];
        if (array != nil && [array count] > 0) {
            id obj = [array objectAtIndex:0];
            [self.pictureModel setImageIntro:[obj objectForKey:@"imageIntro"]];
            NSArray *urls = [[obj objectForKey:@"imagePath"] componentsSeparatedByString:@","];
            for (int i = 0; i < [urls count]; i ++){
                [_imagePaths addObject:[urls objectAtIndex:i]];
            }
            [self initView];
        }
    }

}

- (void)saveImage
{
    NSString *sql = @"select * from images where imageId = ?";
    DBService *service = [[DBService alloc] init];
    NSArray *array = [service query:sql params:[NSArray arrayWithObjects:_pictureModel.imageId, nil]];
    if (array != nil && [array count] > 0) {
        NSString *fromDb = [[array objectAtIndex:0] objectForKey:@"imageId"];
        NSString *fromNet = _pictureModel.imageId;
        if ([fromDb intValue] != [fromNet intValue]) {
            sql = @"delete from images where imageId = ?";
            [service update:sql params:[NSArray arrayWithObjects:fromDb, nil]];
            [self saveToDB];
        }
    } else {
        [self saveToDB];
    }
    [service release];
}

- (void)saveToDB
{
    NSString *sql = @"insert into images(id, imageId, imagePath, imageIntro) values(?,?,?,?)";
    DBService *service = [[DBService alloc] init];
    if ([_imagePaths count] > 0) {
        [service update:sql params:[NSArray arrayWithObjects:[NSNull null], _pictureModel.imageId, _pictureModel.imagePath, _pictureModel.imageIntro,nil]];
    }
    [service release];
    
}

#pragma mark UIScrollerView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (int)(scrollView.contentOffset.x / screenWidth) + 1;
    if (_page != index) {
        _pages.text = [NSString stringWithFormat:@"%d/%d", index, [_imagePaths count]];
        _page = index;
    }
}
int pre = 200;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int current = scrollView.contentOffset.x / screenWidth + 200;
    ImageViewControl *imageView = (ImageViewControl *)[scrollView viewWithTag:current];
    if (current != pre && imageView.zoomScale > 1) {
        imageView.zoomScale = 1;
    }
    pre = current;
}
@end
