//
//  OriginalContextViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-10.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "OriginalContextViewController.h"
#import "ILBarButtonItem.h"
@interface OriginalContextViewController () {
    UIWebView *_webView ;
}
@end

@implementation OriginalContextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark over init
- (id)initWithUrl:(NSString *)url
{
    self = [super init];
    if (self) {
        self.url = url;
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
    [_webView release];
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    ILBarButtonItem *back = [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"back_button"] frame:CGRectMake(0, 0, 50, 44) selectedImage:nil target:self action:@selector(backBarButtonItem)];
    self.navigationItem.leftBarButtonItem = back;
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 60 - 44)];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bounces = NO;
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    [self initBottomView];
}

- (void)initBottomView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - 60 - 44, screenWidth, 60)];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(30, 0, 40, 40);
    [back setImage:[UIImage imageNamed:@"original_back"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(forBack) forControlEvents:UIControlEventTouchUpInside];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forBack) object:back];
    [view addSubview:back];
    UIButton *forWard = [UIButton buttonWithType:UIButtonTypeCustom];
    forWard.frame = CGRectMake(85, 0, 40, 40);
    [forWard setImage:[UIImage imageNamed:@"original_forward"] forState:UIControlStateNormal];
    [forWard addTarget:self action:@selector(forWard) forControlEvents:UIControlEventTouchUpInside];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(forWard) object:forWard];
    [view addSubview:forWard];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(240, 0, 40, 40);
    [cancel setImage:[UIImage imageNamed:@"original_stop"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancel) object:cancel];
    [view addSubview:cancel];
    [self.view addSubview:view];
    [view release];
}

#pragma mark bottom action
- (void)forBack
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }
}

- (void)forWard
{
    if ([_webView canGoForward]) {
        [_webView goForward];
    }
}

- (void)cancel
{
    if ([_webView isLoading]) {
        [_webView stopLoading];
    }
}

#pragma mark nav action
- (void)backBarButtonItem
{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //左右滚动条
    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
}
@end
