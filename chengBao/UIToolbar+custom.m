//
//  UIToolbar+custom.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-9.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "UIToolbar+custom.h"
#import <QuartzCore/QuartzCore.h>
@implementation UIToolbar (custom)
- (void)drawRect:(CGRect)rect
{
    [[UIImage imageNamed:@"navBar_bg"] drawInRect:rect];
}

- (void)customToolbarBar
{
    if ([self respondsToSelector:@selector(setBackgroundColor:)]) {
        [self setBackgroundImage:[UIImage imageNamed:@"navBar_bg"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    } else {
        [self drawRect:self.bounds];
    }
    [self drawRoundCornerAndShadow];
}

- (void)drawRoundCornerAndShadow {
    CGRect bounds = self.bounds;
    bounds.size.height +=10;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    [self.layer addSublayer:maskLayer];
    self.layer.mask = maskLayer;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowOpacity = 0.7;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}
@end
