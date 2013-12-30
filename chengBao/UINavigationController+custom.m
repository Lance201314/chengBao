//
//  UINavigationController+custom.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-26.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "UINavigationController+custom.h"

@implementation UINavigationController (custom)

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationMaskLandscapeRight) {
        //self.view.transform = CGAffineTransformMakeRotation(de)
        self.view.bounds = CGRectMake(0, 0, 480, 320);
    } else if (toInterfaceOrientation == UIInterfaceOrientationMaskLandscapeLeft) {
        self.view.bounds = CGRectMake(0, 0, 480, 320);
    }
}
@end
