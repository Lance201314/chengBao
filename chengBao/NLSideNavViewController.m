//
//  NLSideNavViewController.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-4.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "NLSideNavViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ILBarButtonItem.h"
#import "UINavigationBar+customBar.h"
@interface NLSideNavViewController (){
    @private
    BOOL _LeftOrRight;
    CURRENT_FLAG c_flag;
    struct{
        unsigned int respondsTowillShowViewController:1;
        unsigned int leftAvailable:1;
        unsigned int rightAvailable:1;
    }_menuFlag;
    
    CGFloat _panOriginX;
    CGPoint _panVelocity;
    SidePanDirection panDirection;
}
@property(nonatomic,readonly) UITapGestureRecognizer *tap_left;
@property(nonatomic,readonly) UITapGestureRecognizer *tap_right;
@property(nonatomic,readonly) UIPanGestureRecognizer *pan;
@property (nonatomic, readonly) UITapGestureRecognizer *tap;
@end

@implementation NLSideNavViewController
@synthesize tap_left,tap, tap_right, pan, side_r, side_l;

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
    [_rootVC release];
    [_leftVC release];
    [_rootVC release];
    [tap_right release];
    [tap_left release];
    [tap release];
    [pan release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -- init methods
- (void)initData
{
    c_flag = Root;
    side_l = dSIDE_L;
    side_r = dSIDE_R;
}

#pragma mark -- tap nav
- (void)tapNavView:(UITapGestureRecognizer *)tapview
{
    CGPoint point = [tapview locationInView:self.leftVC.view];
    if (point.x > dSIDE_L && point.y <= 44) {
        [self leftPress:nil];
    }
}

- (void)tapNavView_right:(UITapGestureRecognizer *)tapview
{
    CGPoint point = [tapview locationInView:self.rightVC.view];
    if (point.x < (screenWidth - dSIDE_R) && point.y <= 44) {
        [self rightPress:nil];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSLog(@"%@", [gestureRecognizer class]);
    if (_LeftOrRight) {
        if (gestureRecognizer == tap_left) {
            CGPoint point = [touch locationInView:self.leftVC.view];
            if (point.x > dSIDE_L && point.y <= 44) {
                return YES;
            }
        } else if(gestureRecognizer == tap) {
//            _rootVC.view.userInteractionEnabled = NO;
            return YES;
        } else if (gestureRecognizer == pan) {
            return YES;
        }
    } else {
        if (gestureRecognizer == tap_right) {
            CGPoint point = [touch locationInView:self.rightVC.view];
            if (point.x < (screenWidth - dSIDE_R) && point.y <= 44) {
                return YES;
            }
        } else if(gestureRecognizer == tap) {
//            _rootVC.view.userInteractionEnabled = NO;
            return YES;
        } else if(gestureRecognizer == pan) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}

- (id)initwithRootView:(UIViewController *)root
{
    if (self = [super init]) {
        self.rootVC = root;
        [self initData];
    }
    return self;
}

#pragma mark -- show methods
- (void)showLeftViewController
{
    _LeftOrRight = YES;
    UIView *lView = _leftVC.view;
    [self.view insertSubview:lView atIndex:0];
    CGRect frame;
    frame = _rootVC.view.frame;
    frame.origin.x = side_l;
    [self restRootShadow];
    [UIView animateWithDuration:0.3 animations:^{
        _rootVC.view.frame = frame;
    } completion:^(BOOL finished){
        
    }];
}

- (void)showRightViewController
{
    _LeftOrRight = NO;
    UIView *rView = _rightVC.view;
    [self.view insertSubview: rView atIndex:0];
    CGRect frame;
    frame = _rootVC.view.frame;
    frame.origin.x = (- side_r);
    [self restRootShadow];
    [UIView animateWithDuration:0.3 animations:^{
        _rootVC.view.frame = frame;
    } completion:^(BOOL finished){
        
    }];
}

#pragma mark -- show right 
- (void)showFullRight
{
    CGRect frame;
    frame = _rootVC.view.frame;
    frame.origin.x = (- screenWidth);
    [UIView animateWithDuration:0.3 animations:^{
        _rootVC.view.frame = frame;
    }];
}

- (void)showNormalRight
{
    CGRect frame;
    frame = _rootVC.view.frame;
    frame.origin.x = (- dSIDE_R);
    [UIView animateWithDuration:0.3 animations:^{
        _rootVC.view.frame = frame;
    }];
}

- (void)showRootViewController
{
    _rootVC.view.userInteractionEnabled = YES;
    [self restRootViewNavBar];
    CGRect frame = _rootVC.view.frame;
    frame.origin.x = 0.0;
    [self restRootShadow];
    [UIView animateWithDuration:0.3 animations:^{
        _rootVC.view.frame = frame;
    } completion:^(BOOL finished){
        if (_leftVC && _leftVC.view.subviews) {
            [_leftVC.view removeFromSuperview];
        }
        
        if (_rightVC && _rightVC.view.subviews) {
            [_rightVC.view removeFromSuperview];
        }
    }];
    [self initData];
}

- (void)showCurrentViewController
{
    switch (c_flag) {
        case Root:
            [self showRootViewController];
            break;
        case Left:
            [self showLeftViewController];
            break;
        case Right:
            [self showRightViewController];
            break;
    }
}

#pragma  mark -- rest view
- (void)restRootShadow
{
//    if (!_rootVC){
//        return;
//    }
//    if (c_flag == Root){
//        _rootVC.view.layer.shadowOpacity = 0.0f;
//    }else{
//        _rootVC.view.layer.opacity = 0.8f;
//        _rootVC.view.layer.shadowOpacity = 0.8f;
//        _rootVC.view.layer.cornerRadius = 10.0f;
//        _rootVC.view.layer.shadowOffset = (c_flag == Left) ? CGSizeMake(-10, 0):CGSizeMake(10, 10);
//        _rootVC.view.layer.shadowRadius = 10.0f;
//        _rootVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
//    }
}

- (void)restRootViewNavBar
{
    if (!_rootVC) {
        return;
    }
    UIViewController *topVC;
    if ([_rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)_rootVC;
        if ([[nav viewControllers] count] > 0) {
            topVC = [[nav viewControllers] objectAtIndex:0];
        } else {
            return;
        }
    } else {
        topVC = _rootVC;
    }
    //定制titleview
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 82, 44)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 82, 39)];
    [title setText:topVC.title];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor redColor];
    title.font = [UIFont systemFontOfSize:18];
    title.textAlignment = NSTextAlignmentCenter;
    [view addSubview:title];
    [title release];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 82, 3)];
    imageView.image = [UIImage imageNamed:@"u5_normal"];
    [view addSubview:imageView];
    [imageView release];
    topVC.navigationItem.titleView = view;
    [view release];
    
    if (_menuFlag.leftAvailable) {
        ILBarButtonItem *leftItem =
        [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"u1_normal"] frame:CGRectMake(0, 0, 49, 37)
                            selectedImage:nil
                                   target:self
                                   action:@selector(leftPress:)];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(leftPress:) object:leftItem];
        topVC.navigationItem.leftBarButtonItem = leftItem;
    }
    if (_menuFlag.rightAvailable) {
        ILBarButtonItem *rightItem =
        [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"u3_normal"] frame:CGRectMake(0, 0, 49, 39)
                            selectedImage:nil
                                   target:self
                                   action:@selector(rightPress:)];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(rightPress:) object:rightItem];
        topVC.navigationItem.rightBarButtonItem = rightItem;
    }
    topVC.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
}

