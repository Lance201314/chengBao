//
//  AppDelegate.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-3.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NLSideNavViewController.h"
@class PPRevealSideViewController;
@class Reachability;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) NSString *fontStyle;
@property (nonatomic, retain) NSString *fontSize;
@property (nonatomic, assign) BOOL isNet;
@property (nonatomic, retain) PPRevealSideViewController *revealSideViewController;
@property (nonatomic, retain) Reachability *reachability;
@end
