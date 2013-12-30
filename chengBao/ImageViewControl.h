//
//  ImageViewControl.h
//  chengBao
//
//  Created by Beyondsoft on 13-12-23.
//  Copyright (c) 2013年 Beyondsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EGOImageView;
@interface ImageViewControl : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, retain) EGOImageView *imageView;
@end