#pragma mark - navBar buttons press mnethods
- (void)leftPress:(id)sender
{
//    UITableView *table = (UITableView *)[_rootVC.view viewWithTag:1];
    if (c_flag == Root) {
        c_flag = Left;
    } else if (c_flag == Left) {
        c_flag = Root;
    }
    [self showCurrentViewController];
}

- (void)rightPress:(id)sender
{
    if (c_flag == Root) {
        c_flag = Right;
    } else if (c_flag == Right) {
        c_flag = Root;
    }
    [self showCurrentViewController];
}


#pragma mark -- setter

- (void)setLeftVC:(UIViewController *)leftVC
{
    if (_leftVC) {
        [_leftVC release];
    }
    _leftVC = [leftVC retain];
    _leftVC.view.frame = self.view.bounds;
    
    _menuFlag.leftAvailable = (_leftVC != nil);
    [self restRootViewNavBar];
    tap_left = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNavView:)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapNavView:) object:tap_left];
    tap_left.delegate = self;
    [self.leftVC.view addGestureRecognizer:tap_left];
}

- (void)setRightVC:(UIViewController *)rightVC
{
    if (_rightVC) {
        [_rightVC release];
    }
    _rightVC = [rightVC retain];
    _rightVC.view.frame = self.view.bounds;
    
    _menuFlag.rightAvailable = (_rightVC != nil);
    [self restRootViewNavBar];
    tap_right = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapNavView_right:)];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tapNavView_right:) object:tap_right];
    tap_right.delegate = self;
    [self.rightVC.view addGestureRecognizer:tap_right];
}

- (void)setRootVC:(UIViewController *)rootVC
{
    if (_rootVC) {
        [_rootVC.view removeFromSuperview];
        [_rootVC release];
    }
    _rootVC = [rootVC retain];
    if (_rootVC) {
        _rootVC.view.frame = self.view.bounds;
        [self.view addSubview:_rootVC.view];
        [self restRootViewNavBar];
        pan =[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.delegate = self;
        [rootVC.view addGestureRecognizer:pan];
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNavView:)];
        tap.delegate = self;
        [rootVC.view addGestureRecognizer:tap];
    }
    [_rootVC.view addGestureRecognizer:pan];
}


#pragma mark - GestureRecognizers

