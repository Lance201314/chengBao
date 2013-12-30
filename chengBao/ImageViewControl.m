//
//  ImageViewControl.m
//  chengBao
//
//  Created by Beyondsoft on 13-12-23.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import "ImageViewControl.h"
#import "EGOImageView.h"
@implementation ImageViewControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.maximumZoomScale = 2.5;
        self.minimumZoomScale = 1;
        _imageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"placeholder_lx"]];
        _imageView.frame = self.bounds;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        self.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}

@end
