//
//  DetailNewsViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-9.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//
#import "DetailNewsViewController.h"
#import "AriticleModel.h"
#import "UIToolbar+custom.h"
#import "ILBarButtonItem.h"
#import "EGOImageView.h"
#import "ShowBigImageViewController.h"
#import "UINavigationBar+customBar.h"
#import "ShareActivityView.h"
#import "OriginalContextViewController.h"
#import "DBMenu.h"
#import <ShareSDK/ShareSDK.h>
#import <QuartzCore/QuartzCore.h>
@interface DetailNewsViewController () {
    CGFloat _allHeight;
    UIScrollView *_scrollView;
    UIView *_toolsView;
    UIView *_fontSizeview;
    BOOL _showFontSizeView;
    BOOL _isCollection;
    UIWebView *_webView;
}
@end

static CGFloat _fontSize = 14;  //加载页面的字体大小
@implementation DetailNewsViewController

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
    [_ariticle release];
    [_scrollView release];
    [_toolsView release];
    [_fontSizeview release];
    [_webView release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES; //隐藏点击其它返回按钮时，出现的默认返回按钮
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma  mark calulator stringOfSize;
- (CGRect)stringOfSize:(NSString *)str font:(UIFont *)font frame:(CGRect)frame
{    
    CGSize titleSize = [str sizeWithFont:font constrainedToSize:CGSizeMake(frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    frame = CGRectMake(frame.origin.x, frame.origin.y, titleSize.width, titleSize.height);
    return frame;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [ToolsClass getColor];
    _fontSize = [[ToolsClass getAppDelegate].fontSize floatValue];
    [self configContent];
    [self configBottomButton];
    [self configFontView];
}
#pragma mark init view
//初始化内容信息
- (void)configContent
{
    CGFloat width = screenWidth - 20;
    _allHeight = 0;
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 60)];
    //titlename
    UILabel *titleName = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, width, 30)];
    titleName.text = [NSString stringWithFormat:@"%@  |  %@",_ariticle.newsCategory, _ariticle.name];
    titleName.backgroundColor = [UIColor clearColor];
    titleName.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    titleName.textColor = [UIColor blackColor];
    titleName.numberOfLines = 0;
    titleName.frame = [self stringOfSize:titleName.text font:titleName.font frame:titleName.frame];
    [_scrollView addSubview:titleName];
    [titleName release];
    _allHeight += titleName.frame.size.height;
    //type and time
    UILabel *typeAndTime = [[UILabel alloc]initWithFrame:CGRectMake(10, titleName.frame.origin.y + titleName.frame.size.height + 5, width, 15)];
    if (_ariticle.source != nil && _ariticle.publishTime != nil) {
        typeAndTime.text = [NSString stringWithFormat:@"%@  %@", _ariticle.source,_ariticle.publishTime];
    }
    typeAndTime.backgroundColor = [UIColor clearColor];
    typeAndTime.font = [UIFont systemFontOfSize:14];
    typeAndTime.numberOfLines = 0;
    typeAndTime.frame = [self stringOfSize:typeAndTime.text font:typeAndTime.font frame:typeAndTime.frame];
    [_scrollView addSubview:typeAndTime];
    [typeAndTime release];
    _allHeight += typeAndTime.frame.size.height;
    CGFloat contentY = typeAndTime.frame.origin.y + 5 + typeAndTime.frame.size.height;
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(10, contentY, width, 10)];
    [self setSize:_fontSize];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    _webView.hidden = NO;
    _webView.userInteractionEnabled = YES;
    [_scrollView addSubview:_webView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
    [_scrollView addGestureRecognizer:singleTap];
    [singleTap release];
    [self.view addSubview:_scrollView];
}

#pragma mark content image
- (void)singleTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:_webView];
    NSString *imageUrl = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", point.x, point.y];
    NSString *url = [_webView stringByEvaluatingJavaScriptFromString:imageUrl];
    if (url.length > 0) {
        NSLog(@"%@", url);
    }
}

- (void)setSize:(CGFloat)size
{
    _fontSize = size;
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %f;background-color:#%@}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", size, @"f2f2f2", _ariticle.intro];
    [_webView loadHTMLString:jsString baseURL:nil];
}

//初始化底部按钮
- (void)configBottomButton
{
    //改进 to UiView
    _toolsView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 60, screenWidth, 60)];
    _toolsView.hidden = NO;
    [self isCollection];
    NSArray *images = [NSArray arrayWithObjects:@"back_button", @"news_share", @"news_collection", @"news_fontSize", @"news_original", nil];
    for (int i = 0; i < 5; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(2 + 60 * i + i * 4, 0, 60, 43);
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(bottomButtonClick:) object:button];
        button.tag = 10 + i;
        if (i == 2 && _isCollection) {
            [button setImage:[UIImage imageNamed:@"news_collectioned"] forState:UIControlStateNormal];
        }
        [_toolsView addSubview:button];
        //border color
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(button.frame.origin.x + button.frame.size.width + 2, 3, 1.0f, 38);
        layer.backgroundColor = [ToolsClass getBorderColoer].CGColor;
        [_toolsView.layer addSublayer:layer];
    }
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 2, screenWidth, 1);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [_toolsView.layer addSublayer:layer];
    [self.view addSubview:_toolsView];
}

//判断是否已收藏
- (void)isCollection
{
    NSString *sql = @"select * from collection where id = ?";
    DBMenu *dbMenu = [[DBMenu alloc]init];
    NSArray *list = [dbMenu query:sql params:[NSArray arrayWithObjects:_ariticle.ariticleId, nil]];
    if (list && [list count] > 0) {
        _isCollection = YES;
    } else {
        _isCollection = NO;
    }
    [dbMenu release];
}

