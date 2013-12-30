//
//  NLSideNavViewController.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"
typedef enum {
    Left = 0,
    Root,
    Right
}CURRENT_FLAG;

typedef enum {
    SidePanDirectionLeft = 0,
    SidePanDirectionRight,
}SidePanDirection;

typedef enum {
    SidePanCompletionLeft = 0,
    SidePanCompletionRight,
    SidePanCompletionRoot
}SidePanCompletion;

typedef float side_width;

#define dSIDE_L 273.0
#define dSIDE_R 273.0
#define kMenuOverlayWidth(val) (self.view.bounds.size.width - val)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f
@interface NLSideNavViewController : UIViewController <UIGestureRecognizerDelegate> {
    side_width side_l,side_r;
}

@property (nonatomic, assign) side_width side_l;
@property (nonatomic, assign) side_width side_r;
@property (nonatomic, retain) UIViewController *leftVC;
@property (nonatomic, retain) UIViewController *rightVC;
@property (nonatomic, retain) UIViewController *rootVC;

- (id)initwithRootView:(UIViewController *)root;
- (void)showRootViewController;
- (void)showFullRight;
- (void)showNormalRight;
@end
