//
//  AppDelegate.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "AppDelegate.h"
#import "AsdNetDeal.h"
#import "NewsViewController.h"
#import "NLSideNavViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "MenuList.h"
#import "ToolsClass.h"
#import "UINavigationBar+customBar.h"
#import "EGOImageView.h"
#import <ShareSDK/ShareSDK.h>
#import "Reachability.h"
#import "DBMenu.h"
#import "UINavigationController+custom.h"
@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    _fontSize = nil;
    _fontStyle = nil;
    [_revealSideViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSThread sleepForTimeInterval:2];
    [ShareSDK registerApp:@"f4c95a94633"];
    NSLog(@"wogoiegjrr");
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [ToolsClass getColor];
    [self.window makeKeyAndVisible];
    //配置文件加载
    [self configInit];
    [self shareConfig];
    [self getNet];
    if (_isNet) {
        //广告
        EGOImageView *adsImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"placeholder_Lx"]];
        adsImageView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
        adsImageView.contentMode = UIViewContentModeScaleToFill;
        AsdNetDeal *asdNet = [[AsdNetDeal alloc]init];
        [asdNet getAsdStartApp:^(id result){
            adsImageView.imageURL = [NSURL URLWithString:result];
        }];
        [self.window addSubview:adsImageView];
        [adsImageView release];
        //加载导航栏
        [self performSelector:@selector(homeStart) withObject:nil afterDelay:1.5];
    } else {
        [self homeStart];
    }
    return YES;
}

- (void)getNet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changNet:) name:kReachabilityChangedNotification object:nil];
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    NetworkStatus status = self.reachability.currentReachabilityStatus;
    [self checkNet:status];
}
- (void)changNet:(NSNotification *)notification
{
    NetworkStatus status = self.reachability.currentReachabilityStatus;
    [self checkNet:status];
}

- (void)checkNet:(NetworkStatus)status
{
    if (status == kNotReachable) {
        _isNet = NO;
    } else {
        _isNet = YES;
    }
}

- (void)startImage
{
    //把广告移除window
    [[[self.window subviews] objectAtIndex:0] removeFromSuperview];
#pragma mark menu
    UIViewController *viewController = [[UIViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [nav.navigationBar customNavigationBar];
    [viewController release];
    NLSideNavViewController *side_nav = [[NLSideNavViewController alloc] initwithRootView:nav];
    [nav release];
    LeftViewController *left = [[LeftViewController alloc] init];
    [MenuList getMenuList:_fontStyle block:^(id result){
        left.data = result;
    }];
    [side_nav setLeftVC:left];
    [left release];
#pragma mark setting
    RightViewController *right = [[RightViewController alloc] init];
    [side_nav setRightVC:right];
    [right release];
    self.window.rootViewController = side_nav;
    [side_nav release];
}

- (void)homeStart
{
    if (_isNet) {
        // 移除广告
        [[[self.window subviews] objectAtIndex:0] removeFromSuperview];
    }
    UIViewController *viewController = [[UIViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    nav.view.backgroundColor = [ToolsClass getColor];
    [nav.navigationBar customNavigationBar];
    [viewController release];
    self.revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:nav];
    [nav release];
    // left view
    LeftViewController *left = [[LeftViewController alloc] init];
    DBMenu *dbMenu = [[DBMenu alloc] init];
    NSArray *temp = [dbMenu query:@"select * from menu" params:nil];
    if (temp != nil && [temp count] > 0) {
        left.data = [NSMutableArray arrayWithArray:[dbMenu query:@"select * from menu" params:nil]];
    } else {
        if (_isNet) {
            [MenuList getMenuList:_fontStyle block:^(id result){
                left.data = result;
            }];
        } else {
            //既没有网络，有没有离线文件，
        }
    }
    [self.revealSideViewController preloadViewController:left forSide:PPRevealSideDirectionLeft];
    [left release];
    // right view
    RightViewController *right = [[RightViewController alloc] init];
    [self.revealSideViewController preloadViewController:right forSide:PPRevealSideDirectionRight];
    [right release];
    // config info
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionContentView | PPRevealSideInteractionNavigationBar];
    self.window.rootViewController = self.revealSideViewController;
}

#pragma mark config init data
- (void)configInit
{
    NSUserDefaults *userDefualt = [NSUserDefaults standardUserDefaults];
    if ([userDefualt objectForKey:@"fontSize"] == nil) {
        [userDefualt setObject:@"14" forKey:@"fontSize"];
        _fontSize = @"14";
        [userDefualt setObject:@"true" forKey:@"fontStyle"];
        _fontStyle = @"true";
        [userDefualt setObject:@"1" forKey:@"push_Switch"];
    } else {
        _fontSize = [userDefualt objectForKey:@"fontSize"];
        _fontStyle = [userDefualt objectForKey:@"fontStyle"];
    }
}

- (void)shareConfig
{
    //添加新浪微博应用
    [ShareSDK connectSinaWeiboWithAppKey:@"3201194191"
                               appSecret:@"0334252914651e8f76bad63337b3b78f"
                             redirectUri:@"http://appgo.cn"];
    //添加腾讯微博应用
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    //添加QQ空间应用
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
    //添加网易微博应用
    [ShareSDK connect163WeiboWithAppKey:@"T5EI7BXe13vfyDuy"
                              appSecret:@"gZxwyNOvjFYpxwwlnuizHRRtBRZ2lV1j"
                            redirectUri:@"http://www.shareSDK.cn"];
    //添加搜狐微博应用
    [ShareSDK connectSohuWeiboWithConsumerKey:@"SAfmTG1blxZY3HztESWx"
                               consumerSecret:@"yfTZf)!rVwh*3dqQuVJVsUL37!F)!yS9S!Orcsij"
                                  redirectUri:@"http://www.sharesdk.cn"];
    //添加豆瓣应用
    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
                            appSecret:@"e32896161e72be91"
                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    //添加人人网应用
    [ShareSDK connectRenRenWithAppKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                            appSecret:@"f29df781abdd4f49beca5a2194676ca4"];
    //添加开心网应用
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    //添加Instapaper应用
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    //添加有道云笔记应用
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    //添加Facebook应用
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    //添加Twitter应用
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];    
    //添加搜狐随身看应用
    [ShareSDK connectSohuKanWithAppKey:@"e16680a815134504b746c86e08a19db0"
                             appSecret:@"b8eec53707c3976efc91614dd16ef81c"
                           redirectUri:@"http://sharesdk.cn"];
    //添加Pocket应用
    [ShareSDK connectPocketWithConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
                               redirectUri:@"pocketapp1234"];
    //添加印象笔记应用
    [ShareSDK connectEvernoteWithType:SSEverNoteTypeSandbox
                          consumerKey:@"sharesdk-7807"
                       consumerSecret:@"d05bf86993836004"];
    //添加LinkedIn应用
    [ShareSDK connectLinkedInWithApiKey:@"ejo5ibkye3vo"
                              secretKey:@"cC7B2jpxITqPLZ5M"
                            redirectUri:@"http://sharesdk.cn"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