- (void)pan:(UIPanGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        //显示阴影效果
        [self restRootShadow];
        
        //获取rootview原点的x
        _panOriginX = _rootVC.view.frame.origin.x;
        //拖动的速率初始化
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        //判断是往左还是往右拖动
        if([gesture velocityInView:self.view].x > 0) {
            panDirection = SidePanDirectionRight;
            
        } else {
            panDirection = SidePanDirectionLeft;
        }
        
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        
        //获取拖动的速率；
        CGPoint velocity = [gesture velocityInView:self.view];
        //根据前一个和现在的速率判断是否要改变方向
        if((velocity.x*_panVelocity.x + velocity.y*_panVelocity.y) < 0) {
            
            panDirection = (panDirection == SidePanDirectionRight) ? SidePanDirectionLeft : SidePanDirectionRight;
        }
        
        _panVelocity = velocity;
        //拖动的距离
        CGPoint translation = [gesture translationInView:self.view];
        /**
         下面是rootview拽动改变
         */
        CGRect frame = _rootVC.view.frame;
        frame.origin.x = _panOriginX + translation.x;
        if (c_flag == Root) {
            if (frame.origin.x > 0.0f) {
                if (_menuFlag.leftAvailable) {
                    c_flag = Left;
                    [self showCurrentViewController];
                }else{
                    frame.origin.x = 0;
                }
            }else{
                if (_menuFlag.rightAvailable) {
                    c_flag = Right;
                    [self showCurrentViewController];
                }else{
                    frame.origin.x = 0.0f;
                    
                }
            }
        }else if (c_flag == Left){
            
            if(frame.origin.x <0)
                frame.origin.x = 0.0;
            
        }else if (c_flag == Right){
            
            if (frame.origin.x >0) {
                frame.origin.x  = 0;
            }
        }
        _rootVC.view.frame = frame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.view setUserInteractionEnabled:NO];
        
        SidePanCompletion completion =SidePanCompletionRoot;
        if (panDirection == SidePanDirectionRight && _menuFlag.leftAvailable) {
            
            if(_rootVC.view.frame.origin.x > 0.0f )
                completion = SidePanCompletionLeft;
        } else if (panDirection == SidePanDirectionLeft && _menuFlag.rightAvailable) {
            if(_rootVC.view.frame.origin.x < 0.0f )
                completion = SidePanCompletionRight;
        }
        
        CGPoint velocity = [gesture velocityInView:self.view];
        if (velocity.x < 0.0f) {
            velocity.x *= -1.0f;
        }
        BOOL bounce = (velocity.x > 800);
        CGFloat originX = _rootVC.view.frame.origin.x;
        CGFloat width = _rootVC.view.frame.size.width;
        CGFloat span = (width - kMenuOverlayWidth( fabs( side_l)));
        CGFloat duration = kMenuSlideDuration; // default duration with 0 velocity
        
        
        if (bounce) {
            duration = (span / velocity.x); // bouncing we'll use the current velocity to determine duration
        } else {
            duration = ((span - originX) / span) * duration; // user just moved a little, use the defult duration, otherwise it would be too slow
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion == SidePanCompletionLeft) {
                c_flag = Left;
                
            } else if (completion == SidePanCompletionRight) {
                c_flag = Right;
            } else {
                c_flag = Root;
            }
            [self showCurrentViewController];
            
            [_rootVC.view.layer removeAllAnimations];
            [self.view setUserInteractionEnabled:YES];
        }];
        
        CGPoint pos = _rootVC.view.layer.position;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        
        [values addObject:[NSValue valueWithCGPoint:pos]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [keyTimes addObject:[NSNumber numberWithFloat:0.0f]];
        if (bounce) {
            
            duration += kMenuBounceDuration;
            [keyTimes addObject:[NSNumber numberWithFloat:1.0f - ( kMenuBounceDuration / duration)]];
            if (completion == SidePanCompletionLeft) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
                
            } else if (completion == SidePanCompletionRight) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - (kMenuOverlayWidth(fabs(side_r))-kMenuBounceOffset)), pos.y)]];
                
            } else {
                
                // depending on which way we're panning add a bounce offset
                if (panDirection == SidePanDirectionLeft) {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) - kMenuBounceOffset, pos.y)]];
                } else {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
                }
                
            }
            
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }
        if (completion == SidePanCompletionLeft) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + span, pos.y)]];
        } else if (completion == SidePanCompletionRight) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - kMenuOverlayWidth(side_r)), pos.y)]];
        } else {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
        }
        
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [keyTimes addObject:[NSNumber numberWithFloat:1.0f]];
        
        animation.timingFunctions = timingFunctions;
        animation.keyTimes = keyTimes;
        //animation.calculationMode = @"cubic";
        animation.values = values;
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [_rootVC.view.layer addAnimation:animation forKey:nil];
        [CATransaction commit];
        
    }
    
}

- (void)tap:(UITapGestureRecognizer*)gesture {
    [gesture setEnabled:NO];
    [self showCurrentViewController];
    
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // Check for horizontal pan gesture
    if (gestureRecognizer == pan) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if ([panGesture velocityInView:self.view].x < 600 && sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1) {
            return YES;
        }
        return NO;
    }
    
    if (gestureRecognizer == tap) {
        if (_rootVC && c_flag!=Root) {
            return CGRectContainsPoint(_rootVC.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == tap) {
        return YES;
    }
    return NO;
}
@end