//初始化设置字体页面
- (void)configFontView
{
    _showFontSizeView = NO;
    _fontSizeview = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 100)];
    _fontSizeview.backgroundColor = [UIColor grayColor];
    _fontSizeview.hidden = YES;
    //button
    NSArray *buttonNames = [NSArray arrayWithObjects:@"小号",@"中号",@"大号", nil];
    for (int i = 0; i < 3; i ++) {
        UIButton *fontButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        fontButton.frame = CGRectMake(30 + i * 90 , 6, 80, 40);
        fontButton.tag = 100 + i;
        [fontButton setTitle:[buttonNames objectAtIndex:i] forState:UIControlStateNormal];
        [fontButton addTarget:self action:@selector(setfontSize:) forControlEvents:UIControlEventTouchUpInside];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setfontSize:) object:fontButton];
        [_fontSizeview addSubview:fontButton];
    }
    //取消按钮
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancleButton.frame = CGRectMake(30, 52, 260, 40);
    cancleButton.backgroundColor = [UIColor grayColor];
    cancleButton.tag = 103;
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton addTarget:self action:@selector(setfontSize:) forControlEvents:UIControlEventTouchUpInside];
    [_fontSizeview addSubview:cancleButton];
    [self.view addSubview:_fontSizeview];
    //
}

#pragma mark font action
- (void)setfontSize:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            [self setSize:12];
            break;
        }
        case 101:
        {
            [self setSize:14];
            break;
        }
        case 102:
        {
            [self setSize:18];
            break;
        }
        case 103:
        {
            break;
        }
    }
    [self disappearFontView];
}

- (void)disappearFontView
{
    if (_showFontSizeView) {
        _showFontSizeView = NO;
        //动画
        [UIView animateWithDuration:0.3 animations:^(){
            CGRect frame = _fontSizeview.frame;
            frame.origin.y += 120;
            _fontSizeview.frame = frame;
        } completion:^(BOOL finish){
            _fontSizeview.hidden = YES;
        }];
    }
}

#pragma  mark barButtonItem action

- (void)bottomButtonClick:(UIButton *)button
{
    switch (button.tag) {
        case 10:
        {
            _toolsView.hidden = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case 11:
        {
            [self showLinkView];
            break;
        }
        case 12:
        {
            if (!_isCollection) {
                [self collectionAriticle];
                _isCollection = YES;
                [button setImage:[UIImage imageNamed:@"news_collectioned"] forState:UIControlStateNormal];
            } else {
                [self cancelCollectionAriticle];
                _isCollection = NO;
                [button setImage:[UIImage imageNamed:@"news_collection"] forState:UIControlStateNormal];
            }
            break;
        }
        case 13:
        {
            if (!_showFontSizeView) {
                _fontSizeview.hidden = NO;
                _showFontSizeView = YES;
                //动画
                [UIView animateWithDuration:0.3 animations:^(){
                    CGRect frame = _fontSizeview.frame;
                    frame.origin.y -= 120;
                    _fontSizeview.frame = frame;
                } completion:^(BOOL finish){
                }];
            }
            break;
        }
        case 14:
        {
            if ([_ariticle.source hasPrefix:@"http"]) {
                if ([ToolsClass getAppDelegate].isNet) {
                    OriginalContextViewController *original = [[OriginalContextViewController alloc]initWithUrl:_ariticle.source];
                    original.title = @"原文";
                    [self setNavTitleView:original];
                    [self.navigationController pushViewController:original animated:YES];
                    [original release];
                } else {
                    [ToolsClass showNetInfo:@"网络异常" message:@"没有网络数据"];
                }
            }
            break;
        }
    }
}

#pragma mark collection
- (void)collectionAriticle
{
    NSString *sql = @"create table if not exists collection(id text primary key, name text)";
    DBMenu *dbMenu = [[DBMenu alloc]init];
    [dbMenu update:sql params:nil];
    sql = @"insert into collection(id, name) values(?, ?)";
    [dbMenu update:sql params:[NSArray arrayWithObjects:_ariticle.ariticleId, _ariticle.name, nil]];
    [dbMenu release];
}

- (void)cancelCollectionAriticle
{
    NSString *sql = @"delete from collection where id = ?";
    DBMenu *dbMenu = [[DBMenu alloc]init];
    [dbMenu update:sql params:[NSArray arrayWithObjects:_ariticle.ariticleId, nil]];
    [dbMenu release];
}
    
//链接
- (void)showLinkView
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK"  ofType:@"jpg"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@", _ariticle.name, _ariticle.url]
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:_ariticle.url
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];

}

//设置子界面的导航栏格式
- (void)setNavTitleView:(UIViewController *)viewController
{
    //定制titleview
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 82, 44)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 82, 39)];
    [title setText:viewController.title];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    [title release];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 82, 3)];
    imageView.image = [UIImage imageNamed:@"underline_red"];
    [view addSubview:imageView];
    [imageView release];
    viewController.navigationItem.titleView = view;
    [view release];
}
- (void)bigPictue
{
    NSMutableArray *imagePaths = [[NSMutableArray alloc]init];
    [imagePaths addObject:[_ariticle imagePath]];
    ShowBigImageViewController *showBigImage = [[ShowBigImageViewController alloc]init];
    showBigImage.imagePaths = imagePaths;
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController pushViewController:showBigImage animated:YES];
    [showBigImage release];
}

#pragma mark UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //左右滚动条
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=280;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "};"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    //设置scrollview 高度
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeMake(screenWidth, 0)];
    frame.size = fittingSize;
    webView.frame = frame;
    NSLog(@"内容字体变小 高度有问题， %f", frame.size.height);
    //高度不能一直加
    _scrollView.contentSize = CGSizeMake(screenWidth, _allHeight + webView.frame.size.height);
}
@end
